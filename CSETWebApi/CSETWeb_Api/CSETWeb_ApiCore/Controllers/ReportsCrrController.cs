using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Crr;
using CSETWebCore.Model.Edm;
using CSETWebCore.Reports.Models;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;
using System.Xml.XPath;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ReportsCrrController : ControllerBase
    {
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly CSETContext _context;
        private readonly IReportsDataBusiness _report;
        private readonly IMaturityBusiness _maturity;
        private readonly ICrrScoringHelper _crr;

        public ReportsCrrController(IViewEngine engine, ITokenManager token, IAssessmentBusiness assessment, IDemographicBusiness demographic, CSETContext context, IReportsDataBusiness report, IMaturityBusiness maturity, ICrrScoringHelper crr)
        {
            _engine = engine;
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _context = context;
            _report = report;
            _maturity = maturity;
            _crr = crr;
        }
        public IActionResult Index()
        {
            var baseUrl = ReportHelper.GetBaseUrl(Request);
            return Ok(baseUrl);
        }

        [HttpGet]
        [Route("reportscrr/crr/crr")]
        public async Task<IActionResult> CrrReport(string token, string security)
        {
            if(await _token.IsTokenValid(token))
            {
                return Ok(CrrHtmlInit(token, security));
            }
            return BadRequest();
        }

        

        /// <summary>
        /// Generates and returns markup (SVG) for a MIL
        /// heatmap widget.  
        /// </summary>
        /// <param name="mil"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/report/widget/milheatmap")]
        public async Task<IActionResult> GetWidget([FromQuery] string domain, [FromQuery] string mil, [FromQuery] double? scale = null)
        {
            var assessmentId = await _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);


            var xMil = _crr.XDoc.XPathSelectElement($"//Domain[@abbreviation='{domain}']/Mil[@label='{mil}']");
            if (xMil == null)
            {
                return NotFound();
            }

            // populate the widget with the MIL strip and collapse any hidden goal strips
            var heatmap = new Helpers.ReportWidgets.MilHeatMap(xMil, true, true);
            if (scale != null)
            {
                heatmap.Scale((double)scale);
            }

            // return the svg
            return Content(heatmap.ToString(), "image/svg+xml");
        }

        private async Task<CrrViewModel> CrrHtmlInit(string token, string security)
        {
            await _token.Init(token);
            Request.Headers.Add("Authorization", token);
            var assessmentId =await _token.AssessmentForUser();
            HttpContext.Session.Set("assessmentId", Encoding.ASCII.GetBytes(assessmentId.ToString()));
            HttpContext.Session.Set("security", Encoding.ASCII.GetBytes(security));
            return await GetCrrModel(assessmentId);

        }

        private async Task<CrrViewModel> GetCrrModel(int assessmentId, string token = "", bool includeResultsStylesheet = true)
        {
            _crr.InstantiateScoringHelper(assessmentId);
            var detail = await _assessment.GetAssessmentDetail(assessmentId, token);

            var demographics = _demographic.GetDemographics(assessmentId);

            //Testing
            _report.SetReportsAssessmentId(assessmentId);

            var deficiencyData = new MaturityBasicReportData()
            {
                Information = await _report.GetInformation(),
                DeficienciesList = await _report.GetMaturityDeficiencies(),
                Comments = await _report.GetCommentsList(),
                MarkedForReviewList = await _report.GetMarkedForReviewList(),
                QuestionsList = await _report.GetQuestionsList()
            };
            CrrResultsModel crrResultsData = _crr.GetCrrResultsSummary(); //GenerateCrrResults();
            CrrViewModel viewModel = new CrrViewModel(detail, demographics.CriticalService, _crr, deficiencyData);
            viewModel.IncludeResultsStylesheet = includeResultsStylesheet;
            viewModel.ReportChart = _crr.GetPercentageOfPractice();
            viewModel.crrResultsData = crrResultsData;
            return viewModel;
        }



    }

    public static class ReportHelper
    {
        public static string GetBaseUrl(HttpRequest request)
        {
            var url = string.Format("{0}://{1}", request.Scheme, request.Host.ToUriComponent());
            return url;
        }
    }

    public class CrrViewModel
    {
        public CrrResultsModel crrResultsData { get; set; }

        public AssessmentDetail AssessmentDetails { get; set; }

        public List<EdmScoreParent> ParentScores { get; set; }

        public ICrrScoringHelper CRRScores { get; set; }

        public CrrReportChart ReportChart { get; set; }

        public string CriticalService { get; set; }

        public MaturityBasicReportData ReportData { get; set; }

        public Dictionary<string, int> PageNumbers { get; set; }

        public bool IncludeResultsStylesheet { get; set; }
        public CrrViewModel(AssessmentDetail assessmentDetails, string criticalService, ICrrScoringHelper crrScores, MaturityBasicReportData reportData)
        {
            AssessmentDetails = assessmentDetails;
            CriticalService = criticalService;
            CRRScores = crrScores;
            ReportData = reportData;
            PageNumbers = new Dictionary<string, int>();
        }

    }

    public class CrrHtml
    {
        public string Html { get; set; }
    }

}
