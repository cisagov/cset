//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Model.Assessment;
using Microsoft.AspNetCore.Mvc;
using System;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using NodaTime;
using CSETWebCore.Business.Acet;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Maturity;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Linq;
using System.Xml.Linq;
using System.Xml.XPath;
using Newtonsoft.Json;

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


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentBusiness"></param>
        /// <param name="tokenManager"></param>
        /// <param name="documentBusiness"></param>
        public TsaController(IAssessmentBusiness assessmentBusiness,
            ITokenManager tokenManager, CSETContext context, IAssessmentUtil assessmentUtil,
            IAdminTabBusiness adminTabBusiness)
        {
            _assessmentBusiness = assessmentBusiness;
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
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
        /// 
        /// </summary>
        /// <returns></returns>
        public IActionResult Index()
        {
            return View();
        }
    }


    public class TsaControllerResponse
    {

        public MaturityModel MaturityModel { get; set; }
    }
}
