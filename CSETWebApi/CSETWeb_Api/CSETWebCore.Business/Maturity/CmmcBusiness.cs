//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Maturity;
using System.Collections.Generic;
using System.Xml.Linq;
using System.Linq;


namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// 
    /// </summary>
    public class CmmcBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private TranslationOverlay _overlay;

        private AdditionalSupplemental _addlSuppl;

        private List<MATURITY_EXTRA> _maturityExtra;

        private readonly List<string> _goodAnswerOptions = new List<string>() {"Y", "NA"};

        // CMMC 2.0 FINAL model ID
        private readonly int modelIdCmmc2 = 19;

        private readonly int _level1Max = 15;
        private readonly int _level2Max = 110;
        private readonly int _level3Max = 24;


        /// <summary>
        /// CTOR
        /// </summary>
        public CmmcBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;

            _addlSuppl = new AdditionalSupplemental(context);

            _overlay = new TranslationOverlay();

            var query = from me in _context.MATURITY_EXTRA
                        join mq in _context.MATURITY_QUESTIONS on me.Maturity_Question_Id equals mq.Mat_Question_Id
                        where mq.Maturity_Model_Id == modelIdCmmc2
                        select me;


            _maturityExtra = query.ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        public CmmcScores GetCmmcScores(int assessmentId)
        {
            var response = new CmmcScores();

            var selectedLevel = _context.ASSESSMENT_SELECTED_LEVELS
                .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
                .FirstOrDefault();

            if (selectedLevel != null)
            {
                response.TargetLevel = int.Parse(selectedLevel.Standard_Specific_Sal_Level);
            }



            // Level 1
            response.Level1Score = GetScoreForLevel(assessmentId, 1);
            response.Level1MaxScore = _level1Max;



            // Level 2
            var sprs = GetSPRSScore(assessmentId);
            response.Level2Score = sprs.LevelScore;
            response.Level2MaxScore = _level2Max;
            response.Level2Active = (response.Level1Score == _level1Max);



            // Level 3
            response.Level3Score = GetScoreForLevel(assessmentId, 3);
            response.Level3MaxScore = _level3Max;
            response.Level3Active = response.Level2Active && (response.Level2Score == _level2Max);


            return response;
        }


        /// <summary>
        /// Sums up the number of "Y" and "NA" answers for CMMC2F questions 
        /// at a given maturity level.
        /// 
        /// This method assumes 1 point rewarded per MET question.
        /// </summary>
        public int GetScoreForLevel(int assessmentId, int level)
        {
            var levelId = _context.MATURITY_LEVELS
                .Where(x => x.Level == level && x.Maturity_Model_Id == modelIdCmmc2)
                .Select(x => x.Maturity_Level_Id)
                .FirstOrDefault();

            var query = from a in _context.ANSWER
                        join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                        where q.Maturity_Level_Id == levelId && a.Assessment_Id == assessmentId
                        select a;

            var answerList = query.ToList().Select(x => x.Answer_Text).ToList();

            var score = answerList.Where(x => _goodAnswerOptions.Contains(x)).Count();

            return score;
        }


        /// <summary>
        /// Returns a list of scorecards, one for each active level.
        /// </summary>
        /// <returns></returns>
        public ScorecardResponse GetLevelScorecards(int assessmentId)
        {
            var response = new ScorecardResponse();

            var selectedLevel = _context.ASSESSMENT_SELECTED_LEVELS
               .Where(x => x.Assessment_Id == assessmentId && x.Level_Name == Constants.Constants.MaturityLevel)
               .FirstOrDefault();

            if (selectedLevel != null)
            {
                response.TargetLevel = int.Parse(selectedLevel.Standard_Specific_Sal_Level);
            }

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

            var options = new StructureOptions() {
                IncludeQuestionText = true,
                IncludeSupplemental = false
            };

            var x = biz.GetMaturityStructureAsXml(assessmentId, options);


            var l1 = FilterByLevel(x, 1);
            if (l1.Domains.Count > 0)
            {
                response.LevelScorecards.Add(l1);
            }

            var l2 = FilterByLevel(x, 2);
            if (l2.Domains.Count > 0)
            {
                response.LevelScorecards.Add(l2);
            }

            var l3 = FilterByLevel(x, 3);
            if (l3.Domains.Count > 0)
            {
                response.LevelScorecards.Add(l3);
            }

            return response;
        }


        /// <summary>
        /// Returns an object with all domains and questions at 
        /// the specified maturity level.  
        /// 
        /// Questions are also assigned their score/deduction.
        /// </summary>
        private CmmcScoreModel FilterByLevel(XDocument x, int level)
        {
            var response = new CmmcScoreModel();
            response.Level = level;


            foreach (var goal in x.Descendants("Goal"))
            {
                var d = new CmmcDomain();
                d.DomainName = goal.Attribute("title").Value;
                

                foreach (var question in goal.Descendants("Question"))
                {
                    if (question.Attribute("level").Value != level.ToString())
                    {
                        continue;
                    }

                    var q = new CmmcQuestion();
                    q.QuestionId = int.Parse(question.Attribute("questionid").Value);
                    q.Title = question.Attribute("displaynumber").Value;
                    q.QuestionText = question.Attribute("questiontext")?.Value;
                    q.AnswerText = question.Attribute("answer").Value;

                    q.Score = DeductionForAnswer(q);

                    d.Questions.Add(q);
                }

                if (d.Questions.Count() > 0)
                {
                    response.Domains.Add(d);
                }
            }

            return response;
        }


        /// <summary>
        /// Calculates a SPRS score based on the level 2 question scoring values in MATURITY_EXTRA.
        /// </summary>
        public CmmcScoreModel GetSPRSScore(int assessmentId)
        {
            var response = new CmmcScoreModel();

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var options = new StructureOptions() { IncludeQuestionText = true, IncludeSupplemental = false };
            var x = biz.GetMaturityStructureAsXml(assessmentId, options);


            int calculatedScore = 110;

            foreach (var goal in x.Descendants("Goal"))
            {
                var d = new CmmcDomain();
                d.DomainName = goal.Attribute("title").Value;
                response.Domains.Add(d);

                foreach (var question in goal.Descendants("Question").Where(x => x.Attribute("level").Value == "2"))
                {
                    var q = new CmmcQuestion();
                    q.QuestionId = int.Parse(question.Attribute("questionid").Value);
                    q.Title = question.Attribute("displaynumber").Value;
                    q.QuestionText = question.Attribute("questiontext").Value;
                    q.AnswerText = question.Attribute("answer").Value;
                    q.Score = DeductionForAnswer(q);

                    int questionID = int.Parse(question.Attribute("questionid").Value);

                    // Adjust the SPRS score 
                    calculatedScore -= q.Score;

                    d.Questions.Add(q);
                }
            }

            response.LevelScore = calculatedScore;

            // TODO:  With the release of CMMC 2.0 Final the gauge is built in the UI and this 
            //        code will not be needed.
            var sprsGauge = new Helpers.ReportWidgets.SprsScoreGauge(calculatedScore, 500, 100);
            response.GaugeSvg = sprsGauge.ToString();

            return response;
        }


        /// <summary>
        /// Returns the number of points deducted based on the question's answer.
        /// Successful answers (Y, NA) deduct no points.
        /// Questions not defined with a point value in MATURITY_EXTRA (e.g., Level 1 and Level 3)
        /// default to a 1-point deduction.
        /// </summary>
        private int DeductionForAnswer(CmmcQuestion q)
        {
            if (_goodAnswerOptions.Contains(q.AnswerText))
            {
                return 0;
            }

            var mx = _maturityExtra.Where(x => x.Maturity_Question_Id == q.QuestionId).FirstOrDefault();

            // default to 1 if no score is defined
            if (mx == null || mx.SPRSValue == null)
            {
                return 1;
            }

            return (int)mx.SPRSValue;
        }
    }
}
