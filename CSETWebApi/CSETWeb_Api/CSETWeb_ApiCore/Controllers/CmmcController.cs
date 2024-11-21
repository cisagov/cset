using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Maturity;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;

namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// Encapsulates logic for Cybersecurity Maturity Model Certification (CMMC).
    /// </summary>
    [CsetAuthorize]
    [ApiController]
    public class CmmcController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;



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
        [Route("api/sprs-score")]
        public IActionResult GetSPRSScore()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new CmmcBusiness(_context, _assessmentUtil, _adminTabBusiness).GetSPRSScore(assessmentId));
        }



        [HttpGet]
        [Route("api/results/compliancebylevel")]
        public IActionResult GetComplianceByLevel()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new CmmcBusiness(_context, _assessmentUtil, _adminTabBusiness).GetAnswerDistributionByLevel(assessmentId));
        }


        [HttpGet]
        [Route("api/results/compliancebydomain")]
        public IActionResult GetComplianceByDomain()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(new CmmcBusiness(_context, _assessmentUtil, _adminTabBusiness).GetAnswerDistributionByDomain(assessmentId));
        }
    }
}
