//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Dashboard;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Org.BouncyCastle.Bcpg.OpenPgp;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly int _assessmentId;
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


            //_assessmentId = _tokenManager.AssessmentForUser();
            //_context.FillEmptyQuestionsForAnalysis(_assessmentId);
        }


        /// <summary>
        /// Returns the normalized values for the model's 
        /// answer options.
        /// </summary>
        /// <returns></returns>
        [AllowAnonymous]
        [HttpGet]
        [Route("api/chart/maturity/answerdistrib/normalized")]
        public IActionResult XXX([FromQuery] int modelId)
        {
            //int assessmentId = _tokenManager.AssessmentForUser();
            int assessmentId = 100;

            var biz = new DashboardChartBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var resp = biz.GetAnswerDistributionNormalized(modelId, assessmentId);

            return Ok(resp);
        }
    }
}
