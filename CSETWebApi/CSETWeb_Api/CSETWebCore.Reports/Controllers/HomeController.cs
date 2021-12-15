using CSETWebCore.Reports.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;
using CSETWebCore.Business.Authorization;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Edm;
using CSETWebCore.Business.Reports;
using System;
using Newtonsoft.Json;
using IronPdf;
using CSETWebCore.DataLayer.Model;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Linq;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Reports.Helper;
using DocumentFormat.OpenXml.Bibliography;

namespace CSETWebCore.Reports.Controllers
{
    public class HomeController : Controller
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly CSETContext _context;



        /// <summary>
        /// 
        /// </summary>
        public HomeController(
            ITokenManager token,
            IAssessmentBusiness assessment,
            CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _context = context;
        }


        /// <summary>
        /// Generates and returns markup (SVG) for a MIL
        /// heatmap widget.  
        /// </summary>
        /// <param name="mil"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/report/widget/sprs")]
        public IActionResult GetWidget([FromQuery] int score, [FromQuery] double? scale = null)
        {
            //var assessmentId = _token.AssessmentForUser();
            
            var sprsGauge = new Helpers.ReportWidgets.SprsScoreGauge(score, 500, 50);
            return Content(sprsGauge.ToString(), "image/svg+xml");
        }


        public IActionResult Index()
        {
            TempData["links"] = UrlStringHelper.GetBaseUrl(Request);
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }
    }
}
