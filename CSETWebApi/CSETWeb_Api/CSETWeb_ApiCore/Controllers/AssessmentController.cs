//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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
//using static System.Runtime.InteropServices.JavaScript.JSType;
using CSETWebCore.Business.GalleryParser;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Aggregation;
using DocumentFormat.OpenXml.Spreadsheet;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    [CsetAuthorize]
    public class AssessmentController : ControllerBase
    {
        private readonly IAssessmentBusiness _assessmentBusiness;
        private IACETAssessmentBusiness _acsetAssessmentBusiness;
        private readonly ITokenManager _tokenManager;
        private readonly IDocumentBusiness _documentBusiness;
        private readonly IStandardsBusiness _standards;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IGalleryEditor _galleryEditor;
        private readonly IUtilities _utilities;

        public AssessmentController(IAssessmentBusiness assessmentBusiness,
            IACETAssessmentBusiness acetAssessmentBusiness,
            ITokenManager tokenManager, IDocumentBusiness documentBusiness, CSETContext context,
            IStandardsBusiness standards, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness, IGalleryEditor galleryEditor, IUtilities utilities)
        {
            _assessmentBusiness = assessmentBusiness;
            _acsetAssessmentBusiness = acetAssessmentBusiness;
            _tokenManager = tokenManager;
            _documentBusiness = documentBusiness;
            _context = context;
            _standards = standards;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _galleryEditor = galleryEditor;
            _utilities = utilities;
        }

        /// <summary>
        /// Creates a new Assessment and populates it with the options defined
        /// for the specified gallery ID.
        /// </summary>
        /// <param name="workflow"></param>
        /// <param name="galleryId"></param>
        /// <param name="csn">Custom Set Name, an optional parameter indicating the set to use in the new assessment.</param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/createassessment/gallery")]
        public IActionResult CreateAssessment([FromQuery] string workflow, [FromQuery] Guid galleryGuid, [FromQuery] string csn = null)
        {
            var currentUserId = _tokenManager.GetUserId();

            // read the 'recipe' for the assessment
            GalleryConfig config = null;
            var galleryItem = _context.GALLERY_ITEM.FirstOrDefault(x => x.Gallery_Item_Guid == galleryGuid);
            if (galleryItem != null)
            {
                config = JsonConvert.DeserializeObject<GalleryConfig>(galleryItem.Configuration_Setup);
                config.GalleryGuid = galleryGuid;
            }
            else
            {
                // if a custom set was specified, build the 'recipe' for that custom set
                if (csn != null)
                {
                    config = JsonConvert.DeserializeObject<GalleryConfig>($"{{Sets:[\"{csn}\"],SALLevel:\"Low\",QuestionMode:\"Questions\"}}");
                    config.GalleryGuid = galleryGuid;
                    //_galleryEditor.AddGalleryItem(null, null, )
                }
                else
                {
                    return BadRequest("Assessment cannot be created without options");
                }
            }

            ICreateAssessmentBusiness assessmentBusiness = (ICreateAssessmentBusiness)_assessmentBusiness;
            switch (config.Model?.ModelName)
            {
                case "ACET":
                case "ISE":
                    assessmentBusiness = (ICreateAssessmentBusiness)_acsetAssessmentBusiness;
                    break;
            }

            // create new empty assessment
            var assessment = assessmentBusiness.CreateNewAssessment(currentUserId, workflow, config);


            // build a list of Sets to be selected
            var setNames = new List<string>();

            if (config.Sets != null)
            {
                setNames.AddRange(config.Sets);
            }

            if (setNames.Count > 0)
            {
                var counts = _standards.PersistSelectedStandards(assessment.Id, setNames);
                assessment.QuestionRequirementCounts = counts;
                assessment.UseStandard = true;
            }


            // Application Mode.  Including "only" will restrict the mode on the questions page.
            var ss = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessment.Id).FirstOrDefault();
            if (config.QuestionMode != null && ss != null)
            {
                config.QuestionMode = config.QuestionMode.Trim();
                var words = config.QuestionMode.Split(" ");


                ss.Application_Mode = $"{words[0].Trim()} Based";

                if (words.Length > 1 && words[1].ToLower() == "only")
                {
                    ss.Only_Mode = true;
                }
            }


            // SAL 
            if (config.SALLevel != null && ss != null)
            {
                ss.Selected_Sal_Level = config.SALLevel;
            }


            // Hidden Screens
            if (config.HiddenScreens != null && ss != null)
            {
                ss.Hidden_Screens = string.Join(",", config.HiddenScreens);
            }


            _context.SaveChanges();


            // Model
            if (config.Model != null)
            {
                var matBiz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                matBiz.PersistSelectedMaturityModel(assessment.Id, config.Model.ModelName);

                var newModel = matBiz.GetMaturityModel(assessment.Id);
                assessment.MaturityModel = newModel;
                assessment.UseMaturity = true;

                // maturity level - for models that track a target level
                if (matBiz.ModelsWithTargetLevel.Contains(config.Model.ModelName))
                {
                    if (config.Model.Level == 0)
                    {
                        config.Model.Level = 1;
                    }

                    matBiz.PersistMaturityLevel(assessment.Id, config.Model.Level);
                }


                // store submodel selection
                if (!String.IsNullOrEmpty(config.Model.Submodel))
                {
                    var demo = new DemographicBusiness(_context, _assessmentUtil);
                    demo.SaveDD(assessment.Id, "MATURITY-SUBMODEL", config.Model.Submodel, null);
                }
            }


            // Diagram
            if (config.Diagram)
            {
                assessment.UseDiagram = true;
            }


            // Origin
            if (config.Origin != null)
            {
                assessment.Origin = config.Origin;
            }


            assessmentBusiness.SaveAssessmentDetail(assessment.Id, assessment);

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
            var userId = _tokenManager.GetCurrentUserId();
            if (userId != null)
            {
                return Ok(_assessmentBusiness.GetAssessmentsForUser((int)userId));
            }

            var accessKey = _tokenManager.GetAccessKey();
            if (accessKey != null)
            {
                return Ok(_assessmentBusiness.GetAssessmentsForAccessKey(accessKey));
            }

            return Ok();
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
            var userId = _tokenManager.GetCurrentUserId();
            if (userId != null)
            {
                return Ok(_assessmentBusiness.GetAssessmentsCompletionForUser((int)userId));
            }

            var accessKey = _tokenManager.GetAccessKey();
            if (accessKey != null)
            {
                return Ok(_assessmentBusiness.GetAssessmentsCompletionForAccessKey(accessKey));
            }

            return BadRequest();
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

            if (assessmentDetail.Workflow == "ACET")
            {
                return Ok(_acsetAssessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail));
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
        /// Returns a DateTime indicating the last modified date/time,
        /// converted to the user's timezone.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/lastmodified")]
        public IActionResult GetLastModified()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var dt = _assessmentBusiness.GetLastModifiedDateUtc(assessmentId);

            return Ok(new { LastModifiedDate = _utilities.UtcToLocal(dt) });
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/getMergeNames")]
        public IActionResult GetMergeNames([FromQuery] int id1, [FromQuery] int id2, [FromQuery] int id3,
                                           [FromQuery] int id4, [FromQuery] int id5, [FromQuery] int id6,
                                           [FromQuery] int id7, [FromQuery] int id8, [FromQuery] int id9, [FromQuery] int id10)
        {
            return Ok(_assessmentBusiness.GetNames(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10));
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/getPreventEncrypt")]
        public IActionResult GetPreventEncryptStatus()
        {
            var userId = _tokenManager.GetCurrentUserId();
            var ak = _tokenManager.GetAccessKey();

            IQueryable<bool> query = null;
            if (userId != null)
            {
                query = from u in _context.USERS
                        where u.UserId == userId
                        select u.PreventEncrypt;
            }
            else if (ak != null)
            {
                query = from a in _context.ACCESS_KEY
                        where a.AccessKey == ak
                        select a.PreventEncrypt;
            }

            var result = query.ToList().FirstOrDefault();

            return Ok(result);
        }

        [HttpPost]
        [Route("api/savePreventEncrypt")]
        public IActionResult SavePreventEncryptStatus([FromBody] bool status)
        {
            var userId = _tokenManager.GetCurrentUserId();
            var ak = _tokenManager.GetAccessKey();

            if (userId != null)
            {
                var user = _context.USERS.Where(x => x.UserId == userId).FirstOrDefault();

                user.PreventEncrypt = status;
                _context.SaveChanges();
            }
            else if (ak != null)
            {
                var accessKey = _context.ACCESS_KEY.Where(x => x.AccessKey == ak).FirstOrDefault();

                accessKey.PreventEncrypt = status;
                _context.SaveChanges();
            }

            return Ok();
        }

        [HttpGet]
        [Route("api/remarks")]
        public IActionResult GetOtherRemarks()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var remark = this._assessmentBusiness.GetOtherRemarks(assessmentId);

            return Ok(remark);
        }

        [HttpPost]
        [Route("api/remarks")]
        public IActionResult SaveOtherRemarks([FromBody] string remark)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            this._assessmentBusiness.SaveOtherRemarks(assessmentId, remark);

            return Ok();
        }

        [HttpGet]
        [Route("api/getIseSubmissionStatus")]
        public IActionResult GetSubmissionStatus()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var result = this._acsetAssessmentBusiness.GetIseSubmission(assessmentId);
            return Ok(result);
        }

        [HttpPost]
        [Route("api/updateIseSubmissionStatus")]
        public IActionResult UpdateSubmissionStatus()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            this._acsetAssessmentBusiness.UpdateIseSubmission(assessmentId);
            return Ok();
        }

        [HttpGet]
        [Route("api/clearFirstTime")]
        public IActionResult clearFirstTime()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            int userid = _tokenManager.GetCurrentUserId() ?? 0;
            this._assessmentBusiness.clearFirstTime(userid, assessmentId);
            return Ok();
        }

        [HttpGet]
        [Route("api/moveHydroActionsOutOfIseActions")]
        public IActionResult MoveHydroActionsOutOfIseActions()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            this._assessmentBusiness.MoveHydroActionsOutOfIseActions();
            return Ok();
        }

        [HttpGet]
        [Route("api/getAssessmentObservations")]
        public IActionResult GetAssessmentObservations([FromQuery] int id1, [FromQuery] int id2, [FromQuery] int id3,
                                                       [FromQuery] int id4, [FromQuery] int id5, [FromQuery] int id6,
                                                       [FromQuery] int id7, [FromQuery] int id8, [FromQuery] int id9, [FromQuery] int id10)
        {
            
            return Ok(this._assessmentBusiness.GetAssessmentObservations(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10));
        }

        [HttpGet]
        [Route("api/getAssessmentDocuments")]
        public IActionResult GetAssessmentDocuments([FromQuery] int id1, [FromQuery] int id2, [FromQuery] int id3,
                                                       [FromQuery] int id4, [FromQuery] int id5, [FromQuery] int id6,
                                                       [FromQuery] int id7, [FromQuery] int id8, [FromQuery] int id9, [FromQuery] int id10)
        {

            return Ok(this._assessmentBusiness.GetAssessmentDocuments(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10));
        }
    }
}
