using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class CmmcController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;


        /// <summary>
        /// 
        /// </summary>
        public CmmcController(ITokenManager tokenManager, CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
        }


        /// <summary>        
        /// </summary>
        [HttpGet]
        [Route("api/cmmc/scores")]
        public IActionResult GetCmmcScores()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new CmmcBusiness(_context, _assessmentUtil, _adminTabBusiness).GetCmmcScores(assessmentId));
        }


        /// <summary>       
        /// Returns a collection of scorecards for each active maturity level.
        /// </summary>
        [HttpGet]
        [Route("api/cmmc/scorecards")]
        public IActionResult GetLevelScorecards()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var biz = new CmmcBusiness(_context, _assessmentUtil, _adminTabBusiness);

            return Ok(biz.GetLevelScorecards(assessmentId));
        }


        /// <summary>     
        /// TODO:  This should be deprecated with CMMC2 final
        /// </summary>
        [HttpGet]
        [Route("api/SPRSScore")]
        public IActionResult GetSPRSScore()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new CmmcBusiness(_context, _assessmentUtil, _adminTabBusiness).GetSPRSScore(assessmentId));
        }
    }
}
