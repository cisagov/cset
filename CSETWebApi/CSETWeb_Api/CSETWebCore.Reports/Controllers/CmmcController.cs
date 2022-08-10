using CSETWebCore.Business.Reports;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Reports.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Reports.Controllers
{
    public class CmmcController : Controller
    {
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IReportsDataBusiness _report;
        private readonly CSETContext _context;
        private readonly IMaturityBusiness _maturity;


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="engine"></param>
        /// <param name="token"></param>
        /// <param name="assessment"></param>
        /// <param name="demographic"></param>
        /// <param name="context"></param>
        /// <param name="report"></param>
        /// <param name="maturity"></param>
        public CmmcController(IViewEngine engine, ITokenManager token,
            IAssessmentBusiness assessment,
            IDemographicBusiness demographic,
            CSETContext context, IReportsDataBusiness report, IMaturityBusiness maturity)
        {
            _engine = engine;
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
            _context = context;
            _maturity = maturity;
        }

        [HttpGet]
        [Route("reports/cmmc/deficiency")]
        public async Task<IActionResult> CmmcDeficiencyReport(string token)
        {
            if (await _token.IsTokenValid(token))
            {
                return View(HtmlInit(token));
            }

            return Unauthorized();
        }


        [HttpGet]
        [Route("reports/cmmc/comments")]
        public async Task<IActionResult> CmmcCommentsMarkedForReviewReport(string token)
        {
            if (await _token.IsTokenValid(token))
            {
                return View(HtmlInit(token));
            }

            return Unauthorized();
        }


        [HttpGet]
        [Route("reports/cmmc/alt")]
        public async Task<IActionResult> CmmcAlternateJustificationReport(string token)
        {
            if (await _token.IsTokenValid(token))
            {
                return View(HtmlInit(token));
            }

            return Unauthorized();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        /// <param name="security"></param>
        /// <returns></returns>
        private async Task<object> HtmlInit(string token)
        {
            await _token.Init(token);
            Request.Headers.Add("Authorization", token);
            var assessmentId = await _token.AssessmentForUser();
            HttpContext.Session.Set("token", Encoding.ASCII.GetBytes(token));
            return GetCmmcModel(assessmentId);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        private async Task<object> GetCmmcModel(int assessmentId, string token = "")
        {
            var detail = await _assessment.GetAssessmentDetail(assessmentId, token);

            var demographics = _demographic.GetDemographics(assessmentId);

            //Testing
            _report.SetReportsAssessmentId(assessmentId);

            var reportData = new MaturityBasicReportData()
            {
                Information = await _report.GetInformation(),
                QuestionsList = await _report.GetQuestionsList(),
                DeficienciesList = await _report.GetMaturityDeficiencies(),
                Comments = await _report.GetCommentsList(),
                MarkedForReviewList = await _report.GetMarkedForReviewList(),
                AlternateList = await _report.GetAlternatesList()
            };

            var viewModel = new ReportViewModel(detail, reportData);
            return viewModel;
        }


        public IActionResult Index()
        {
            return View();
        }
    }
}
