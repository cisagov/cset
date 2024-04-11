//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.IRP;
using CSETWebCore.Model.Acet;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class IRPController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IIRPBusiness _irp;
        private readonly IAssessmentUtil _assessmentUtil;
        private CSETContext _context;


        public IRPController(ITokenManager token, IAssessmentUtil assessmentUtil, IIRPBusiness irp, CSETContext context)
        {
            _token = token;
            _assessmentUtil = assessmentUtil;
            _irp = irp;
            _context = context;
        }


        /// <summary>
        /// Returns a list of all available documentation.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/irps")]
        public IActionResult GetIRPList()
        {
            int assessmentId = _token.AssessmentForUser();
            var lang = _token.GetCurrentLanguage();

            return Ok(_irp.GetIRPList(assessmentId, lang));
        }


        /// <summary>
        /// Persists the selected required docs value to the database.
        /// </summary>
        [HttpPost]
        [Route("api/irp")]
        public IActionResult PersistSelectedIRP(IRPModel reqIRP)
        {
            // In case nothing is sent, bail out gracefully
            if (reqIRP == null)
            {
                return Ok();
            }

            int assessmentId = _token.AssessmentForUser();
            _irp.PersistSelectedIRP(assessmentId, reqIRP);

            _assessmentUtil.TouchAssessment(assessmentId);

            // reset maturity filters because the risk profile has changed
            new ACETFilterController(_context, _assessmentUtil, _token).ResetAllAcetFilters();
            return Ok();
        }
    }
}
