using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer;
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
        private CSETContext _context;

        public IRPController(ITokenManager token, IIRPBusiness irp, CSETContext context)
        {
            _token = token;
            _irp = irp;
            _context = context;
        }

        /// <summary>
        /// Returns a list of all available documentation.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/irps")]
        public IRPResponse GetIRPList()
        {
            int assessmentId = _token.AssessmentForUser();
            return _irp.GetIRPList(assessmentId);
        }

        /// <summary>
        /// Persists the selected required docs value to the database.
        /// </summary>
        [HttpPost]
        [Route("api/irp")]
        public void PersistSelectedIRP(IRPModel reqIRP)
        {
            // In case nothing is sent, bail out gracefully
            if (reqIRP == null)
            {
                return;
            }

            int assessmentId = _token.AssessmentForUser();
            _irp.PersistSelectedIRP(assessmentId, reqIRP);

            // reset maturity filters because the risk profile has changed
            new ACETFilterController(_context, _token).ResetAllAcetFilters();
        }
    }
}
