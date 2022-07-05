using System;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.DataLayer.Model;
using NodaTime;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    [CsetAuthorize]
    public class AssessmentController : ControllerBase
    {
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly ITokenManager _tokenManager;
        private readonly IDocumentBusiness _documentBusiness;
        private readonly CSETContext _context;
        
        public AssessmentController(IAssessmentBusiness assessmentBusiness, 
            ITokenManager tokenManager, IDocumentBusiness documentBusiness, CSETContext context)
        {
            _assessmentBusiness = assessmentBusiness;
            _tokenManager = tokenManager;
            _documentBusiness = documentBusiness;
            _context = context;
        }

        /// <summary>
        /// Creates a new Assessment with the current user as the first contact
        /// in an admin role.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/createassessment")]
        public IActionResult CreateAssessment(string workflow)
        {
            int currentuserId = _tokenManager.GetUserId();
            return Ok(_assessmentBusiness.CreateNewAssessment(currentuserId, workflow));
        }

        /// <summary>
        /// Returns an array of Assessments connected to the current user.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentsforuser")]
        public IActionResult GetMyAssessments()
        {
            // get all Assessments that the current user is associated with
            return Ok(_assessmentBusiness.GetAssessmentsForUser(_tokenManager.GetCurrentUserId()));
        }

        /// <summary>
        /// Returns an array of Assessments connected to the current user 
        /// and their completion stats (questions answered / total questions).
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentsCompletionForUser")]
        public IActionResult GetAssessmentsCompletion()
        {
            // get completion stats for all assessments associated to the current user
            return Ok(_assessmentBusiness.GetAssessmentsCompletionForUser(_tokenManager.GetCurrentUserId()));
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
        public IActionResult Get()
        {
            // Get the AssessmentId from the token
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(_assessmentBusiness.GetAssessmentDetail(assessmentId));
        }

        /// <summary>
        /// Persists the posted AssessmentDetail.
        /// </summary>
        /// <param name="assessmentDetail"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/assessmentdetail")]
        public IActionResult Post([FromBody] AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = _tokenManager.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new Exception("Not currently authorized to update the Assessment", null);
            }

            return Ok(_assessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail));
        }

        /// <summary>
        /// Returns a collection of all documents attached to any question in the Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmentdocuments")]
        public IActionResult GetDocumentsForAssessment()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            _documentBusiness.SetUserAssessmentId(assessmentId);
            
            return Ok(_documentBusiness.GetDocumentsForAssessment(assessmentId));
        }


        /// <summary>
        /// Returns a string indicating the last modified date/time,
        /// converted to the user's timezone.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/lastmodified")]
        public IActionResult GetLastModified()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var tzOffset = _tokenManager.PayloadInt(Constants.Constants.Token_TimezoneOffsetKey);

            var dt = _assessmentBusiness.GetLastModifiedDateUtc(assessmentId);
            dt = DateTime.SpecifyKind(dt, DateTimeKind.Utc);

            var offset = Offset.FromSeconds(-((tzOffset ?? 0) * 60));
            var instant = Instant.FromDateTimeUtc(dt);
            var dtLocal = instant.WithOffset(offset)
                          .LocalDateTime
                          .ToDateTimeUnspecified();

            return Ok(dtLocal.ToString("MM/dd/yyyy hh:mm:ss tt zzz"));
        }


        /// <summary>
        /// Gets all of the assessment icons to be used on the asessment type selection screen
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessmenticons")]
        public IActionResult GetAssessmentIcons()
        {
            return Ok(_context.ASSESSMENT_ICONS);
        }
    }
}
