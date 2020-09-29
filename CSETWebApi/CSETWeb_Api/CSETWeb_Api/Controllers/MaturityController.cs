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
    //[CSETAuthorize]
    public class MaturityController : ApiController
    {
        /// <summary>
        /// Get all maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityModels")]
        public List<string> GetMaturityModels()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new MaturityManager().GetMaturityModels(assessmentId);
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityModel")]
        public IHttpActionResult SetMaturityModel(string modelName)
        {
            int assessmentId = Auth.AssessmentForUser();
            new MaturityManager().PersistSelectedMaturityModel(assessmentId, modelName);
            return Ok();
        }


        /// <summary>
        /// Return the current maturity level for an assessment.
        /// Currently returns an int, but could be expanded
        /// if more data needed.
        /// </summary>
        [HttpGet]
        [Route("api/MaturityLevel")]
        public int GetMaturityLevel()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new MaturityManager().GetMaturityLevel(assessmentId);
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityLevel")]
        public IHttpActionResult SetMaturityLevel([FromBody] int level)
        {
            int assessmentId = Auth.AssessmentForUser();            
            new MaturityManager().PersistMaturityLevel(assessmentId, level);
            return Ok();
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/MaturityQuestions")]
        public object GetQuestions()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new MaturityManager().GetMaturityQuestions(assessmentId);
        }





        // --------------------------------------
        // The controller methods that follow were originally built for NCUA/ACET.
        // It is hoped that they will eventually be refactored to fit a more
        // 'generic' approach to maturity models.
        // --------------------------------------


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
