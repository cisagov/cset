using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System.Xml.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;



namespace CSETWebCore.Business.CyOTE
{
    /// <summary>
    /// The main home for all CyOTE functionality.
    /// </summary>
    public class CyoteBusiness
    {
        private CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        /// <param name="adminTabBusiness"></param>
        public CyoteBusiness(CSETContext context, IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public object GetCyoteAssessmentDetail()
        {
            return "";
        }
    }
}
