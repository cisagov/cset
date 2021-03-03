//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.ReportEngine;
using System.Collections.Generic;

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
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityModel/DomainRemarks")]
        public List<MaturityDomainRemarks> GetDomainRemarks()
        {
            int assessmentId = Auth.AssessmentForUser();
            return new MaturityManager().GetDomainRemarks(assessmentId);
        }

        /// <summary>
        /// Set selected maturity models for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/MaturityModel/DomainRemarks")]
        public IHttpActionResult SetDomainRemarks(MaturityDomainRemarks remarks)
        {
            int assessmentId = Auth.AssessmentForUser();
            new MaturityManager().SetDomainRemarks(assessmentId, remarks);
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
        public object GetQuestions([FromUri] bool isAcetInstallation, bool fill)
        {
            int assessmentId = Auth.AssessmentForUser();

            return new MaturityManager().GetMaturityQuestions(assessmentId, isAcetInstallation, fill);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/MaturityModels")]
        public List<MaturityModel> GetAllModels()
        {
            return new MaturityManager().GetAllModels();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/MaturityAnswerCompletionRate")]
        public double GetAnswerCompletionRate()
        {
            int assessmentId = Auth.AssessmentForUser();

            return new MaturityManager().GetAnswerCompletionRate(assessmentId);
        }


        /// <summary>
        /// Get all EDM glossary entries in alphabetical order.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/GetGlossary")]
        public List<GlossaryEntry> GetGlossaryEntries(string model)
        {
            MaturityManager maturityManager = new MaturityManager();
            return maturityManager.GetGlossaryEntries(model);
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


        /// <summary>
        /// get maturity definiciency list
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
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
            catch (Exception ex)
            {
                return Ok();
            }
        }


        /// <summary>
        /// get all comments and marked for review
        /// </summary>
        /// <param name="maturity"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getCommentsMarked")]
        public MaturityBasicReportData GetCommentsMarked(string maturity)
        {
            int assessmentId = Auth.AssessmentForUser();
            ReportsDataManager reportsDataManager = new ReportsDataManager(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.Comments = reportsDataManager.getCommentsList(maturity);
            data.MarkedForReviewList = reportsDataManager.getMarkedForReviewList(maturity);
            data.information = reportsDataManager.GetInformation();
            return data;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="section"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getEdmScores")]
        public IHttpActionResult GetEdmScores(string section)
        {
            try
            {
                int assessmentId = Auth.AssessmentForUser();
                MaturityManager maturityManager = new MaturityManager();
                var scores = maturityManager.GetEdmScores(assessmentId, section);

                return Ok(scores);
            }
            catch (Exception ex)
            {
                return BadRequest();
            }
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="section"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getEdmPercentScores")]
        public IHttpActionResult GetEdmPercentScores()
        {
            try
            {
                int assessmentId = Auth.AssessmentForUser();
                MaturityManager maturityManager = new MaturityManager();
                var scores = maturityManager.GetEdmPercentScores(assessmentId);

                return Ok(scores);
            }
            catch (Exception ex)
            {
                return BadRequest();
            }
        }

        /// <summary>
        /// Get maturity calculations
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/getMaturityEDMResults")]
        public IHttpActionResult GetMaturityEDMResults()
        {
            int assessmentId = Auth.AssessmentForUser();
            MaturityManager manager = new MaturityManager();
            var maturity = manager.GetMaturityEDMAnswers(assessmentId);

            return Ok(maturity);
        }


        /// <summary>
        /// Returns all reference text for the specified maturity model.
        /// </summary>
        /// <param name="x"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/referencetext")]
        public IHttpActionResult GetReferenceText(string model)
        {
            try
            {
                var maturityManager = new MaturityManager();
                var refText = maturityManager.GetReferenceText(model);

                return Ok(refText);
            }
            catch (Exception ex)
            {
                return BadRequest();
            }
        }

    }
}
