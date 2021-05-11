using System;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using CSETWebCore.Authorization;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    [CsetAuthorize]
    public class AssessmentController : ControllerBase
    {
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly ITokenManager _tokenManager;
        private readonly IDocumentBusiness _documentBusiness;
        
        public AssessmentController(IAssessmentBusiness assessmentBusiness, 
            ITokenManager tokenManager, IDocumentBusiness documentBusiness)
        {
            _assessmentBusiness = assessmentBusiness;
            _tokenManager = tokenManager;
            _documentBusiness = documentBusiness;
        }

        /// <summary>
        /// Creates a new Assessment with the current user as the first contact
        /// in an admin role.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        
        [Route("api/createassessment")]
        public IActionResult CreateAssessment(bool mode)
        {
            int currentuserId = _tokenManager.GetUserId();
            return Ok(_assessmentBusiness.CreateNewAssessment(currentuserId, mode));
        }

        /// <summary>
        /// Returns an array of Assessments connected to the current user.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentsforuser")]
        public IEnumerable<Assessments_For_User> GetMyAssessments()
        {
            // get all Assessments that the current user is associated with
            return _assessmentBusiness.GetAssessmentsForUser(_tokenManager.GetCurrentUserId());
        }

        [HttpGet]
        [Route("api/getAssessmentById")]
        public IActionResult GetAssessmentById(int assessmentId)
        {
            var assessment = _assessmentBusiness.GetAssessmentById(assessmentId);
            return Ok(assessment);
        }

        /// <summary>
        /// Returns the AssessmentDetail for current Assessment defined in the security token.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentdetail")]
        public AssessmentDetail Get()
        {
            // Get the AssessmentId from the token
            int assessmentId = _tokenManager.AssessmentForUser();

            return _assessmentBusiness.GetAssessmentDetail(assessmentId);
        }

        /// <summary>
        /// Persists the posted AssessmentDetail.
        /// </summary>
        /// <param name="assessmentDetail"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/assessmentdetail")]
        public int Post([FromBody] AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = _tokenManager.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new Exception("Not currently authorized to update the Assessment", null);
            }

            return _assessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail);
        }

        /// <summary>
        /// Returns a collection of all documents attached to any question in the Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentdocuments")]
        public object GetDocumentsForAssessment()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            _documentBusiness.SetUserAssessmentId(assessmentId);
            
            return _documentBusiness.GetDocumentsForAssessment(assessmentId);
        }
    }
}
