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
using CSETWebCore.Model.Acet;
using CSETWebCore.Model.Edm;
using CSETWebCore.Model.Maturity;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Sal;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Xml.Linq;
using CSETWebCore.Model.Mvra;
using CSETWebCore.Business.Acet;
using CSETWebCore.DataLayer.Manual;


namespace CSETWebCore.Business.Maturity
{
    public class MaturityBusiness : IMaturityBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        private int _maturityModelId;

        private TranslationOverlay _overlay;

        private AdditionalSupplemental _addlSuppl;

        public readonly List<string> ModelsWithTargetLevel = new List<string>() { "ACET", "CMMC", "CMMC2" };

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
            List<Tuple<int, string>> sourceFiles = (from a in _context.MATURITY_SOURCE_FILES
                                                    join q in _context.MATURITY_QUESTIONS on a.Mat_Question_Id equals q.Mat_Question_Id
                                                    join g in _context.GEN_FILE on a.Gen_File_Id equals g.Gen_File_Id
                                                    where q.Maturity_Model_Id == 7
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

        private static object myLock = new object();

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


        public AVAILABLE_MATURITY_MODELS ProcessModelDefaults(int assessmentId, string installationMode, int maturityModelId = 3)
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
        public virtual MaturityResponse GetMaturityQuestions(int assessmentId, bool fill, int groupingId, string installationMode, string lang)
        {
            var response = new MaturityResponse();
            return GetMaturityQuestions(assessmentId, installationMode, fill, groupingId, response, lang);
        }


        /// <summary>
        /// Assembles a response consisting of maturity questions for the assessment.
        /// </summary>
        /// <returns></returns>
        public MaturityResponse GetMaturityQuestions(int assessmentId, string installationMode, bool fill, int groupingId, MaturityResponse response, string lang)
        {
            if (fill)
            {
                _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);
            }

            var myModel = ProcessModelDefaults(assessmentId, installationMode);


            var myModelDefinition = _context.MATURITY_MODELS.Where(x => x.Maturity_Model_Id == myModel.model_id).FirstOrDefault();

            if (myModelDefinition == null)
            {
                return response;
            }


            response.ModelId = myModelDefinition.Maturity_Model_Id;
            response.ModelName = myModelDefinition.Model_Name;

            response.QuestionsAlias = myModelDefinition.Questions_Alias ?? "Questions";


            if (myModelDefinition.Answer_Options != null)
            {
                response.AnswerOptions = myModelDefinition.Answer_Options.Split(',').ToList();
                response.AnswerOptions.ForEach(x => x = x.Trim());
            }


            response.MaturityTargetLevel = GetMaturityTargetLevel(assessmentId);

            // get the levels and their display names for this model
            response.Levels = GetMaturityLevelsForModel(myModel.model_id, response.MaturityTargetLevel);



            // Get all maturity questions for the model regardless of level.
            // The user may choose to see questions above the target level via filtering. 
            var questionQuery = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_Level)
                .Include(x => x.MATURITY_QUESTION_PROPS)
                .Where(q =>
                myModel.model_id == q.Maturity_Model_Id);

            if (groupingId != 0)
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

            if (lang == "es")
            {
                Dictionary<int, SpanishQuestionRow> dictionary = AcetBusiness.buildQuestionDictionary();
                questions.ForEach(
                    question =>
                    {
                        var output = new SpanishQuestionRow();
                        var temp = new SpanishQuestionRow();
                        // test if not finding a match will safely skip
                        if (dictionary.TryGetValue(question.Mat_Question_Id, out output))
                        {
                            question.Question_Text = dictionary[question.Mat_Question_Id].Question_Text;
                            question.Examination_Approach = dictionary[question.Mat_Question_Id].Examination_Approach;
                            question.Supplemental_Info = dictionary[question.Mat_Question_Id].Supplemental_Info;
                        }
                    });
            }
            //


            // Get all MATURITY answers for the assessment
            var answers = from a in _context.ANSWER.Where(x => x.Assessment_Id == assessmentId && x.Question_Type == "Maturity")
                          from b in _context.VIEW_QUESTIONS_STATUS.Where(x => x.Answer_Id == a.Answer_Id).DefaultIfEmpty()
                          select new FullAnswer() { a = a, b = b };


