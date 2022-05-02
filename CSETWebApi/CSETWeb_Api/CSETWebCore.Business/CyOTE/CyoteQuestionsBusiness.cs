using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Cis;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model.CyOTE;

namespace CSETWebCore.Business.CyOTE
{
    public class CyoteQuestionsBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly int _assessmentId;


        List<string> standardQuestions = new List<string>()
        {
            "Where was this observed?",
            "Select the data sources to investigate",
            "Did you investigate the following"
        };


        private List<CYOTE_OPTIONS> allOptions;

        private List<CYOTE_PATHS> allPaths;

        private List<ANSWER> allAnswers;

        // This class is designed to be CyOTE specific for now
        private readonly int _maturityModelId = 9;

        public CisQuestions QuestionsModel;


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        /// <param name="assessmentId"></param>
        public CyoteQuestionsBusiness(CSETContext context, IAssessmentUtil assessmentUtil, int assessmentId = 0)
        {
            this._context = context;
            this._assessmentUtil = assessmentUtil;
            this._assessmentId = assessmentId;

            this.allPaths = _context.CYOTE_PATHS.ToList();
            this.allOptions = _context.CYOTE_OPTIONS.ToList();
            this.allAnswers = _context.ANSWER
                .Where(x => x.Assessment_Id == this._assessmentId)
                .ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        public CyoteAttackResponse GetQuestionAndOptions(int optionId)
        {
            var resp = new CyoteAttackResponse();

            resp.Question = GetQuestion(optionId);


            return resp;
        }


        /// <summary>
        /// Based on the specified optionId, return the question, its options
        /// and the selected state of the options.
        /// 
        /// An optionId of 0 will return the top question and its options.
        /// </summary>
        /// <returns></returns>
        private CyoteQuestion GetQuestion(int optionId)
        {
            var options = GetOptions(optionId, out int questionLevel);

            if (options.Count == 0)
            {
                return null;
            }

            var q = new CyoteQuestion()
            {
                QuestionText = this.standardQuestions[questionLevel]
            };

            foreach (int o in options)
            {
                var oo = new CyoteOption()
                {
                    OptionId = o,
                    OptionText = allOptions.FirstOrDefault(x => x.Option_Id == o)?.Option_Text,
                    Selected = allAnswers.Any(x => x.Mat_Option_Id == o && x.Answer_Text == "S")
                };
                q.Options.Add(oo);
            }

            return q;
        }


        private List<int> GetOptions(int optionId, out int level)
        {
            level = 0;

            var recs = allPaths.Where(x => x.Option1 == optionId || x.Option2 == optionId || x.Option3 == optionId).ToList();

            if (recs.Any(x => x.Option1 == optionId))
            {
                level = 1;
            }
            if (recs.Any(x => x.Option2 == optionId))
            {
                level = 2;
            }
            if (recs.Any(x => x.Option3 == optionId))
            {
                level = 3;
            }


            switch (level)
            {
                case 0:
                    return allPaths.Select(x => x.Option1).Distinct().ToList();
                case 1:
                    return recs.Where(x => x.Option1 == optionId).Select(x => x.Option2).Distinct().ToList();
                case 2:
                    return recs.Where(x => x.Option2 == optionId).Select(x => x.Option3).Distinct().ToList();
            }

            return new List<int>();
        }



    }
}
