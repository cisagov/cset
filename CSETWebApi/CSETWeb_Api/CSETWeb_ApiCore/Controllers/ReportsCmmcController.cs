//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Model.Reports;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ReportsCmmcController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IReportsDataBusiness _report;

        public ReportsCmmcController(ITokenManager token, IAssessmentBusiness assessment, IDemographicBusiness demographic, IReportsDataBusiness report)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
        }

        [HttpGet]
        [Route("api/reportscmmc/maturitymodel")]
        public IActionResult GetMaturityModel()
        {
            int assessmentId = _token.AssessmentForUser();
            _report.SetReportsAssessmentId(assessmentId);

            var detail = _assessment.GetAssessmentDetail(assessmentId);


            var reportData = new MaturityBasicReportData()
            {
                Information = _report.GetInformation(),
                QuestionsList = _report.GetQuestionsList(),
                DeficienciesList = _report.GetMaturityDeficiencies(),
                Comments = _report.GetCommentsList(),
                MarkedForReviewList = _report.GetMarkedForReviewList(),
                AlternateList = _report.GetAlternatesList()
            };

            reportData.DeficienciesList = reportData.AddMissingParentsTo(reportData.DeficienciesList);
            reportData.Comments = reportData.AddMissingParentsTo(reportData.Comments);
            reportData.MarkedForReviewList = reportData.AddMissingParentsTo(reportData.MarkedForReviewList);
            reportData.AlternateList = reportData.AddMissingParentsTo(reportData.AlternateList);

            var viewModel = new ReportVM(detail, reportData);

            return Ok(viewModel);
        }
    }
}
