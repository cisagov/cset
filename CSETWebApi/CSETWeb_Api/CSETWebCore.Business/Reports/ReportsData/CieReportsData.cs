//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Reports
{
    public partial class ReportsDataBusiness : IReportsDataBusiness
    {

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