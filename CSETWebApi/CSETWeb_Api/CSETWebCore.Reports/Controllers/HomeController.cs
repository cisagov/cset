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
using CSETWebCore.Reports.Models.CRR;
using IronPdf;
using CSETWebCore.DataLayer;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Linq;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Crr;

namespace CSETWebCore.Reports.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IReportsDataBusiness _report;
        private readonly IMaturityBusiness _maturity;
        private readonly CSETContext _context;
        private readonly ICrrScoringHelper _crr;

        public HomeController(ILogger<HomeController> logger, IReportsDataBusiness report, IViewEngine engine, ITokenManager token, 
            IAssessmentBusiness assessment, IMaturityBusiness maturity, CSETContext context, ICrrScoringHelper crr)

        {
            _logger = logger;
            _engine = engine;
            _token = token;
            _assessment = assessment;
            _report = report;
            _maturity = maturity;
            _context = context;
            _crr = crr;
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
            int assessmentId = 5393;
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var scores = (List<EdmScoreParent>)_maturity.GetEdmScores(assessmentId, "MIL");

            //var crrScores = new CrrScoringHelper(_context, 4622);
            _crr.InstantiateScoringHelper(assessmentId);
            return View(new CrrViewModel(detail, scores, _crr));
        }

        private CrrViewModel GetCrrModel(int assessmentId)
        {

            //var crrScores = new CrrScoringHelper(_context, 4622);
            _crr.InstantiateScoringHelper(assessmentId);
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var scores = (List<EdmScoreParent>)_maturity.GetEdmScores(assessmentId, "MIL");

            //Testing
            _report.SetReportsAssessmentId(assessmentId);
            MaturityReportData maturityData = new MaturityReportData(_context);

            maturityData.MaturityModels = _report.GetMaturityModelData();
            maturityData.information = _report.GetInformation();
            maturityData.AnalyzeMaturityData();


            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            maturityData.MaturityModels.ForEach(d =>
            {
                d.MaturityQuestions.ForEach(q =>
                {
                    q.Answer.Assessment_ = null;
                });
            });
            CrrResultsModel crrResultsData = generateCrrResults(maturityData);
            return new CrrViewModel(detail, scores, mil1, crrResultsData);
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
            var report = await CreateHtmlString("CrrReport", assessmentId);
            var renderer = new IronPdf.ChromePdfRenderer();
            
            renderer.RenderingOptions.HtmlFooter = new HtmlHeaderFooter()
            {
                MaxHeight = 15,
                HtmlFragment = 
                    "<span style=\"font-family:Arial\">"+ security=="None" ? string.Empty : security +"</span><span style=\"font-family:Arial;float: right\">{page} | CRR Self-Assessment</span>"
            };

            renderer.RenderingOptions.MarginLeft = 0;
            renderer.RenderingOptions.MarginRight = 0;
            var pdf = renderer.RenderHtmlAsPdf(report);
            return File(pdf.BinaryData,"application/pdf", "test.pdf");
        }

        [CsetAuthorize]
        [HttpGet]
        [Route("GetCrrResults")]
        public async Task<IActionResult> GetCrrResults(string view, string security)
        {
            var assessmentId = 9042;
            var report = await CreateHtmlString("CrrResults", assessmentId);
            var renderer = new IronPdf.ChromePdfRenderer();

            renderer.RenderingOptions.HtmlFooter = new HtmlHeaderFooter()
            {
                MaxHeight = 15,
                HtmlFragment =
                    "<span style=\"font-family:Arial\">" + security + "</span><span style=\"font-family:Arial;float: right\">{page} | CRR Self-Assessment</span>"
            };

            renderer.RenderingOptions.MarginLeft = 0;
            renderer.RenderingOptions.MarginRight = 0;
            var pdf = renderer.RenderHtmlAsPdf(report);
            return File(pdf.BinaryData, "application/pdf", "test.pdf");
        }

        private async Task<string> CreateHtmlString(string view, int assessmentId)
        {
            TempData["links"] = GetCssLinks();
            ViewData.Model = GetCrrModel(assessmentId);
            System.Console.Write(assessmentId);
            System.Console.Write(ViewData.Model);
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
        private CrrResultsModel generateCrrResults(MaturityReportData data)
        {
            //For Testing

            CrrResultsModel retVal = new CrrResultsModel();
            List<DomainStats> cmmcDataDomainLevelStats = data.MaturityModels.Where(d => d.MaturityModelName == "CMMC").First().StatsByDomainAndLevel;
            retVal.EvaluateCmmcDataList(cmmcDataDomainLevelStats);
            retVal.TrimToNElements(10);
            retVal.GenerateWidthValues(); //If generating wrong values, check inner method values match the ones set in the css
            return retVal;
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

            // populate the widget without the MIL strip and collapse any hidden goal strips
            var heatmap = new Helpers.ReportWidgets.MilHeatMap(xMil, true, true);

            // return the svg
            return Content(heatmap.ToString(), "image/svg+xml");
        }
    }
}
