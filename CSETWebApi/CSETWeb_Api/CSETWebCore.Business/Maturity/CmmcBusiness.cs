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


        private readonly int modelIdCmmc2 = 19;

        private int _level1Max = 15;
        private int _level2Max = 110;


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
        }


        /// <summary>
        /// 
        /// </summary>
        public CmmcScores GetCmmcScores(int assessmentId)
        {
            var response = new CmmcScores();


            // Level 1
            response.Level1Score = GetScoreForLevel(assessmentId, 1);



            // Level 2
            var sprs = GetSPRSScore(assessmentId);
            response.Level2Score = sprs.SprsScore;
            response.Level2Active = (response.Level1Score == _level1Max);



            // Level 3
            response.Level3Score = GetScoreForLevel(assessmentId, 3);
            response.Level3Active = (response.Level2Score == _level2Max);


            return response;
        }


        /// <summary>
        /// Sums up the number of "Y" and "NA" answers for CMMC2F questions 
        /// at a given maturity level.
        /// </summary>
        public int GetScoreForLevel(int assessmentId, int level)
        {
            var goodAnswers = new List<string>() { "Y", "NA" };

            var levelId = _context.MATURITY_LEVELS
                .Where(x => x.Level == level && x.Maturity_Model_Id == modelIdCmmc2)
                .Select(x => x.Maturity_Level_Id)
                .FirstOrDefault();

            var query = from a in _context.ANSWER
                        join q in _context.MATURITY_QUESTIONS on a.Question_Or_Requirement_Id equals q.Mat_Question_Id
                        where q.Maturity_Level_Id == levelId && a.Assessment_Id == assessmentId
                        select a;

            var answerList = query.ToList().Select(x => x.Answer_Text).ToList();

            var score = answerList.Where(x => goodAnswers.Contains(x)).Count();

            return score;
        }


        /// <summary>
        /// Calculates a SPRS score based on the question scoring values in MATURITY_EXTRA.
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
                                q.Score = mx.SPRSValue ?? 0;
                            }
                            break;
                    }

                    calculatedScore -= q.Score;

                    d.Questions.Add(q);
                }
            }

            response.SprsScore = calculatedScore;

            // TODO:  With the release of CMMC 2.0 Final the gauge is built in the UI and this 
            //        code will not be needed.
            var sprsGauge = new Helpers.ReportWidgets.SprsScoreGauge(calculatedScore, 500, 100);
            response.GaugeSvg = sprsGauge.ToString();

            return response;
        }
    }
}
