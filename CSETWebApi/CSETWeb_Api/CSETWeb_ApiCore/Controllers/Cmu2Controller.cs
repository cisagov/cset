using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Cmu;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Helpers.ReportWidgets;
using System.Xml.Linq;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Helpers;
using CSETWebCore.Business.Reports;
using CSETWebCore.Reports.Models;
using CSETWebCore.Api.Models;
using Newtonsoft.Json;

namespace CSETWebCore.Api.Controllers
{
    public class Cmu2Controller : Controller
    {
        private readonly ITokenManager _token;
        private readonly Helpers.ICmuScoringHelper _scoring;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _report;
        private readonly CSETContext _context;

        public Cmu2Controller(ITokenManager token, IAssessmentBusiness assessment,
          IDemographicBusiness demographic, IReportsDataBusiness report,
          IAssessmentUtil assessmentUtil, IAdminTabBusiness admin, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = admin;
            _context = context;


            _scoring = new Helpers.ICmuScoringHelper(context);
        }


        [HttpGet]
        [Route("api/reportscrr2/GetCrrModel")]
        public IActionResult GetCrrModel()
        {
            var assessmentId = 1094; // _token.AssessmentForUser();



            //_crr.InstantiateScoringHelper(assessmentId);
            //var detail = _assessment.GetAssessmentDetail(assessmentId);
            //var demographics = _demographic.GetDemographics(assessmentId);
            //_report.SetReportsAssessmentId(assessmentId);

            //var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            //var crrStructure = biz.GetMaturityStructureAsXml(assessmentId, true);

            //var deficiencyData = new MaturityBasicReportData()
            //{
            //    Information = _report.GetInformation(),
            //    DeficienciesList = _report.GetMaturityDeficiencies(),
            //    Comments = _report.GetCommentsList(),
            //    MarkedForReviewList = _report.GetMarkedForReviewList(),
            //    QuestionsList = _report.GetQuestionsList()
            //};
            //CrrResultsModel crrResultsData = _crr.GetCrrResultsSummary(); //GenerateCrrResults();
            //CrrVM viewModel = new CrrVM(detail, demographics.CriticalService, _crr, deficiencyData);
            //viewModel.ReportData.Comments = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.Comments);
            //viewModel.ReportData.MarkedForReviewList = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.MarkedForReviewList);
            //viewModel.ReportData.DeficienciesList = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.DeficienciesList);
            //viewModel.IncludeResultsStylesheet = includeResultsStylesheet;
            //viewModel.ReportChart = _crr.GetPercentageOfPractice();
            //viewModel.crrResultsData = crrResultsData;
            //viewModel.Structure = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(crrStructure.Root));

            return Ok();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="includeResultsStylesheet"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/model")]
        public IActionResult GetModel(bool includeResultsStylesheet = true)
        {
            //var assessmentId = _token.AssessmentForUser();
            var assessmentId = 1094;



            _scoring.InstantiateScoringHelper(assessmentId);
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var demographics = _demographic.GetDemographics(assessmentId);
            _report.SetReportsAssessmentId(assessmentId);

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var modelXml = biz.GetMaturityStructureAsXml(assessmentId, false);

            var deficiencyData = new MaturityBasicReportData()
            {
                Information = _report.GetInformation(),
                DeficienciesList = _report.GetMaturityDeficiencies(),
                Comments = _report.GetCommentsList(),
                MarkedForReviewList = _report.GetMarkedForReviewList(),
                QuestionsList = _report.GetQuestionsList()
            };
            CmuResultsModel cmuResultsData = _scoring.GetCmuResultsSummary(); //GenerateCrrResults();
            CmuVM viewModel = new CmuVM(detail, demographics.CriticalService, _scoring, deficiencyData);
            viewModel.ReportData.Comments = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.Comments);
            viewModel.ReportData.MarkedForReviewList = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.MarkedForReviewList);
            viewModel.ReportData.DeficienciesList = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.DeficienciesList);
            viewModel.IncludeResultsStylesheet = includeResultsStylesheet;
            viewModel.ReportChart = _scoring.GetPercentageOfPractice();
            viewModel.CMUResultsData = cmuResultsData;
            viewModel.Structure = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(modelXml.Root));

            return Ok(viewModel);
        }


        /// <summary>
        /// Gets the charts for Goal Performance and returns them in a list of raw HTML strings.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/goalperformance")]
        public IActionResult GetGoalPerformance()
        {
            var assessmentId = _token.AssessmentForUser();

            _scoring.InstantiateScoringHelper(assessmentId);
            var XDocument = _scoring.XDoc;

            List<string> scoreBarCharts = new List<string>();
            List<object> stackedBarCharts = new List<object>();

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _scoring.DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 50, Width = 75 };
                barChartInput.IncludePercentFirstBar = true;
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                scoreBarCharts.Add(new ScoreBarChart(barChartInput).ToString());

                var goals = domain.Descendants("Goal");

                foreach (XElement goal in goals)
                {
                    var goalScores = _scoring.GoalAnswerDistrib(domain.Attribute("abbreviation").Value,
                    goal.Attribute("abbreviation").Value);
                    var stackedBarChartInput = new BarChartInput() { Height = 10, Width = 265 };
                    stackedBarChartInput.AnswerCounts = new List<int> { goalScores.Green, goalScores.Yellow, goalScores.Red };

                    stackedBarCharts.Add(new { Title = goal.Attribute("title").Value, Chart = new ScoreStackedBarChart(stackedBarChartInput).ToString() });
                }
            }

            return Ok(new { ScoreBarCharts = scoreBarCharts, StackedBarCharts = stackedBarCharts });
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/fullanswerdistrib")]

        public IActionResult getMil1FullAnswerDistribHtml()
        {
            return Content(GetTotalBarChart(), "text/html");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private string GetTotalBarChart()
        {
            string totalBarChartString = string.Empty;
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var totalDistribution = _scoring.FullAnswerDistrib();
            var totalBarChartInput = new BarChartInput() { Height = 50, Width = 110 };
            totalBarChartInput.AnswerCounts = new List<int>
                                        { totalDistribution.Green, totalDistribution.Yellow, totalDistribution.Red };
            ScoreBarChart barChart = new ScoreBarChart(totalBarChartInput);
            totalBarChartString = barChart.ToString();
            return totalBarChartString;
        }
    }
}
