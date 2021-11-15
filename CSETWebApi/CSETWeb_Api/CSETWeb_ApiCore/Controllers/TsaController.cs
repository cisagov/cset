//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Standards;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Maturity;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;

namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// Encapsulates endpoints used by the TSA version of CSET.
    /// </summary>
    public class TsaController : Controller
    {
        private readonly CSETContext _context;
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly ITokenManager _tokenManager;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private IQuestionRequirementManager _questionRequirement;
        private IDemographicBusiness _demographicBusiness;
        private readonly StandardsBusiness _standards;

        private readonly static string tsaStandardSetName = "TSA2018";


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentBusiness"></param>
        /// <param name="tokenManager"></param>B
        /// <param name="documentBusiness"></param>
        public TsaController(IAssessmentBusiness assessmentBusiness,
            ITokenManager tokenManager, CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness, IQuestionRequirementManager questionRequirement,
            IDemographicBusiness demographicBusiness)
        {
            _assessmentBusiness = assessmentBusiness;
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _questionRequirement = questionRequirement;
            _demographicBusiness = demographicBusiness;
            _standards = new StandardsBusiness(_context, _assessmentUtil, _questionRequirement, _tokenManager,
                _demographicBusiness);
        }


        /// <summary>
        /// Sets the assessment's maturity model to CRR automatically.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/tsa/togglecrr")]
        public IActionResult ToggleCRR([FromBody] AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = _tokenManager.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new Exception("Not currently authorized to update the Assessment", null);
            }

            // save the assessment detail (primarily the UseMaturity setting)
            _assessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail);


            // set CRR as the maturity model
            if (assessmentDetail.UseMaturity)
            {
                var modelName = "CRR";
                new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistSelectedMaturityModel(assessmentId, modelName);
                return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(assessmentId));
            }

            // If the user was de-selecting CRR, we don't 'delete' the maturity model in the database.
            // Let's try just returning an empty response.  
            return Ok();
        }


        /// <summary>
        /// Sets the assessment's maturity model to RRA automatically.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/tsa/togglerra")]
        public IActionResult ToggleRRA([FromBody] AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = _tokenManager.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new Exception("Not currently authorized to update the Assessment", null);
            }


            // save the assessment detail (primarily the UseMaturity setting)
            _assessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail);


            // set CRR as the maturity model
            if (assessmentDetail.UseMaturity)
            {
                var modelName = "RRA";
                new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistSelectedMaturityModel(assessmentId, modelName);
                return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(assessmentId));
            }

            // If the user was de-selecting CRR there's no maturity model to return; just return an empty response.  
            return Ok();
        }


        /// <summary>
        /// Adds or removes the TSA standard to the assessment.  
        /// Because this method is exclusive to a TSA installation, it cannot be used
        /// if other standards have been selected on the assessment and they need to be preserved.
        /// This method will add ONLY TSA or remove all standards from the assessment.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpPost]
        [Route("api/tsa/togglestandard")]
        public IActionResult ToggleStandard([FromBody] AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = _tokenManager.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new Exception("Not currently authorized to update the Assessment", null);
            }


            // save the assessment detail (primarily the UseMaturity setting)
            _assessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail);


            // Add or remove the TSA standard
            var selectedStandards = new List<string>();
            if (assessmentDetail.UseStandard)
            {
                selectedStandards.Add(tsaStandardSetName);
            }

            return Ok(_standards.PersistSelectedStandards(assessmentId, selectedStandards));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public IActionResult Index()
        {
            return View();
        }
    }
}
