using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Model.Acet;
using CSETWebCore.Model.Edm;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Sal;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.AdminTab;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;

namespace CSETWebCore.Business.Maturity
{
    public class MaturityBusiness : IMaturityBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        public MaturityBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Returns the maturity model selected for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityModel GetMaturityModel(int assessmentId)
        {
            var q = from amm in _context.AVAILABLE_MATURITY_MODELS
                    from mm in _context.MATURITY_MODELS
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
                myModel.MaturityTargetLevel = GetMaturityTargetLevel(assessmentId);

                myModel.Levels = GetMaturityLevelsForModel(myModel.ModelId, 100);
            }

            return myModel;
        }


        /// <summary>
        /// Gets the current target level for the assessment form ASSESSMENT_SELECTED_LEVELS.
        /// </summary>
        /// <returns></returns>
        public int GetMaturityTargetLevel(int assessmentId)
        {
            // The maturity target level is stored similar to a SAL level
            int targetLevel = 0;
            var myLevel = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level").FirstOrDefault();
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
            List<MaturityDomainRemarks> remarks = new List<MaturityDomainRemarks>();
            foreach (var m in _context.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == assessmentId).ToList())
            {
                remarks.Add(new MaturityDomainRemarks()
                {
                    Group_Id = m.Grouping_ID,
                    DomainRemark = m.DomainRemarks
                });
            }
            return remarks;
        }


        /// <summary>
        /// Persists a domain remark.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="remarks"></param>
        public void SetDomainRemarks(int assessmentId, MaturityDomainRemarks remarks)
        {
            var remark = _context.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == assessmentId
                                                               && x.Grouping_ID == remarks.Group_Id).FirstOrDefault();
            if (remark != null)
            {
                remark.DomainRemarks = remarks.DomainRemark;
            }
            else
            {
                if (remarks.DomainRemark != null)
                {
                    _context.MATURITY_DOMAIN_REMARKS.Add(new MATURITY_DOMAIN_REMARKS()
                    {
                        Assessment_Id = assessmentId,
                        Grouping_ID = remarks.Group_Id,
                        DomainRemarks = remarks.DomainRemark
                    });
                }
            }
            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="myModel"></param>
        /// <param name="db"></param>
        /// <returns></returns>
        public List<MaturityLevel> GetMaturityLevelsForModel(int maturityModelId, int targetLevel)
        {
            // get the levels and their display names
            var levels = new List<MaturityLevel>();
            foreach (var l in _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == maturityModelId)
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

            var result = from a in _context.MATURITY_MODELS
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
                m.Levels = GetMaturityLevelsForModel(m.ModelId, 100);
            }

            return response;
        }


        /// <summary>
        /// Saves the selected maturity models.
        /// </summary>
        /// <returns></returns>
        public void PersistSelectedMaturityModel(int assessmentId, string modelName)
        {
            var model = _context.MATURITY_MODELS.FirstOrDefault(x => x.Model_Name == modelName);

            if (model == null)
            {
                return;
            }


            var amm = _context.AVAILABLE_MATURITY_MODELS.FirstOrDefault(x => x.model_id == model.Maturity_Model_Id && x.Assessment_Id == assessmentId);
            if (amm != null)
            {
                // we already have the model set; do nothing
                return;
            }


            ClearMaturityModel(assessmentId);

            var mm = _context.MATURITY_MODELS.FirstOrDefault(x => x.Model_Name == modelName);
            if (mm != null)
            {
                _context.AVAILABLE_MATURITY_MODELS.Add(new AVAILABLE_MATURITY_MODELS()
                {
                    Assessment_Id = assessmentId,
                    model_id = mm.Maturity_Model_Id,
                    Selected = true
                });


                // default the target level if CMMC
                if (mm.Model_Name == "CMMC")
                {
                    var targetLevel = _context.ASSESSMENT_SELECTED_LEVELS.Where(l => l.Assessment_Id == assessmentId && l.Level_Name == "Maturity_Level").FirstOrDefault();
                    if (targetLevel == null)
                    {
                        _context.ASSESSMENT_SELECTED_LEVELS.Add(new ASSESSMENT_SELECTED_LEVELS()
                        {
                            Assessment_Id = assessmentId,
                            Level_Name = "Maturity_Level",
                            Standard_Specific_Sal_Level = "1"
                        });
                    }
                }
            }

            _context.SaveChanges();

            SetDefaultTargetLevels(assessmentId, modelName);
            _assessmentUtil.TouchAssessment(assessmentId);
        }


        /// <summary>
        /// Deletes any maturity model connections to the assessment
        /// </summary>
        /// <param name="assessmentId"></param>
        public void ClearMaturityModel(int assessmentId)
        {
            var result = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).ToList();
            _context.AVAILABLE_MATURITY_MODELS.RemoveRange(result);

            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetMaturityLevel(int assessmentId)
        {
            var result = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level").FirstOrDefault();
            if (result != null)
            {
                if (int.TryParse(result.Standard_Specific_Sal_Level, out int level))
                {
                    return level;
                }
            }

            return 0;
        }


        /// <summary>
        /// Connects the assessment to a Maturity_Level.
        /// </summary>
        public void PersistMaturityLevel(int assessmentId, int level)
        {
            // SAL selections live in ASSESSMENT_SELECTED_LEVELS, which
            // is more complex to allow for the different types of SALs
            // as well as the user's selection(s).

            var result = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level");
            if (result.Any())
            {
                _context.ASSESSMENT_SELECTED_LEVELS.RemoveRange(result);
                _context.SaveChanges();
            }

            _context.ASSESSMENT_SELECTED_LEVELS.Add(new ASSESSMENT_SELECTED_LEVELS()
            {
                Assessment_Id = assessmentId,
                Level_Name = "Maturity_Level",
                Standard_Specific_Sal_Level = level.ToString()
            });

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
        }


        public AVAILABLE_MATURITY_MODELS ProcessModelDefaults(int assessmentId, bool isAcetInstallation)
        {
            //if the available maturity model is not selected and the application is CSET
            //the default is EDM
            //if the application is ACET the default is ACET

            var myModel = _context.AVAILABLE_MATURITY_MODELS
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
                _context.AVAILABLE_MATURITY_MODELS.Add(myModel);
                _context.SaveChanges();
            }

            return myModel;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public object GetEdmPercentScores(int assessmentId)
        {
            EDMScoring scoring = new EDMScoring(_context);
            var partial = scoring.GetPartialScores(assessmentId);
            var summary = scoring.GetPercentageScores(assessmentId);
            return new
            {
                summary = summary,
                partial = partial
            };
        }


        /// <summary>
        /// Assembles a response consisting of maturity settings for the assessment
        /// as well as the question set in its hierarchy of domains, practices, etc.
        /// </summary>
        /// <param name="assessmentId"></param>
        public MaturityResponse GetMaturityQuestions(int assessmentId, bool isAcetInstallation, bool fill)
        {
            var response = new MaturityResponse();

            if (fill)
            {
                _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);
            }

            var myModel = ProcessModelDefaults(assessmentId, isAcetInstallation);


            var myModelDefinition = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == myModel.model_id).FirstOrDefault();

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


            response.MaturityTargetLevel = GetMaturityTargetLevel(assessmentId);

            if (response.ModelName == "ACET")
            {
                response.OverallIRP = GetOverallIrpNumber(assessmentId);
                response.MaturityTargetLevel = response.OverallIRP;
            }


            // get the levels and their display names for this model
            response.Levels = GetMaturityLevelsForModel(myModel.model_id, response.MaturityTargetLevel);



            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_LevelNavigation)
                .Where(q =>
                myModel.model_id == q.Maturity_Model_Id).ToList();


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type_)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();


            // Recursively build the grouping/question hierarchy
            var tempModel = new MaturityGrouping();
            BuildSubGroupings(tempModel, null, allGroupings, questions, answers.ToList());

            //GRAB all the domain remarks and assign them if necessary
            Dictionary<int, MATURITY_DOMAIN_REMARKS> domainRemarks =
                _context.MATURITY_DOMAIN_REMARKS.Where(x => x.Assessment_Id == assessmentId)
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

            return response;
        }


        /// <summary>
        /// Recursive method that builds subgroupings for the specified group.
        /// It also attaches any questions pertinent to this group.
        /// </summary>
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
                    GroupingType = sg.Type_.Grouping_Type_Name,
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
                        Sequence = myQ.Sequence,
                        QuestionType = "Maturity",
                        QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/>"),
                        Answer = answer?.a.Answer_Text,
                        AltAnswerText = answer?.a.Alternate_Justification,
                        Comment = answer?.a.Comment,
                        Feedback = answer?.a.FeedBack,
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

                newGrouping.Questions.Sort((a, b) => a.Sequence.CompareTo(b.Sequence));

                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingID, allGroupings, questions, answers);
            }
        }


        /// <summary>
        /// Returns a Dictionary of all Supplemental_Info for an assessment's questions.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Dictionary<int, string> GetReferences(int assessmentId)
        {
            var myModel = _context.AVAILABLE_MATURITY_MODELS
                .Include(x => x.model_)
                .Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();

            var refQ = from q in _context.MATURITY_QUESTIONS
                       join t in _context.MATURITY_REFERENCE_TEXT on q.Mat_Question_Id equals t.Mat_Question_Id
                       where q.Maturity_Model_Id == myModel.model_id
                       select t;

            var refText = refQ.ToList();

            var dict = new Dictionary<int, string>();
            refText.ForEach(t =>
            {
                dict.Add(t.Mat_Question_Id, t.Reference_Text);
            });

            return dict;
        }


        /// <summary>
        /// Stores an answer.
        /// </summary>
        /// <param name="answer"></param>
        public int StoreAnswer(int assessmentId, Answer answer)
        {
            // Find the Maturity Question
            var question = _context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == answer.QuestionId).FirstOrDefault();

            if (question == null)
            {
                throw new Exception("Unknown question or requirement ID: " + answer.QuestionId);
            }


            // in case a null is passed, store 'unanswered'
            if (string.IsNullOrEmpty(answer.AnswerText))
            {
                answer.AnswerText = "U";
            }

            ANSWER dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId
                && x.Question_Or_Requirement_Id == answer.QuestionId
                && x.Question_Type == answer.QuestionType).FirstOrDefault();


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }

            dbAnswer.Assessment_Id = assessmentId;
            dbAnswer.Question_Or_Requirement_Id = answer.QuestionId;
            dbAnswer.Question_Type = answer.QuestionType;
            dbAnswer.Question_Number = 0;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
            dbAnswer.Component_Guid = answer.ComponentGuid;

            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);

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
            var irp = GetOverallIrpNumber(assessmentId);

            // get the highest maturity level for the risk level (use the stairstep model)
            var topMatLevel = GetTopMatLevelForRisk(irp);

            var answerDistribution = _context.AcetAnswerDistribution(assessmentId, topMatLevel).ToList();

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


        /// <summary>
        /// Using the 'stairstep' model, determines the highest maturity level
        /// that corresponds to the specified IRP/risk.  
        /// 
        /// This stairstep model must match the stairstep defined in the UI -- getStairstepRequired(),
        /// though this method only returns the top level.
        /// </summary>
        /// <param name="irp"></param>
        /// <returns></returns>
        private int GetTopMatLevelForRisk(int irp)
        {
            switch (irp)
            {
                case 1:
                case 2:
                    return 1; // Baseline
                case 3:
                    return 2; // Evolving
                case 4:
                    return 3; // Intermediate
                case 5:
                    return 4; // Advanced
            }

            return 0;
        }



        // The methods that follow were originally built for NCUA/ACET.
        // It is hoped that they will eventually be refactored to fit a more
        // 'generic' approach to maturity models.




        public List<MaturityDomain> GetMaturityAnswers(int assessmentId)
        {
            var data = _context.GetMaturityDetailsCalculations(assessmentId).ToList();
            return CalculateComponentValues(data, assessmentId);
        }

        public bool GetTargetBandOnly(int assessmentId)
        {
            bool? defaultTarget = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault().MatDetail_targetBandOnly;
            return defaultTarget ?? false;
        }

        public void SetTargetBandOnly(int assessmentId, bool value)
        {
            var assessment = _context.ASSESSMENTS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            assessment.MatDetail_targetBandOnly = value;
            _context.SaveChanges();
        }


        /// <summary>
        /// Calculate maturity levels of components
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MaturityDomain> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity, int assessmentId)
        {

            var maturityDomains = new List<MaturityDomain>();
            var domains = _context.FINANCIAL_DOMAINS.ToList();
            var standardCategories = _context.FINANCIAL_DETAILS.ToList();
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
                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0
                            };

                            // Calc total questons and anserwed
                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.BaselineMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }
                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            var evolving = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0


                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }
                            CompQT += CompQuestions;
                            CompAT += totalAnswered;


                            var intermediate = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }

                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            var advanced = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }

                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            var innovative = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0;

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
                            component.AssessedMaturityLevel = baseline.UnAnswered ? Constants.Constants.IncompleteMaturity :
                                                                baseline.Answered < 100 ? Constants.Constants.SubBaselineMaturity :
                                                                    evolving.Answered < 100 ? Constants.Constants.BaselineMaturity :
                                                                        intermediate.Answered < 100 ? Constants.Constants.EvolvingMaturity :
                                                                            advanced.Answered < 100 ? Constants.Constants.IntermediateMaturity :
                                                                                innovative.Answered < 100 ? Constants.Constants.AdvancedMaturity :
                                                                                "Innovative";

                            maturityAssessment.Components.Add(component);

                            AssQT += CompQT;
                            AssAT += CompAT;
                        }

                        maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                       maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                       maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.BaselineMaturity) ? Constants.Constants.BaselineMaturity :
                                                                           maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.EvolvingMaturity) ? Constants.Constants.EvolvingMaturity :
                                                                            maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.IntermediateMaturity) ? Constants.Constants.IntermediateMaturity :
                                                                               maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.AdvancedMaturity) ? Constants.Constants.AdvancedMaturity :
                                                                                   maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.InnovativeMaturity) ? Constants.Constants.InnovativeMaturity :
                                                                                   Constants.Constants.IncompleteMaturity;
                        maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                        maturityDomain.Assessments.Add(maturityAssessment);

                        DomainQT += AssQT;
                        DomainAT += AssAT;

                    }

                    maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                           maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.BaselineMaturity) ? Constants.Constants.BaselineMaturity :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.EvolvingMaturity) ? Constants.Constants.EvolvingMaturity :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.IntermediateMaturity) ? Constants.Constants.IntermediateMaturity :
                                                                                    maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.AdvancedMaturity) ? Constants.Constants.AdvancedMaturity :
                                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.InnovativeMaturity) ? Constants.Constants.InnovativeMaturity :
                                                                                        Constants.Constants.IncompleteMaturity;
                    maturityDomain.Assessments = maturityDomain.Assessments.OrderBy(x => x.Sequence).ToList();

                    double AchPerTol = Math.Round(((double)DomainAT / DomainQT) * 100, 0);
                    maturityDomain.TargetPercentageAchieved = AchPerTol;

                    maturityDomains.Add(maturityDomain);
                }
            }

            maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
            return maturityDomains;
        }


        /// <summary>
        /// Get matrix for maturity determination based on total irp rating
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> GetMaturityRange(int assessmentId)
        {
            Model.Acet.ACETDashboard irpCalculation = GetIrpCalculation(assessmentId);
            bool targetBandOnly = GetTargetBandOnly(assessmentId);
            int irpRating = irpCalculation.Override > 0 ? irpCalculation.Override : irpCalculation.SumRiskLevel;
            if (!targetBandOnly)
                irpRating = 6; //Do the default configuration
            return IrpSwitch(irpRating);
        }


        /// <summary>
        /// Returns the active maturity level list, but the IDs for the levels.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<int> GetMaturityRangeIds(int assessmentId)
        {
            var output = new List<int>();

            var result = GetMaturityRange(assessmentId);

            var levels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == 1).ToList();
            foreach (string r in result)
            {
                output.Add(levels.Where(x => x.Level_Name.ToLower() == r.ToLower()).First().Maturity_Level_Id);
            }

            return output;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> IrpSwitch(int irpRating)
        {
            switch (irpRating)
            {
                case 1:
                    return new List<string> { Constants.Constants.BaselineMaturity, Constants.Constants.EvolvingMaturity };
                case 2:
                    return new List<string>
                        {Constants.Constants.BaselineMaturity, Constants.Constants.EvolvingMaturity, Constants.Constants.IntermediateMaturity};
                case 3:
                    return new List<string>
                        {Constants.Constants.EvolvingMaturity, Constants.Constants.IntermediateMaturity, Constants.Constants.AdvancedMaturity};
                case 4:
                    return new List<string>
                        {Constants.Constants.IntermediateMaturity, Constants.Constants.AdvancedMaturity, Constants.Constants.InnovativeMaturity};
                case 5:
                    return new List<string> { Constants.Constants.AdvancedMaturity, Constants.Constants.InnovativeMaturity };
                default:
                    return new List<string>
                    {
                        Constants.Constants.BaselineMaturity, Constants.Constants.EvolvingMaturity, Constants.Constants.IntermediateMaturity,
                        Constants.Constants.AdvancedMaturity, Constants.Constants.InnovativeMaturity
                    };
            }
        }


        /// <summary>
        /// Returns a Dictionary mapping requirement ID to its corresponding maturity level.
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, MaturityMap> GetRequirementMaturityLevels()
        {
            var q = from req in _context.NEW_REQUIREMENT
                    join fr in _context.FINANCIAL_REQUIREMENTS on req.Requirement_Id equals fr.Requirement_Id
                    join fd in _context.FINANCIAL_DETAILS on fr.StmtNumber equals fd.StmtNumber
                    join fg in _context.FINANCIAL_GROUPS on fd.FinancialGroupId equals fg.FinancialGroupId
                    join fm in _context.FINANCIAL_MATURITY on fg.MaturityId equals fm.MaturityId
                    where req.Original_Set_Name == "ACET_V1"
                    select new { req.Requirement_Id, fr.StmtNumber, fm.MaturityId, fm.Acronym, fm.MaturityLevel };

            var dict = new Dictionary<int, MaturityMap>();
            foreach (var a in q)
            {
                dict.Add(a.Requirement_Id, new MaturityMap(a.MaturityId, a.Acronym, a.MaturityLevel));
            }

            return dict;
        }

        /// <summary>
        /// Get edm scoring
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public object GetEdmScores(int assessmentId, string section)
        {
            var scoring = new EDMScoring(_context);
            scoring.LoadDataStructure();
            scoring.SetAnswers(assessmentId);
            var scores = scoring.GetScores().Where(x => x.Title_Id.Contains(section.ToUpper()));

            var parents = (from s in scores
                           where !s.Title_Id.Contains('.')
                           select new EdmScoreParent
                           {
                               parent = new EDMscore
                               {
                                   Title_Id = s.Title_Id.Contains('G') ? "Goal " + s.Title_Id.Split(':')[1][1] : s.Title_Id,
                                   Color = s.Color

                               },
                               children = (from s2 in scores
                                           where s2.Title_Id.Contains(s.Title_Id)
                                              && s2.Title_Id.Contains('.') && !s2.Title_Id.Contains('-')
                                           select new EDMscore
                                           {
                                               Title_Id = s2.Title_Id.Contains('-') ? s2.Title_Id.Split('-')[0].Split('.')[1] : s2.Title_Id.Split('.')[1],
                                               Color = s2.Color,
                                               children = (from s3 in scores
                                                           where s3.Title_Id.Contains(s2.Title_Id) &&
                                                                 s3.Title_Id.Contains('-')
                                                           select new EDMscore
                                                           {
                                                               Title_Id = s3.Title_Id.Split('-')[1],
                                                               Color = s3.Color
                                                           }).ToList()
                                           }).ToList()
                           }).ToList();

            for (int p = 0; p < parents.Count(); p++)
            {
                var parent = parents[p];
                for (int c = 0; c < parent.children.Count(); c++)
                {
                    var children = parent.children[c];
                    if (children.children.Any())
                    {
                        parents[p].children[c].Color = ScoreStatus.LightGray.ToString();
                    }
                }
            }

            return parents;
        }


        /// <summary>
        /// Returns a collection of all reference text defined for questions in a maturity model. 
        /// </summary>
        /// <param name="modelName"></param>
        /// <returns></returns>
        public object GetReferenceText(string modelName)
        {
            var q = from model in _context.MATURITY_MODELS
                    join questions in _context.MATURITY_QUESTIONS on model.Maturity_Model_Id equals questions.Maturity_Model_Id
                    join refText in _context.MATURITY_REFERENCE_TEXT on questions.Mat_Question_Id equals refText.Mat_Question_Id
                    where model.Model_Name == modelName
                    select new { refText.Mat_Question_Id, questions.Question_Title, refText.Sequence, refText.Reference_Text };

            return q.ToList();
        }


        /// <summary>
        /// Returns glossary entries by model ID.
        /// </summary>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public List<GlossaryEntry> GetGlossaryEntries(int modelId)
        {
            var modelName = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == modelId).Select(y => y.Model_Name).FirstOrDefault();
            return GetGlossaryEntries(modelName);
        }


        /// <summary>
        /// Returns glossary entries by model name.
        /// </summary>
        /// <returns></returns>
        public List<GlossaryEntry> GetGlossaryEntries(string modelName)
        {
            var mm = _context.MATURITY_MODELS.Where(x => x.Model_Name == modelName).FirstOrDefault();
            if (mm == null)
            {
                return null;
            }

            var glossaryTerms = from g in _context.GLOSSARY.Where(x => x.Maturity_Model_Id == mm.Maturity_Model_Id).OrderBy(x => x.Term)
                                select new GlossaryEntry() { Term = g.Term, Definition = g.Definition };

            return glossaryTerms.ToList();
        }

        public Model.Acet.ACETDashboard LoadDashboard(int assessmentId)
        {

            Model.Acet.ACETDashboard result = GetIrpCalculation(assessmentId);

            result.Domains = new List<DashboardDomain>();

            List<MaturityDomain> domains = GetMaturityAnswers(assessmentId);
            foreach (var d in domains)
            {
                result.Domains.Add(new DashboardDomain
                {
                    Maturity = d.DomainMaturity,
                    Name = d.DomainName
                });

            }

            return result;
        }
        /// <summary>
        /// Get the string value for the overall IRP mapping
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public string GetOverallIrp(int assessmentId)
        {
            var calc = GetIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall == 1 ? Constants.Constants.LeastIrp :
                overall == 2 ? Constants.Constants.MinimalIrp :
                overall == 3 ? Constants.Constants.ModerateIrp :
                overall == 4 ? Constants.Constants.SignificantIrp :
                overall == 5 ? Constants.Constants.MostIrp : string.Empty;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetOverallIrpNumber(int assessmentId)
        {
            var calc = GetIrpCalculation(assessmentId);
            int overall = calc.Override > 0 ? calc.Override : calc.SumRiskLevel;
            return overall;
        }


        /// <summary>
        /// Get all IRP calculations for display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Model.Acet.ACETDashboard GetIrpCalculation(int assessmentId)
        {
            Model.Acet.ACETDashboard result = new Model.Acet.ACETDashboard();


            // now just properties on an Assessment
            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment == null) { return null; }
            result.CreditUnionName = assessment.CreditUnionName;
            result.Charter = assessment.Charter;
            result.Assets = assessment.Assets;

            result.Hours = _adminTabBusiness.GetTabData(assessmentId).GrandTotal;

            //IRP Section
            result.Override = assessment.IRPTotalOverride ?? 0;
            result.OverrideReason = assessment.IRPTotalOverrideReason;
            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER_.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT_.Assessment_Id == assessmentId);
                if (headerInfo != null)
                {
                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                    summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    summary.Comment = headerInfo.COMMENT;
                }

                List<DataLayer.IRP> irps = _context.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = _context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x => x);
                foreach (DataLayer.IRP irp in irps)
                {
                    ASSESSMENT_IRP answer = null;
                    dictionaryIRPS.TryGetValue(irp.IRP_ID, out answer);
                    //ASSESSMENT_IRP answer = irp.ASSESSMENT_IRP.FirstOrDefault(i => i.Assessment_.Assessment_Id == assessmentId);
                    if (answer != null && answer.Response != 0)
                    {
                        summary.RiskCount[answer.Response.Value - 1]++;
                        summary.RiskSum++;
                        result.SumRisk[answer.Response.Value - 1]++;
                        result.SumRiskTotal++;
                    }
                }

                result.Irps.Add(summary);
            }

            //go back through the IRPs and calculate the Risk Level for each section
            foreach (IRPSummary irp in result.Irps)
            {
                int MaxRisk = 0;
                irp.RiskLevel = 0;
                for (int i = 0; i < irp.RiskCount.Length; i++)
                {
                    if (irp.RiskCount[i] >= MaxRisk && irp.RiskCount[i] > 0)
                    {
                        MaxRisk = irp.RiskCount[i];
                        irp.RiskLevel = i + 1;
                    }
                }
            }

            _context.SaveChanges();

            result.SumRiskLevel = 1;
            int maxRisk = 0;
            for (int i = 0; i < result.SumRisk.Length; i++)
            {
                if (result.SumRisk[i] >= maxRisk && result.SumRisk[i] > 0)
                {
                    result.SumRiskLevel = i + 1;
                    maxRisk = result.SumRisk[i];
                }
            }

            return result;
        }

        public void UpdateACETDashboardSummary(int assessmentId, Model.Acet.ACETDashboard summary)
        {
            if (assessmentId == 0 || summary == null) { return; }

            ASSESSMENTS assessment = _context.ASSESSMENTS.FirstOrDefault(a => a.Assessment_Id == assessmentId);
            if (assessment != null)
            {
                assessment.CreditUnionName = summary.CreditUnionName;
                assessment.Charter = summary.Charter;
                assessment.Assets = summary.Assets;

                assessment.IRPTotalOverride = summary.Override;
                assessment.IRPTotalOverrideReason = summary.OverrideReason;
            }

            foreach (IRPSummary irp in summary.Irps)
            {
                ASSESSMENT_IRP_HEADER dbSummary = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(s => s.ASSESSMENT_ID == assessment.Assessment_Id && s.HEADER_RISK_LEVEL_ID == irp.RiskLevelId);
                if (dbSummary != null)
                {
                    dbSummary.RISK_LEVEL = irp.RiskLevel;
                    dbSummary.COMMENT = irp.Comment;
                } // the else should never happen
                else
                {
                    return;
                }
            }

            _context.SaveChanges();
        }

        /// <summary>
        /// Set default values for target level where applicable
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void SetDefaultTargetLevels(int assessmentId, string modelName)
        {
            var result = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == "Maturity_Level");
            //If any level is already selected, avoid setting default
            if (result.Any())
            {
                return;
            }

            //Set the default level for CMMC to 1 (the minimum level)
            if (modelName == "CMMC")
            {
                _context.ASSESSMENT_SELECTED_LEVELS.Add(new ASSESSMENT_SELECTED_LEVELS()
                {
                    Assessment_Id = assessmentId,
                    Level_Name = "Maturity_Level",
                    Standard_Specific_Sal_Level = "1"
                });
                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(assessmentId);
            }
        }


    }
}
