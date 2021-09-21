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
using CSETWebCore.Reports.Models;
using IronPdf;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;

namespace CSETWebCore.Reports.Controllers
{
    public class CrrController : Controller
    {
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IMaturityBusiness _maturity;
        private readonly ICrrScoringHelper _crr;

        public CrrController(IViewEngine engine, ITokenManager token,
            IAssessmentBusiness assessment, IMaturityBusiness maturity, ICrrScoringHelper crr)
        {
            _engine = engine;
            _token = token;
            _assessment = assessment;
            _maturity = maturity;
            _crr = crr;
        }

        public IActionResult Index()
        {
            return View();
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
                    "<span style=\"font-family:Arial\">" + security == "None" ? string.Empty : security + "</span><span style=\"font-family:Arial;float: right\">{page} | CRR Self-Assessment</span>"
            };

            renderer.RenderingOptions.MarginLeft = 0;
            renderer.RenderingOptions.MarginRight = 0;
            var pdf = renderer.RenderHtmlAsPdf(report);
            return File(pdf.BinaryData, "application/pdf", "test.pdf");
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
            return new CrrViewModel(detail, scores, _crr);
        }

        private async Task<string> CreateHtmlString(string view, int assessmentId)
        {
            var hController = new HomeController();
            TempData["links"] = UrlStringHelper.GetBaseUrl(Request);
            ViewData.Model = GetCrrModel(assessmentId);
            await using var sw = new StringWriter();
            var viewResult = _engine.FindView(ControllerContext, view, false);
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

            // populate the widget without the MIL strip and collapse any hidden goal strips
            var heatmap = new Helpers.ReportWidgets.MilHeatMap(xMil, true, true);

            // return the svg
            return Content(heatmap.ToString(), "image/svg+xml");
        }
    }
}
