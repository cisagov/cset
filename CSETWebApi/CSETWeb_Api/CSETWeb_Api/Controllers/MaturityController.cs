using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;
using CSETWeb_Api.Helpers;


namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class MaturityController : ApiController
    {
        /// <summary>
        /// Get maturity calculations
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getMaturityResults")]
        public IHttpActionResult GetMaturityResults()
        {
            int assessmentId = Auth.AssessmentForUser();
            MaturityManager manager = new MaturityManager();
            var maturity = manager.GetMaturityAnswers(assessmentId);

            return Ok(maturity);
        }

        /// <summary>
        /// Get maturity range based on IRP rating
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getMaturityRange")]
        public IHttpActionResult GetMaturityRange()
        {
            int assessmentId = Auth.AssessmentForUser();
            MaturityManager manager = new MaturityManager();
            var maturityRange = manager.GetMaturityRange(assessmentId);
            return Ok(maturityRange);
        }

        /// <summary>
        /// Get IRP total for maturity
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getOverallIrpForMaturity")]
        public IHttpActionResult GetOverallIrp()
        {
            int assessmentId = Auth.AssessmentForUser();
            return Ok(new ACETDashboardManager().GetOverallIrp(assessmentId));
        }

        /// <summary>
        /// Get target band for maturity
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getTargetBand")]
        public IHttpActionResult GetTargetBand()
        {
            int assessmentId = Auth.AssessmentForUser();
            return Ok(new MaturityManager().GetTargetBandOnly(assessmentId));
        }

        /// <summary>
        /// Set target band for maturity rating
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/setTargetBand")]
        public IHttpActionResult SetTargetBand([FromBody]bool value)
        {
            int assessmentId = Auth.AssessmentForUser();
            new MaturityManager().SetTargetBandOnly(assessmentId, value);
            return Ok();
        }
    }
}
