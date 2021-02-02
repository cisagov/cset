using System;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.ReportEngine;


namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class MaturityController : ApiController
    {
        /// <summary>
        /// Get all maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityModel")]
        public MaturityModel GetMaturityModel()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new MaturityManager().GetMaturityModel(assessmentId);
        }


        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityModel")]
        public MaturityModel SetMaturityModel(string modelName)
        {
            int assessmentId = Auth.AssessmentForUser();
            new MaturityManager().PersistSelectedMaturityModel(assessmentId, modelName);
            return new MaturityManager().GetMaturityModel(assessmentId);
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
        public object GetQuestions([FromUri] bool isAcetInstallation)
        {
            int assessmentId = Auth.AssessmentForUser();
            
            return new MaturityManager().GetMaturityQuestions(assessmentId,isAcetInstallation);
        }

        [HttpGet]
        [Route("api/MaturityModels")]
        public List<MaturityModel> GetAllModels()
        {
            int assessmentId = Auth.AssessmentForUser();

            return new MaturityManager().GetAllModels();
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

        [HttpGet]
        [Route("api/getMaturityDeficiencyList")]
        public IHttpActionResult GetDeficiencyList([FromUri]string maturity)
        {
            try
            {

                int assessmentId = Auth.AssessmentForUser();
                ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
                MaturityBasicReportData data = new MaturityBasicReportData();
                data.DeficiencesList = reportsDataManager.getMaturityDeficiences(maturity);
                data.information = reportsDataManager.GetInformation();
                return Ok(data);
            }
            catch ( Exception ex )
            {
                return Ok();
            }
        }
    }
}
