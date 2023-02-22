using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    public class C2M2Business
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// 
        /// </summary>
        public C2M2Business(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }

        public object GetDonuts(int assessmentId)
        {
            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);


            //var matBiz = new MaturityBusiness


            var answers = _context.ANSWER.Where(x => x.Assessment_Id == assessmentId).ToList();

            return "xxx";
        }
    }
}
