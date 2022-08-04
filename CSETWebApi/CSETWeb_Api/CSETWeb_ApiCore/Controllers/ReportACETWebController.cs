using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ReportACETWebController : ControllerBase
    {
        private readonly IReportsDataBusiness _report;
        private readonly ITokenManager _token;


        public ReportACETWebController(IReportsDataBusiness report, ITokenManager token)
        {
            _report = report;
            _token = token;
        }


        [HttpGet]
        [Route("api/reports/acet/getDeficiencyList")]
        public async Task<IActionResult> GetDeficiencyList()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.DeficienciesList = await _report.GetMaturityDeficiencies();
            data.Information = await _report.GetInformation();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/acet/GetAssessmentInformation")]
        public async Task<IActionResult> GetAssessmentInformation()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.Information = await _report.GetInformation();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/acet/getAnsweredQuestions")]
        public async Task<IActionResult> GetAnsweredQuestions()
        {
            int assessmentId = await _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.MatAnsweredQuestions = await _report.GetAnsweredQuestionList();
            data.Information = await _report.GetInformation();
            return Ok(data);
        }
    }
}
