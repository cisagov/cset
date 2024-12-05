//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Acet;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Maturity.Configuration;
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
using System.Threading.Tasks;
using static Lucene.Net.Util.Fst.Util;


namespace CSETWebCore.Business.Reports
{
    public partial class ReportsDataBusiness : IReportsDataBusiness
    {

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
    }
}