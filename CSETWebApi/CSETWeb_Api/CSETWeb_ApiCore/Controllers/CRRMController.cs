using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Cmu;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Helpers.ReportWidgets;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Helpers;
using CSETWebCore.Business.Reports;
using CSETWebCore.Reports.Models;
using CSETWebCore.Api.Models;
using Newtonsoft.Json;
using CSETWebCore.Model.Acet;
using CSETWebCore.Business.Authorization;

namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// This controller will handle all interactions with the CRRM.
    /// </summary>
    public class CRRMController : Controller
    {
        public CRRMController()
        {

        }

        [HttpGet]
        [ApiKeyAuthorize]
        [Route("api/crrm/exportAllAccessKeyAssessments")]
        public IActionResult GetAssessments()
        {
            return Ok();
        }
    }
}
