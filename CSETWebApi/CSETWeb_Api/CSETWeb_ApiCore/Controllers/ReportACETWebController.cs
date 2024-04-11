//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Business.Observations;
using CSETWebCore.DataLayer.Model;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ReportACETWebController : ControllerBase
    {
        private readonly IReportsDataBusiness _report;
        private readonly ITokenManager _token;
        private readonly CSETContext _context;

        public ReportACETWebController(IReportsDataBusiness report, ITokenManager token, CSETContext context)
        {
            _report = report;
            _token = token;
            _context = context;
        }


        [HttpGet]
        [Route("api/reports/acet/getDeficiencyList")]
        public IActionResult GetDeficiencyList()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.DeficienciesList = _report.GetMaturityDeficiencies();
            data.Information = _report.GetInformation();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/acet/GetActionItemsReport")]
        public IActionResult GetActionItemsReport([FromQuery] int Exam_Level)
        {
            int assessId = _token.AssessmentForUser();
            ObservationsManager fm = new ObservationsManager(_context, assessId);

            return Ok(fm.GetActionItemsReport(assessId, Exam_Level).Result);
        }


        [HttpGet]
        [Route("api/reports/acet/GetAssessmentInformation")]
        public IActionResult GetAssessmentInformation()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.Information = _report.GetInformation();
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
            data.Information = _report.GetInformation();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/acet/getIseAnsweredQuestions")]
        public IActionResult GetIseAnsweredQuestions()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.MatAnsweredQuestions = _report.GetIseAnsweredQuestionList();
            data.Information = _report.GetIseInformation();
            return Ok(data);
        }

        [HttpGet]
        [Route("api/reports/acet/getIseAllQuestions")]
        public IActionResult GetIseAllQuestions()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            MaturityBasicReportData data = new MaturityBasicReportData();
            data.MatAnsweredQuestions = _report.GetIseAllQuestionList();
            data.Information = _report.GetInformation();

            data.AssessmentGuid = _report.GetAssessmentGuid(assessmentId);
            data.CsetVersion = _report.GetCsetVersion();
            return Ok(data);
        }



        [HttpGet]
        [Route("api/reports/acet/getIseSourceFiles")]
        public IActionResult GetIseSourceFiles()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);
            return Ok(_report.GetIseSourceFiles());
        }
    }
}
