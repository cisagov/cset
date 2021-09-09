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
using CSETWebCore.Model.Edm;
using System;
using Newtonsoft.Json;
using CSETWebCore.Reports.Models.CRR;
using IronPdf;

namespace CSETWebCore.Reports.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IMaturityBusiness _maturity;

        public HomeController(ILogger<HomeController> logger, IViewEngine engine, ITokenManager token, 
            IAssessmentBusiness assessment, IMaturityBusiness maturity)
        {
            _logger = logger;
            _engine = engine;
            _token = token;
            _assessment = assessment;
            _maturity = maturity;
        }

        public IActionResult Index()
        {
            ViewData.Model = GetCssLinks();
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        [HttpGet]
        public IActionResult CrrReport()
        {
            int assessmentId = 5390;
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var scores = (List<EdmScoreParent>)_maturity.GetEdmScores(assessmentId, "MIL");

            // There exists no such API call providing the MIL-1 data structure with nested goals. Instead for now, one is created and passed to the model as "mil1".
            MIL1ScoreParent mil1;
            using (StreamReader r = new StreamReader("./wwwroot/crr-mil1-test.json"))
            {
                string json = r.ReadToEnd();
                mil1 = JsonConvert.DeserializeObject<MIL1ScoreParent>(json);
            }

            return View(new CrrViewModel(detail, scores, mil1));
        }

        private CrrViewModel GetCrrModel(int assessmentId)
        {
            MIL1ScoreParent mil1;
            using (StreamReader r = new StreamReader("./wwwroot/crr-mil1-test.json"))
            {
                string json = r.ReadToEnd();
                mil1 = JsonConvert.DeserializeObject<MIL1ScoreParent>(json);
            }
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var scores = (List<EdmScoreParent>)_maturity.GetEdmScores(assessmentId, "MIL");
            return new CrrViewModel(detail, scores, mil1);
        }


        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        [CsetAuthorize]
        [HttpGet]
        [Route("getPdf")]
        public async Task<IActionResult> CreatePdf(string view, string security)
        {
            var assessmentId = _token.AssessmentForUser();
            var report = await CreateHtmlString("Index", assessmentId);
            var renderer = new IronPdf.ChromePdfRenderer();
            
            renderer.RenderingOptions.HtmlFooter = new HtmlHeaderFooter()
            {
                MaxHeight = 15,
                HtmlFragment = 
                    "<span style=\"font-family:Arial\">"+ security +"</span><span style=\"font-family:Arial;float: right\">{page} | CRR Self-Assessment</span>"
            };

            renderer.RenderingOptions.MarginLeft = 0;
            renderer.RenderingOptions.MarginRight = 0;
            var pdf = renderer.RenderHtmlAsPdf(report);
            return File(pdf.BinaryData,"application/pdf", "test.pdf");
        }

        private async Task<string> CreateHtmlString(string view, int assessmentId)
        {
            TempData["links"] = GetCssLinks();
            ViewData.Model = GetCrrModel(assessmentId);
            await using var sw = new StringWriter();
            var viewResult = _engine.FindView(ControllerContext, view, false);
            var viewContext = new ViewContext(ControllerContext, viewResult.View,
                ViewData, TempData, sw, new HtmlHelperOptions());
            await viewResult.View.RenderAsync(viewContext);
            string report = sw.GetStringBuilder().ToString();
           
            return report;
        }

        private string GetCssLinks()
        {
            var url = string.Format("{0}://{1}", Request.Scheme, Request.Host.ToUriComponent());
            return url;
        }



        /// <summary>
        /// Generates and returns markup (SVG) for a MIL
        /// heatmap widget.  
        /// </summary>
        /// <param name="mil"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/report/widget/milheatmap")]
        public IActionResult GetWidget([FromQuery] string mil)
        {
            // TODO:
            // get the assessment
            // instantiate the MilHeatmap widget
            // populate the widget
            // return the svg as a string -or- as an SVG object


            return Content($"<svg><text>TEMP SVG - MIL-{mil}</text></svg>", "image/svg+xml; charset=utf-8");
        }
    }
}
