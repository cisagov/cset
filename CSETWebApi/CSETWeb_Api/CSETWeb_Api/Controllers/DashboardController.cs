using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class DashboardController : ApiController
    {

        [HttpGet]
        [Route("api/dashboard")]
        public ACETDashboard GetDashboard()
        {
            int assessmentId = Auth.AssessmentForUser();
            return (new ACETDashboardManager()).LoadDashboard(assessmentId);
        }

        [HttpPost]
        [Route("api/summary")]
        public void UpdateACETDashboardSummary(ACETDashboard summary)
        {
            int assessmentId = Auth.AssessmentForUser();
            (new ACETDashboardManager()).UpdateACETDashboardSummary(assessmentId, summary);
        }
    }
}