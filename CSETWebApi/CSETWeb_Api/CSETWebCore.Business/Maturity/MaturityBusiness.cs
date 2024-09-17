//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Model.Edm;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using CSETWebCore.Model.Mvra;



namespace CSETWebCore.Business.Maturity
{
    public class MaturityBusiness : IMaturityBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        private int _maturityModelId;

        private static object myLock = new object();

        private TranslationOverlay _overlay;

        private AdditionalSupplemental _addlSuppl;

        public readonly List<string> ModelsWithTargetLevel = ["ACET", "CMMC", "CMMC2"];



        /// <summary>
        /// CTOR
        /// </summary>
        public MaturityBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;

            _addlSuppl = new AdditionalSupplemental(context);

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// Returns the maturity model selected for the assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        public Model.Maturity.MaturityModel GetMaturityModel(int assessmentId)
        {
            var q = from amm in _context.AVAILABLE_MATURITY_MODELS
                    from mm in _context.MATURITY_MODELS
                    from a in _context.ASSESSMENTS
                    join gii in _context.GALLERY_ITEM on a.GalleryItemGuid equals gii.Gallery_Item_Guid into gig
                    from gi in gig.DefaultIfEmpty()
                    where amm.model_id == mm.Maturity_Model_Id
                        && amm.Assessment_Id == assessmentId && a.Assessment_Id == assessmentId


                    select new Model.Maturity.MaturityModel()
                    {
                        ModelId = mm.Maturity_Model_Id,
                        ModelName = mm.Model_Name,
                        ModelTitle = mm.Model_Title,
                        QuestionsAlias = mm.Questions_Alias,
                        ModelDescription = (gi != null) ? gi.Description : string.Empty
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
            // Start with a high value to include all questions by default
            int targetLevel = 100;

            // The maturity target level is stored similar to a SAL level
            var myLevel = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();

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

        public List<GroupScores> Get_LevelScoresByGroup(int assessmentId, int mat_model_id)
        {
            var list = _context.usp_countsForLevelsByGroupMaturityModel(assessmentId, mat_model_id);

            //while the answer text is not null 
            // increment the achieved level
            // must achieve level 1 before we can achieve level 2 ....
            //

            bool isLevelAchieved = false;
            int nextLevel = 0;

            foreach (var item in list)
            {

                switch (item.Answer_Text)
                {
                    case "N":
                        isLevelAchieved = item.Answer_Text2 == null;
                        break;
                    case "U":
                        isLevelAchieved = isLevelAchieved && item.Answer_Text2 == null;
                        break;
                    case "Y":
                        isLevelAchieved = isLevelAchieved && item.Answer_Text2 != null;
                        if (!isLevelAchieved)
                        {
                            nextLevel++;
                            pushLevel(nextLevel, item);
                        }
                        break;
                }
            }

            List<GroupScores> groupScores = new List<GroupScores>();

            foreach (var keyPair in levels)
            {
                groupScores.Add(new GroupScores()
                {
                    Group_Id = keyPair.Key.GROUPING_ID,
                    Maturity_Level_Id = keyPair.Key.Maturity_Level_Id,
                    Maturity_Level_Name = "We'll get there"
                });
            }

            return groupScores;
        }

        private Dictionary<usp_countsForLevelsByGroupMaturityModelResults, int> levels = new Dictionary<usp_countsForLevelsByGroupMaturityModelResults, int>();
        private void pushLevel(int nextLevel, usp_countsForLevelsByGroupMaturityModelResults item)
        {
            //if the previous level was achieved then we can go for the next level
            //other wise we cannot
            int level = 0;
            if (nextLevel == 0)
            {
                levels.Add(item, nextLevel);
            }
            if (levels.TryGetValue(item, out level))
            {
                if (nextLevel == level + 1)
                {
                    levels.Add(item, nextLevel);
                }
                //else we did not and keep the previous level (ie. cannot skip 1 and goto 2 or 3
            }
        }


        /// <summary>
        /// Returns an int indicating the selected target level of the assessment.
        /// If no target level is found, 0 is returned.
        /// </summary>
        /// <returns></returns>
        public int GetTargetLevel(int assessmentId)
        {
            var asl = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();
            if (asl != null)
            {
                return int.Parse(asl.Standard_Specific_Sal_Level);
            }
            return 0;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public SprsScoreModel GetSPRSScore(int assessmentId)
        {
            var response = new SprsScoreModel();

            IList<SPRSScore> scores = _context.usp_GetSPRSScore(assessmentId);


            var maturityExtra = _context.MATURITY_EXTRA.ToList();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var x = biz.GetMaturityStructureAsXml(assessmentId, true);


            int calculatedScore = 110;

            foreach (var goal in x.Descendants("Goal"))
            {
                var d = new SprsDomain();
                d.DomainName = goal.Attribute("title").Value;
                response.Domains.Add(d);

                foreach (var question in goal.Descendants("Question"))
                {
                    var q = new SprsQuestion();
                    q.Id = question.Attribute("displaynumber").Value;
                    q.QuestionText = question.Attribute("questiontext").Value;
                    q.AnswerText = question.Attribute("answer").Value;

                    int questionID = int.Parse(question.Attribute("questionid").Value);
                    var mx = maturityExtra.Where(x => x.Maturity_Question_Id == questionID).FirstOrDefault();

                    switch (q.AnswerText)
                    {
                        case "Y":
                        case "NA":
                            break;
                        case "N":
                        case "U":
                            if (mx != null)
                            {
                                q.Score = (int)mx.SPRSValue;
                            }
                            break;
                    }

                    calculatedScore -= q.Score;

                    d.Questions.Add(q);
                }
            }

            response.SprsScore = calculatedScore;

            var sprsGauge = new Helpers.ReportWidgets.SprsScoreGauge(calculatedScore, 500, 100);
            response.GaugeSvg = sprsGauge.ToString();

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<LevelAnswers> GetAnswerDistributionByLevel(int assessmentId)
        {
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

            var model = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            int targetLevel;

            var selectedLevel = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();

            if (selectedLevel == null)
            {
                targetLevel = 1;
            }
            else
            {
                targetLevel = int.Parse(selectedLevel.Standard_Specific_Sal_Level);
            }

            var levels = _context.MATURITY_LEVELS
                .Include(x => x.MATURITY_QUESTIONS)
                .Where(x => x.Maturity_Model_Id == model.model_id && x.Level <= targetLevel)
                .ToList();

            var answers = _context.Answer_Maturity.Where(x => x.Assessment_Id == assessmentId);


            var response = new List<LevelAnswers>();

            foreach (var l in levels)
            {
                var levelAnswers = answers.Where(x =>
                    l.MATURITY_QUESTIONS.Select(q => q.Mat_Question_Id).Contains(x.Question_Or_Requirement_Id));

                var distrib = StatUtils.CalculateDistribution(levelAnswers.Select(a => a.Answer_Text).ToList());

                var levelAns = new LevelAnswers();
                levelAns.Name = l.Level_Name;
                levelAns.LevelValue = l.Level;
                levelAns.AnswerDistribution = distrib;
                response.Add(levelAns);
            }

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<DomainAnswers> GetAnswerDistributionByDomain(int assessmentId)
        {
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);
            var response = new List<DomainAnswers>();


            var structure = new MaturityStructureAsXml(assessmentId, _context, false);


            // In this model sructure, the Goal element represents domains
            // because there are no goals/subcategories above the questions

            var xDoc = structure.ToXDocument();

            foreach (var domain in xDoc.Descendants("Goal"))
            {
                var da = new DomainAnswers();
                da.DomainName = domain.Attribute("title").Value;

                var questions = domain.Descendants("Question").ToList();
                var answers = questions.Select(x => x.Attribute("answer")).Select(x => x.Value).ToList();
                var distrib = StatUtils.CalculateDistribution(answers);

                da.AnswerDistribution = distrib;

                response.Add(da);
            }

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public Dictionary<int, string> GetSourceFiles()
        {
            List<Tuple<int, string>> sourceFiles = (from a in _context.MATURITY_REFERENCES
                                                    join q in _context.MATURITY_QUESTIONS on a.Mat_Question_Id equals q.Mat_Question_Id
                                                    join g in _context.GEN_FILE on a.Gen_File_Id equals g.Gen_File_Id
                                                    where q.Maturity_Model_Id == 7 && a.Source
                                                    select new Tuple<int, string>(a.Mat_Question_Id, g.Short_Name + " " + a.Section_Ref))
                                                   .ToList();

            Dictionary<int, string> result = new Dictionary<int, string>();
            foreach (var sourceFile in sourceFiles)
            {
                if (result.TryGetValue(sourceFile.Item1, out var value))
                {
                    result[sourceFile.Item1] += "\r\n" + sourceFile.Item2;
                }
                else
                {
                    result.Add(sourceFile.Item1, sourceFile.Item2);
                }
            }

            return result;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public List<Model.Maturity.MaturityModel> GetAllModels()
        {
            var response = new List<Model.Maturity.MaturityModel>();

            var result = from a in _context.MATURITY_MODELS
                         select new Model.Maturity.MaturityModel()
                         {
                             MaturityTargetLevel = 1,
                             ModelId = a.Maturity_Model_Id,
                             ModelName = a.Model_Name,
                             QuestionsAlias = a.Questions_Alias,
                             // Leaving description blank for now. Model Description is being removed in favor of gallery card description.
                             ModelDescription = "",
                             ModelTitle = a.Model_Title
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


                // default the target level if the model supports a target level
                if (ModelsWithTargetLevel.Contains(mm.Model_Name))
                {
                    var targetLevel = _context.ASSESSMENT_SELECTED_LEVELS
                        .Where(l => l.Assessment_Id == assessmentId && l.Level_Name == Constants.Constants.MaturityLevel)
                        .FirstOrDefault();

                    if (targetLevel == null)
                    {
                        _context.ASSESSMENT_SELECTED_LEVELS.Add(new ASSESSMENT_SELECTED_LEVELS()
                        {
                            Assessment_Id = assessmentId,
                            Level_Name = Constants.Constants.MaturityLevel,
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
        /// Connects the assessment to a Maturity_Level.
        /// </summary>
        public void PersistMaturityLevel(int assessmentId, int level)
        {
            // SAL selections live in ASSESSMENT_SELECTED_LEVELS, which
            // is more complex to allow for the different types of SALs
            // as well as the user's selection(s).

            lock (myLock)
            {
                var result = _context.ASSESSMENT_SELECTED_LEVELS
                    .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel);
                if (result.Any())
                {
                    _context.ASSESSMENT_SELECTED_LEVELS.RemoveRange(result);
                    _context.SaveChanges();
                }
                _context.ASSESSMENT_SELECTED_LEVELS.Add(new ASSESSMENT_SELECTED_LEVELS()
                {
                    Assessment_Id = assessmentId,
                    Level_Name = Constants.Constants.MaturityLevel,
                    Standard_Specific_Sal_Level = level.ToString()
                });
                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(assessmentId);
            }
        }


        /// <summary>
        /// Deletes any maturity model connections to the assessment
        /// </summary>
        /// <param name="assessmentId"></param>
        public void ClearMaturityModel(int assessmentId)
        {
            var targetLevel = _context.ASSESSMENT_SELECTED_LEVELS.Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel).FirstOrDefault();
            if (targetLevel != null)
            {
                _context.ASSESSMENT_SELECTED_LEVELS.Remove(targetLevel);
            }

            var result = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId).ToList();
            if (result.Count > 0)
            {
                _context.AVAILABLE_MATURITY_MODELS.RemoveRange(result);
            }

            _context.SaveChanges();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetMaturityLevel(int assessmentId)
        {
            var result = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();
            if (result != null)
            {
                if (int.TryParse(result.Standard_Specific_Sal_Level, out int level))
                {
                    return level;
                }
            }

            return 0;
        }






        public AVAILABLE_MATURITY_MODELS ProcessModelDefaults(int assessmentId, int maturityModelId = 3)
        {
            //if the available maturity model is not selected and the application is CSET
            //the default is EDM
            //if the application is ACET the default is ACET
            //see ACETMaturityBusiness implementation

            var myModel = _context.AVAILABLE_MATURITY_MODELS
              .Include(x => x.model)
              .Where(x => x.Assessment_Id == assessmentId).FirstOrDefault();
            if (myModel == null)
            {
                myModel = new AVAILABLE_MATURITY_MODELS()
                {
                    Assessment_Id = assessmentId,
                    model_id = maturityModelId,
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
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public List<FunctionScore> GetMvraScoring(MaturityStructureForModel model)
        {
            List<FunctionScore> functionScores = new List<FunctionScore>();
            var functions = model.Model.Groupings;
            for (int f = 0; f < functions.Count(); f++)
            {
                FunctionScore functionScore = new FunctionScore()
                {
                    Title = functions[f].Title,
                    LevelScores = new List<LevelScore>()
                };
                if (functions[f]?.GroupType == "Function" && functions[f].Groupings.Any())
                {

                    var domains = functions[f].Groupings;
                    functionScore.DomainScores = new List<DomainScore>();
                    for (int d = 0; d < domains.Count(); d++)
                    {
                        var domain = domains[d];
                        DomainScore domainScore = new DomainScore();
                        domainScore.Title = domain.Title;
                        domainScore.CapabilityScores = new List<CapabilityScore>();
                        var capabilities = domain.Groupings;
                        for (int c = 0; c < capabilities.Count(); c++)
                        {
                            var capability = new CapabilityScore();
                            capability.Title = capabilities[c].Title;
                            capability.LevelScores = new List<LevelScore>();
                            capability.LevelScores.Add(GetLevelScoreQuestions(capabilities[c], "Basic"));
                            capability.LevelScores.Add(GetLevelScoreQuestions(capabilities[c], "Intermediate"));
                            capability.LevelScores.Add(GetLevelScoreQuestions(capabilities[c], "Advanced"));
                            domainScore.CapabilityScores.Add(capability);
                        }

                        domainScore.LevelScores = new List<LevelScore>();
                        domainScore.LevelScores.Add(GetLevelScore(domainScore.CapabilityScores, "Basic"));
                        domainScore.LevelScores.Add(GetLevelScore(domainScore.CapabilityScores, "Intermediate"));
                        domainScore.LevelScores.Add(GetLevelScore(domainScore.CapabilityScores, "Advanced"));
                        domainScore.Rating = GetDomainRating(domainScore.LevelScores);
                        domainScore.Credit = domainScore.Rating == "Pass" ? "Yes" : "No";

                        functionScore.DomainScores.Add(domainScore);
                    }
                    functionScore.Credit = GetFunctionCredit(functionScore.DomainScores);
                    functionScore.LevelScores.Add(GetFunctionLevelScores(functionScore.DomainScores, "Basic"));
                    functionScore.LevelScores.Add(GetFunctionLevelScores(functionScore.DomainScores, "Intermediate"));
                    functionScore.LevelScores.Add(GetFunctionLevelScores(functionScore.DomainScores, "Advanced"));
                    functionScores.Add(functionScore);
                }
            }

            return functionScores;
        }

        private LevelScore GetFunctionLevelScores(List<DomainScore> domains, string level)
        {
            LevelScore levelScore = new LevelScore();
            levelScore.Level = level;
            var capabilities = domains.SelectMany(x => x.CapabilityScores);
            var tiers = capabilities.SelectMany(z => z.LevelScores.Where(x => x.TotalTiers > 0 && x.Level == level));
            levelScore.TotalTiers = tiers.Count();
            levelScore.TotalPassed = tiers.Count(x => x.Credit == 100);
            if (levelScore.TotalTiers != 0)
            {
                var total = (double)levelScore.TotalPassed / levelScore.TotalTiers;
                levelScore.Credit = (int)Math.Round(total * 100, MidpointRounding.AwayFromZero);
            }
            else
            {
                levelScore.Credit = 0;
            }
            return levelScore;
        }


        private int GetFunctionCredit(List<DomainScore> domains)
        {
            var total = domains.Count();
            var totalPassed = domains.Count(x => x.Credit == "Yes");
            if (total != 0)
            {
                var div = (double)totalPassed / total;
                var percent = (int)Math.Round(div * 100, MidpointRounding.AwayFromZero);
                return percent;
            }

            return 0;
        }


        private string GetDomainRating(List<LevelScore> levels)
        {
            var total = levels.Sum(x => x.TotalTiers);
            var totalPassed = levels.Sum(x => x.TotalPassed);

            if (total != 0)
            {
                var div = (double)totalPassed / total;
                var percent = (int)Math.Round(div * 100, MidpointRounding.AwayFromZero);
                return percent >= 50 ? "Pass" : "Fail";
            }
            return "Fail";
        }


        private LevelScore GetLevelScore(List<CapabilityScore> scores, string level)
        {
            LevelScore levelScore = new LevelScore();
            levelScore.Level = level;
            var tiers = scores.SelectMany(x => x.LevelScores.Where(y => y.Level == level));
            levelScore.TotalTiers = tiers.Sum(x => x.TotalTiers);
            levelScore.TotalPassed = tiers.Sum(x => x.TotalPassed);
            if (levelScore.TotalTiers != 0)
            {
                var total = (double)levelScore.TotalPassed / levelScore.TotalTiers;
                levelScore.Credit = (int)Math.Round(total * 100, MidpointRounding.AwayFromZero);
            }
            else
            {
                levelScore.Credit = 0;
            }
            return levelScore;
        }

        private LevelScore GetLevelScoreQuestions(Model.Nested.Grouping group, string level)
        {
            LevelScore levelScore = new LevelScore();
            levelScore.Level = level;
            levelScore.TotalTiers = group.Questions.Count(x => x.MaturityLevelName == level);
            levelScore.TotalPassed = group.Questions.Count(x => x.AnswerText == "Y" && x.MaturityLevelName == level);
            if (levelScore.TotalTiers != 0)
            {
                var total = (double)levelScore.TotalPassed / levelScore.TotalTiers;
                levelScore.Credit = (int)Math.Round(total * 100, MidpointRounding.AwayFromZero);
            }
            else
            {
                levelScore.Credit = 0;
            }

            return levelScore;
        }


        /// <summary>
        /// Assembles a response consisting of maturity settings for the assessment
        /// as well as the question set in its hierarchy of domains, practices, etc.
        /// </summary>
        /// <param name="assessmentId"></param>
        public virtual MaturityResponse GetMaturityQuestions(int assessmentId, bool fill, int groupingId, string lang)
        {
            var response = new MaturityResponse();
            return GetMaturityQuestions(assessmentId, fill, groupingId, response, null, lang);
        }


        /// <summary>
        /// Assembles a response consisting of maturity questions for the assessment.
        /// </summary>
        /// <returns></returns>
        public MaturityResponse GetMaturityQuestions(int assessmentId, bool fill, int groupingId, MaturityResponse response, int? modelId, string lang)
        {
            if (fill)
            {
                _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);
            }

            var defaultModel = ProcessModelDefaults(assessmentId);

            var targetModelId = defaultModel.model_id;


            // If the model ID was specified by the caller, use that instead of the assessment's model
            if (modelId != null)
            {
                targetModelId = (int)modelId;
            }



            var targetModel = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == targetModelId).FirstOrDefault();

            if (targetModel == null)
            {
                return response;
            }


            response.ModelId = targetModel.Maturity_Model_Id;
            response.ModelName = targetModel.Model_Name;

            response.QuestionsAlias = targetModel.Questions_Alias ?? "Questions";


            if (targetModel.Answer_Options != null)
            {
                response.AnswerOptions = targetModel.Answer_Options.Split(',').ToList();
                response.AnswerOptions.ForEach(x => x = x.Trim());
            }


            response.MaturityTargetLevel = GetMaturityTargetLevel(assessmentId);

            // get the levels and their display names for this model
            response.Levels = GetMaturityLevelsForModel(targetModelId, response.MaturityTargetLevel);



            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questionQuery = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_QUESTION_PROPS)
                .Where(q =>
                targetModelId == q.Maturity_Model_Id);

            if (groupingId != 0 && targetModelId != 17)
            {
                questionQuery = questionQuery.Where(x => x.Question_Text.StartsWith("A"));
            }


            // Special "sub-model" logic 
            // Filter out questions that aren't whitelisted in MATURITY_SUB_MODEL_QUESTIONS if the assessment uses a sub-model
            var maturitySubmodel = _context.DETAILS_DEMOGRAPHICS.Where(x => x.Assessment_Id == assessmentId && x.DataItemName == "MATURITY-SUBMODEL").FirstOrDefault();
            if (maturitySubmodel != null)
            {
                var whitelist = _context.MATURITY_SUB_MODEL_QUESTIONS.Where(x => x.Sub_Model_Name == maturitySubmodel.StringValue).Select(q => q.Mat_Question_Id).ToList();
                questionQuery = questionQuery.Where(x => whitelist.Contains(x.Mat_Question_Id));
            }


            var questions = questionQuery.ToList();


            // apply translation overlay to the questions
            foreach (var q in questions)
            {
                var o = _overlay.GetMaturityQuestion(q.Mat_Question_Id, lang);
                if (o != null)
                {
                    if (o.QuestionTitle != null)
                    {
                        q.Question_Title = o.QuestionTitle;
                    }
                    q.Question_Text = o.QuestionText;
                    q.Supplemental_Info = o.SupplementalInfo;
                    q.Examination_Approach = o.ExaminationApproach;
                    q.Security_Practice = o.SecurityPractice;
                    q.Outcome = o.Outcome;
                    q.Scope = o.Scope;
                    q.Recommend_Action = o.RecommendAction;
                    q.Risk_Addressed = o.RiskAddressed;
                    q.Services = o.Services;
                    q.Implementation_Guides = o.Implementation_Guides;
                }
            }


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == targetModel.Maturity_Model_Id).ToList();


            // overlay group properties for language
            allGroupings.ForEach(
                grouping =>
                {
                    var o = _overlay.GetMaturityGrouping(grouping.Grouping_Id, lang);
                    if (o != null)
                    {
                        grouping.Title = o.Title;
                        grouping.Description = o.Description;
                    }
                });


            // Recursively build the grouping/question hierarchy
            var tempModel = new MaturityGrouping();
            BuildSubGroupings(tempModel, null, allGroupings, questions, answers.ToList(), lang);

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
            response.Glossary = this.GetGlossaryEntries(targetModel.Maturity_Model_Id);

            return response;
        }


        /// <summary>
        /// Recursive method that builds subgroupings for the specified group.
        /// It also attaches any questions pertinent to this group.
        /// </summary>
        public void BuildSubGroupings(MaturityGrouping g, int? parentID,
            List<MATURITY_GROUPINGS> allGroupings,
            List<MATURITY_QUESTIONS> questions,
            List<FullAnswer> answers,
            string lang)
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

                var o = _overlay.GetMaturityGrouping(newGrouping.GroupingID, lang);
                if (o != null)
                {
                    newGrouping.Title = o.Title;
                    newGrouping.Description = o.Description;
                }


                g.SubGroupings.Add(newGrouping);


                // are there any questions that belong to this grouping?
                var myQuestions = questions.Where(x => x.Grouping_Id == newGrouping.GroupingID).ToList();

                var parentQuestionIDs = myQuestions.Select(x => x.Parent_Question_Id).Distinct().ToList();

                foreach (var myQ in myQuestions)
                {
                    FullAnswer answer = answers.Where(x => x.a.Question_Or_Requirement_Id == myQ.Mat_Question_Id).FirstOrDefault();


                    var qa = QuestionAnswerBuilder.BuildQuestionAnswer(myQ, answer);
                    qa.MaturityModelId = sg.Maturity_Model_Id;
                    qa.IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id);


                    // Include CSF mappings
                    qa.CsfMappings = _addlSuppl.GetCsfMappings(qa.QuestionId, "Maturity");

                    // Include any TTPs
                    qa.TTP = _addlSuppl.GetTTPReferenceList(qa.QuestionId);


                    foreach (var prop in myQ.MATURITY_QUESTION_PROPS)
                    {
                        qa.Props.Add(new QuestionProp()
                        {
                            Name = prop.PropertyName,
                            Value = prop.PropertyValue
                        });
                    }

                    qa.Countable = IsQuestionCountable(myQ.Maturity_Model_Id, qa);

                    if (answer != null)
                    {
                        TinyMapper.Bind<VIEW_QUESTIONS_STATUS, QuestionAnswer>();
                        TinyMapper.Map(answer.b, qa);

                        // db view still uses the term "HasDiscovery" - map to "HasObservation"
                        qa.HasObservation = answer.b.HasDiscovery ?? false;
                    }

                    newGrouping.Questions.Add(qa);
                }


                newGrouping.Questions.Sort((a, b) => a.Sequence.CompareTo(b.Sequence));


                // Recurse down to build subgroupings
                BuildSubGroupings(newGrouping, newGrouping.GroupingID, allGroupings, questions, answers, lang);
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
                .Include(x => x.model)
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
        /// This method attempts to identify which questions are countable
        /// in the UI's answer completion widget on the questions page.  
        /// Maybe the real solution is a new property on the question 
        /// record itself, but for now we will try to identify which
        /// questions should not be counted.
        /// </summary>
        /// <param name="modelId"></param>
        /// <param name="question"></param>
        /// <returns></returns>
        private bool IsQuestionCountable(int modelId, QuestionAnswer qa)
        {
            // EDM and CRR - parent questions are unanswerable and not countable
            if (modelId == 3 || modelId == 4)
            {
                return !qa.IsParentQuestion;
            }

            // VADR - child questions are freeform and not countable
            if (modelId == 7)
            {
                return qa.ParentQuestionId == null;
            }

            // ISE - parent questions are not answerable and not countable
            if (modelId == 10)
            {
                return !qa.IsParentQuestion;
            }

            return true;
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
                && x.Question_Type == answer.QuestionType
                && x.Mat_Option_Id == answer.OptionId).FirstOrDefault();


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
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
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




        /// <summary>
        /// Set default values for target level where applicable
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public void SetDefaultTargetLevels(int assessmentId, string modelName)
        {
            var result = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel);
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
                    Level_Name = Constants.Constants.MaturityLevel,
                    Standard_Specific_Sal_Level = "1"
                });
                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(assessmentId);
            }
        }


        /// <summary>
        /// This method gets the CPG model.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="includeSupplemental"></param>
        /// <returns></returns>
        public Model.Maturity.CPG.ContentModel GetMaturityStructure(int assessmentId, bool includeSupplemental, string lang)
        {
            var ss = new CpgStructure(assessmentId, _context, includeSupplemental, lang, null);
            return ss.Top;
        }


        /// <summary>
        /// This method gets a specified SSG model, but in the CPG structure needed for reports.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="includeSupplemental"></param>
        /// <returns></returns>
        public Model.Maturity.CPG.ContentModel GetMaturityStructure(int assessmentId, bool includeSupplemental, string lang, int modelId)
        {
            var ss = new CpgStructure(assessmentId, _context, includeSupplemental, lang, modelId);
            return ss.Top;
        }


        /// <summary>
        /// Returns the maturity grouping/question structure
        /// for an assessment as JSON.     
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public XDocument GetMaturityStructureAsXml(int assessmentId, bool includeSupplemental)
        {
            var x = new MaturityStructureAsXml(assessmentId, _context, includeSupplemental);
            return x.ToXDocument();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public MaturityStructureForModel GetMaturityStructureForModel(int modelId, int assessmentId)
        {
            var msfm = new MaturityStructureForModel(modelId, _context, true, assessmentId);
            return msfm;
        }


        /// <summary>
        /// Returns an unordered list of MATURITY_GROUPINGS titles and IDs for a model.
        /// </summary>
        /// <param name="modelId"></param>
        /// <returns></returns>
        public List<GroupingTitle> GetGroupingTitles(int modelId, string lang)
        {
            var dbList = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == modelId).ToList();

            var response = new List<GroupingTitle>();
            dbList.ForEach(x =>
            {
                var o = _overlay.GetMaturityGrouping(x.Grouping_Id, lang);
                if (o != null)
                {
                    x.Title = o.Title;
                    //x.Title_Prefix = ?
                }


                response.Add(new GroupingTitle()
                {
                    Id = x.Grouping_Id,
                    Title = x.Title,
                    TitlePrefix = x.Title_Prefix
                });
            });

            return response;
        }


        /// <summary>
        /// Converts a NestedQuestions structure to a MaturityResponse structure.
        /// </summary>
        /// <param name="structure"></param>
        /// <returns></returns>
        public MaturityResponse ConvertToMaturityResponse(Model.Nested.NestedQuestions structure)
        {
            this._maturityModelId = structure.ModelId;

            var resp = new MaturityResponse();

            resp.MaturityTargetLevel = 100;

            foreach (var g in structure.Groupings)
            {
                resp.Groupings = MapGroupings(g);
            }

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        private List<MaturityGrouping> MapGroupings(Model.Nested.Grouping g)
        {
            var list = new List<MaturityGrouping>();

            foreach (var cisG in g.Groupings)
            {
                var newG = new MaturityGrouping()
                {
                    Description = cisG.Description,
                    Abbreviation = cisG.Abbreviation,
                    GroupingType = cisG.GroupType,
                    GroupingID = cisG.GroupingId,
                    Title = cisG.Title
                };

                list.Add(newG);

                newG.Questions = MapQuestions(cisG);

                newG.SubGroupings = MapGroupings(cisG);
            }

            return list;
        }


        /// <summary>
        /// 
        /// </summary>
        private List<QuestionAnswer> MapQuestions(Model.Nested.Grouping g)
        {
            var questionAnswer = new List<QuestionAnswer>();

            foreach (var q in g.Questions)
            {
                var newQ = new QuestionAnswer()
                {
                    Answer = q.AnswerText,
                    AltAnswerText = q.AltAnswerText,
                    QuestionId = q.QuestionId,
                    DisplayNumber = q.DisplayNumber,
                    Sequence = q.Sequence,
                    QuestionText = q.QuestionText,
                    QuestionType = "Maturity",
                    Comment = q.Comment,
                    MaturityLevelName = q.MaturityLevelName
                };

                newQ.Countable = IsQuestionCountable(this._maturityModelId, newQ);

                q.Options.ForEach(o =>
                {
                    newQ.Options.Add(o);
                });

                questionAnswer.Add(newQ);
            }

            return questionAnswer;
        }
    }
}
