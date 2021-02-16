//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
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


        /// <summary>
        /// Assembles a response consisting of maturity settings for the assessment
        /// as well as the question set in its hierarchy of domains, practices, etc.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityResponse GetMaturityQuestions(int assessmentId, bool isAcetInstallation)
        {
            var response = new MaturityResponse();

            using (var db = new CSET_Context())
            {
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
                var glossaryTerms = from g in db.GLOSSARY.Where(x => x.Maturity_Model_Id == myModel.model_id)
                                    select new GlossaryEntry() { Term = g.Term, Definition = g.Definition };
                response.Glossary = glossaryTerms.ToList();
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
                    Description = sg.Description
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
        public List<EDMscore> GetEdmScores(int assessmentId)
        {
            var scoring = new EDMScoring();
            scoring.LoadDataStructure();
            scoring.SetAnswers(assessmentId);
            var scores = scoring.GetScores();

            return scores;
        }
    }
}
