using System;
using System.Linq;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Interfaces.AdminTab;
using System.Collections.Generic;
using J2N.Threading;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
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
        private readonly IStandardsBusiness _standards;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        
        public AssessmentController(IAssessmentBusiness assessmentBusiness, 
            ITokenManager tokenManager, IDocumentBusiness documentBusiness, CSETContext context, 
            IStandardsBusiness standards,IAssessmentUtil assessmentUtil, 
            IAdminTabBusiness adminTabBusiness )
        {
            _assessmentBusiness = assessmentBusiness;
            _tokenManager = tokenManager;
            _documentBusiness = documentBusiness;
            _context = context;
            _standards = standards;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
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
        
        [HttpPost]
        [Route("api/createassessment")]
        public IActionResult CreateAssessment([FromBody] StartAssessment sAssessment)
        {
            int currentuserId = _tokenManager.GetUserId();
            var galleryItem = _context.GALLERY_ITEM.FirstOrDefault(x => x.Gallery_Item_Id == sAssessment.GalleryId);
            List<string> assessType = new List<string>();
            if (galleryItem != null)
            {
                var galleryConfig = JsonConvert.DeserializeObject<GalleryConfig>(galleryItem.Configuration_Setup);
                
                assessType = galleryConfig?.Sets != null ? galleryConfig.Sets : null;
            }

            if (assessType != null)
            {
                //create new assessment
                var nAssessment = _assessmentBusiness.CreateNewAssessment(currentuserId, sAssessment.Workflow);
                //determine if set or model
                var isSet = _context.SETS.Any(x => x.Set_Name == assessType.First());
                if (isSet)
                {
                    //set for assessment
                    var newStandard = _standards.PersistSelectedStandards(nAssessment.Id, assessType);
                    nAssessment.QuestionRequirementCounts = newStandard;
                }
                else
                {
                    //model for assessment
                    new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistSelectedMaturityModel(nAssessment.Id, assessType.First());
                    var newModel = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(nAssessment.Id);
                    nAssessment.MaturityModel = newModel;
                }

                return Ok(nAssessment);
            }

            return BadRequest("Assessment was not created");
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

    }
}
