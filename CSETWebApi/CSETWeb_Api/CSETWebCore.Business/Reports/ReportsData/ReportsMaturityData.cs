//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Maturity.Configuration;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Reports
{
    public partial class ReportsDataBusiness : IReportsDataBusiness
    {
        /// <summary>
        /// Returns an unfiltered list of MatRelevantAnswers for the current assessment.
        /// The optional modelId parameter is used to get a specific model's questions.  If not
        /// supplied, the default model's questions are retrieved.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetQuestionsList(int? modelId = null)
        {
            int targetModelId = 0;

            if (modelId == null)
            {
                var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();
                if (myModel == null)
                {
                    return new List<MatRelevantAnswers>();
                }

                targetModelId = myModel.model_id;
            }
            else
            {
                targetModelId = (int)modelId;
            }


            var lang = _tokenManager.GetCurrentLanguage();

            _context.FillEmptyMaturityQuestionsForAnalysis(_assessmentId);

            // flesh out model-specific questions 
            if (modelId != null)
            {
                _context.FillEmptyMaturityQuestionsForModel(_assessmentId, (int)modelId);
            }

            var query = from a in _context.ANSWER
                        join m in _context.MATURITY_QUESTIONS.Include(x => x.Maturity_Level)
                            on a.Question_Or_Requirement_Id equals m.Mat_Question_Id
                        where a.Assessment_Id == _assessmentId
                            && m.Maturity_Model_Id == targetModelId
                            && a.Question_Type == "Maturity"
                            && !this.OutOfScopeQuestions.Contains(m.Mat_Question_Id)
                        orderby m.Grouping_Id, m.Maturity_Level_Id, m.Mat_Question_Id ascending
                        select new MatRelevantAnswers()
                        {
                            ANSWER = a,
                            Mat = m
                        };

            var responseList = query.ToList();
            var childQuestions = responseList.FindAll(x => x.Mat.Parent_Question_Id != null);

            // Set IsParentWithChildren property for all parent questions that have child questions
            foreach (var matAns in responseList)
            {
                if (childQuestions.Exists(x => x.Mat.Parent_Question_Id == matAns.Mat.Mat_Question_Id))
                {
                    matAns.IsParentWithChildren = true;
                }
            }

            foreach (var matAns in responseList)
            {
                var o = _overlay.GetMaturityQuestion(matAns.Mat.Mat_Question_Id, lang);
                if (o != null)
                {
                    matAns.Mat.Question_Title = o.QuestionTitle ?? matAns.Mat.Question_Title;
                    matAns.Mat.Question_Text = o.QuestionText;
                    matAns.Mat.Supplemental_Info = o.SupplementalInfo;
                }
            }


            // if a maturity level is defined, only report on questions at or below that level
            int? selectedLevel = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == _assessmentId
                && x.Level_Name == Constants.Constants.MaturityLevel).Select(x => int.Parse(x.Standard_Specific_Sal_Level)).FirstOrDefault();

            NullOutNavigationPropeties(responseList);

            // RRA should be always be defaulted to its maximum available level (3)
            // since the user can't configure it
            if (targetModelId == 5)
            {
                selectedLevel = 3;
            }

            if (selectedLevel != null && selectedLevel != 0)
            {
                responseList = responseList.Where(x => x.Mat.Maturity_Level.Level <= selectedLevel).ToList();
            }


            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswers that are considered deficient for the assessment.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetMaturityDeficiencies(int? modelId = null)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var targetModel = myModel.model;


            // if a model was explicitly requested, do that one
            if (modelId != null)
            {
                targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).FirstOrDefault();
            }


            bool ignoreParentQuestions = false;

            // default answer values that are considered 'deficient' (in case we can't find a model config profile)
            List<string> deficientAnswerValues = new List<string>() { "N", "U" };


            // try to get a configuration for the actual model
            var modelProperties = new ModelProfile().GetModelProperties(targetModel.Maturity_Model_Id);
            if (modelProperties != null)
            {
                deficientAnswerValues = modelProperties.DeficientAnswers;
                ignoreParentQuestions = modelProperties.IgnoreParentQuestions;
            }


            var responseList = GetQuestionsList(targetModel.Maturity_Model_Id).Where(x => deficientAnswerValues.Contains(x.ANSWER.Answer_Text)).ToList();


            // We don't consider parent questions that have children to be unanswered for certain maturity models
            // (i.e. for CRR, EDM since they just house the question extras)
            if (ignoreParentQuestions)
            {
                responseList = responseList.Where(x => !x.IsParentWithChildren).ToList();
            }


            // If the assessment is using a submodel, only keep the submodel's subset of questions
            var maturitySubmodel = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == _assessmentId && x.DataItemName == "MATURITY-SUBMODEL").FirstOrDefault();
            if (maturitySubmodel != null)
            {
                var whitelist = _context.MATURITY_SUB_MODEL_QUESTIONS.Where(x => x.Sub_Model_Name == maturitySubmodel.StringValue).Select(q => q.Mat_Question_Id).ToList();
                responseList = responseList.Where(x => whitelist.Contains(x.Mat.Mat_Question_Id)).ToList();
            }

            return responseList;
        }



        /// <summary>
        /// Returns a list of MatRelevantAnswers that contain comments.
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetCommentsList(int? modelId = null)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var targetModel = myModel.model;

            // if a model was explicitly requested, do that one
            if (modelId != null)
            {
                targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).FirstOrDefault();
            }

            var responseList = GetQuestionsList(targetModel.Maturity_Model_Id).Where(x => !string.IsNullOrWhiteSpace(x.ANSWER.Comment)).ToList();

            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswers that are marked for review.
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetMarkedForReviewList(int? modelId = null)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS.Include(x => x.model).Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var targetModel = myModel.model;

            // if a model was explicitly requested, do that one
            if (modelId != null)
            {
                targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).FirstOrDefault();
            }

            var responseList = GetQuestionsList(targetModel.Maturity_Model_Id).Where(x => x.ANSWER.Mark_For_Review ?? false).ToList();

            return responseList;
        }


        /// <summary>
        /// Returns a list of MatRelevantAnswers that have been answered "A".
        /// </summary>
        /// <returns></returns>
        public List<MatRelevantAnswers> GetAlternatesList()
        {
            var responseList = GetQuestionsList().Where(x => (x.ANSWER.Answer_Text == "A")).ToList();
            return responseList;
        }


        /// <summary>
        /// Returns a list of answered maturity questions.  This was built for ACET
        /// but could be used by other maturity models with some work.
        /// </summary>
        /// <returns></returns>
        public List<MatAnsweredQuestionDomain> GetAnsweredQuestionList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();

            var lang = _tokenManager.GetCurrentLanguage();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var myMaturityLevels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            // get the target maturity level IDs
            var targetRange = new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityRangeIds(_assessmentId);

            var questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id
                && targetRange.Contains(q.Maturity_Level_Id)).ToList();


            // apply overlay
            foreach (var q in questions)
            {
                var o = _overlay.GetMaturityQuestion(q.Mat_Question_Id, lang);
                if (o != null)
                {
                    q.Question_Title = o.QuestionTitle ?? q.Question_Title;
                    q.Question_Text = o.QuestionText;
                    q.Supplemental_Info = o.SupplementalInfo;
                    q.Examination_Approach = o.ExaminationApproach;
                }
            }


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();


            // apply translation overlay
            foreach (var g in allGroupings)
            {
                var o = _overlay.GetMaturityGrouping(g.Grouping_Id, lang);
                if (o != null)
                {
                    g.Title = o.Title;
                    g.Description = o.Description;
                }
            }


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    IsDeficient = false,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        IsDeficient = false,
                        Components = new List<MaturityAnsweredQuestionsComponent>()
                    };

                    foreach (var componenet in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = componenet.Title,
                            IsDeficient = false,
                            Questions = new List<MaturityAnsweredQuestions>()
                        };

                        foreach (var question in componenet.Questions)
                        {
                            if (question.Answer != null)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = GetLevelLabel(question.MaturityLevel, myMaturityLevels),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview
                                };


                                // overlay
                                var o = _overlay.GetMaturityQuestion(question.QuestionId, lang);
                                if (o != null)
                                {
                                    newQuestion.QuestionText = o.QuestionText;
                                }



                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                    newComponent.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }

                                newComponent.Questions.Add(newQuestion);
                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                        }
                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }
                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }

            return maturityDomains;
        }


        /// <summary>
        /// Returns a list of answered maturity questions.  This was built for ACET ISE
        /// but could be used by other maturity models with some work.
        /// </summary>
        /// <returns></returns>
        public List<MatAnsweredQuestionDomain> GetIseAnsweredQuestionList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var myMaturityLevels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            // get the target maturity level IDs
            var targetRange = new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetIseMaturityRangeIds(_assessmentId);

            var questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id
                && targetRange.Contains(q.Maturity_Level_Id)).ToList();


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            //Get All the Observations and issues with the Observations. 


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            // ToDo: Refactor the following stucture of loops
            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    IsDeficient = false,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        IsDeficient = false,
                        Components = new List<MaturityAnsweredQuestionsComponent>()
                    };

                    foreach (var componenet in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = componenet.Title,
                            IsDeficient = false,
                            Questions = new List<MaturityAnsweredQuestions>()
                        };

                        foreach (var question in componenet.Questions)
                        {
                            if (question.Answer != null)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = GetLevelLabel(question.MaturityLevel, myMaturityLevels),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                    newComponent.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }

                                newComponent.Questions.Add(newQuestion);
                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                        }
                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }
                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }

            return maturityDomains;
        }

        /// <summary>
        /// Returns a list of answered maturity questions.  This was built for ACET ISE
        /// but could be used by other maturity models with some work.
        /// </summary>
        /// <returns></returns>
        public List<MatAnsweredQuestionDomain> GetIseAllQuestionList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            var myMaturityLevels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            // get the target maturity level IDs
            var targetRange = new ACETMaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetIseMaturityRangeIds(_assessmentId);

            var questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id).ToList();


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            //Get All the Observations and issues with the Observations. 


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            // ToDo: Refactor the following stucture of loops
            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    IsDeficient = false,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        IsDeficient = false,
                        Components = new List<MaturityAnsweredQuestionsComponent>()
                    };

                    foreach (var componenet in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = componenet.Title,
                            IsDeficient = false,
                            Questions = new List<MaturityAnsweredQuestions>()
                        };

                        foreach (var question in componenet.Questions)
                        {
                            if (question.Answer != null)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = GetLevelLabel(question.MaturityLevel, myMaturityLevels),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                    newComponent.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }

                                newComponent.Questions.Add(newQuestion);
                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                        }
                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }
                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }

            return maturityDomains;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<MaturityReportData.MaturityModel> GetMaturityModelData()
        {
            List<MaturityQuestion> mat_questions = new List<MaturityQuestion>();
            List<MaturityReportData.MaturityModel> mat_models = new List<MaturityReportData.MaturityModel>();

            _context.FillEmptyMaturityQuestionsForAnalysis(_assessmentId);

            var query = (
                from amm in _context.AVAILABLE_MATURITY_MODELS
                join mm in _context.MATURITY_MODELS on amm.model_id equals mm.Maturity_Model_Id
                join mq in _context.MATURITY_QUESTIONS on mm.Maturity_Model_Id equals mq.Maturity_Model_Id
                join ans in _context.ANSWER on mq.Mat_Question_Id equals ans.Question_Or_Requirement_Id
                join asl in _context.ASSESSMENT_SELECTED_LEVELS on amm.Assessment_Id equals asl.Assessment_Id
                where amm.Assessment_Id == _assessmentId
                && ans.Assessment_Id == _assessmentId
                && ans.Is_Maturity == true
                && asl.Level_Name == Constants.Constants.MaturityLevel
                select new { amm, mm, mq, ans, asl }
                ).ToList();
            var models = query.Select(x => new { x.mm, x.asl }).Distinct();
            foreach (var model in models)
            {
                MaturityReportData.MaturityModel newModel = new MaturityReportData.MaturityModel();
                newModel.MaturityModelName = model.mm.Model_Name;
                newModel.MaturityModelID = model.mm.Maturity_Model_Id;
                if (Int32.TryParse(model.asl.Standard_Specific_Sal_Level, out int lvl))
                {
                    newModel.TargetLevel = lvl;
                }
                else
                {
                    newModel.TargetLevel = null;
                }
                mat_models.Add(newModel);
            }

            foreach (var queryItem in query)
            {
                MaturityQuestion newQuestion = new MaturityQuestion();
                newQuestion.Mat_Question_Id = queryItem.mq.Mat_Question_Id;
                newQuestion.Question_Title = queryItem.mq.Question_Title;
                newQuestion.Question_Text = queryItem.mq.Question_Text;
                newQuestion.Supplemental_Info = queryItem.mq.Supplemental_Info;
                newQuestion.Examination_Approach = queryItem.mq.Examination_Approach;
                newQuestion.Grouping_Id = queryItem.mq.Grouping_Id ?? 0;
                newQuestion.Parent_Question_Id = queryItem.mq.Parent_Question_Id;
                newQuestion.Maturity_Level = queryItem.mq.Maturity_Level_Id;
                newQuestion.Set_Name = queryItem.mm.Model_Name;
                newQuestion.Sequence = queryItem.mq.Sequence;
                newQuestion.Maturity_Model_Id = queryItem.mm.Maturity_Model_Id;
                newQuestion.Answer = queryItem.ans;

                mat_models.Where(x => x.MaturityModelID == newQuestion.Maturity_Model_Id)
                    .FirstOrDefault()
                    .MaturityQuestions.Add(newQuestion);

                mat_questions.Add(newQuestion);
            }

            return mat_models;
        }
        public List<MatAnsweredQuestionDomain> GetCieQuestionList(int matLevel, bool filterForNa = false)
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            //var myMaturityLevels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();
            List<MATURITY_QUESTIONS> questions = new List<MATURITY_QUESTIONS>();

            questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id).ToList();

            // Get all MATURITY answers for the assessment
            //IQueryable<FullAnswer> answers = new IQueryable<FullAnswer>();

            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };

            if (filterForNa)
            {
                answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity" && x.Answer_Text == "NA")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };
            }

            Dictionary<int, List<DocumentWithAnswerId>> docDictionary = new Dictionary<int, List<DocumentWithAnswerId>>();

            List<DocumentWithAnswerId> documentList = new List<DocumentWithAnswerId>();

            var results = (from f in _context.DOCUMENT_FILE
                           join da in _context.DOCUMENT_ANSWERS on f.Document_Id equals da.Document_Id
                           join a in _context.ANSWER on da.Answer_Id equals a.Answer_Id
                           join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                           where f.Assessment_Id == _assessmentId
                           select new { f, da, a, q }).ToList();

            var questionIds = results.DistinctBy(x => x.q.Mat_Question_Id).ToList();

            results.ForEach(doc =>
            {
                DocumentWithAnswerId newDoc = new DocumentWithAnswerId()
                {
                    Answer_Id = doc.da.Answer_Id,
                    Title = doc.f.Title,
                    FileName = doc.f.Name,
                    Document_Id = doc.da.Document_Id,
                    Question_Id = doc.a.Question_Or_Requirement_Id,
                    Question_Title = doc.q.Question_Title
                };
                documentList.Add(newDoc);
                if (docDictionary.ContainsKey(newDoc.Question_Id))
                {
                    docDictionary[newDoc.Question_Id].Add(newDoc);
                }
                else
                {
                    docDictionary.Add(newDoc.Question_Id, [newDoc]);
                }
            });

            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            //Get All the Observations and issues with the Observations. 


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            // ToDo: Refactor the following stucture of loops
            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    IsDeficient = false,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        IsDeficient = false,
                        Components = new List<MaturityAnsweredQuestionsComponent>(),
                        Questions = new List<MaturityAnsweredQuestions>()
                    };


                    if (assesmentFactor.Questions.Count > 0)
                    {
                        foreach (var question in assesmentFactor.Questions)
                        {
                            // if the report shows N/A only, make sure the answer's included are only "NA"
                            if (question.Answer != null && (filterForNa ? question.Answer == "NA" : true))
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = question.MaturityLevel.ToString(),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer,
                                    Documents = docDictionary.ContainsKey(question.QuestionId) ? docDictionary[question.QuestionId] : null,
                                    Visible = true
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }
                                if (newQuestion.MaturityLevel == "5")
                                {
                                    newAssesmentFactor.Questions.Add(newQuestion);
                                }
                            }
                        }
                    }
                    foreach (var component in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = component.Title,
                            IsDeficient = false,
                            Questions = new List<MaturityAnsweredQuestions>(),
                        };

                        foreach (var question in component.Questions)
                        {
                            if (question.Answer != null)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = question.MaturityLevel.ToString(),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer,
                                    Documents = docDictionary.ContainsKey(question.QuestionId) ? docDictionary[question.QuestionId] : null,
                                    Visible = true
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                    newComponent.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }

                                newComponent.Questions.Add(newQuestion);
                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                            //newAssesmentFactor.Questions.AddRange(newComponent.Questions);
                        }
                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }
                    //}

                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }

            return maturityDomains;
        }

        public List<MatAnsweredQuestionDomain> GetCieMfrQuestionList()
        {
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            //var myMaturityLevels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();
            List<MATURITY_QUESTIONS> questions = new List<MATURITY_QUESTIONS>();

            questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id).ToList();

            // Get all MATURITY answers for the assessment
            //IQueryable<FullAnswer> answers = new IQueryable<FullAnswer>();

            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };

            Dictionary<int, List<DocumentWithAnswerId>> docDictionary = new Dictionary<int, List<DocumentWithAnswerId>>();

            List<DocumentWithAnswerId> documentList = new List<DocumentWithAnswerId>();

            var results = (from f in _context.DOCUMENT_FILE
                           join da in _context.DOCUMENT_ANSWERS on f.Document_Id equals da.Document_Id
                           join a in _context.ANSWER on da.Answer_Id equals a.Answer_Id
                           join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                           where f.Assessment_Id == _assessmentId
                           select new { f, da, a, q }).ToList();

            var questionIds = results.DistinctBy(x => x.q.Mat_Question_Id).ToList();

            results.ForEach(doc =>
            {
                DocumentWithAnswerId newDoc = new DocumentWithAnswerId()
                {
                    Answer_Id = doc.da.Answer_Id,
                    Title = doc.f.Title,
                    FileName = doc.f.Name,
                    Document_Id = doc.da.Document_Id,
                    Question_Id = doc.a.Question_Or_Requirement_Id,
                    Question_Title = doc.q.Question_Title
                };
                documentList.Add(newDoc);
                if (docDictionary.ContainsKey(newDoc.Question_Id))
                {
                    docDictionary[newDoc.Question_Id].Add(newDoc);
                }
                else
                {
                    docDictionary.Add(newDoc.Question_Id, [newDoc]);
                }
            });

            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            //Get All the Observations and issues with the Observations. 


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            // ToDo: Refactor the following stucture of loops
            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    IsDeficient = false,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        IsDeficient = false,
                        Components = new List<MaturityAnsweredQuestionsComponent>(),
                        Questions = new List<MaturityAnsweredQuestions>()
                    };


                    if (assesmentFactor.Questions.Count > 0)
                    {
                        foreach (var question in assesmentFactor.Questions)
                        {
                            // make sure only MarkForReview quest6ions are included
                            if (question.Answer != null && question.MarkForReview)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = question.MaturityLevel.ToString(),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer,
                                    Documents = docDictionary.ContainsKey(question.QuestionId) ? docDictionary[question.QuestionId] : null,
                                    Visible = true
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }
                                if (newQuestion.MaturityLevel == "5")
                                {
                                    newAssesmentFactor.Questions.Add(newQuestion);
                                }
                            }
                        }
                    }
                    foreach (var component in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = component.Title,
                            IsDeficient = false,
                            Questions = new List<MaturityAnsweredQuestions>(),
                        };

                        foreach (var question in component.Questions)
                        {
                            if (question.Answer != null && question.MarkForReview)
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = question.MaturityLevel.ToString(),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer,
                                    Documents = docDictionary.ContainsKey(question.QuestionId) ? docDictionary[question.QuestionId] : null,
                                    Visible = true
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                    newComponent.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }

                                newComponent.Questions.Add(newQuestion);
                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                            //newAssesmentFactor.Questions.AddRange(newComponent.Questions);
                        }
                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }
                    //}

                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }

            return maturityDomains;
        }
        //

        public List<MatAnsweredQuestionDomain> GetCieDocumentsForAssessment()
        {
            Dictionary<int, List<DocumentWithAnswerId>> docDictionary = new Dictionary<int, List<DocumentWithAnswerId>>();

            List<DocumentWithAnswerId> documentList = new List<DocumentWithAnswerId>();

            var results = (from f in _context.DOCUMENT_FILE
                           join da in _context.DOCUMENT_ANSWERS on f.Document_Id equals da.Document_Id
                           join a in _context.ANSWER on da.Answer_Id equals a.Answer_Id
                           join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                           where f.Assessment_Id == _assessmentId
                           select new { f, da, a, q }).ToList();

            var questionIds = results.DistinctBy(x => x.q.Mat_Question_Id).ToList();

            results.ForEach(doc =>
            {
                DocumentWithAnswerId newDoc = new DocumentWithAnswerId()
                {
                    Answer_Id = doc.da.Answer_Id,
                    Title = doc.f.Title,
                    FileName = doc.f.Name,
                    Document_Id = doc.da.Document_Id,
                    Question_Id = doc.a.Question_Or_Requirement_Id,
                    Question_Title = doc.q.Question_Title
                };
                documentList.Add(newDoc);
                if (docDictionary.ContainsKey(newDoc.Question_Id))
                {
                    docDictionary[newDoc.Question_Id].Add(newDoc);
                }
                else
                {
                    docDictionary.Add(newDoc.Question_Id, [newDoc]);
                }
            });

            //
            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();


            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            List<MATURITY_QUESTIONS> questions = new List<MATURITY_QUESTIONS>();

            questions = _context.MATURITY_QUESTIONS.Where(q =>
                myModel.model_id == q.Maturity_Model_Id).ToList();


            // Get all MATURITY answers for the assessment
            //IQueryable<FullAnswer> answers = new IQueryable<FullAnswer>();

            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };

            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            //Get All the Observations and issues with the Observations. 


            // Recursively build the grouping/question hierarchy
            var questionGrouping = new MaturityGrouping();
            BuildSubGroupings(questionGrouping, null, allGroupings, questions, answers.ToList());

            var maturityDomains = new List<MatAnsweredQuestionDomain>();

            // ToDo: Refactor the following stucture of loops
            foreach (var domain in questionGrouping.SubGroupings)
            {
                var newDomain = new MatAnsweredQuestionDomain()
                {
                    Title = domain.Title,
                    IsDeficient = false,
                    AssessmentFactors = new List<MaturityAnsweredQuestionsAssesment>()
                };
                foreach (var assesmentFactor in domain.SubGroupings)
                {
                    var newAssesmentFactor = new MaturityAnsweredQuestionsAssesment()
                    {
                        Title = assesmentFactor.Title,
                        IsDeficient = false,
                        AreQuestionsDeficient = false,
                        Components = new List<MaturityAnsweredQuestionsComponent>(),
                        Questions = new List<MaturityAnsweredQuestions>()
                    };


                    if (assesmentFactor.Questions.Count > 0)
                    {
                        foreach (var question in assesmentFactor.Questions)
                        {
                            // if the report shows N/A only, make sure the answer's included are only "NA"
                            if (docDictionary.ContainsKey(question.QuestionId))
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = question.MaturityLevel.ToString(),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer,
                                    Documents = docDictionary[question.QuestionId],
                                    Visible = true
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }
                                if (newQuestion.MaturityLevel == "5")
                                {
                                    newAssesmentFactor.Questions.Add(newQuestion);
                                }
                            }
                        }
                    }
                    foreach (var component in assesmentFactor.SubGroupings)
                    {
                        var newComponent = new MaturityAnsweredQuestionsComponent()
                        {
                            Title = component.Title,
                            IsDeficient = false,
                            Questions = new List<MaturityAnsweredQuestions>(),
                        };

                        foreach (var question in component.Questions)
                        {
                            if (docDictionary.ContainsKey(question.QuestionId))
                            {
                                var newQuestion = new MaturityAnsweredQuestions()
                                {
                                    Title = question.DisplayNumber,
                                    QuestionText = question.QuestionText,
                                    MaturityLevel = question.MaturityLevel.ToString(),
                                    AnswerText = question.Answer,
                                    Comment = question.Comment,
                                    MarkForReview = question.MarkForReview,
                                    MatQuestionId = question.QuestionId,
                                    FreeResponseText = question.FreeResponseAnswer,
                                    Documents = docDictionary[question.QuestionId],
                                    Visible = true
                                };

                                if (question.Answer == "N")
                                {
                                    newDomain.IsDeficient = true;
                                    newAssesmentFactor.IsDeficient = true;
                                    newComponent.IsDeficient = true;
                                }

                                if (question.Comment != null)
                                {
                                    newQuestion.Comments = "Yes";
                                }
                                else
                                {
                                    newQuestion.Comments = "No";
                                }

                                newComponent.Questions.Add(newQuestion);
                            }
                        }
                        if (newComponent.Questions.Count > 0)
                        {
                            newAssesmentFactor.Components.Add(newComponent);
                            //newAssesmentFactor.Questions.AddRange(newComponent.Questions);
                        }
                    }
                    if (newAssesmentFactor.Components.Count > 0)
                    {
                        newDomain.AssessmentFactors.Add(newAssesmentFactor);
                    }
                    //}

                }
                if (newDomain.AssessmentFactors.Count > 0)
                {
                    maturityDomains.Add(newDomain);
                }
            }
            //

            return maturityDomains;
        }
    }
}
