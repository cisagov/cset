//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Acet;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Sal;
using CSETWebCore.DataLayer.Manual;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Diagram;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Reports;
using CSETWebCore.Model.Set;
using Microsoft.AspNetCore.Components;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Runtime.Intrinsics.Arm;
using System.Text.RegularExpressions;
using static Lucene.Net.Util.Fst.Util;


namespace CSETWebCore.Business.Reports
{
    public class ReportsDataBusiness : IReportsDataBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private int _assessmentId;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IMaturityBusiness _maturityBusiness;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly ITokenManager _tokenManager;

        public List<int> OutOfScopeQuestions = new List<int>();

        private TranslationOverlay _overlay;



        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="assessment_id"></param>
        public ReportsDataBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IAssessmentModeData assessmentMode,
            IMaturityBusiness maturityBusiness, IQuestionRequirementManager questionRequirement, ITokenManager tokenManager)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _maturityBusiness = maturityBusiness;
            _questionRequirement = questionRequirement;
            _tokenManager = tokenManager;

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        public void SetReportsAssessmentId(int assessmentId)
        {
            _assessmentId = assessmentId;
        }


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

            // default answer values that are considered 'deficient'
            List<string> deficientAnswerValues = new List<string>() { "N", "U" };


            // CMMC considers unanswered as deficient
            if (targetModel.Model_Name.ToUpper() == "CMMC" ||
                targetModel.Model_Name.ToUpper() == "CMMC2")
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
            }

            // EDM also considers unanswered and incomplete as deficient
            if (targetModel.Model_Name.ToUpper() == "EDM")
            {
                ignoreParentQuestions = true;
                deficientAnswerValues = new List<string>() { "N", "U", "I" };
            }

            if (targetModel.Model_Name.ToUpper() == "CRR")
            {
                ignoreParentQuestions = true;
                deficientAnswerValues = new List<string>() { "N", "U", "I" };
            }

            // IMR considers unanswered and incomplete as deficient
            if (targetModel.Model_Name.ToUpper() == "IMR")
            {
                deficientAnswerValues = new List<string>() { "N", "U", "I" };
            }

            // RRA also considers unanswered and incomplete as deficient
            if (targetModel.Model_Name.ToUpper() == "RRA")
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
            }

            // VADR considers unanswered as deficient
            if (targetModel.Model_Name.ToUpper() == "VADR")
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
            }

            // CPG
            if (targetModel.Model_Name.ToUpper() == "CPG")
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
            }

            // SSG - CHEMICAL can only be requested explicitly
            if (targetModel.Maturity_Model_Id == 18)
            {
                deficientAnswerValues = new List<string>() { "N", "U" };
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
        /// Primarily used for ACET which uses strings to describe their levels
        /// </summary>
        /// <param name="maturityLevel"></param>
        /// <returns></returns>
        private string GetLevelLabel(int maturityLevel, List<MATURITY_LEVELS> levels)
        {
            return levels.FirstOrDefault(x => x.Maturity_Level_Id == maturityLevel)?.Level_Name ?? "";
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
        /// Returns a block of data generally from the INFORMATION table plus a few others.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.INFORMATION GetIseInformation()
        {
            INFORMATION infodb = _context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();

            TinyMapper.Bind<INFORMATION, BasicReportData.INFORMATION>(config =>
            {
                config.Ignore(x => x.Additional_Contacts);
            });
            var info = TinyMapper.Map<INFORMATION, BasicReportData.INFORMATION>(infodb);

            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            info.Assessment_Date = assessment.Assessment_Date;

            info.Assessment_Effective_Date = assessment.AssessmentEffectiveDate;
            info.Assessment_Creation_Date = assessment.AssessmentCreatedDate;

            // Primary Assessor
            var user = _context.USERS.FirstOrDefault(x => x.UserId == assessment.AssessmentCreatorId);
            info.Assessor_Name = user != null ? FormatName(user.FirstName, user.LastName) : string.Empty;


            // Other Contacts
            info.Additional_Contacts = new List<string>();
            var contacts = _context.ASSESSMENT_CONTACTS
                .Where(ac => ac.Assessment_Id == _assessmentId
                        && ac.UserId != assessment.AssessmentCreatorId)
                .Include(u => u.User)
                .ToList();
            foreach (var c in contacts)
            {
                info.Additional_Contacts.Add(FormatName(c.FirstName, c.LastName));
            }

            // Include anything that was in the INFORMATION record's Additional_Contacts column
            if (infodb.Additional_Contacts != null)
            {
                string[] acLines = infodb.Additional_Contacts.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string c in acLines)
                {
                    info.Additional_Contacts.Add(c);
                }
            }

            info.UseStandard = assessment.UseStandard;
            info.UseMaturity = assessment.UseMaturity;
            info.UseDiagram = assessment.UseDiagram;

            // ACET properties
            info.Credit_Union_Name = assessment.CreditUnionName;
            info.Charter = assessment.Charter;

            info.Assets = 0;
            bool a = long.TryParse(assessment.Assets, out long assets);
            if (a)
            {
                info.Assets = assets;
            }

            // Maturity properties
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            if (myModel != null)
            {
                info.QuestionsAlias = myModel.model.Questions_Alias;
            }

            return info;
        }


        /// <summary>
        /// Returns a list of domains for the assessment.
        /// </summary>
        /// <returns></returns>
        public List<string> GetDomains()
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            // Get all domains for this maturity model
            var domains = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id && x.Type_Id == 1).ToList();

            return domains.Select(d => d.Title).ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="g"></param>
        /// <param name="parentID"></param>
        /// <param name="allGroupings"></param>
        /// <param name="questions"></param>
        /// <param name="answers"></param>
        public void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers)
        {
            var mySubgroups = allGroupings.Where(x => x.Parent_Id == parentID).OrderBy(x => x.Sequence).ToList();

            if (mySubgroups.Count == 0)
            {
                return;
            }

            foreach (var sg in mySubgroups)
            {
                var newGrouping = new MaturityGrouping()
                {
                    GroupingID = sg.Grouping_Id,
                    GroupingType = sg.Type.Grouping_Type_Name,
                    Title = sg.Title,
                    Description = sg.Description,
                    Abbreviation = sg.Abbreviation
                };

                g.SubGroupings.Add(newGrouping);


                // are there any questions that belong to this grouping?
                var myQuestions = questions.Where(x => x.Grouping_Id == newGrouping.GroupingID).ToList();

                var parentQuestionIDs = myQuestions.Select(x => x.Parent_Question_Id).Distinct().ToList();

                foreach (var myQ in myQuestions)
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == myQ.Mat_Question_Id).FirstOrDefault();

                    var qa = new QuestionAnswer()
                    {
                        DisplayNumber = myQ.Question_Title,
                        QuestionId = myQ.Mat_Question_Id,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        QuestionType = "Maturity",
                        QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>"),
                        Answer = answer?.a.Answer_Text,
                        AltAnswerText = answer?.a.Alternate_Justification,
                        //freeResponseAnswer= answer?.a.Free_Response_Answer,
                        Comment = answer?.a.Comment,
                        Feedback = answer?.a.FeedBack,
                        MarkForReview = answer?.a.Mark_For_Review ?? false,
                        Reviewed = answer?.a.Reviewed ?? false,
                        Is_Maturity = true,
                        MaturityLevel = myQ.Maturity_Level_Id,
                        IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id),
                        SetName = string.Empty,
                        FreeResponseAnswer = answer?.a.Free_Response_Answer
                    };

                    if (answer != null)
                    {
                        TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                        TinyMapper.Map(answer.b, qa);

                        // db view still uses the term "HasDiscovery" - map to "HasObservation"
                        qa.HasObservation = answer.b.HasDiscovery ?? false;
                    }

                    newGrouping.Questions.Add(qa);
                }

                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingID, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControls(string applicationMode)
        {
            var lang = _tokenManager.GetCurrentLanguage();

            _questionRequirement.InitializeManager(_assessmentId);

            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            string level = _questionRequirement.StandardLevel == null ? "L" : _questionRequirement.StandardLevel;

            List<ControlRow> controlRows = new List<ControlRow>();

            if (applicationMode == CSETWebCore.Business.Assessment.AssessmentMode.QUESTIONS_BASED_APPLICATION_MODE)
            {
                var qQ = (from rs in _context.REQUIREMENT_SETS
                          join r in _context.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                          join rl in _context.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                          join s in _context.SETS on rs.Set_Name equals s.Set_Name
                          join av in _context.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                          join rqs in _context.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                          join qu in _context.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                          join a in _context.Answer_Questions_No_Components on qu.Question_Id equals a.Question_Or_Requirement_Id
                          where rl.Standard_Level == level && av.Selected == true && rl.Level_Type == "NST"
                           && av.Assessment_Id == _assessmentId && a.Assessment_Id == _assessmentId
                          orderby r.Standard_Category, r.Standard_Sub_Category, rs.Requirement_Sequence
                          select new { r, rl, s, qu, a }).ToList();

                foreach (var q in qQ)
                {
                    controlRows.Add(new ControlRow()
                    {
                        Requirement_Id = q.r.Requirement_Id,
                        Requirement_Text = q.r.Requirement_Text,
                        Answer_Text = q.a.Answer_Text,
                        Comment = q.a.Comment,
                        Question_Id = q.qu.Question_Id,
                        Requirement_Title = q.r.Requirement_Title,
                        Short_Name = q.s.Short_Name,
                        Simple_Question = q.qu.Simple_Question,
                        Standard_Category = q.r.Standard_Category,
                        Standard_Sub_Category = q.r.Standard_Sub_Category,
                        Standard_Level = q.rl.Standard_Level
                    });
                }
            }
            else
            {
                var qR = (from rs in _context.REQUIREMENT_SETS
                          join r in _context.NEW_REQUIREMENT on rs.Requirement_Id equals r.Requirement_Id
                          join rl in _context.REQUIREMENT_LEVELS on r.Requirement_Id equals rl.Requirement_Id
                          join s in _context.SETS on rs.Set_Name equals s.Set_Name
                          join av in _context.AVAILABLE_STANDARDS on s.Set_Name equals av.Set_Name
                          join rqs in _context.REQUIREMENT_QUESTIONS_SETS on new { r.Requirement_Id, s.Set_Name } equals new { rqs.Requirement_Id, rqs.Set_Name }
                          join qu in _context.NEW_QUESTION on rqs.Question_Id equals qu.Question_Id
                          join a in _context.Answer_Requirements on r.Requirement_Id equals a.Question_Or_Requirement_Id
                          where rl.Standard_Level == level && av.Selected == true && rl.Level_Type == "NST"
                           && av.Assessment_Id == _assessmentId && a.Assessment_Id == _assessmentId
                          orderby r.Standard_Category, r.Standard_Sub_Category, rs.Requirement_Sequence
                          select new { r, rl, s, qu, a }).ToList();

                foreach (var q in qR)
                {
                    controlRows.Add(new ControlRow()
                    {
                        Requirement_Id = q.a.Question_Or_Requirement_Id,
                        Requirement_Text = q.r.Requirement_Text,
                        Answer_Text = q.a.Answer_Text,
                        Comment = q.a.Comment,
                        Question_Id = q.qu.Question_Id,
                        Requirement_Title = q.r.Requirement_Title,
                        Short_Name = q.s.Short_Name,
                        Simple_Question = q.qu.Simple_Question,
                        Standard_Category = q.r.Standard_Category,
                        Standard_Sub_Category = q.r.Standard_Sub_Category,
                        Standard_Level = q.rl.Standard_Level
                    });
                }
            }



            //get all the questions for this control 
            //determine the percent implemented.                 
            int prev_requirement_id = 0;
            int questionCount = 0;
            int questionsAnswered = 0;
            BasicReportData.RequirementControl control = null;
            List<BasicReportData.Control_Questions> questions = null;

            // The response
            List<BasicReportData.RequirementControl> controls = [];

            foreach (var a in controlRows)
            {
                if (prev_requirement_id != a.Requirement_Id)
                {
                    questionCount = 0;
                    questionsAnswered = 0;
                    questions = new List<BasicReportData.Control_Questions>();


                    // look for translations
                    var r = _overlay.GetRequirement(a.Requirement_Id, lang);
                    var c = _overlay.GetPropertyValue("STANDARD_CATEGORY", a.Standard_Category.ToLower(), lang);
                    var s = _overlay.GetPropertyValue("STANDARD_CATEGORY", a.Standard_Sub_Category.ToLower(), lang);

                    // Check for custom parameters
                    var customParameter = (from pa in _context.PARAMETER_ASSESSMENT
                                           join pr in _context.PARAMETER_REQUIREMENTS
                                           on pa.Parameter_ID equals pr.Parameter_Id
                                           join p in _context.PARAMETERS
                                           on pa.Parameter_ID equals p.Parameter_ID
                                           where pr.Requirement_Id == a.Requirement_Id 
                                           where pa.Assessment_ID == _assessmentId
                                           select new
                                           {
                                               pa.Parameter_Value_Assessment,
                                               pa.Assessment_ID,
                                               p.Parameter_Name
                                           }).Distinct().ToList();

                    var QuestionRequirementText = r?.RequirementText ?? a.Requirement_Text;

                    // Replace parameter in requirement text if custom parameter is found 
                    if (customParameter != null)
                    {
                        // Replace text or escape quickly if parameter is not found in original text
                        foreach (var param in customParameter)
                        {
                            if (QuestionRequirementText.Contains(param.Parameter_Name))
                            {
                                var newText = Regex.Replace(r?.RequirementText ?? a.Requirement_Text, param.Parameter_Name.Replace("[", "\\[").Replace("]", "\\]"), param.Parameter_Value_Assessment);

                                if (r?.RequirementText != null)
                                {
                                    r.RequirementText = newText;
                                }
                                else
                                {
                                    a.Requirement_Text = newText;
                                }
                            }
                        }
                    }

                    control = new BasicReportData.RequirementControl()
                    {
                        ControlDescription = r?.RequirementText ?? a.Requirement_Text,
                        RequirementTitle = a.Requirement_Title,
                        Level = a.Standard_Level,
                        StandardShortName = a.Short_Name,
                        Standard_Category = c ?? a.Standard_Category,
                        SubCategory = s ?? a.Standard_Sub_Category,
                        Control_Questions = questions
                    };



                    controls.Add(control);
                }

                questionCount++;

                switch (a.Answer_Text)
                {
                    case Constants.Constants.ALTERNATE:
                    case Constants.Constants.YES:
                        questionsAnswered++;
                        break;
                }

                questions.Add(new BasicReportData.Control_Questions()
                {
                    Answer = a.Answer_Text,
                    Comment = a.Comment,
                    Simple_Question = a.Simple_Question
                });

                control.ImplementationStatus = StatUtils.Percentagize(questionsAnswered, questionCount, 2).ToString("##.##");
                prev_requirement_id = a.Requirement_Id;
            }

            return controls;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<BasicReportData.RequirementControl> GetControlsDiagram(string applicationMode)

        {

            List<BasicReportData.RequirementControl> controls = new List<BasicReportData.RequirementControl>();
            _questionRequirement.InitializeManager(_assessmentId);

            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            string level = _questionRequirement.StandardLevel == null ? "L" : _questionRequirement.StandardLevel;

            List<ControlRow> controlRows = new List<ControlRow>();

            var qQ = (from rs in _context.Answer_Components_Default
                      orderby rs.Question_Group_Heading
                      where rs.Assessment_Id == _assessmentId
                      select new { rs }).ToList();

            foreach (var q in qQ)
            {
                controlRows.Add(new ControlRow()
                {
                    Requirement_Id = q.rs.heading_pair_id,
                    Requirement_Text = q.rs.Sub_Heading_Question_Description,
                    Answer_Text = q.rs.Answer_Text,
                    Comment = q.rs.Comment,
                    Question_Id = q.rs.Question_Id,
                    Requirement_Title = q.rs.Question_Group_Heading,
                    Short_Name = q.rs.ComponentName,
                    Simple_Question = q.rs.QuestionText,
                    Standard_Category = q.rs.Question_Group_Heading,
                    Standard_Sub_Category = q.rs.Universal_Sub_Category,
                    Standard_Level = q.rs.SAL
                });
            }

            //get all the questions for this control 
            //determine the percent implemented.                 
            int prev_requirement_id = 0;
            int questionCount = 0;
            int questionsAnswered = 0;
            BasicReportData.RequirementControl control = null;
            List<BasicReportData.Control_Questions> questions = null;

            foreach (var a in controlRows)
            {
                if (prev_requirement_id != a.Requirement_Id)
                {
                    questionCount = 0;
                    questionsAnswered = 0;
                    questions = new List<BasicReportData.Control_Questions>();
                    control = new BasicReportData.RequirementControl()
                    {
                        ControlDescription = a.Requirement_Text,
                        RequirementTitle = a.Requirement_Title,
                        Level = a.Standard_Level,
                        StandardShortName = a.Short_Name,
                        Standard_Category = a.Standard_Category,
                        SubCategory = a.Standard_Sub_Category,
                        Control_Questions = questions
                    };
                    controls.Add(control);
                }
                questionCount++;

                switch (a.Answer_Text)
                {
                    case Constants.Constants.ALTERNATE:
                    case Constants.Constants.YES:
                        questionsAnswered++;
                        break;
                }

                questions.Add(new BasicReportData.Control_Questions()
                {
                    Answer = a.Answer_Text,
                    Comment = a.Comment,
                    Simple_Question = a.Simple_Question
                });

                control.ImplementationStatus = StatUtils.Percentagize(questionsAnswered, questionCount, 2).ToString("##.##");
                prev_requirement_id = a.Requirement_Id;
            }

            return controls;
        }

        public List<List<DiagramZones>> GetDiagramZones()
        {
            var level = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();


            var rval1 = (from c in _context.ASSESSMENT_DIAGRAM_COMPONENTS
                         join s in _context.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                         where c.Assessment_Id == _assessmentId && c.Zone_Id == null
                         orderby s.Symbol_Name, c.label
                         select new DiagramZones
                         {
                             Diagram_Component_Type = s.Symbol_Name,
                             label = c.label,
                             Zone_Name = "No Assigned Zone",
                             Universal_Sal_Level = level == null ? "Low" : level.Selected_Sal_Level
                         }).ToList();

            var rval = (from c in _context.ASSESSMENT_DIAGRAM_COMPONENTS
                        join z in _context.DIAGRAM_CONTAINER on c.Zone_Id equals z.Container_Id
                        join s in _context.COMPONENT_SYMBOLS on c.Component_Symbol_Id equals s.Component_Symbol_Id
                        where c.Assessment_Id == _assessmentId
                        orderby s.Symbol_Name, c.label
                        select new DiagramZones
                        {
                            Diagram_Component_Type = s.Symbol_Name,
                            label = c.label,
                            Zone_Name = z.Name,
                            Universal_Sal_Level = z.Universal_Sal_Level
                        }).ToList();

            return rval.Union(rval1).GroupBy(u => u.Zone_Name).Select(grp => grp.ToList()).ToList();
        }


        public List<usp_getFinancialQuestions_Result> GetFinancialQuestions()
        {
            return _context.usp_getFinancialQuestions(_assessmentId).ToList();
        }


        public List<StandardQuestions> GetQuestionsForEachStandard()
        {
            var dblist = from a in _context.AVAILABLE_STANDARDS
                         join b in _context.NEW_QUESTION_SETS on a.Set_Name equals b.Set_Name
                         join c in _context.Answer_Questions on b.Question_Id equals c.Question_Or_Requirement_Id
                         join q in _context.NEW_QUESTION on c.Question_Or_Requirement_Id equals q.Question_Id
                         join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                         join s in _context.SETS on b.Set_Name equals s.Set_Name
                         where a.Selected == true && a.Assessment_Id == _assessmentId
                         && c.Assessment_Id == _assessmentId
                         orderby s.Short_Name, h.Question_Group_Heading, c.Question_Number
                         select new SimpleStandardQuestions()
                         {
                             ShortName = s.Short_Name,
                             Answer = c.Answer_Text,
                             CategoryAndNumber = h.Question_Group_Heading + " #" + c.Question_Number,
                             Question = q.Simple_Question,
                             QuestionId = q.Question_Id
                         };

            List<StandardQuestions> list = new List<StandardQuestions>();
            string lastshortname = "";
            List<SimpleStandardQuestions> qlist = new List<SimpleStandardQuestions>();
            foreach (var a in dblist.ToList())
            {
                if (a.ShortName != lastshortname)
                {
                    qlist = new List<SimpleStandardQuestions>();
                    list.Add(new StandardQuestions()
                    {
                        Questions = qlist,
                        StandardShortName = a.ShortName
                    });
                }
                lastshortname = a.ShortName;
                qlist.Add(a);
            }

            return list;
        }


        /// <summary>
        /// Returns a list of questions generated by components in the network.
        /// The questions correspond to the SAL level of each component's Zone level.
        /// Questions for components in hidden layers are not included.
        /// </summary>
        /// <returns></returns>
        public List<ComponentQuestion> GetComponentQuestions()
        {
            var l = new List<ComponentQuestion>();

            List<usp_getExplodedComponent> results = null;

            _context.LoadStoredProc("[usp_getExplodedComponent]")
              .WithSqlParam("assessment_id", _assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  results = handler.ReadToList<usp_getExplodedComponent>().OrderBy(c => c.ComponentName).ThenBy(c => c.QuestionText).ToList();
              });

            foreach (usp_getExplodedComponent q in results)
            {
                l.Add(new ComponentQuestion
                {
                    Answer = q.Answer_Text,
                    ComponentName = q.ComponentName,
                    Component_Symbol_Id = q.Component_Symbol_Id,
                    Question = q.QuestionText,
                    QuestionId = q.Question_Id,
                    LayerName = q.LayerName,
                    SAL = q.SAL,
                    Zone = q.ZoneName
                });
            }


            return l;
        }


        public List<usp_GetOverallRankedCategoriesPage_Result> GetTop5Categories()
        {
            var lang = _tokenManager.GetCurrentLanguage();

            var categories = _context.usp_GetOverallRankedCategoriesPage(_assessmentId).Take(5).ToList();

            for (var i = 0; i < categories.Count; i++)
            {
                var cat = categories[i];
                cat.Question_Group_Heading = _overlay.GetValue("QUESTION_GROUP_HEADING", cat.QGH_Id.ToString(), lang)?.Value ?? cat.Question_Group_Heading;
            }

            return categories;
        }


        public List<RankedQuestions> GetTop5Questions()
        {
            return GetRankedQuestions().Take(5).ToList();
        }


        /// <summary>
        /// Returns a list of questions that have been answered "Alt"
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithAltJust> GetQuestionsWithAlternateJustification()
        {

            var results = new List<QuestionsWithAltJust>();

            // get any "A" answers that currently apply

            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
                .Where(ans => ans.Answer_Text == "A").ToList();

            if (relevantAnswers.Count == 0)
            {
                return results;
            }

            bool requirementMode = relevantAnswers[0].Is_Requirement;

            // include Question or Requirement contextual information
            if (requirementMode)
            {
                var query = from ans in relevantAnswers
                            join req in _context.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                            select new QuestionsWithAltJust()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                AlternateJustification = ans.Alternate_Justification,
                                Question = req.Requirement_Text
                            };

                return query.ToList();
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsWithAltJust()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                AlternateJustification = ans.Alternate_Justification,
                                Question = q.Simple_Question
                            };

                return query.ToList();
            }

        }


        /// <summary>
        /// Returns a list of questions that have comments.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsWithComments> GetQuestionsWithComments()
        {

            var results = new List<QuestionsWithComments>();

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
                .Where(ans => !string.IsNullOrEmpty(ans.Comment))
                .ToList();

            if (relevantAnswers.Count == 0)
            {
                return results;
            }

            bool requirementMode = relevantAnswers[0].Is_Requirement;

            // include Question or Requirement contextual information
            if (requirementMode)
            {
                var query = from ans in relevantAnswers
                            join req in _context.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                            select new QuestionsWithComments()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                Question = req.Requirement_Text,
                                Comment = ans.Comment
                            };

                return query.ToList();
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsWithComments()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                Question = q.Simple_Question,
                                Comment = ans.Comment
                            };

                return query.ToList();
            }
        }


        /// <summary>
        /// Returns a list of questions that have been marked for review.
        /// </summary>
        /// <returns></returns>
        public List<QuestionsMarkedForReview> GetQuestionsMarkedForReview()
        {

            var results = new List<QuestionsMarkedForReview>();

            // get any "marked for review" or commented answers that currently apply
            var relevantAnswers = new RelevantAnswers().GetAnswersForAssessment(_assessmentId, _context)
                .Where(ans => ans.Mark_For_Review)
                .ToList();

            if (relevantAnswers.Count == 0)
            {
                return results;
            }

            bool requirementMode = relevantAnswers[0].Is_Requirement;

            // include Question or Requirement contextual information
            if (requirementMode)
            {
                var query = from ans in relevantAnswers
                            join req in _context.NEW_REQUIREMENT on ans.Question_Or_Requirement_ID equals req.Requirement_Id
                            select new QuestionsMarkedForReview()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = req.Standard_Category + " - " + req.Requirement_Title,
                                Question = req.Requirement_Text
                            };

                return query.ToList();
            }
            else
            {
                var query = from ans in relevantAnswers
                            join q in _context.NEW_QUESTION on ans.Question_Or_Requirement_ID equals q.Question_Id
                            join h in _context.vQUESTION_HEADINGS on q.Heading_Pair_Id equals h.Heading_Pair_Id
                            orderby h.Question_Group_Heading
                            select new QuestionsMarkedForReview()
                            {
                                Answer = ans.Answer_Text,
                                CategoryAndNumber = h.Question_Group_Heading + " #" + ans.Question_Number,
                                Question = q.Simple_Question
                            };

                return query.ToList();
            }

        }


        public List<RankedQuestions> GetRankedQuestions()
        {
            var lang = _tokenManager.GetCurrentLanguage();

            var rm = new Question.RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _tokenManager);

            List<RankedQuestions> list = new List<RankedQuestions>();
            List<usp_GetRankedQuestions_Result> rankedQuestionList = _context.usp_GetRankedQuestions(_assessmentId).ToList();
            foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
            {
                if (q.RequirementId != null)
                {
                    var reqOverlay = _overlay.GetRequirement((int)q.RequirementId, lang);
                    if (reqOverlay != null)
                    {
                        q.QuestionText = reqOverlay.RequirementText;
                    }
                }


                q.QuestionText = rm.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);

                q.Category = _overlay.GetPropertyValue("STANDARD_CATEGORY", q.Category.ToLower(), lang) ?? q.Category;

                list.Add(new RankedQuestions()
                {
                    Answer = q.AnswerText,
                    CategoryAndNumber = q.Category + " #" + q.QuestionRef,
                    Level = q.Level,
                    Question = q.QuestionText,
                    Rank = q.Rank ?? 0
                });
            }

            return list;
        }


        public List<DocumentLibraryTable> GetDocumentLibrary()
        {
            List<DocumentLibraryTable> list = new List<DocumentLibraryTable>();
            var docs = from a in _context.DOCUMENT_FILE
                       where a.Assessment_Id == _assessmentId
                       select a;
            foreach (var doc in docs)
            {
                var dlt = new DocumentLibraryTable()
                {
                    DocumentTitle = doc.Title,
                    FileName = doc.Path
                };

                if (dlt.DocumentTitle == "click to edit title")
                {
                    dlt.DocumentTitle = "(untitled)";
                }

                list.Add(dlt);
            }

            return list;
        }


        public BasicReportData.OverallSALTable GetNistSals()
        {
            var manager = new NistSalBusiness(_context, _assessmentUtil, _tokenManager);
            var sals = manager.CalculatedNist(_assessmentId);
            List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
            var infos = _context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToList();
            Dictionary<string, string> typeToLevel = _context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToDictionary(x => x.CIA_Type, x => x.DropDownValueLevel);

            BasicReportData.OverallSALTable overallSALTable = new BasicReportData.OverallSALTable()
            {
                OSV = sals.Selected_Sal_Level,
                Q_AV = sals.ALevel,
                Q_CV = sals.CLevel,
                Q_IV = sals.ILevel
            };

            bool ok;
            string l;
            ok = typeToLevel.TryGetValue(Constants.Constants.Availabilty, out l);
            overallSALTable.IT_AV = ok ? l : "Low";
            ok = typeToLevel.TryGetValue(Constants.Constants.Confidentiality, out l);
            overallSALTable.IT_CV = ok ? l : "Low";
            ok = typeToLevel.TryGetValue(Constants.Constants.Integrity, out l);
            overallSALTable.IT_IV = ok ? l : "Low";

            return overallSALTable;
        }


        public List<BasicReportData.CNSSSALJustificationsTable> GetNistInfoTypes()
        {
            List<BasicReportData.CNSSSALJustificationsTable> list = new List<BasicReportData.CNSSSALJustificationsTable>();
            var infos = _context.CNSS_CIA_JUSTIFICATIONS.Where(x => x.Assessment_Id == _assessmentId).ToList();
            foreach (CNSS_CIA_JUSTIFICATIONS info in infos)
            {
                list.Add(new BasicReportData.CNSSSALJustificationsTable()
                {
                    CIA_Type = info.CIA_Type,
                    Justification = info.Justification
                });
            }

            return list;
        }


        /// <summary>
        /// Returns SAL CIA values for the assessment.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.OverallSALTable GetSals()
        {
            var sals = (from a in _context.STANDARD_SELECTION
                        join b in _context.ASSESSMENT_SELECTED_LEVELS on a.Assessment_Id equals b.Assessment_Id
                        where a.Assessment_Id == _assessmentId
                        select new { a, b }).ToList();

            string OSV = "Low";
            string Q_CV = "Low";
            string Q_IV = "Low";
            string Q_AV = "Low";
            foreach (var s in sals)
            {
                OSV = s.a.Selected_Sal_Level;
                switch (s.b.Level_Name)
                {
                    case "Confidence_Level":
                        Q_CV = s.b.Standard_Specific_Sal_Level;
                        break;
                    case "Integrity_Level":
                        Q_IV = s.b.Standard_Specific_Sal_Level;
                        break;
                    case "Availability_Level":
                        Q_AV = s.b.Standard_Specific_Sal_Level;
                        break;
                }
            }

            // get active SAL type
            var standardSelection = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == _assessmentId).FirstOrDefault();

            return new BasicReportData.OverallSALTable()
            {
                OSV = OSV,
                Q_CV = Q_CV,
                Q_AV = Q_AV,
                Q_IV = Q_IV,
                LastSalDeterminationType = standardSelection.Last_Sal_Determination_Type
            };
        }


        /// <summary>
        /// Returns a block of data generally from the INFORMATION table plus a few others.
        /// </summary>
        /// <returns></returns>
        public BasicReportData.INFORMATION GetInformation()
        {
            INFORMATION infodb = _context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();

            TinyMapper.Bind<INFORMATION, BasicReportData.INFORMATION>(config =>
            {
                config.Ignore(x => x.Additional_Contacts);
            });
            var info = TinyMapper.Map<INFORMATION, BasicReportData.INFORMATION>(infodb);

            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            info.Assessment_Date = assessment.Assessment_Date;

            info.Assessment_Effective_Date = assessment.AssessmentEffectiveDate;
            info.Assessment_Creation_Date = assessment.AssessmentCreatedDate;

            // Primary Assessor
            var user = _context.USERS.FirstOrDefault(x => x.UserId == assessment.AssessmentCreatorId);
            info.Assessor_Name = user != null ? FormatName(user.FirstName, user.LastName) : string.Empty;


            // Other Contacts
            info.Additional_Contacts = new List<string>();
            var contacts = _context.ASSESSMENT_CONTACTS
                .Where(ac => ac.Assessment_Id == _assessmentId
                        && ac.UserId != assessment.AssessmentCreatorId)
                .Include(u => u.User)
                .ToList();
            foreach (var c in contacts)
            {
                info.Additional_Contacts.Add(FormatName(c.FirstName, c.LastName));
            }

            // Include anything that was in the INFORMATION record's Additional_Contacts column
            if (infodb.Additional_Contacts != null)
            {
                string[] acLines = infodb.Additional_Contacts.Split(new[] { Environment.NewLine }, StringSplitOptions.RemoveEmptyEntries);
                foreach (string c in acLines)
                {
                    info.Additional_Contacts.Add(c);
                }
            }

            info.UseStandard = assessment.UseStandard;
            info.UseMaturity = assessment.UseMaturity;
            info.UseDiagram = assessment.UseDiagram;

            // ACET properties
            info.Credit_Union_Name = assessment.CreditUnionName;
            info.Charter = assessment.Charter;

            info.Assets = 0;
            bool a = long.TryParse(assessment.Assets, out long assets);
            if (a)
            {
                info.Assets = assets;
            }

            // Maturity properties
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model)
                .FirstOrDefault(x => x.Assessment_Id == _assessmentId);
            if (myModel != null)
            {
                info.QuestionsAlias = myModel.model.Questions_Alias;
            }

            return info;
        }


        /// <summary>
        /// Returns a list of individuals assigned to observations.
        /// </summary>
        /// <returns></returns>
        public List<Individual> GetObservationIndividuals()
        {
            var observations = (from a in _context.FINDING_CONTACT
                                join b in _context.FINDING on a.Finding_Id equals b.Finding_Id
                                join c in _context.ANSWER on b.Answer_Id equals c.Answer_Id
                                join mq in _context.MATURITY_QUESTIONS on c.Question_Or_Requirement_Id equals mq.Mat_Question_Id into mq1
                                from mq in mq1.DefaultIfEmpty()
                                join r in _context.NEW_REQUIREMENT on c.Question_Or_Requirement_Id equals r.Requirement_Id into r1
                                from r in r1.DefaultIfEmpty()
                                join d in _context.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals d.Assessment_Contact_Id
                                join i in _context.IMPORTANCE on b.Importance_Id equals i.Importance_Id into i1
                                from i in i1.DefaultIfEmpty()
                                where c.Assessment_Id == _assessmentId
                                orderby a.Assessment_Contact_Id, b.Answer_Id, b.Finding_Id
                                select new { a, b, c, mq, r, d, i.Value }).ToList();


            // Get any associated questions to get their display reference
            var standardQuestions = GetQuestionsForEachStandard();
            var componentQuestions = GetComponentQuestions();


            List<Individual> individualList = new List<Individual>();

            int contactId = 0;
            Individual individual = null;

            foreach (var f in observations)
            {
                if (contactId != f.a.Assessment_Contact_Id)
                {
                    individual = new Individual()
                    {
                        Observations = new List<Observations>(),
                        INDIVIDUALFULLNAME = FormatName(f.d.FirstName, f.d.LastName)
                    };

                    individualList.Add(individual);
                }
                contactId = f.a.Assessment_Contact_Id;


                TinyMapper.Bind<FINDING, Observations>();
                Observations obs = TinyMapper.Map<Observations>(f.b);
                obs.Observation = f.b.Summary;
                obs.ResolutionDate = f.b.Resolution_Date;
                obs.Importance = f.Value;

                // get the question identifier and text
                GetQuestionTitleAndText(f, standardQuestions, componentQuestions, f.c.Answer_Id,
                    out string qid, out string qtxt);

                var temp = _maturityBusiness.GetMaturityModel(_assessmentId).ModelTitle;
                if (_maturityBusiness.GetMaturityModel(_assessmentId).ModelName == "CIE")
                {
                    GetQuestionTitleAndTextForCie(f, standardQuestions, componentQuestions, f.c.Answer_Id,
                        out qid, out qtxt);
                }

                obs.QuestionIdentifier = qid;
                obs.QuestionText = qtxt;


                var othersList = (from a in f.b.FINDING_CONTACT
                                  join b in _context.ASSESSMENT_CONTACTS on a.Assessment_Contact_Id equals b.Assessment_Contact_Id
                                  select FormatName(b.FirstName, b.LastName)).ToList();
                obs.OtherContacts = string.Join(",", othersList);

                individual.Observations.Add(obs);
            }

            return individualList;
        }


        /// <summary>
        /// Formats an identifier for the corresponding question. 
        /// Also returns the question text with parameters applied, in the
        /// case of a requirement.
        /// 
        /// If the user's language is non-English, attempts to overlay the
        /// question text with the translated version.
        /// </summary>
        /// <returns></returns>
        private void GetQuestionTitleAndText(dynamic f,
            List<StandardQuestions> stdList, List<ComponentQuestion> compList,
            int answerId,
            out string identifier, out string questionText)
        {
            identifier = "";
            questionText = "";
            var lang = _tokenManager.GetCurrentLanguage();

            switch (f.c.Question_Type)
            {
                case "Question":
                    foreach (var s in stdList)
                    {
                        var q1 = s.Questions.FirstOrDefault(x => x.QuestionId == f.c.Question_Or_Requirement_Id);
                        if (q1 != null)
                        {
                            identifier = q1.CategoryAndNumber;
                            questionText = q1.Question;
                            return;
                        }
                    }

                    return;

                case "Component":
                    var q2 = compList.FirstOrDefault(x => x.QuestionId == f.c.Question_Or_Requirement_Id);
                    if (q2 != null)
                    {
                        identifier = q2.ComponentName;
                        questionText = q2.Question;
                    }

                    return;

                case "Requirement":
                    identifier = f.r.Requirement_Title;
                    var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _tokenManager);
                    questionText = rb.ResolveParameters(f.r.Requirement_Id, answerId, f.r.Requirement_Text);

                    // translate
                    questionText = _overlay.GetRequirement(f.r.Requirement_Id, lang)?.RequirementText ?? questionText;

                    return;

                case "Maturity":

                    identifier = f.mq.Question_Title;
                    questionText = f.mq.Question_Text;

                    // CPG is a special case
                    if (!String.IsNullOrEmpty(f.mq.Security_Practice))
                    {
                        questionText = f.mq.Security_Practice;
                    }

                    // overlay
                    MaturityQuestionOverlay o = _overlay.GetMaturityQuestion(f.mq.Mat_Question_Id, lang);
                    if (o != null)
                    {
                        identifier = o.QuestionTitle;
                        questionText = o.QuestionText;
                    }
                    return;

                default:
                    return;
            }
        }


        /// <summary>
        /// Formats the Title for CIE observations the way they want
        /// </summary>
        /// <returns></returns>
        private void GetQuestionTitleAndTextForCie(dynamic f,
            List<StandardQuestions> stdList, List<ComponentQuestion> compList,
            int answerId,
            out string identifier, out string questionText)
        {
            identifier = "";
            questionText = "";
            var lang = _tokenManager.GetCurrentLanguage();

            identifier = f.mq.Question_Title;
            questionText = f.mq.Question_Text;
            int groupId = f.mq.Grouping_Id ?? 0;

            var groupRow = _context.MATURITY_GROUPINGS.Where(x => x.Grouping_Id == groupId).FirstOrDefault();
            int principleNumber = 0;
            int phaseNumber = 0;

            if (groupRow.Group_Level == 2)
            {
                // tracking the principle number
                principleNumber = groupRow.Sequence;
                identifier = "Principle " + principleNumber + " - " + identifier;
            }
            else if (groupRow.Group_Level == 3)
            {
                // tracking the phase number
                // the -1 is because the "General" grouping is first at Sequence = 1, but it's hidden from the user for now (request from the client)
                phaseNumber = groupRow.Sequence - 1;

                // finding the principle number
                groupRow = _context.MATURITY_GROUPINGS.Where(x => x.Grouping_Id == groupRow.Parent_Id).FirstOrDefault();
                principleNumber = groupRow.Sequence;

                identifier = "Principle " + principleNumber + " - Phase " + phaseNumber + " - " + identifier;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public GenSALTable GetGenSals()
        {
            var gensalnames = _context.GEN_SAL_NAMES.ToList();
            var actualvalues = (from a in _context.GENERAL_SAL.Where(x => x.Assessment_Id == _assessmentId)
                                join b in _context.GEN_SAL_WEIGHTS on new { a.Sal_Name, a.Slider_Value } equals new { b.Sal_Name, b.Slider_Value }
                                select b).ToList();
            GenSALTable genSALTable = new GenSALTable();
            foreach (var a in gensalnames)
            {
                genSALTable.setValue(a.Sal_Name, "None");
            }
            foreach (var a in actualvalues)
            {
                genSALTable.setValue(a.Sal_Name, a.Display);
            }
            return genSALTable;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public MaturityReportData.MaturityModel GetBasicMaturityModel()
        {
            var query = (
                from amm in _context.AVAILABLE_MATURITY_MODELS
                join mm in _context.MATURITY_MODELS on amm.model_id equals mm.Maturity_Model_Id
                where amm.Assessment_Id == _assessmentId
                select new { amm, mm }
                ).FirstOrDefault();


            var response = new MaturityReportData.MaturityModel()
            {
                MaturityModelName = query.mm.Model_Name,
                TargetLevel = null
            };

            var asl = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == _assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();

            if (asl != null)
            {
                response.TargetLevel = int.Parse(asl.Standard_Specific_Sal_Level);
            }

            return response;
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


        /// <summary>
        /// Formats first and last name.  If the name is believed to be a domain\userid, 
        /// the userid is returned with the domain removed.
        /// </summary>
        /// <param name="firstName"></param>
        /// <param name="lastName"></param>
        /// <returns></returns>
        public string FormatName(string firstName, string lastName)
        {
            firstName = firstName.Trim();
            lastName = lastName.Trim();

            if (firstName.Length > 0 && lastName.Length > 0)
            {
                return string.Format("{0} {1}", firstName, lastName);
            }

            // if domain-qualified userid, remove domain
            if (firstName.IndexOf('\\') >= 0 && firstName.IndexOf(' ') < 0 && lastName.Length == 0)
            {
                return firstName.Substring(firstName.LastIndexOf('\\') + 1);
            }

            return string.Format("{0} {1}", firstName, lastName);
        }


        /// <summary>
        /// Gets all confidential types for report generation
        /// </summary>
        /// <returns></returns>
        public IEnumerable<CONFIDENTIAL_TYPE> GetConfidentialTypes()
        {
            return _context.CONFIDENTIAL_TYPE.OrderBy(x => x.ConfidentialTypeOrder);
        }

        private void NullOutNavigationPropeties(List<MatRelevantAnswers> list)
        {
            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            foreach (MatRelevantAnswers a in list)
            {
                a.ANSWER.Assessment = null;
                a.Mat.Maturity_Model = null;
                a.Mat.InverseParent_Question = null;
                a.Mat.Parent_Question = null;

                if (a.Mat.Grouping != null)
                {
                    a.Mat.Grouping.Maturity_Model = null;
                    a.Mat.Grouping.MATURITY_QUESTIONS = null;
                    a.Mat.Grouping.Type = null;
                }

                if (a.Mat.Maturity_Level != null)
                {
                    a.Mat.Maturity_Level.MATURITY_QUESTIONS = null;
                    a.Mat.Maturity_Level.Maturity_Model = null;
                }
            }
        }

        public List<SourceFiles> GetIseSourceFiles()
        {

            var data = (from g in _context.GEN_FILE
                        join a in _context.MATURITY_REFERENCES
                            on g.Gen_File_Id equals a.Gen_File_Id
                        join q in _context.MATURITY_QUESTIONS
                             on a.Mat_Question_Id equals q.Mat_Question_Id
                        where q.Maturity_Model_Id == 10 && a.Source
                        select new { a, q, g }).ToList();

            List<SourceFiles> result = new List<SourceFiles>();
            SourceFiles file = new SourceFiles();
            foreach (var item in data)
            {
                try
                {
                    file.Mat_Question_Id = item.q.Mat_Question_Id;
                    file.Gen_File_Id = item.g.Gen_File_Id;
                    file.Title = item.g.Title;
                }
                catch
                {

                }
                result.Add(file);

            }

            return result;

        }

        public string GetCsetVersion()
        {
            return _context.CSET_VERSION.Select(x => x.Cset_Version1).FirstOrDefault();
        }
        public string GetAssessmentGuid(int assessmentId)
        {
            return _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Assessment_GUID).FirstOrDefault().ToString();
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
        //
    }
}