            // Get all subgroupings for this maturity model
            var allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == myModel.model_id).ToList();

            //
            if (lang == "es")
            {
                Dictionary<int, GroupingSpanishRow> dictionary = AcetBusiness.buildGroupingDictionary();
                allGroupings.ForEach(
                    group =>
                    {
                        var output = new GroupingSpanishRow();
                        var temp = new GroupingSpanishRow();
                        if (dictionary.TryGetValue(group.Grouping_Id, out output))
                        {
                            group.Title = dictionary[group.Grouping_Id].Spanish_Title;
                        }
                    });
            }
            //

            // overlay group properties for language
            allGroupings.ForEach(
                grouping =>
                {
                    var o = _overlay.GetGrouping(grouping.Grouping_Id, lang);
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

                var o = _overlay.GetGrouping(newGrouping.GroupingID, lang);
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

                    var qa = new QuestionAnswer()
                    {
                        DisplayNumber = myQ.Question_Title,
                        QuestionId = myQ.Mat_Question_Id,
                        ParentQuestionId = myQ.Parent_Question_Id,
                        Sequence = myQ.Sequence,
                        ShortName = myQ.Short_Name,
                        QuestionType = "Maturity",
                        QuestionText = myQ.Question_Text,

                        Scope = myQ.Scope,
                        RecommendedAction = myQ.Recommend_Action,
                        RiskAddressed = myQ.Risk_Addressed,
                        Services = myQ.Services,

                        Answer = answer?.a.Answer_Text,
                        AltAnswerText = answer?.a.Alternate_Justification,
                        FreeResponseAnswer = answer?.a.Free_Response_Answer,

                        Comment = answer?.a.Comment,
                        Feedback = answer?.a.FeedBack,
                        MarkForReview = answer?.a.Mark_For_Review ?? false,
                        Reviewed = answer?.a.Reviewed ?? false,

                        Is_Maturity = true,
                        MaturityModelId = sg.Maturity_Model_Id,
                        MaturityLevel = myQ.Maturity_Level.Level,
                        MaturityLevelName = myQ.Maturity_Level.Level_Name,
                        IsParentQuestion = parentQuestionIDs.Contains(myQ.Mat_Question_Id),
                        SetName = string.Empty
                    };


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


        // The methods that follow were originally built for NCUA/ACET.
        // It is hoped that they will eventually be refactored to fit a more
        // 'generic' approach to maturity models.
        public List<MaturityDomain> GetMaturityAnswers(int assessmentId, bool spanishFlag = false)
        {
            var data = _context.GetMaturityDetailsCalculations(assessmentId).ToList();
            // If there are no data, we have no maturity answers so skip the rest
            if (data.Count == 0)
            {
                return new List<MaturityDomain>();
            }
            return CalculateComponentValues(data, assessmentId, spanishFlag);
        }

        public List<MaturityDomain> GetIseMaturityAnswers(int assessmentId)
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
        public List<MaturityDomain> CalculateComponentValues(List<GetMaturityDetailsCalculations_Result> maturity, int assessmentId, bool spanishFlag = false)
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

            var maturityRange = GetMaturityRange(assessmentId);
            Dictionary<string, GroupingSpanishRow> dictionary = new Dictionary<string, GroupingSpanishRow>();

            if (spanishFlag)
            {
                dictionary = AcetBusiness.buildResultsGroupingDictionary();
            }

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
                            if (maturityRange.Contains("Baseline"))
                            {
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
                            }


                            var evolving = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0


                            };
                            if (maturityRange.Contains("Evolving"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.EvolvingMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }
                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var intermediate = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };
                            if (maturityRange.Contains("Intermediate"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.IntermediateMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var advanced = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };
                            if (maturityRange.Contains("Advanced"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.AdvancedMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }


                            var innovative = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            if (maturityRange.Contains("Innovative"))
                            {
                                CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).Total) : 0;
                                AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.InnovativeMaturity.ToUpper()).AnswerPercent * 100) : 0;

                                totalAnswered = 0;

                                if (AnsweredPer > 0)
                                {
                                    totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                                }

                                CompQT += CompQuestions;
                                CompAT += totalAnswered;
                            }

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

                    //
                    if (spanishFlag)
                    {
                        var output = new GroupingSpanishRow();
                        if (dictionary.TryGetValue(maturityDomain.DomainName, out output))
                        {
                            maturityDomain.DomainName = dictionary[maturityDomain.DomainName].Spanish_Title;
                            maturityDomain.Assessments.ForEach(
                                assessment =>
                                {
                                    var output = new GroupingSpanishRow();
                                    // test if not finding a match will safely skip
                                    if (dictionary.TryGetValue(assessment.AssessmentFactor, out output))
                                    {
                                        assessment.AssessmentFactor = dictionary[assessment.AssessmentFactor].Spanish_Title;

                                        assessment.Components.ForEach(
                                            component =>
                                            {
                                                var output = new GroupingSpanishRow();
                                                // test if not finding a match will safely skip
                                                if (dictionary.TryGetValue(component.ComponentName, out output))
                                                {
                                                    component.ComponentName = dictionary[component.ComponentName].Spanish_Title;
                                                }
                                            });
                                    }
                                });
                        }
                    }
                    //

                    maturityDomains.Add(maturityDomain);
                }
            }

            maturityDomains = maturityDomains.OrderBy(x => x.Sequence).ToList();
            return maturityDomains;
        }

        /// <summary>
        /// Calculate maturity levels of components
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        public List<MaturityDomain> CalculateIseComponentValues(List<GetMaturityDetailsCalculations_Result> maturity, int assessmentId)
        {

            var maturityDomains = new List<MaturityDomain>();
            var domains = _context.MATURITY_GROUPINGS.Where(row => row.Maturity_Model_Id == 10 && row.Group_Level == 2).ToList();
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
                    var tGroupOrder = maturity.FirstOrDefault(x => x.Domain == d.Title);
                    var maturityDomain = new MaturityDomain
                    {
                        DomainName = d.Title,
                        Assessments = new List<MaturityAssessment>(),
                        Sequence = Int32.Parse(d.Title_Id),
                        TargetPercentageAchieved = 0,
                        PercentAnswered = 0
                    };

                    var DomainQT = 0;
                    var DomainAT = 0;

                    var partial_sub_categoy = sub_categories.Where(x => x.Domain == d.Title).GroupBy(x => x.AssessmentFactor).Select(x => x.Key);
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
                            var scuep = new SalAnswers
                            {
                                UnAnswered = !maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent).Complete,
                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()).AnswerPercent * 100) : 0
                            };

                            // Calc total questons and anserwed
                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.ScuepMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }
                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            var core = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()).AnswerPercent * 100) : 0


                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CoreMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }
                            CompQT += CompQuestions;
                            CompAT += totalAnswered;


                            var corePlus = new SalAnswers
                            {

                                Answered = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()).AnswerPercent * 100) : 0

                            };

                            CompQuestions = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()).Total) : 0;
                            AnsweredPer = maturity.Any(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()) ? Convert.ToInt32(maturity.FirstOrDefault(x => x.FinComponent == c.FinComponent && x.MaturityLevel == Constants.Constants.CorePlusMaturity.ToUpper()).AnswerPercent * 100) : 0;

                            totalAnswered = 0;

                            if (AnsweredPer > 0)
                            {
                                totalAnswered = Convert.ToInt32((AnsweredPer / 100) * CompQuestions);
                            }

                            CompQT += CompQuestions;
                            CompAT += totalAnswered;

                            component.Scuep = scuep.Answered;
                            component.Core = core.Answered;
                            component.CorePlus = corePlus.Answered;
                            component.AssessedMaturityLevel = scuep.UnAnswered ? Constants.Constants.IncompleteMaturity :
                                                                scuep.Answered < 100 ? Constants.Constants.SubBaselineMaturity :
                                                                    core.Answered < 100 ? Constants.Constants.ScuepMaturity :
                                                                        corePlus.Answered < 100 ? Constants.Constants.CoreMaturity :
                                                                            "CORE+";

                            maturityAssessment.Components.Add(component);

                            AssQT += CompQT;
                            AssAT += CompAT;
                        }

                        maturityAssessment.AssessmentFactorMaturity = maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                        maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                            maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.ScuepMaturity) ? Constants.Constants.ScuepMaturity :
                                                                                maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.CoreMaturity) ? Constants.Constants.CoreMaturity :
                                                                                    maturityAssessment.Components.Any(x => x.AssessedMaturityLevel == Constants.Constants.CorePlusMaturity) ? Constants.Constants.CorePlusMaturity :
                                                                                        Constants.Constants.IncompleteMaturity;

                        maturityAssessment.Components = maturityAssessment.Components.OrderBy(x => x.Sequence).ToList();
                        maturityDomain.Assessments.Add(maturityAssessment);

                        DomainQT += AssQT;
                        DomainAT += AssAT;

                    }

                    maturityDomain.DomainMaturity = maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.IncompleteMaturity) ? Constants.Constants.IncompleteMaturity :
                                                                        maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.SubBaselineMaturity) ? Constants.Constants.SubBaselineMaturity :
                                                                           maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.ScuepMaturity) ? Constants.Constants.ScuepMaturity :
                                                                               maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.CoreMaturity) ? Constants.Constants.CoreMaturity :
                                                                                   maturityDomain.Assessments.Any(x => x.AssessmentFactorMaturity == Constants.Constants.CorePlusMaturity) ? Constants.Constants.CorePlusMaturity :
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
        /// Get matrix for maturity determination based on total irp rating
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> GetIseMaturityRange(int assessmentId)
        {
            Model.Acet.ACETDashboard irpCalculation = GetIseIrpCalculation(assessmentId);
            int assetLevel = long.Parse(irpCalculation.Assets) > 50000000 ? 2 : 1;
            bool targetBandOnly = GetTargetBandOnly(assessmentId);
            int irpRating = irpCalculation.Override > 0 ? irpCalculation.Override : assetLevel;
            if (!targetBandOnly)
                irpRating = 2; //Do the default configuration
            return IrpSwitchIse(irpRating);
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
        /// Returns the active maturity level list, but the IDs for the levels.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<int> GetIseMaturityRangeIds(int assessmentId)
        {
            var output = new List<int>();

            var result = GetIseMaturityRange(assessmentId);

            var levels = _context.MATURITY_LEVELS.Where(x => x.Maturity_Model_Id == 10).ToList();
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
        /// 
        /// </summary>
        /// <param name="irpRating"></param>
        /// <returns></returns>
        public List<string> IrpSwitchIse(int irpRating)
        {
            switch (irpRating)
            {
                case 1:
                    return new List<string> { Constants.Constants.ScuepMaturity };
                case 2:
                    return new List<string>
                        { Constants.Constants.CoreMaturity, Constants.Constants.CorePlusMaturity };
                default:
                    return new List<string>
                    {
                        Constants.Constants.ScuepMaturity, Constants.Constants.CoreMaturity, Constants.Constants.CorePlusMaturity
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
                    join fm in _context.FINANCIAL_MATURITY on fg.Financial_Level_Id equals fm.Financial_Level_Id
                    where req.Original_Set_Name == "ACET_V1"
                    select new { req.Requirement_Id, fr.StmtNumber, fm.Financial_Level_Id, fm.Acronym, fm.MaturityLevel };

            var dict = new Dictionary<int, MaturityMap>();
            foreach (var a in q)
            {
                dict.Add(a.Requirement_Id, new MaturityMap(a.Financial_Level_Id, a.Acronym, a.MaturityLevel));
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
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int GetOverallIseIrpNumber(int assessmentId)
        {
            var calc = GetIseIrpCalculation(assessmentId);
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

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT.Assessment_Id == assessmentId);
                if (headerInfo != null)
                {
                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                    summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    summary.Comment = headerInfo.COMMENT;
                }

                List<DataLayer.Model.IRP> irps = _context.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = _context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x => x);
                foreach (DataLayer.Model.IRP irp in irps)
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

        /// <summary>
        /// Get all IRP calculations for display
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public Model.Acet.ACETDashboard GetIseIrpCalculation(int assessmentId)
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

            var scuepIRPLevel = 1;
            var coreIRPLevel = 2;

            if (result.Override == 0)
            {
                result.Override = long.Parse(result.Assets) > 50000000 ? coreIRPLevel : scuepIRPLevel;
            }

            foreach (IRP_HEADER header in _context.IRP_HEADER)
            {
                IRPSummary summary = new IRPSummary();
                summary.HeaderText = header.Header;

                ASSESSMENT_IRP_HEADER headerInfo = _context.ASSESSMENT_IRP_HEADER.FirstOrDefault(h => h.IRP_HEADER.IRP_Header_Id == header.IRP_Header_Id && h.ASSESSMENT.Assessment_Id == assessmentId);
                if (headerInfo != null)
                {
                    summary.RiskLevelId = headerInfo.HEADER_RISK_LEVEL_ID ?? 0;
                    summary.RiskLevel = headerInfo.RISK_LEVEL.Value;
                    summary.Comment = headerInfo.COMMENT;
                }

                List<DataLayer.Model.IRP> irps = _context.IRP.Where(i => i.Header_Id == header.IRP_Header_Id).ToList();
                Dictionary<int, ASSESSMENT_IRP> dictionaryIRPS = _context.ASSESSMENT_IRP.Where(x => x.Assessment_Id == assessmentId).ToDictionary(x => x.IRP_Id, x => x);
                foreach (DataLayer.Model.IRP irp in irps)
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
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="includeSupplemental"></param>
        /// <returns></returns>
        public Model.Maturity.CPG.ContentModel GetMaturityStructure(int assessmentId, bool includeSupplemental, string lang)
        {
            var ss = new MaturityStructure(assessmentId, _context, includeSupplemental, lang);
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
        public List<GroupingTitle> GetGroupingTitles(int modelId)
        {
            var dbList = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == modelId).ToList();

            var response = new List<GroupingTitle>();
            dbList.ForEach(x =>
            {
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
