using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Threading.Tasks;
using System.Xml.XPath;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Model.Edm;
using CSETWebCore.Reports.Helper;
using CSETWebCore.Business.Reports;
using CSETWebCore.Reports.Models;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.DataLayer;
using IronPdf;
using System.Linq;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Model.Crr;
using System;


namespace CSETWebCore.Reports.Controllers
{
    public class CrrController : Controller
    {
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IReportsDataBusiness _report;
        private readonly CSETContext _context;
        private readonly IMaturityBusiness _maturity;
        private readonly ICrrScoringHelper _crr;

        public CrrController(IViewEngine engine, ITokenManager token,
            IAssessmentBusiness assessment,
            IDemographicBusiness demographic,
            CSETContext context, IReportsDataBusiness report, IMaturityBusiness maturity, ICrrScoringHelper crr)
        {
            _engine = engine;
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
            _context = context;
            _maturity = maturity;
            _crr = crr;
        }

        public IActionResult Index()
        {
            TempData["links"] = UrlStringHelper.GetBaseUrl(Request);
            return View();
        }


        [CsetAuthorize]
        [HttpGet]
        [Route("getPdf")]
        public async Task<IActionResult> CreatePdf(string view, string security)
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var report = await CreateHtmlString(view, assessmentId);
            var renderer = new IronPdf.ChromePdfRenderer();

            renderer.RenderingOptions.HtmlFooter = new HtmlHeaderFooter()
            {
                MaxHeight = 15,
                HtmlFragment =
                    "<div style=\"padding: 0 3rem\"><span style=\"font-family:Arial; font-size: 1rem\">"
                    + (security.ToLower() == "none" ? string.Empty : security)
                    + "</span><span style=\"font-family:Arial;float: right\">{page} | CRR Self-Assessment</span></div>"
            };

            renderer.RenderingOptions.MarginTop = 15;
            renderer.RenderingOptions.MarginBottom = 15;
            renderer.RenderingOptions.MarginLeft = 15;
            renderer.RenderingOptions.MarginRight = 15;
            renderer.RenderingOptions.EnableJavaScript = true;
            renderer.RenderingOptions.RenderDelay = 1000;
            var pdf = renderer.RenderHtmlAsPdf(report);
            return File(pdf.BinaryData, "application/pdf", "test.pdf");
        }


        [HttpGet]
        public IActionResult CrrReport(int assessmentId)
        {
            // Enter your report number here:
            //int assessmentId = 4622;

            _crr.InstantiateScoringHelper(assessmentId);
            return View(GetCrrModel(assessmentId));
        }


        private object GetCrrModel(int assessmentId)
        {

            _crr.InstantiateScoringHelper(assessmentId);
            var detail = _assessment.GetAssessmentDetail(assessmentId);

            var demographics = _demographic.GetDemographics(assessmentId);

            //Testing
            _report.SetReportsAssessmentId(assessmentId);

            var deficiencyData = new MaturityBasicReportData()
            {
                Information = _report.GetInformation(),
                DeficienciesList = _report.GetMaturityDeficiencies()
            };
            CrrViewModel viewModel = new CrrViewModel(detail, demographics.CriticalService, _crr, deficiencyData);
            viewModel.ReportChart = _crr.GetPercentageOfPractice();
            return viewModel;
        }


        private async Task<string> CreateHtmlString(string view, int assessmentId)
        {
            var hController = new HomeController();
            TempData["links"] = UrlStringHelper.GetBaseUrl(Request);
            ViewData.Model = GetCrrModel(assessmentId);
            await using var sw = new StringWriter();
            var viewResult = _engine.FindView(ControllerContext, "crrReport", false);
            var viewContext = new ViewContext(ControllerContext, viewResult.View,
                ViewData, TempData, sw, new HtmlHelperOptions());
            await viewResult.View.RenderAsync(viewContext);

            string report = sw.GetStringBuilder().ToString();

            return report;
        }


        /// <summary>
        /// Generates and returns markup (SVG) for a MIL
        /// heatmap widget.  
        /// </summary>
        /// <param name="mil"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/report/widget/milheatmap")]
        public IActionResult GetWidget([FromQuery] string domain, [FromQuery] string mil)
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);


            var xMil = _crr.XDoc.XPathSelectElement($"//Domain[@abbreviation='{domain}']/Mil[@label='{mil}']");
            if (xMil == null)
            {
                return NotFound();
            }

            // populate the widget with the MIL strip and collapse any hidden goal strips
            var heatmap = new Helpers.ReportWidgets.MilHeatMap(xMil, true, true);

            // return the svg
            return Content(heatmap.ToString(), "image/svg+xml");
        }


        [HttpGet]
        [Route("api/report/getPercentageOfPractice")]
        public IActionResult GetPercentageOfPractice()
        {
            Report result = new Report
            {
                Labels = new List<string>
                {
                    "Asset Management",
                    "Controls Management",
                    "Configuration and Change Management",
                    "Vulnerability Management",
                    "Incident Mangement",
                    "Service Continuity Management",
                    "Risk Management",
                    "External Dependencies Management",
                    "Training and Awareness",
                    "Situational Awareness"
                },
                Value = new List<int>
                {
                    25,
                    45,
                    50,
                    10,
                    20,
                    90,
                    70,
                    38,
                    85,
                    65
                }
            };

            return Ok(result);
        }


        private CrrResultsModel generateCrrResults(MaturityReportData data)
        {
            //For Testing

            CrrResultsModel retVal = new CrrResultsModel();
            List<DomainStats> cmmcDataDomainLevelStats = data.MaturityModels.Where(d => d.MaturityModelName == "CRR").First().StatsByDomainAndLevel;
            retVal.EvaluateCmmcDataList(cmmcDataDomainLevelStats);
            retVal.TrimToNElements(10);
            retVal.GenerateWidthValues(); //If generating wrong values, check inner method values match the ones set in the css
            return retVal;
        }
    }


    public class Report
    {
        public List<string> Labels { get; set; }
        public List<int> Value { get; set; }
    }
}
