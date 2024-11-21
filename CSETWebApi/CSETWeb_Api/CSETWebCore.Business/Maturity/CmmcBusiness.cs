//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AdminTab;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Maturity;
using DocumentFormat.OpenXml.InkML;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Maturity
{
    public class CmmcBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;

        private int _maturityModelId;

        private TranslationOverlay _overlay;

        private AdditionalSupplemental _addlSuppl;


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
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public SprsScoreModel GetSPRSScore(int assessmentId)
        {
            var response = new SprsScoreModel();

            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);

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
                    q.Score = 0;

                    int questionID = int.Parse(question.Attribute("questionid").Value);
                    var mx = maturityExtra.Where(x => x.Maturity_Question_Id == questionID).FirstOrDefault();

                    switch (q.AnswerText)
                    {
                        case "Y":
                        case "NA":
                            break;
                        case "N":
                        case "U":
                        case "":
                            if (mx != null && mx.SPRSValue != null)
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


    }
}
