using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Authorization;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Acet;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class DashboardController : ControllerBase
    {
        private readonly ITokenManager _token;
        private IACETDashboardBusiness _acetDashboard;

        public DashboardController(ITokenManager token, IACETDashboardBusiness acetDashboard)
        {
            _token = token;
            _acetDashboard = acetDashboard;
        }

        [HttpGet]
        [Route("api/dashboard")]
        public IActionResult GetDashboard()
        {
            int assessmentId = _token.AssessmentForUser();
            return Ok(_acetDashboard.LoadDashboard(assessmentId));
        }

        [HttpPost]
        [Route("api/summary")]
        public IActionResult UpdateACETDashboardSummary(ACETDashboard summary)
        {
            int assessmentId = _token.AssessmentForUser();
            _acetDashboard.UpdateACETDashboardSummary(assessmentId, summary);
            return Ok();
        }
    }
}
