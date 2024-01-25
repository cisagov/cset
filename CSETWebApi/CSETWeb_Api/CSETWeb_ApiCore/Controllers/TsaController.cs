//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

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
        private readonly StandardsBusiness _standards;

        private static readonly string tsaStandardSetName = "TSA2018";


        /// <summary>
        /// constructor
        /// </summary>
        /// <param name="assessmentBusiness"></param>
        /// <param name="tokenManager"></param>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        /// <param name="adminTabBusiness"></param>
        /// <param name="questionRequirement"></param>
        /// <param name="demographicBusiness"></param>
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
            _standards = new StandardsBusiness(_context, _assessmentUtil, questionRequirement, _tokenManager,
                demographicBusiness);
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


            // set RRA as the maturity model
            if (assessmentDetail.UseMaturity)
            {
                var modelName = "RRA";
                new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).PersistSelectedMaturityModel(assessmentId, modelName);
                return Ok(new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness).GetMaturityModel(assessmentId));
            }

            // If the user was de-selecting CRR there's no maturity model to return; just return an empty response.  
            return Ok();
        }

        [CsetAuthorize]
        [HttpPost]
        [Route("api/tsa/togglevadr")]
        public IActionResult ToggleVADR([FromBody] AssessmentDetail assessmentDetail)
        {
            // validate the assessment for the user
            int assessmentId = _tokenManager.AssessmentForUser();
            if (assessmentId != assessmentDetail.Id)
            {
                throw new Exception("Not currently authorized to update the Assessment", null);
            }


            // save the assessment detail (primarily the UseMaturity setting)
            _assessmentBusiness.SaveAssessmentDetail(assessmentId, assessmentDetail);


            // set VADR as the maturity model
            if (assessmentDetail.UseMaturity)
            {
                var modelName = "VADR";
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


            // Add or remove the TSA standard
            var selectedStandards = new List<string>();
            if (assessmentDetail.UseStandard)
            {
                selectedStandards.Add(tsaStandardSetName);
            }

            return Ok(_standards.PersistSelectedStandards(assessmentId, selectedStandards));
        }


        [HttpPost]
        [Route("api/tsa/standard")]
        public IActionResult PersistSelectedStandards([FromBody] List<string> selectedStandards)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            return Ok(_standards.PersistSelectedStandards(assessmentId, selectedStandards));
        }


        [HttpGet]
        [Route("api/tsa/getModelsName")]
        public List<TSAModelNames> getModelsName()
        {
            List<TSAModelNames> allModelsList = new List<TSAModelNames>();
            var allModelsStandard = (from m in _context.MODES_SETS_MATURITY_MODELS
                                     join s in _context.SETS on m.Set_Name equals s.Set_Name
                                     // join maturity in _context.MATURITY_MODELS on m.Model_Name equals maturity.Model_Name

                                     select new TSAModelNames()
                                     {
                                         App_Code_Id = m.App_Code_Id,
                                         Name = m.Set_Name,
                                         AppCode = m.AppCode,
                                         Set_Name = s.Set_Name,
                                         Full_Name = s.Full_Name,
                                         Model_Description = s.Standard_ToolTip,
                                         Standard_ToolTip = s.Standard_ToolTip,
                                         Is_Included = m.Is_Included



                                     }).ToList();
            var allModelsMaturity = (from m in _context.MODES_SETS_MATURITY_MODELS
                                     join mat in _context.MATURITY_MODELS on m.Model_Name equals mat.Model_Name
                                     where m.AppCode == "TSA"
                                     select new TSAModelNames()
                                     {
                                         App_Code_Id = m.App_Code_Id,
                                         Name = m.Model_Name,
                                         AppCode = m.AppCode,
                                         Model_Name = mat.Model_Name,
                                         Model_Title = mat.Model_Title,
                                         // Leaving description blank for now. Maturity Model Description is being removed in favor of gallery card description.
                                         // getModelsName is legacy CSET functionality that is not presently being used with the new gallery interface.
                                         Model_Description = "",//mat.Model_Description,
                                         Is_Included = m.Is_Included
                                     }
               ).ToList();
            foreach (var x in allModelsStandard)
            {
                TSAModelNames cl = new TSAModelNames();
                cl.App_Code_Id = x.App_Code_Id;
                cl.Name = x.Name;
                cl.AppCode = x.AppCode;
                cl.Set_Name = x.Set_Name;
                cl.Full_Name = x.Full_Name;

                // cl.Standard_ToolTip = x.Standard_ToolTip;
                //cl.Model_Title = x.Model_Title;
                cl.Model_Name = x.Model_Name;
                cl.Model_Description = x.Model_Description;
                cl.Is_Included = x.Is_Included;
                allModelsList.Add(cl);

            }

            foreach (var x in allModelsMaturity)
            {
                TSAModelNames cl = new TSAModelNames();
                cl.App_Code_Id = x.App_Code_Id;
                cl.Name = x.Name;
                cl.AppCode = x.AppCode;
                cl.Set_Name = x.Set_Name;
                cl.Standard_ToolTip = x.Standard_ToolTip;
                cl.Model_Name = x.Model_Name;
                cl.Full_Name = x.Model_Title;
                cl.Model_Description = x.Model_Description;
                cl.Is_Included = x.Is_Included;
                allModelsList.Add(cl);
            }
            return allModelsList;
        }
    }
}
