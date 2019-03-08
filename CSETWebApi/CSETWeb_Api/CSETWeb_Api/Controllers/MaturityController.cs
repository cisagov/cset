using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.Helpers;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class MaturityController : ApiController
    {

        [HttpGet]
        [Route("api/getMaturityResults")]
        public IHttpActionResult GetMaturityResults()
        {
            int assessmentId = Auth.AssessmentForUser();
            MaturityManager manager = new MaturityManager();
            var maturity = manager.GetMaturityAnswers(assessmentId);

            return Ok(maturity);
        }
    }
}
