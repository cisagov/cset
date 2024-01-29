//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Standards;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    public class StandardsController : ControllerBase
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private IQuestionRequirementManager _questionRequirement;
        private IDemographicBusiness _demographicBusiness;
        private readonly StandardsBusiness _standards;


        public StandardsController(ITokenManager tokenManager, CSETContext context,
             IAssessmentUtil assessmentUtil, IQuestionRequirementManager questionRequirement,
            IDemographicBusiness demographicBusiness)
        {
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _questionRequirement = questionRequirement;
            _demographicBusiness = demographicBusiness;
            _standards = new StandardsBusiness(_context, _assessmentUtil, _questionRequirement, _tokenManager,
                _demographicBusiness);
        }

        [HttpGet]
        [Route("api/standards")]
        public IActionResult GetStandards()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(_standards.GetStandards(assessmentId));
        }


        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpPost]
        [Route("api/standard")]
        public IActionResult PersistSelectedStandards([FromBody] List<string> selectedStandards)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(_standards.PersistSelectedStandards(assessmentId, selectedStandards));
        }

        /// <summary>
        /// Set default standard for basic assessment
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/basicStandard")]
        public IActionResult PersistDefaultSelectedStandards()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(_standards.PersistDefaultSelectedStandard(assessmentId));
        }

        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpGet]
        [Route("api/standard/IsFramework")]
        public IActionResult GetFrameworkSelected()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(_standards.GetFramework(assessmentId));
        }

        /// <summary>
        /// Persists the current Standards selection in the database.
        /// </summary>
        [HttpGet]
        [Route("api/standard/IsACET")]
        public IActionResult GetACETSelected()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(_standards.GetACET(assessmentId));
        }
    }
}
