//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Dashboard;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        /// <param name="tokenManager"></param>
        public DashboardController(CSETContext context, ITokenManager tokenManager, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _context = context;
            _tokenManager = tokenManager;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
        }


        /// <summary>
        /// Returns the normalized values for the model's 
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/normalized")]
        public IActionResult GetNormalizedAnswerDistribution([FromQuery] int modelId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new DashboardChartBusiness(assessmentId, modelId, _context, _assessmentUtil, _adminTabBusiness);
            var resp = biz.GetAnswerDistributionNormalized();

            return Ok(resp);
        }


        /// <summary>
        /// Returns the normalized values for the model's 
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/domain")]
        public IActionResult GetAnswerDistributionByDomain([FromQuery] int modelId)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new DashboardChartBusiness(assessmentId, modelId, _context, _assessmentUtil, _adminTabBusiness);
            var resp = biz.GetAnswerDistributionByDomain();

            return Ok(resp);
        }
    }
}
