using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Acet;
using System.Threading.Tasks;

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
        [Route("api/acet/dashboard")]
        public async Task<IActionResult> GetDashboard()
        {
            int assessmentId = await _token.AssessmentForUser();
            return Ok(_acetDashboard.LoadDashboard(assessmentId));
        }

        [HttpPost]
        [Route("api/acet/summary")]
        public async Task<IActionResult> UpdateACETDashboardSummary(ACETDashboard summary)
        {
            int assessmentId = await _token.AssessmentForUser();
            _acetDashboard.UpdateACETDashboardSummary(assessmentId, summary);
            return Ok();
        }
    }
}
