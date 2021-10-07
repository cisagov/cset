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
            var model = GetCrrModel(assessmentId);
            var pageList = ReportHelper.GetReportList(view);
            List<PdfDocument> pdf = new List<PdfDocument>();
            PdfDocument tempPdf = null;
            int pageCount = 1;
            string baseUrl = UrlStringHelper.GetBaseUrl(Request);
  
            foreach (var page in pageList)
            {
                var html = await ReportHelper.RenderRazorViewToString(this,page, model, baseUrl, _engine);
                tempPdf = await ReportHelper.RenderPdf(html, security, pageCount);
                pdf.Add(tempPdf);
                pageCount = pageCount + tempPdf.PageCount;
            }

            var finalPdf = pdf.Count > 1 ? await ReportHelper.MergePdf(pdf) : pdf.FirstOrDefault();
            return File(finalPdf.BinaryData, "application/pdf", "test.pdf");
        }

        [HttpGet]
        public IActionResult CrrReport(int assessmentId)
        {
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
                DeficienciesList = _report.GetMaturityDeficiencies(),
                Comments = _report.GetCommentsList(),
                MarkedForReviewList = _report.GetMarkedForReviewList(),
                QuestionsList = _report.GetQuestionsList()
            };
            CrrViewModel viewModel = new CrrViewModel(detail, demographics.CriticalService, _crr, deficiencyData);
            viewModel.ReportChart = _crr.GetPercentageOfPractice();
            return viewModel;
        }

        [HttpGet]
        [Route("api/report/getCrrHtml")]
        public async Task<IActionResult> GetCrrHtml(string view)
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var model = GetCrrModel(assessmentId);
            string baseUrl = UrlStringHelper.GetBaseUrl(Request);
            var html = new CrrHtml();
            html.Html = await ReportHelper.RenderRazorViewToString(this, view, model, baseUrl, _engine);

            return Ok(html);
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

    public class CrrHtml
    {
        public string Html { get; set; }
    }
}
