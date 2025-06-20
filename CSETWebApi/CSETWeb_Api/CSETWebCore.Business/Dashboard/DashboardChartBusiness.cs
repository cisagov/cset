using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Business.AdminTab;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Dashboard.BarCharts;


namespace CSETWebCore.Business.Dashboard
{
    /// <summary>
    /// 
    /// </summary>
    public class DashboardChartBusiness
    {
        CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name=""></param>
        public DashboardChartBusiness(CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Returns the distribution of answers for an assessment and model, normalized to 100%
        /// </summary>
        /// <returns></returns>
        public List<Model.Dashboard.BarCharts.Grouping> GetAnswerDistributionNormalized(int modelId, int assessmentId)
        {
            var resp = new List<Model.Dashboard.BarCharts.Grouping>();



            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var structure = biz.GetMaturityStructureForModel(modelId, assessmentId);

            // transform into our response




            return resp;
        }
    }
}
