//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Diagnostics;
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;
using CSETWeb_Api.BusinessLogic.Scoring;
using Microsoft.EntityFrameworkCore;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Models;
using Microsoft.EntityFrameworkCore.Update;
using Nelibur.ObjectMapper;
using Newtonsoft.Json;
using Remotion.Linq.Clauses.ResultOperators;


namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    public class MaturityManager
    {

        /// <summary>
        /// Constructor.
        /// </summary>
        public MaturityManager()
        { }


        /// <summary>
        /// Returns the maturity model selected for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityModel GetMaturityModel(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var q = from amm in db.AVAILABLE_MATURITY_MODELS
                        from mm in db.MATURITY_MODELS
                        where amm.model_id == mm.Maturity_Model_Id && amm.Assessment_Id == assessmentId
                        select new MaturityModel()
                        {
                            ModelId = mm.Maturity_Model_Id,
                            ModelName = mm.Model_Name,
                            QuestionsAlias = mm.Questions_Alias
                        };
                var myModel = q.FirstOrDefault();

                if (myModel != null)
                {
                    myModel.MaturityTargetLevel = GetMaturityTargetLevel(assessmentId, db);

                    myModel.Levels = GetMaturityLevelsForModel(myModel.ModelId, 100, db);
                }

                return myModel;
            }
        }


        /// <summary>
        /// Gets the current target level for the assessment form ASSESSMENT_SELECTED_LEVELS.
        /// </summary>
        /// <returns></returns>
        public int GetMaturityTargetLevel(int assessmentId, CSET_Context db)
        {
            // The maturity target level is stored similar to a SAL level
            int targetLevel = 0;
            var myLevel = db.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level").FirstOrDefault();
            if (myLevel != null)
            {
                targetLevel = int.Parse(myLevel.Standard_Specific_Sal_Level);
            }
            return targetLevel;
        }


        /// <summary>
        /// Gets all domain remarks for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<MaturityDomainRemarks> GetDomainRemarks(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                List<MaturityDomainRemarks> remarks = new List<MaturityDomainRemarks>();
                foreach (var m in db.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == assessmentId).ToList())
                {
                    remarks.Add(new MaturityDomainRemarks()
                    {
                        Group_Id = m.Grouping_ID,
                        DomainRemark = m.DomainRemarks
                    });
                }
                return remarks;
            }

        }


        /// <summary>
        /// Persists a domain remark.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="remarks"></param>
        public void SetDomainRemarks(int assessmentId, MaturityDomainRemarks remarks)
        {
            using (var db = new CSET_Context())
            {
                var remark = db.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == assessmentId
                && x.Grouping_ID == remarks.Group_Id).FirstOrDefault();
                if (remark != null)
                {
                    remark.DomainRemarks = remarks.DomainRemark;
                }
                else
                {
                    if (remarks.DomainRemark != null)
                    {
                        db.MATURITY_DOMAIN_REMARKS.Add(new MATURITY_DOMAIN_REMARKS()
                        {
                            Assessment_Id = assessmentId,
                            Grouping_ID = remarks.Group_Id,
                            DomainRemarks = remarks.DomainRemark
                        });
                    }
                }
                db.SaveChanges();
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="myModel"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        public List<MaturityLevel> GetMaturityLevelsForModel(int maturityModelId, int targetLevel, CSET_Context db)
        {
            // get the levels and their display names
            var levels = new List<MaturityLevel>();
            foreach (var l in db.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == maturityModelId)
                .OrderBy(y => y.Level).ToList())
            {
                levels.Add(new MaturityLevel()
                {
                    Level = l.Level,
                    Label = l.Level_Name,
                    Applicable = l.Level <= targetLevel
                });
            }
            return levels;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<MaturityModel> GetAllModels()
        {
            var response = new List<MaturityModel>();

            using (var db = new CSET_Context())
            {
                var result = from a in db.MATURITY_MODELS
                             select new MaturityModel()
                             {
                                 MaturityTargetLevel = 1,
                                 ModelId = a.Maturity_Model_Id,
                                 ModelName = a.Model_Name,
                                 QuestionsAlias = a.Questions_Alias
                             };
                foreach (var m in result.ToList())
                {
                    response.Add(m);
                    m.Levels = GetMaturityLevelsForModel(m.ModelId, 100, db);
                }

                return response;
            }
        }


        /// <summary>
        /// Saves the selected maturity models.
        /// </summary>
        /// <returns></returns>
        public void PersistSelectedMaturityModel(int assessmentId, string modelName)
        {
            using (var db = new CSET_Context())
            {
                var result = db.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId);
                db.AVAILABLE_MATURITY_MODELS.RemoveRange(result);
                db.SaveChanges();

                var mm = db.MATURITY_MODELS.Where(x => x.Model_Name == modelName).FirstOrDefault();
                if (mm != null)
                {
                    db.AVAILABLE_MATURITY_MODELS.Add(new AVAILABLE_MATURITY_MODELS()
                    {
                        Assessment_Id = assessmentId,
                        model_id = mm.Maturity_Model_Id,
                        Selected = true
                    });
                }

                db.SaveChanges();
            }

            AssessmentUtil.TouchAssessment(assessmentId);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetMaturityLevel(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var result = db.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level").FirstOrDefault();
                if (result != null)
                {
                    if (int.TryParse(result.Standard_Specific_Sal_Level, out int level))
                    {
                        return level;
                    }
                }

                return 0;
            }
        }


        /// <summary>
        /// Connects the assessment to a Maturity_Level.
        /// </summary>
        public void PersistMaturityLevel(int assessmentId, int level)
        {
            using (var db = new CSET_Context())
            {
                // SAL selections live in ASSESSMENT_SELECTED_LEVELS, which
                // is more complex to allow for the different types of SALs
                // as well as the user's selection(s).

                var result = db.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level");
                if (result.Any())
                {
                    db.ASSESSMENT_SELECTED_LEVELS.RemoveRange(result);
                    db.SaveChanges();
                }

                db.ASSESSMENT_SELECTED_LEVELS.Add(new ASSESSMENT_SELECTED_LEVELS()
                {
                    Assessment_Id = assessmentId,
                    Level_Name = "Maturity_Level",
                    Standard_Specific_Sal_Level = level.ToString()
                });

                db.SaveChanges();
            }

            AssessmentUtil.TouchAssessment(assessmentId);
        }

        private AVAILABLE_MATURITY_MODELS processModelDefaults(CSET_Context db, int assessmentId, bool isAcetInstallation)
        {
            //if the available maturity model is not selected and the application is CSET
            //the default is EDM
            //if the application is ACET the default is ACET

            var myModel = db.AVAILABLE_MATURITY_MODELS
              .Include(x => x.model_)
              .Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (myModel == null)
            {
                myModel = new AVAILABLE_MATURITY_MODELS()
                {
                    Assessment_Id = assessmentId,
                    model_id = isAcetInstallation ? 1 : 3,
                    Selected = true
                };
                db.AVAILABLE_MATURITY_MODELS.Add(myModel);
                db.SaveChanges();
            }

            return myModel;
        }

        public object GetEdmPercentScores(int assessmentId)
        {
            EDMScoring scoring = new EDMScoring();
            return scoring.GetPercentageScores(assessmentId);
        }


        /// <summary>
        /// Assembles a response consisting of maturity settings for the assessment
        /// as well as the question set in its hierarchy of domains, practices, etc.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityResponse GetMaturityQuestions(int assessmentId, bool isAcetInstallation, bool fill)
        {
            var response = new MaturityResponse();

            using (var db = new CSET_Context())
            {
                if (fill)
                {
                    db.FillEmptyMaturityQuestionsForAnalysis(assessmentId);
                }

                var myModel = processModelDefaults(db, assessmentId, isAcetInstallation);


                var myModelDefinition = db.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == myModel.model_id).FirstOrDefault();

                if (myModelDefinition == null)
                {
                    return response;
                }


                response.ModelName = myModelDefinition.Model_Name;

                response.QuestionsAlias = myModelDefinition.Questions_Alias ?? "Questions";


                if (myModelDefinition.Answer_Options != null)
                {
                    response.AnswerOptions = myModelDefinition.Answer_Options.Split(',').ToList();
                    response.AnswerOptions.ForEach(x => x = x.Trim());
                }


                response.MaturityTargetLevel = this.GetMaturityTargetLevel(assessmentId, db);

                if (response.ModelName == "ACET")
                {
                    response.OverallIRP = new ACETDashboardManager().GetOverallIrpNumber(assessmentId);
                    response.MaturityTargetLevel = response.OverallIRP;
                }


                // get the levels and their display names for this model
                response.Levels = this.GetMaturityLevelsForModel(myModel.model_id, response.MaturityTargetLevel, db);



                // Get all maturity questions for the model regardless of level.
                // The user may choose to see questions above the target level via filtering. 
                var questions = db.MATURITY_QUESTIONS
                    .Include(x => x.Maturity_LevelNavigation)
                    .Where(q =>
                    myModel.model_id == q.Maturity_Model_Id).ToList();


                // Get all MATURITY answers for the assessment
                var answers = from a in db.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Maturity")
                              from b in db.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                              select new FullAnswer() { a = a, b = b };


                // Get all subgroupings for this maturity model
                var allGroupings = db.MATURITY_GROUPINGS
                    .Include(x => x.Type)
                    .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();


                // Recursively build the grouping/question hierarchy
                var tempModel = new MaturityGrouping();
                BuildSubGroupings(tempModel, null, allGroupings, questions, answers.ToList());

                //GRAB all the domain remarks and assign them if necessary
                Dictionary<int, MATURITY_DOMAIN_REMARKS> domainRemarks =
                    db.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == assessmentId)
                    .ToDictionary(x => x.Grouping_ID, x => x);
                foreach (MaturityGrouping g in tempModel.SubGroupings)
                {
                    MATURITY_DOMAIN_REMARKS dm;
                    if (domainRemarks.TryGetValue(g.GroupingID, out dm))
                    {
                        g.DomainRemark = dm.DomainRemarks;
                    }
                }

                response.Groupings = tempModel.SubGroupings;


                // Add any glossary terms
                response.Glossary = this.GetGlossaryEntries(myModel.model_id);
            }

            return response;
        }


        /// <summary>
        /// Recursive method that builds subgroupings for the specified group.
        /// It also attaches any questions pertinent to this group.
        /// </summary>
        private void BuildSubGroupings(MaturityGrouping g, int? parentID,
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
                        Comment = answer?.a.Comment,
                        Feedback = answer?.a.Feedback,
                        MarkForReview = answer?.a.Mark_For_Review ?? false,
                        Reviewed = answer?.a.Reviewed ?? false,
                        Is_Maturity = true,
                        MaturityLevel = myQ.Maturity_LevelNavigation.Level,
                        MaturityLevelName = myQ.Maturity_LevelNavigation.Level_Name,
                        IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id),
                        SetName = string.Empty
                    };

                    if (answer != null)
                    {
                        TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                        TinyMapper.Map(answer.b, qa);
                    }

                    newGrouping.Questions.Add(qa);
                }

                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingID, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(int assessmentId, Answer answer)
        {
            var db = new CSET_Context();

            // Find the Maturity Question
            var question = db.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == answer.QuestionId).FirstOrDefault();

            if (question == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }


            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }

            ANSWER dbAnswer = db.ANSWER.Where(x => x.Assessment_Id == assessmentId
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Question_Type == answer.QuestionType).FirstOrDefault();


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = assessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Type = answer.QuestionType;
            dbAnswer.Question_Number = answer.QuestionNumber;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.Feedback = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;

            db.ANSWER.AddOrUpdate(dbAnswer, x => x.Answer_Id);
            db.SaveChanges();

            AssessmentUtil.TouchAssessment(assessmentId);

            return dbAnswer.Answer_Id;
        }


        /// <summary>
        /// Returns the percentage of maturity questions that have been answered for the 
        /// current maturity level (IRP).
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public double GetAnswerCompletionRate(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var targetLevel = new ACETDashboardManager().GetOverallIrpNumber(assessmentId);

                var answerDistribution = db.AcetAnswerDistribution(assessmentId, targetLevel).ToList();

                var answeredCount = 0;
                var totalCount = 0;
                foreach (var d in answerDistribution)
                {
                    if (d.Answer_Text != "U")
                    {
                        answeredCount += d.Count;
                    }
                    totalCount += d.Count;
                }

                return ((double)answeredCount / (double)totalCount) * 100d;
            }
        }



        // The methods that follow were originally built for NCUA/ACET.
        // It is hoped that they will eventually be refactored to fit a more
        // 'generic' approach to maturity models.




        public List<MaturityDomain> GetMaturityAnswers(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var data = db.GetMaturityDetailsCalculations(assessmentId).ToList();
                return CalculateComponentValues(data, assessmentId);
            }

        }

        public bool GetTargetBandOnly(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                bool? defaultTarget = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault().MatDetail_targetBandOnly;
                return defaultTarget ?? false;
            }
        }

        public void SetTargetBandOnly(int assessmentId, bool value)
        {
            using (var db = new CSET_Context())
            {
                var assessment = db.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
                assessment.MatDetail_targetBandOnly = value;
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Calculate maturity levels of components
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MaturityDomain> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity, int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var maturityDomains = new List<MaturityDomain>();
                var domains = db.FINANCIAL_DOMAINS.ToList();
                var standardCategories = db.FINANCIAL_DETAILS.ToList();
                var sub_categories = from m in maturity
                                     group new { m.Domain, m.AssessmentFactor, m.FinComponent }
                                      by new { m.Domain, m.AssessmentFactor, m.FinComponent } into mk
                                     select new
                                     {
                                         mk.Key.Domain,
                                         mk.Key.AssessmentFactor,
                                         mk.Key.FinComponent
                                     };

                //var maturityRange = GetMaturityRange(assessmentId);

                if (maturity.Count > 0)
                {
                    foreach (var d in domains)
                    {
                        var tGroupOrder = maturity.FirstOrDefault(x => x.Domain == d.Domain);
                        var maturityDomain = new MaturityDomain
                        {
                            DomainName = d.Domain,
                            Assessments = new List<MaturityAssessment>(),
                            Sequence = tGroupOrder == null ? 0 : tGroupOrder.grouporder,
                            TargetPercentageAchieved = 0,
                            PercentAnswered = 0
                        };

                        var DomainQT = 0;
                        var DomainAT = 0;

                        var partial_sub_categoy = sub_categories.Where(x => x.Domain == d.Domain).GroupBy(x => x.AssessmentFactor).Select(x => x.Key);
                        foreach (var s in partial_sub_categoy)
                        {

                            int AssQT = 0;
                            int AssAT = 0;

                            var maturityAssessment = new MaturityAssessment
                            {
                                AssessmentFactor = s,
                                Components = new List<MaturityComponent>(),
                                Sequence = (int)maturity.FirstOrDefault(x => x.AssessmentFactor == s).grouporder

                            };
                            var assessmentCategories = sub_categories.Where(x => x.AssessmentFactor == s);
                            foreach (var c in assessmentCategories)
                            {
                                int CompQT = 0;
                                int CompAT = 0;
                                int CompQuestions = 0;
                                int totalAnswered = 0;
                                double AnsweredPer = 0;

                                var component = new MaturityComponent
                                {
                                    ComponentName = c.FinComponent,
                                    Sequence = (int)maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).grouporder

                                };
                                var baseline = new SalAnswers
                                {
                                    UnAnswered = !maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).Complete,
                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0
                                };

                                // Calc total questons and anserwed
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }
                                CompQT += CompQuestions;
                                CompAT += totalAnswered;

                                var evolving = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0


                                };

                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvingMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }
                                CompQT += CompQuestions;
                                CompAT += totalAnswered;


                                var intermediate = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };

                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;

                                var advanced = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };

                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;

                                var innovative = new SalAnswers
                                {

                                    Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0

                                };

                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;

                                component.Baseline = baseline.Answered;
                                component.Evolving = evolving.Answered;
                                component.Intermediate = intermediate.Answered;
                                component.Advanced = advanced.Answered;
                                component.Innovative = innovative.Answered;
                                component.AssessedMaturityLevel = baseline.UnAnswered ? Constants.IncompleteMaturity :
                                                                    baseline.Answered < 100 ? Constants.SubBaselineMaturity :
                                                                        evolving.Answered < 100 ? Constants.BaselineMaturity :
                                                                            intermediate.Answered < 100 ? Constants.EvolvingMaturity :
                                                                                advanced.Answered < 100 ? Constants.IntermediateMaturity :
                                                                                    innovative.Answered < 100 ? Constants.AdvancedMaturity :
                                                                                    "Innovative";

                                maturityAssessment.Components.Add(component);

                                AssQT += CompQT;
                                AssAT += CompAT;
                            }

                            maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.IncompleteMaturity) ? Constants.IncompleteMaturity :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.SubBaselineMaturity) ? Constants.SubBaselineMaturity :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.BaselineMaturity) ? Constants.BaselineMaturity :
                                                                               maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.EvolvingMaturity) ? Constants.EvolvingMaturity :
                                                                                maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.IntermediateMaturity) ? Constants.IntermediateMaturity :
                                                                                   maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.AdvancedMaturity) ? Constants.AdvancedMaturity :
                                                                                       maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.InnovativeMaturity) ? Constants.InnovativeMaturity :
                                                                                           Constants.IncompleteMaturity;
                            maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                            maturityDomain.Assessments.Add(maturityAssessment);

                            DomainQT += AssQT;
                            DomainAT += AssAT;

                        }

                        maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.IncompleteMaturity) ? Constants.IncompleteMaturity :
                                                                            maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.SubBaselineMaturity) ? Constants.SubBaselineMaturity :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.BaselineMaturity) ? Constants.BaselineMaturity :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.EvolvingMaturity) ? Constants.EvolvingMaturity :
                                                                                       maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.IntermediateMaturity) ? Constants.IntermediateMaturity :
                                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.AdvancedMaturity) ? Constants.AdvancedMaturity :
                                                                                            maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.InnovativeMaturity) ? Constants.InnovativeMaturity :
                                                                                                Constants.IncompleteMaturity;
                        maturityDomain.Assessments = maturityDomain.Assessments.OrderBy(x => x.Sequence).ToList();

                        double AchPerTol = Math.Round(((double)DomainAT / DomainQT) * 100, 0);
                        maturityDomain.TargetPercentageAchieved = AchPerTol;

                        maturityDomains.Add(maturityDomain);
                    }
                }

                maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
                return maturityDomains;
            }
        }


        /// <summary>
        /// Get matrix for maturity determination based on total irp rating
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> GetMaturityRange(int assessmentId)
        {
            ACETDashboardManager manager = new ACETDashboardManager();
            ACETDashboard irpCalculation = manager.GetIrpCalculation(assessmentId);
            bool targetBandOnly = GetTargetBandOnly(assessmentId);
            int irpRating = irpCalculation.Override > 0 ? irpCalculation.Override : irpCalculation.SumRiskLevel;
            if (!targetBandOnly)
                irpRating = 6; //Do the default configuration
            return irpSwitch(irpRating);
        }

        public List<string> irpSwitch(int irpRating)
        {
            switch (irpRating)
            {
                case 1:
                    return new List<string> { Constants.BaselineMaturity, Constants.EvolvingMaturity };
                case 2:
                    return new List<string>
                        {Constants.BaselineMaturity, Constants.EvolvingMaturity, Constants.IntermediateMaturity};
                case 3:
                    return new List<string>
                        {Constants.EvolvingMaturity, Constants.IntermediateMaturity, Constants.AdvancedMaturity};
                case 4:
                    return new List<string>
                        {Constants.IntermediateMaturity, Constants.AdvancedMaturity, Constants.InnovativeMaturity};
                case 5:
                    return new List<string> { Constants.AdvancedMaturity, Constants.InnovativeMaturity };
                default:
                    return new List<string>
                    {
                        Constants.BaselineMaturity, Constants.EvolvingMaturity, Constants.IntermediateMaturity,
                        Constants.AdvancedMaturity, Constants.InnovativeMaturity
                    };
            }
        }

        /// <summary>
        /// Returns a Dictionary mapping requirement ID to its corresponding maturity level.
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, MaturityMap> GetRequirementMaturityLevels()
        {
            using (var db = new CSET_Context())
            {
                var q = from req in db.NEW_REQUIREMENT
                        join fr in db.FINANCIAL_REQUIREMENTS on req.Requirement_Id equals fr.Requirement_Id
                        join fd in db.FINANCIAL_DETAILS on fr.StmtNumber equals fd.StmtNumber
                        join fg in db.FINANCIAL_GROUPS on fd.FinancialGroupId equals fg.FinancialGroupId
                        join fm in db.FINANCIAL_MATURITY on fg.MaturityId equals fm.MaturityId
                        where req.Original_Set_Name == "ACET_V1"
                        select new { req.Requirement_Id, fr.StmtNumber, fm.MaturityId, fm.Acronym, fm.MaturityLevel };

                var dict = new Dictionary<int, MaturityMap>();
                foreach (var a in q)
                {
                    dict.Add(a.Requirement_Id, new MaturityMap(a.MaturityId, a.Acronym, a.MaturityLevel));
                }

                return dict;
            }
        }

        /// <summary>
        /// Get edm scoring
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public object GetEdmScores(int assessmentId, string section)
        {
            var scoring = new EDMScoring();
            scoring.LoadDataStructure();
            scoring.SetAnswers(assessmentId);
            var scores = scoring.GetScores().Where(x => x.Title_Id.Contains(section.ToUpper()));

            var parents = from s in scores
                          where !s.Title_Id.Contains('.')
                          select new
                          {
                              parent = new
                              {
                                  Title_Id = s.Title_Id.Contains('G') ? "Goal " + s.Title_Id.Split(':')[1][1] : s.Title_Id,
                                  Color = s.Color

                              },
                              children = from s2 in scores
                                         where s2.Title_Id.Contains(s.Title_Id)
                                            && s2.Title_Id.Contains('.') && !s2.Title_Id.Contains('-')
                                         select new
                                         {
                                             Title_Id = s2.Title_Id.Contains('-') ? s2.Title_Id.Split('-')[0].Split('.')[1] : s2.Title_Id.Split('.')[1],
                                             Color = s2.Color,
                                             children = from s3 in scores
                                                        where s3.Title_Id.Contains(s2.Title_Id) &&
                                                              s3.Title_Id.Contains('-')
                                                        select new
                                                        {
                                                            Title_Id = s3.Title_Id.Split('-')[1],
                                                            Color = s3.Color
                                                        }
                                         }
                          };

            return parents;
        }


        /// <summary>
        /// Returns a collection of all reference text defined for questions in a maturity model. 
        /// </summary>
        /// <param name="modelName"></param>
        /// <returns></returns>
        public object GetReferenceText(string modelName)
        {
            using (var db = new CSET_Context())
            {
                var q = from model in db.MATURITY_MODELS
                        join questions in db.MATURITY_QUESTIONS on model.Maturity_Model_Id equals questions.Maturity_Model_Id
                        join refText in db.MATURITY_REFERENCE_TEXT on questions.Mat_Question_Id equals refText.Mat_Question_Id
                        where model.Model_Name == modelName
                        select new { refText.Mat_Question_Id, questions.Question_Title, refText.Sequence, refText.Reference_Text };

                return q.ToList();
            }
        }


        /// <summary>
        /// Returns glossary entries by model ID.
        /// </summary>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public List<GlossaryEntry> GetGlossaryEntries(int modelId)
        {
            using (var db = new CSET_Context())
            {
                var modelName = db.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).Select(y => y.Model_Name).FirstOrDefault();
                return GetGlossaryEntries(modelName);
            }
        }


        /// <summary>
        /// Returns glossary entries by model name.
        /// </summary>
        /// <returns></returns>
        public List<GlossaryEntry> GetGlossaryEntries(string modelName)
        {
            using (var db = new CSET_Context())
            {
                var mm = db.MATURITY_MODELS.Where(x => x.Model_Name == modelName).FirstOrDefault();
                if (mm == null)
                {
                    return null;
                }

                var glossaryTerms = from g in db.GLOSSARY.Where(x => x.Maturity_Model_Id == mm.Maturity_Model_Id).OrderBy(x => x.Term)
                                    select new GlossaryEntry() { Term = g.Term, Definition = g.Definition };

                return glossaryTerms.ToList();
            }
        }


        /// <summary>
        /// Returns EDM Data.
        /// </summary>
        /// <returns></returns>
        public List<RelevantEDMAnswersAppendix> GetMaturityEDMAnswers(int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                // Here we queuery the db for all the edm answers

                var q = from a in db.MATURITY_QUESTIONS
                        join b in db.ANSWER on a.Mat_Question_Id equals b.Question_Or_Requirement_Id
                        where b.Assessment_Id == assessmentId && a.Maturity_Model_Id == 3
                        select new RelevantEDMAnswerResult() { QuestionTitle = a.Question_Title, QuestionText = a.Question_Text, AnswerText = b.Answer_Text };

                q.ToList();

                var answers = GetFrameworkFuctions(q.ToList());
                GetFrameworkTotals(ref answers);
                GetAnswersByGoalNumber(ref answers);

              
                return answers;
            }

        }

        public List<RelevantEDMAnswersAppendix> GetFrameworkFuctions(List<RelevantEDMAnswerResult> answers)
        {
            var builtdata = new List<RelevantEDMAnswersAppendix>();

            var fucntionIdentify = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Identify",
                Acronym = "ID",
                Summary = "The data, personnel, devices, systems, and facilities that enable the organization to achieve business purposes are identified and managed consistent with their relative importance to organizational objectives and the organization’s risk strategy.",
                Categories = new List<Category> { 
                    new Category {
                        Name = "Asset Management",
                        Acronym = "AM",
                        Description = "The data, personnel, devices, systems, and facilities that enable the organization to achieve business purposes are identified and managed consistent with their relative importance to organizational objectives and the organization’s risk strategy",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.AM-1",
                                Question_Text = "Physical devices and systems within the organization are inventoried",
                                EDMReferences = new List<string>{"RF:G1.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-2",
                                Question_Text = "Software platforms and applications within the organization are inventoried",
                                EDMReferences = new List<string>{"RF:G1.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-3",
                                Question_Text = " Organizational communication and data flows are mapped",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-4",
                                Question_Text = "External information systems are catalogued",
                                EDMReferences = new List<string>{"RF:G1.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-5",
                                Question_Text = "Resources (e.g., hardware, devices, data, time, personnel, and software) are prioritized based on their classification, criticality, and business value",
                                EDMReferences = new List<string>{"RF:G1.Q2"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q2"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-6",
                                Question_Text = "Cybersecurity roles and responsibilities for the entire workforce and third - party stakeholders(e.g., suppliers, customers, partners) are established",
                                EDMReferences = new List<string>{"RMG:G6.Q2", "RMG:G6.Q3", "SPS:G3.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G6.Q2", "RMG:G6.Q3", "SPS:G3.Q1"}, answers)
                            }

                        }
                        
                    },
                    new Category {
                        Name = "Business Environment",
                        Acronym = "BE",
                        Description = ": The organization’s mission, objectives, stakeholders, and activities are understood and prioritized; this information is used to inform cybersecurity roles, responsibilities, and risk management decisions.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.BE-1",
                                Question_Text = "The organization’s role in the supply chain is identified and communicated",
                                EDMReferences = new List<string>{"RF:G1.Q1", "RF:G1.Q2", "RF:G1.Q3", "RF:G1.Q4", "RF:G3.Q2-S", "RF:G3.Q2-IP", "RF:G3.Q2-G", "RF:G4.Q2", "RF:G5.Q1", "RMG:G2.Q1", "RMG:G6.Q1" },
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q1", "RF:G1.Q2", "RF:G1.Q3", "RF:G1.Q4", "RF:G3.Q2-S", "RF:G3.Q2-IP", "RF:G3.Q2-G", "RF:G4.Q2", "RF:G5.Q1", "RMG:G2.Q1", "RMG:G6.Q1" }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-2",
                                Question_Text = "The organization’s place in critical infrastructure and its industry sector is identified and communicated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-3",
                                Question_Text = " Priorities for organizational mission, objectives, and activities are established and communicated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-4",
                                Question_Text = "Dependencies and critical functions for delivery of critical services are established",
                                EDMReferences = new List<string>{"RF:G2.Q4", "RF:G4.Q2", "RF:G6.Q2", "RMG:G1.Q1-S", "RMG:G1.Q1-IP", "RMG:G1.Q1-G", "RMG:G1.Q2", "RMG:G1.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q4", "RF:G4.Q2", "RF:G6.Q2", "RMG:G1.Q1-S", "RMG:G1.Q1-IP", "RMG:G1.Q1-G", "RMG:G1.Q2", "RMG:G1.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.BE-5",
                                Question_Text = " Resilience requirements to support delivery of critical services are established for all operating states(e.g.under duress / attack, during recovery, normal operations)",
                                EDMReferences = new List<string>{"RF:G1.Q4", "RF:G2.Q3", "RF:G6.Q1", "RMG:G2.Q1", "RMG:G6.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q4", "RF:G2.Q3", "RF:G6.Q1", "RMG:G2.Q1", "RMG:G6.Q1"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Governance",
                        Acronym = "GV",
                        Description = "The policies, procedures, and processes to manage and monitor the organization’s regulatory, legal, risk, environmental, and operational requirements are understood and inform the management of cybersecurity risk.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.GV-1",
                                Question_Text = ": Organizational cybersecurity policy is established and communicated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.GV-2",
                                Question_Text = "Cybersecurity roles and responsibilities are coordinated and aligned with internal roles and external partners",
                                EDMReferences = new List<string>{"RMG:G6.Q2", "RMG:G6.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G6.Q2", "RMG:G6.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.GV-3",
                                Question_Text = ": Legal and regulatory requirements regarding cybersecurity, including privacy and civil liberties obligations, are understood and managed",
                                EDMReferences = new List<string>{"RF:G1.Q4", "RF:G2.Q2"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G1.Q4", "RF:G2.Q2"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.GV-4",
                                Question_Text = "Governance and risk management processes address cybersecurity risks",
                                EDMReferences = new List<string>{"RF:G3.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q1"}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Risk Assessment",
                        Acronym = "RA",
                        Description = "The organization understands the cybersecurity risk to organizational operations (including mission, functions, image, or reputation), organizational assets, and individuals.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.RA-1",
                                Question_Text = ": Asset vulnerabilities are identified and documented",
                                EDMReferences = new List<string>{ "RF:G6.Q2", "RMG:G2.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{ "RF:G6.Q2", "RMG:G2.Q4"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-2",
                                Question_Text = "Cyber threat intelligence is received from information sharing forums and sources",
                                EDMReferences = new List<string>{"SPS:G3.Q1", "SPS:G3.Q2","SPS:G3.Q4","SPS:G3.Q5"},
                                answeredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q1", "SPS:G3.Q2","SPS:G3.Q4","SPS:G3.Q5"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-3",
                                Question_Text = "Threats, both internal and external, are identified and documented",
                                EDMReferences = new List<string>{"SPS:G3.Q2", "SPS:G3.Q3-S","SPS:G3.Q3-IP"},
                                answeredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q2", "SPS:G3.Q3-S","SPS:G3.Q3-IP"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-4",
                                Question_Text = "Potential business impacts and likelihoods are identified",
                                EDMReferences = new List<string>{"RF:G3.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-5",
                                Question_Text = "Threats, vulnerabilities, likelihoods, and impacts are used to determine risk",
                                EDMReferences = new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-G","RF:G3.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-G","RF:G3.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RA-6",
                                Question_Text = " Risk responses are identified and prioritized",
                                EDMReferences = new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-G"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-G"}, answers)
                            }
                        }

                    },
                    new Category {
                        Name = "Risk Management Strategy",
                        Acronym = "RM",
                        Description = "The organization’s priorities, constraints, risk tolerances, and assumptions are established and used to support operational risk decisions.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.RM-1",
                                Question_Text = " Risk management processes are established, managed, and agreed to by organizational stakeholders",
                                EDMReferences = new List<string>{"RF:G3.Q1", "RMG:G2.Q5", "RMG:G2.Q6", "RMG:G6.Q5"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G3.Q1", "RMG:G2.Q5", "RMG:G2.Q6", "RMG:G6.Q5"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RM-2",
                                Question_Text = " Organizational risk tolerance is determined and clearly expressed",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.RM-3",
                                Question_Text = " The organization’s determination of risk tolerance is informed by its role in critical infrastructure and sector specific risk analysis",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Supply Chain Risk Management",
                        Acronym = "SC",
                        Description = "The organization’s priorities, constraints, risk tolerances, and assumptions are established and used to support risk decisions associated with managing supply chain risk. The organization has established and implemented the processes to identify, assess and manage supply chain risks.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "ID.SC-1",
                                Question_Text = "Cyber supply chain risk management processes are identified, established, assessed, managed, and agreed to by organizational stakeholders",
                                EDMReferences = new List<string>{"RF:G2.Q1","RF:G3.Q1","RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-G","RMG:G2.Q2","RMG:G2.Q5","RMG:G2.Q6","RMG:G3.Q2","RMG:G4.Q3","RMG:G4.Q4","RMG:G5.Q1","RMG:G5.Q2","RMG.G5.Q3","RMG:G6.Q5","SPS:G2.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q1","RF:G3.Q1","RF:G3.Q2-S","RF:G3.Q2-IP","RF:G3.Q2-G","RMG:G2.Q2","RMG:G2.Q5","RMG:G2.Q6","RMG:G3.Q2","RMG:G4.Q3","RMG:G4.Q4","RMG:G5.Q1","RMG:G5.Q2","RMG.G5.Q3","RMG:G6.Q5","SPS:G2.Q4"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-2",
                                Question_Text = "Suppliers and third party partners of information systems, components, and services are identified, prioritized, and assessed using a cyber supply chain risk assessment process ",
                                EDMReferences = new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-G",
                                    "RF:G3.Q3",
                                    "RF:G4.Q1",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G6.Q3",
                                    "RF:G6.Q4",
                                    "RF:G6.Q5",
                                    "RMG:G1.Q1-S",
                                    "RMG:G1.Q1-IP",
                                    "RMG:G1.Q1-G",
                                    "RMG:G1.Q2",
                                    "RMG:G1.Q3",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-G",
                                    "RF:G3.Q3",
                                    "RF:G4.Q1",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G6.Q3",
                                    "RF:G6.Q4",
                                    "RF:G6.Q5",
                                    "RMG:G1.Q1-S",
                                    "RMG:G1.Q1-IP",
                                    "RMG:G1.Q1-G",
                                    "RMG:G1.Q2",
                                    "RMG:G1.Q3",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-3",
                                Question_Text = "Contracts with suppliers and third-party partners are used to implement appropriate measures designed to meet the objectives of an organization’s cybersecurity program and Cyber Supply Chain Risk Management Plan.",
                                EDMReferences = new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G2.Q2",
                                    "RF:G2.Q3",
                                    "RF:G2.Q4",
                                    "RF:G4.Q1",
                                    "RF:G4.Q2",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G5.Q1",
                                    "RF:G5.Q2",
                                    "RF:G5.Q3",
                                    "RF:G5.Q4",
                                    "RF:G5.Q5",
                                    "RF:G5.Q6",
                                    "RMG:G2.Q1",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q5",
                                    "RMG:G5.Q1",
                                    "RMG:G5.Q2",
                                    "RMG:G6.Q1",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RF:G2.Q1",
                                    "RF:G2.Q2",
                                    "RF:G2.Q3",
                                    "RF:G2.Q4",
                                    "RF:G4.Q1",
                                    "RF:G4.Q2",
                                    "RF:G4.Q3",
                                    "RF:G4.Q4",
                                    "RF:G5.Q1",
                                    "RF:G5.Q2",
                                    "RF:G5.Q3",
                                    "RF:G5.Q4",
                                    "RF:G5.Q5",
                                    "RF:G5.Q6",
                                    "RMG:G2.Q1",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q5",
                                    "RMG:G5.Q1",
                                    "RMG:G5.Q2",
                                    "RMG:G6.Q1",
                                    "SPS:G2.Q2-IM",
                                    "SPS:G2.Q2-SC",
                                    "SPS:G2.Q4" }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-4",
                                Question_Text = " Suppliers and third-party partners are routinely assessed using audits, test results, or other forms of evaluations to confirm they are meeting their contractual obligations.",
                                EDMReferences = new List<string>{
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-G",
                                    "RF:G3.Q3",
                                    "RMG:G2.Q2",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q4",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "RMG:G3.Q1",
                                    "RMG:G3.Q2",
                                    "RMG:G3.Q3",
                                    "RMG:G3.Q4",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q4",
                                    "RMG:G4.Q5",
                                    "RMG:G6.Q2",
                                    "RMG:G6.Q3",
                                    "RMG:G6.Q4",
                                    "SPS:G2.Q1-IM",
                                    "SPS:G2.Q1-SC",
                                    "SPS:G2.Q3",
                                    "SPS:G2.Q4" },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RF:G3.Q2-S",
                                    "RF:G3.Q2-IP",
                                    "RF:G3.Q2-G",
                                    "RF:G3.Q3",
                                    "RMG:G2.Q2",
                                    "RMG:G2.Q3",
                                    "RMG:G2.Q4",
                                    "RMG:G2.Q5",
                                    "RMG:G2.Q6",
                                    "RMG:G3.Q1",
                                    "RMG:G3.Q2",
                                    "RMG:G3.Q3",
                                    "RMG:G3.Q4",
                                    "RMG:G4.Q3",
                                    "RMG:G4.Q4",
                                    "RMG:G4.Q5",
                                    "RMG:G6.Q2",
                                    "RMG:G6.Q3",
                                    "RMG:G6.Q4",
                                    "SPS:G2.Q1-IM",
                                    "SPS:G2.Q1-SC",
                                    "SPS:G2.Q3",
                                    "SPS:G2.Q4" },answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.SC-5",
                                Question_Text = "Response and recovery planning and testing are conducted with suppliers and third-party providers",
                                EDMReferences = new List<string>{
                                "RF:G5.Q6",
                                "SPS:G1.Q1",
                                "SPS:G1.Q3",
                                "SPS:G1.Q4-IM",
                                "SPS:G1.Q4-SC",
                                "SPS:G1.Q5-IM",
                                "SPS:G1.Q5-SC",
                                "SPS:G2.Q1-IM",
                                "SPS:G2.Q1-SC"},
                                answeredEDM = GetEDMAnswers(new List<string>{
                                "RF:G5.Q6",
                                "SPS:G1.Q1",
                                "SPS:G1.Q3",
                                "SPS:G1.Q4-IM",
                                "SPS:G1.Q4-SC",
                                "SPS:G1.Q5-IM",
                                "SPS:G1.Q5-SC",
                                "SPS:G2.Q1-IM",
                                "SPS:G2.Q1-SC"}, answers)
                            }
                        }
                    },
                }
            };

            var fucntionProtect = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Protect",
                Acronym = "PR",
                Summary = "The Protect Function supports the ability to limit or contain the impact of a potential cybersecurity event.",
                Categories = new List<Category> {
                    new Category {
                        Name = "Identity Management, Authentication and Access Control",
                        ShortName = "Access Control",
                        Acronym = "AC",
                        Description = " Access to physical and logical assets and associated facilities is limited to authorized users, processes, and devices, and is managed consistent with the assessed risk of unauthorized access to authorized activities and transactions.", 
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.AC-1",
                                Question_Text = ": Identities and credentials are issued, managed, verified, revoked, and audited for authorized devices, users and processes",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"
                                },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-2",
                                Question_Text = ": Physical access to assets is managed and protected",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"},
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-3",
                                Question_Text = "Remote access is managed",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"},
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q2",
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG:G7.Q3-F",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-4",
                                Question_Text = "Access permissions and authorizations are managed, incorporating the principles of least privilege and separation of duties",
                                EDMReferences = new List<string>{
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG: G7.Q3-F"},
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G7.Q3-I",
                                    "RMG:G7.Q3-T",
                                    "RMG: G7.Q3-F"},answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AC-5",
                                Question_Text = "Network integrity is protected (e.g., network segregation, network segmentation)",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-6",
                                Question_Text = " Identities are proofed and bound to credentials and asserted in interactions",
                                EDMReferences = new List<string>{"RMG:G7.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G7.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "ID.AM-6",
                                Question_Text = "Users, devices, and other assets are authenticated (e.g., singlefactor, multi-factor) commensurate with the risk of the transaction (e.g., individuals’ security and privacy risks and other organizational risks)",
                                EDMReferences = new List<string>{"RMG:G7.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G7.Q1"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Awareness and Training",
                        Acronym = "AT",
                        Description = " The organization’s personnel and partners are provided cybersecurity awareness education and are trained to perform their cybersecurity-related duties and responsibilities consistent with related policies, procedures, and agreements.", 
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.AT-1",
                                Question_Text = "All users are informed and trained",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-2",
                                Question_Text = ": Privileged users understand their roles and responsibilities",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-3",
                                Question_Text = "Third-party stakeholders (e.g., suppliers, customers, partners) understand their roles and responsibilities ",
                                EDMReferences = new List<string>{"RF:G5.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G5.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-4",
                                Question_Text = "Senior executives understand their roles and responsibilities",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.AT-5",
                                Question_Text = "Physical and cybersecurity personnel understand their roles and responsibilities",
                                EDMReferences = new List<string>{"SPS:G3.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q1"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Data Security",
                        Acronym = "DS",
                        Description = " Information and records (data) are managed consistent with the organization’s risk strategy to protect the confidentiality, integrity, and availability of information.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.DS-1",
                                Question_Text = " Data-at-rest is protected",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-2",
                                Question_Text = "Data-in-transit is protected",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-3",
                                Question_Text = "Assets are formally managed throughout removal, transfers, and disposition",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-4",
                                Question_Text = "Adequate capacity to ensure availability is maintained",
                                EDMReferences = new List<string>{"RMG:G4.Q5"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G4.Q5"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-5",
                                Question_Text = "Protections against data leaks are implemented",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-6",
                                Question_Text = " Integrity checking mechanisms are used to verify software, firmware, and information integrity",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-7",
                                Question_Text = "The development and testing environment(s) are separate from the production environment",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.DS-8",
                                Question_Text = ": Integrity checking mechanisms are used to verify hardware integrity",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                    new Category {
                        Name = "Information Protection Processes and Procedures",
                        Acronym = "IP",
                        Description = "Security policies (that address purpose, scope, roles, responsibilities, management commitment, and coordination among organizational entities), processes, and procedures are maintained and used to manage protection of information systems and assets.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.IP-1",
                                Question_Text = "A baseline configuration of information technology/industrial control systems is created and maintained incorporating security principles (e.g. concept of least functionality) ",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-2",
                                Question_Text = "A System Development Life Cycle to manage systems is implemented",
                                EDMReferences = new List<string>{ "RF:G6.Q5", "RMG:G5.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{ "RF:G6.Q5", "RMG:G5.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-3",
                                Question_Text = "Configuration change control processes are in place",
                                EDMReferences = new List<string>{
                                    "RMG:G4.Q1-I",
                                    "RMG:G4.Q1-T",
                                    "RMG:G4.Q1-F",
                                    "RMG:G4.Q1-P",
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G4.Q1-I",
                                    "RMG:G4.Q1-T",
                                    "RMG:G4.Q1-F",
                                    "RMG:G4.Q1-P",
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-4",
                                Question_Text = "Backups of information are conducted, maintained, and tested",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-5",
                                Question_Text = "Policy and regulations regarding the physical operating environment for organizational assets are met",
                                EDMReferences = new List<string>{"RF:G2.Q2","RMG:G3.Q1"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RF:G2.Q2","RMG:G3.Q1"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-6",
                                Question_Text = "Data is destroyed according to policy",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-7",
                                Question_Text = "Protection processes are improved",
                                EDMReferences = new List<string>{ "RMG:G5.Q3"},
                                answeredEDM = GetEDMAnswers(new List<string>{ "RMG:G5.Q3"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-8",
                                Question_Text = ": Effectiveness of protection technologies is shared",
                                EDMReferences = new List<string>{
                                    "RMG:G5.Q3",
                                    "SPS:G3.Q3-S",
                                    "SPS:G3.Q3-IP",
                                    "SPS:G3.Q4",
                                    "SPS:G3.Q6"
                                },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G5.Q3",
                                    "SPS:G3.Q3-S",
                                    "SPS:G3.Q3-IP",
                                    "SPS:G3.Q4",
                                    "SPS:G3.Q6"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-9",
                                Question_Text = " Response plans (Incident Response and Business Continuity) and recovery plans(Incident Recovery and Disaster Recovery) are in place and managed",
                                EDMReferences = new List<string>{
                                    "SPS:G1.Q1",
                                    "SPS:G1.Q3",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G1.Q5-IM",
                                    "SPS:G1.Q5-SC"
                                },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "SPS:G1.Q1",
                                    "SPS:G1.Q3",
                                    "SPS:G1.Q4-IM",
                                    "SPS:G1.Q4-SC",
                                    "SPS:G1.Q5-IM",
                                    "SPS:G1.Q5-SC"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-10",
                                Question_Text = "Response and recovery plans are tested",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-11",
                                Question_Text = "Cybersecurity is included in human resources practices (e.g., deprovisioning, personnel screening)",
                                EDMReferences = new List<string>{"RMG:G7.Q2"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G7.Q2"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.IP-12",
                                Question_Text = "A vulnerability management plan is developed and implemented",
                                EDMReferences = new List<string>{"RMG:G2.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            }
                        }

                    },
                    new Category {
                        Name = "Maintenance",
                        Acronym = "MA",
                        Description = "Maintenance and repairs of industrial control and information system components are performed consistent with policies and procedures.", 
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.MA-1",
                                Question_Text = ": Maintenance and repair of organizational assets are performed and logged, with approved and controlled tools",
                                EDMReferences = new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P"
                                }, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.MA-2",
                                Question_Text = ": Remote maintenance of organizational assets is approved, logged, and performed in a manner that prevents unauthorized access",
                                EDMReferences = new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P",
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"

                                },
                                answeredEDM = GetEDMAnswers(new List<string>{
                                    "RMG:G4.Q2-I",
                                    "RMG:G4.Q2-T",
                                    "RMG:G4.Q2-F",
                                    "RMG:G4.Q2-P",
                                    "RMG:G7.Q1",
                                    "RMG:G7.Q4-I",
                                    "RMG:G7.Q4-T",
                                    "RMG:G7.Q4-F"
                                }, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Protective Technology",
                        Acronym = "PT",
                        Description = "Technical security solutions are managed to ensure the security and resilience of systems and assets, consistent with related policies, procedures, and agreements.", 
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "PR.PT-1",
                                Question_Text = "Audit/log records ar determined, documented, implemented, and reviewed in accordance with policy",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-2",
                                Question_Text = "Removable media is protected and its use restricted according to policy",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-3",
                                Question_Text = " The principle of least functionality is incorporated by configuring systems to provide only essential capabilities",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-4",
                                Question_Text = ": Communications and control networks are protected",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "PR.PT-5",
                                Question_Text = "Mechanisms (e.g., failsafe, load balancing, hot swap) are implemented to achieve resilience requirements in normal and adverse situations",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                        }
                    },
                }
            };

            var fucntionDetect = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Detect",
                Acronym = "DE",
                Summary = "Detect, ...",
                Categories = new List<Category> {
                    new Category {
                        Name = "Anomalies and Events",
                        Acronym = "AE",
                        Description = " Anomalous activity is detected and the potential impact of events is understood.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "DE.AE-1",
                                Question_Text = "A baseline of network operations and expected data flows for users and systems is established and managed",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-2",
                                Question_Text = "Detected events are analyzed to understand attack targets and methods",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-3",
                                Question_Text = " Event data are collected and correlated from multiple sources and sensors",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-4",
                                Question_Text = "Impact of events is determined ",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.AE-5",
                                Question_Text = "Incident alert thresholds are established",
                                EDMReferences = new List<string>{"SPS:G1.Q2"},
                                answeredEDM = GetEDMAnswers(new List<string>{"SPS:G1.Q2"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Security Continuous Monitoring",
                        Acronym = "CM",
                        Description = "The information system and assets are monitored to identify cybersecurity events and verify the effectiveness of protective measures.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "DE.CM-1",
                                Question_Text = "The network is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-2",
                                Question_Text = "The physical environment is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-3",
                                Question_Text = " Personnel activity is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-4",
                                Question_Text = "Malicious code is detected",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-5",
                                Question_Text = " Unauthorized mobile code is detected",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-6",
                                Question_Text = "External service provider activity is monitored to detect potential cybersecurity events",
                                EDMReferences = new List<string>{"RMG:G3.Q1", "RMG:G4.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G3.Q1", "RMG:G4.Q4"}, answers)
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-7",
                                Question_Text = "Monitoring for unauthorized personnel, connections, devices, and software is performed",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.CM-8",
                                Question_Text = "Vulnerability scans are performed",
                                EDMReferences = new List<string>{"RMG:G2.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            },

                        }

                    },
                    new Category {
                        Name = "Detection Processes",
                        Acronym = "DP",
                        Description = " Detection processes and procedures are maintained and tested to ensure awareness of anomalous event",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "DE.DP-1",
                                Question_Text = " Roles and responsibilities for detection are well defined to ensure accountability",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-2",
                                Question_Text = " Detection activities comply with all applicable requirements",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-3",
                                Question_Text = "Detection processes are tested",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-4",
                                Question_Text = "Event detection information is communicated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "DE.DP-5",
                                Question_Text = "Detection processes are continuously improved",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                        }
                    }
                }
            };

            var fucntionRespond = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Respond",
                Acronym = "RS",
                Summary = "Respond ...",
                Categories = new List<Category> {
                    new Category {
                        Name = "Response Planning",
                        Acronym = "AC",
                        Description = ": Response processes and procedures are executed and maintained, to ensure response to detected cybersecurity incidents.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RS.RP-1",
                                Question_Text = "Response plan is executed during or after an incident",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }

                        }

                    },
                    new Category {
                        Name = "Communications",
                        Acronym = "CO",
                        Description = ": Response activities are coordinated with internal and external stakeholders(e.g.external support from law enforcement agencies)",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RS.CO-1",
                                Question_Text = " Personnel know their roles and order of operations when a response is needed",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-2",
                                Question_Text = "Incidents are reported consistent with established criteria",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-3",
                                Question_Text = "Information is shared consistent with response plans",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-4",
                                Question_Text = "Coordination with stakeholders occurs consistent with response plans",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RS.CO-5",
                                Question_Text = "Voluntary information sharing occurs with external stakeholders to achieve broader cybersecurity situational awareness.",
                                EDMReferences = new List<string>{ "SPS:G3.Q3-S", "SPS:G3.Q3-IP", "SPS:G3.Q4", "SPS:G3.Q5", "SPS:G3.Q6"},
                                answeredEDM = GetEDMAnswers(new List<string>{"SPS:G3.Q3-S", "SPS:G3.Q3-IP", "SPS:G3.Q4", "SPS:G3.Q5", "SPS:G3.Q6"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Analysis",
                        Acronym = "AN",
                        Description = " Analysis is conducted to ensure effective response and support recovery activities.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RS.AN-1",
                                Question_Text = " Notifications from detection systems are investigated ",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-2",
                                Question_Text = ": The impact of the incident is understood",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-3",
                                Question_Text = "Forensics are performed",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-4",
                                Question_Text = "Incidents are categorized consistent with response plans",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.AN-5",
                                Question_Text = "Processes are established to receive, analyze and respond to vulnerabilities disclosed to the organization from internal and external sources(e.g. internal testing, security bulletins, or security researchers)",
                                EDMReferences = new List<string>{ "RMG:G2.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4 "}, answers)
                            }
                        }
                    },
                    new Category {
                        Name = "Mitigation",
                        Acronym = "MI",
                        Description = "Activities are performed to prevent expansion of an event, mitigate its effects, and resolve the incident.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory {
                                Question_Title = "RS.MI-1",
                                Question_Text = "Incidents are contained",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.MI-2",
                                Question_Text = "Incidents are mitigated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.MI-3",
                                Question_Text = "Newly identified vulnerabilities are mitigated or documented as accepted risks",
                                EDMReferences = new List<string>{ "RMG:G2.Q4"},
                                answeredEDM = GetEDMAnswers(new List<string>{"RMG:G2.Q4"}, answers)
                            }

                        }

                    },
                    new Category {
                        Name = "Improvements",
                        Acronym = "IM",
                        Description = "Organizational response activities are improved by incorporating lessons learned from current and previous detection/response activities.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory {
                                Question_Title = "RS.IM-1",
                                Question_Text = " Response plans incorporate lessons learned",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory {
                                Question_Title = "RS.IM-2",
                                Question_Text = " Response strategies are updated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    },
                }
            };

            var fucntionRecover = new RelevantEDMAnswersAppendix
            {
                FunctionName = "Recover",
                Acronym = "RC",
                Summary = "Recovery....",
                Categories = new List<Category> {
                    new Category {
                        Name = "Recovery Planning",
                        Acronym = "RP",
                        Description = " Recovery processes and procedures are executed and maintained to ensure restoration of systems or assets affected by cybersecurity incidents.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RC.RP-1",
                                Question_Text = "Recovery plan is executed during or after a cybersecurity incident",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }

                        }

                    },
                    new Category {
                        Name = "Improvements",
                        Acronym = "IM",
                        Description = "): Recovery planning and processes are improved by incorporating lessons learned into future activities.",
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RC.IM-1",
                                Question_Text = ": Recovery plans incorporate lessons learned",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RC.IM-2",
                                Question_Text = ": Recovery strategies are updated",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }

                    },
                    new Category {
                        Name = "Communications",
                        Acronym = "CO",
                        Description = ": Restoration activities are coordinated with internal and external parties(e.g.coordinating centers, Internet Service Providers, owners of attacking systems, victims, other CSIRTs, and vendors).",   
                        SubCategories = new List<SubCategory>
                        {
                            new SubCategory
                            {
                                Question_Title = "RC.CO-1",
                                Question_Text = " Public relations are managed",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RC.CO-2",
                                Question_Text = " Reputation is repaired after an incident",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            },
                            new SubCategory
                            {
                                Question_Title = "RC.CO-3",
                                Question_Text = ": Recovery activities are communicated to internal and external stakeholders as well as executive and management teams",
                                EDMReferences = new List<string>(),
                                answeredEDM = new List<RelevantEDMAnswerResult>()
                            }
                        }
                    }
                    
                }
            };

            builtdata.Add(fucntionIdentify);
            builtdata.Add(fucntionProtect);
            builtdata.Add(fucntionDetect);
            builtdata.Add(fucntionRespond);
            builtdata.Add(fucntionRecover);

            return builtdata;
        }

        public void GetFrameworkTotals(ref List<RelevantEDMAnswersAppendix> answers)
        {
            var functionTotal = new EDMAnswerTotal();
            var catTotal = new EDMAnswerTotal();
            var subCatTotal = new EDMAnswerTotal();
            foreach (RelevantEDMAnswersAppendix function in answers)
            {
                functionTotal = new EDMAnswerTotal();
                foreach(Category cat in function.Categories) 
                {
                    catTotal = new EDMAnswerTotal();
                    foreach (SubCategory subcat in cat.SubCategories)
                    {
                        subCatTotal = new EDMAnswerTotal();
                        foreach (RelevantEDMAnswerResult ans in subcat.answeredEDM)
                        {
                            functionTotal.AddToTotal(ans);
                            catTotal.AddToTotal(ans);
                            subCatTotal.AddToTotal(ans);
                        }
                        subcat.totals = subCatTotal;
                    }
                    cat.totals = catTotal;
                }
                function.totals = functionTotal;
            }

        }
        public void GetAnswersByGoalNumber(ref List<RelevantEDMAnswersAppendix> answers)
        {
            string[] subGoalResultsName;
            string[] subGoalResultSection;
            IEnumerable<EDMSubcategoryGoalGroup> subGoalResults;
            IEnumerable<EDMSubcategoryGoalResults> subGoalSectionsResults;
            EDMSubcategoryGoalResults edmSubCatResult;

            foreach (RelevantEDMAnswersAppendix function in answers)
            {
                foreach (Category cat in function.Categories)
                {
                    foreach (SubCategory subcat in cat.SubCategories)
                    {
                        subcat.GoalResults = new List<EDMSubcategoryGoalGroup>();
                        foreach (RelevantEDMAnswerResult ans in subcat.answeredEDM)
                        {
                            //Get subresults section, create new one if its new, add to previous if it exists
                            subGoalResultsName = ans.QuestionTitle.Split(':');
                            subGoalResults = subcat.GoalResults.Where(g => g.GroupName == subGoalResultsName[0]);
                            if (subGoalResults.Count() <= 0)
                            {
                                subcat.GoalResults.Add(new EDMSubcategoryGoalGroup {
                                    GroupName = subGoalResultsName[0],
                                    subResults = new List<EDMSubcategoryGoalResults>()
                                });
                                subGoalResults = subcat.GoalResults.Where(g => g.GroupName == subGoalResultsName[0]);
                            }

                            //Check if edm reference has further sub results
                            if (subGoalResultsName[1].Contains('-'))
                            {
                                subGoalResultSection = subGoalResultsName[1].Split('-');
                                subGoalSectionsResults = subGoalResults.First().subResults.Where(s => s.GoalName == subGoalResultSection[0]);
                                if (subGoalSectionsResults.Count() == 0) {
                                    subGoalResults.First().subResults.Add(
                                        new EDMSubcategoryGoalResults
                                        {
                                            GoalName = subGoalResultSection[0],
                                            Answer = "N/A"
                                        }
                                    );
                                    subGoalSectionsResults = subGoalResults.First().subResults.Where(s => s.GoalName == subGoalResultSection[0]);
                                    subGoalSectionsResults.First().subResults = new List<EDMSubcategoryGoalResults>();
                                }
                                subGoalSectionsResults.First().subResults.Add(
                                    new EDMSubcategoryGoalResults
                                    {
                                        GoalName = subGoalResultSection[1],
                                        Answer = ans.AnswerText
                                    }
                                );


                            } else {                            
                                subGoalResults.First().subResults.Add(new EDMSubcategoryGoalResults {
                                    GoalName = subGoalResultsName[1],
                                    Answer = ans.AnswerText
                                });
                            }

                        }
                    }
                }
            }
        }

        public List<RelevantEDMAnswerResult> GetEDMAnswers(List<string> EDMReferences, List<RelevantEDMAnswerResult> answers)
        {
            var filtered = answers.Where(x => EDMReferences.Any(y => y == x.QuestionTitle));
            return filtered.ToList();
        }
    }

    public static class EDMExtensions
    {
        public static void AddToTotal(this EDMAnswerTotal totals, RelevantEDMAnswerResult result)
        {
            switch (result.AnswerText)
            {
                case "Y":
                    totals.Y += 1;
                    break;
                case "I":
                    totals.I += 1;
                    break;
                case "N":
                    totals.N += 1;
                    break;
            }
        }
    }

}
