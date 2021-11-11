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
        public IActionResult CmmcDeficiencyReport(string token)
        {
            if (_token.IsTokenValid(token))
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
        private object HtmlInit(string token)
        {
            _token.Init(token);
            Request.Headers.Add("Authorization", token);
            var assessmentId = _token.AssessmentForUser();
            HttpContext.Session.Set("token", Encoding.ASCII.GetBytes(token));
            return GetCmmcModel(assessmentId);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="token"></param>
        /// <returns></returns>
        private object GetCmmcModel(int assessmentId, string token = "")
        {
            var detail = _assessment.GetAssessmentDetail(assessmentId, token);

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

            var viewModel = new CmmcViewModel(detail, deficiencyData);
            return viewModel;
        }


        public IActionResult Index()
        {
            return View();
        }
    }
}
