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
            IStandardsBusiness standards, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
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
        public IActionResult CreateAssessment([FromQuery] string workflow)
        {
            int currentuserId = _tokenManager.GetUserId();
            return Ok(_assessmentBusiness.CreateNewAssessment(currentuserId, workflow));
        }


        /// <summary>
        /// Creates a new Assessment and populates it with the options defined
        /// for the specified gallery ID.
        /// </summary>
        /// <param name="workflow"></param>
        /// <param name="galleryId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/createassessment/gallery")]
        public IActionResult CreateAssessment([FromQuery] string workflow, [FromQuery] int galleryId)
        {
            int currentUserId = _tokenManager.GetUserId();


            // read the 'recipe' for the assessment
            GalleryConfig config = null;
            var galleryItem = _context.GALLERY_ITEM.FirstOrDefault(x => x.Gallery_Item_Id == galleryId);
            if (galleryItem != null)
            {
                config = JsonConvert.DeserializeObject<GalleryConfig>(galleryItem.Configuration_Setup);
            }
            else
            {
                return BadRequest("Assessment cannot be created without options");
            }


            // create new empty assessment
            var assessment = _assessmentBusiness.CreateNewAssessment(currentUserId, workflow);

            // now add the options
            if (config.Sets != null)
            {
                var counts = _standards.PersistSelectedStandards(assessment.Id, config.Sets);
                assessment.QuestionRequirementCounts = counts;                
                assessment.UseStandard = true;                
            }

            var ss = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment.Id).FirstOrDefault();

            // Application Mode
            if (config.QuestionMode != null && ss != null)
            {
                ss.Application_Mode = $"{config.QuestionMode.Trim()} Based";
            }

            // SAL 
            if (config.SALLevel != null && ss != null)
            {
                ss.Selected_Sal_Level = config.SALLevel;
            }

            _context.SaveChanges();


            // Model
            if (config.Model != null)
            {
                new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistSelectedMaturityModel(assessment.Id, config.Model.ModelName);
                var newModel = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(assessment.Id);
                assessment.MaturityModel = newModel;
                assessment.UseMaturity = true;

                // maturity level
                var mb = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                if (config.Model.Level == 0)
                {
                    config.Model.Level = 1;
                }
                mb.PersistMaturityLevel(assessment.Id, config.Model.Level);
            }


            // Diagram
            if (config.Diagram)
            {
                assessment.UseDiagram = true;
            }

            _assessmentBusiness.SaveAssessmentDetail(assessment.Id, assessment);

            return Ok(assessment);
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
