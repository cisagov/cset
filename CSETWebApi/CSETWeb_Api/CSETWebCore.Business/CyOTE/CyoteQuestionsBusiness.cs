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
        }


        /// <summary>
        /// 
        /// </summary>
        public CyoteAttackResponse GetTopSubtree(int groupingId)
        {
            var resp = new CyoteAttackResponse();
            resp.Questions.Add("Where seen?");
            resp.Questions.Add("Select the data sources to investigate");
            resp.Questions.Add("Did you investigate the following");


            var o1 = allPaths.Where(x => x.Option1 == 1).Select(x => x.Option1).Distinct().ToList();


            return resp;
        }






    }
}
