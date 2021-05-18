using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;

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
        public IActionResult GetDeficiencyList()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.DeficiencesList = _report.GetMaturityDeficiences("ACET");
            data.information = _report.GetInformation();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/acet/GetAssessmentInformation")]
        public IActionResult GetAssessmentInformation()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.information = _report.GetInformation();
            return Ok(data);
        }


        [HttpGet]
        [Route("api/reports/acet/getAnsweredQuestions")]
        public IActionResult GetAnsweredQuestions()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.MatAnsweredQuestions = _report.GetAnsweredQuestionList();
            data.information = _report.GetInformation();
            return Ok(data);
        }
    }
}
