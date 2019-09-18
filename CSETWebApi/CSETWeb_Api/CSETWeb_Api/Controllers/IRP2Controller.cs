using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.BusinessManagers;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// why is it IRP2 and not just IRP?
    /// because Visual Studio is a steaming pile of garbage and it sees a ghost file where none exists.
    /// </summary>
    [CSETAuthorize]
    public class IRP2Controller : ApiController
    {
        /// <summary>
        /// Returns a list of all available documentation.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/irps")]
        public IRPResponse GetIRPList()
        {
            int assessmentId = Auth.AssessmentForUser();
            return (new IRPManager()).GetIRPList(assessmentId);
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

            int assessmentId = Auth.AssessmentForUser();
            new IRPManager().PersistSelectedIRP(assessmentId, reqIRP);

            // reset maturity filters because the risk profile has changed
            new ACETFilterController().ResetAllAcetFilters();
        }
    }
}