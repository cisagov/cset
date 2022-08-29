using CSETWebCore.Business.Reports;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Crr;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Reports.Models;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Api.Models;
using System.Xml.XPath;
using System.Linq;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers.ReportWidgets;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Interfaces.AdminTab;
using Newtonsoft.Json;
using CSETWebCore.Model.Reports;
using System.Xml.Linq;

namespace CSETWebCore.Api.Controllers
{
    public class ReportsCrrController : Controller
    {
        private readonly ITokenManager _token;
        private readonly ICrrScoringHelper _crr;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _report;
        private readonly CSETContext _context;

        public ReportsCrrController(ITokenManager token, ICrrScoringHelper crr, IAssessmentBusiness assessment, 
            IDemographicBusiness demographic, IReportsDataBusiness report,
            IAssessmentUtil assessmentUtil, IAdminTabBusiness admin, CSETContext context)
        {
            _token = token;
            _crr = crr;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = admin;
            _context = context;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="includeResultsStylesheet"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/GetCrrModel")]
        public IActionResult GetCrrModel(bool includeResultsStylesheet = true)
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var demographics = _demographic.GetDemographics(assessmentId);
            _report.SetReportsAssessmentId(assessmentId);

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var crrStructure = biz.GetMaturityStructure(assessmentId);

            var deficiencyData = new MaturityBasicReportData()
            {
                Information = _report.GetInformation(),
                DeficienciesList = _report.GetMaturityDeficiencies(),
                Comments = _report.GetCommentsList(),
                MarkedForReviewList = _report.GetMarkedForReviewList(),
                QuestionsList = _report.GetQuestionsList()
            };
            CrrResultsModel crrResultsData = _crr.GetCrrResultsSummary(); //GenerateCrrResults();
            CrrVM viewModel = new CrrVM(detail, demographics.CriticalService, _crr, deficiencyData);
            viewModel.IncludeResultsStylesheet = includeResultsStylesheet;
            viewModel.ReportChart = _crr.GetPercentageOfPractice();
            viewModel.crrResultsData = crrResultsData;
            viewModel.Structure = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(crrStructure.Root));
   
            return Ok(viewModel);
        }

        /// <summary>
        /// Gets the charts for Mil1 Performance Summary and returns them in a list of raw HTML strings.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/getCrrMil1PerformanceSummaryBodyCharts")]
        public IActionResult GetMil1PerformanceSummaryBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var XDocument = _crr.XDoc;

            List<string> scoreBarCharts = new List<string>();
            List<object> stackedBarCharts = new List<object>();

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _crr.MIL1DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 50, Width = 75 };
                barChartInput.IncludePercentFirstBar = true;
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                scoreBarCharts.Add(new ScoreBarChart(barChartInput).ToString());

                var goals = domain.Descendants("Mil").FirstOrDefault().Descendants("Goal");

                foreach (XElement goal in goals)
                {
                    var goalScores = _crr.GoalAnswerDistrib(domain.Attribute("abbreviation").Value,
                    goal.Attribute("abbreviation").Value);
                    var stackedBarChartInput = new BarChartInput() { Height = 10, Width = 265 };
                    stackedBarChartInput.AnswerCounts = new List<int> { goalScores.Green, goalScores.Yellow, goalScores.Red };

                    stackedBarCharts.Add(new { Title = goal.Attribute("title").Value, Chart = new ScoreStackedBarChart(stackedBarChartInput).ToString() });
                }
            }

            return Ok(new { ScoreBarCharts = scoreBarCharts, StackedBarCharts = stackedBarCharts });
        }

        /// <summary>
        /// Gets the charts for Mil1 Performance and returns them in a list of raw HTML strings.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/getCrrMil1PerformanceBodyCharts")]
        public IActionResult GetMil1PerformanceBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var XDocument = _crr.XDoc;

            List<string> scoreBarCharts = new List<string>();
            List<object> heatMaps = new List<object>();

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _crr.MIL1DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 50, Width = 75 };
                barChartInput.IncludePercentFirstBar = true;
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                scoreBarCharts.Add(new ScoreBarChart(barChartInput).ToString());

                var goals = domain.Descendants("Mil").FirstOrDefault().Descendants("Goal");

                foreach (XElement goal in goals)
                {
                    var questionsHeatMap = new QuestionsHeatMap(goal, false, 12);
                    questionsHeatMap.Scale(1.2);

                    heatMaps.Add(new { Title = goal.Attribute("title").Value, Chart = questionsHeatMap.ToString() });
                }
            }

            return Ok(new { ScoreBarCharts = scoreBarCharts, HeatMaps = heatMaps });
        }

        /// <summary>
        /// Gets the heatmaps for CRR Performance Summary a returns them in a list of raw HTML strings.
        /// these are returned as a list of lists, (10 lists, one for each domain, each containing five heatmaps).
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/getCrrPerformanceSummaryBodyCharts")]
        public IActionResult GetCrrPerformanceSummaryBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var XDocument = _crr.XDoc;

            List<List<object>> charts = new List<List<object>>();
            foreach (XElement domain in XDocument.Root.Elements()) 
            {
                List<object> chartList = new List<object>();

                for (int i = 1; i <= 5; i++) 
                {
                    XElement mil = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                    el.Attribute("label").Value == "MIL-" + i);


                    if (i == 1)
                    {
                        chartList.Add( new GoalsHeatMap(mil, 26).ToString());
                    }
                    else
                    {
                        var milGoals = mil.Descendants("Goal").FirstOrDefault();
                        chartList.Add(new QuestionsHeatMap(milGoals, true, 26).ToString());
                    }
                }

                charts.Add(chartList);
            }
        
            return Ok(charts);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="domain"></param>
        /// <param name="mil"></param>
        /// <param name="scale"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/widget/milheatmap")]
        public IActionResult GetWidget([FromQuery] string domain, [FromQuery] string mil, [FromQuery] double? scale = null)
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);


            var xMil = _crr.XDoc.XPathSelectElement($"//Domain[@abbreviation='{domain}']/Mil[@label='{mil}']");
            if (xMil == null)
            {
                return NotFound();
            }

            // populate the widget with the MIL strip and collapse any hidden goal strips
            var heatmap = new MilHeatMap(xMil, true, false);
            if (scale != null)
            {
                heatmap.Scale((double)scale);
            }

            // return the svg
            return Content(heatmap.ToString(), "image/svg+xml");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/widget/mil1FullAnswerDistrib")]

        public IActionResult getMil1FullAnswerDistribHtml()
        {            
            return Content(GetTotalBarChart(), "text/html");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/widget/nistCsfSummaryChart")]
        public IActionResult GetNistCsfSummaryChart()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var distAll = _crr.CrrReferenceAnswerDistrib(_crr.XCsf.Root);

            var bciAll = new BarChartInput() { Height = 80, Width = 100 };
            bciAll.IncludePercentFirstBar = true;
            bciAll.AnswerCounts = new List<int> { distAll.Green, distAll.Yellow, distAll.Red };
            return Content(new ScoreBarChart(bciAll).ToString(), "text/html");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/getNistCsfReportBodyData")]
        public IActionResult GetNistCsfReportBodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);

            List<object> funcs = new List<object>();

            foreach (var func in _crr.XCsf.Descendants("Function")) 
            {
                var distFunc = _crr.CrrReferenceAnswerDistrib(func);

                var bciFunc = new BarChartInput() { Height = 80, Width = 100 };
                bciFunc.IncludePercentFirstBar = true;
                bciFunc.AnswerCounts = new List<int> { distFunc.Green, distFunc.Yellow, distFunc.Red };
                var chartFunc = new ScoreBarChart(bciFunc);

                List<object> cats = new List<object>();
                foreach (var cat in func.Elements()) 
                {
                    var distCat = _crr.CrrReferenceAnswerDistrib(cat);

                    var bciCat = new BarChartInput() { Height = 15, Width = 360 };
                    bciCat.IncludePercentFirstBar = true;
                    bciCat.AnswerCounts = new List<int> { distCat.Green, distCat.Yellow, distCat.Red };
                    var chartCat = new ScoreStackedBarChart(bciCat);

                    cats.Add(new 
                        { 
                            Name = cat.Attribute("name").Value, 
                            ParentCode = cat.Parent.Attribute("code").Value, 
                            Code = cat.Attribute("code").Value,
                            CatChart = chartCat.ToString() 
                        });
                }

                funcs.Add(new 
                    { 
                        Function = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(func)), 
                        Chart = chartFunc.ToString(),
                        Cats = cats
                    });
            }

            return Ok(funcs);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/widget/performanceLegend")]
        public IActionResult GetCrrPerformanceLegend()
        {
            return Content(new CRRPerformanceLegend().ToString(), "text/html");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/widget/mil1PerformanceSummaryLegend")]

        public IActionResult getMil1PerformanceSummaryLegend()
        {
           
            return Content(GetMil1PerformanceSummaryLegendData(), "text/html");
        }

        [HttpGet]
        [Route("api/reportscrr/widget/GetCrrPerformanceAppendixA")]
        public IActionResult GetCrrPerformanceAppendixA()
        {
            return Ok(GetCrrPerformanceAppendixAData());
        }

        private CrrResultsModel GenerateCrrResults()
        {
            MaturityReportData maturityData = new MaturityReportData(_context);

            maturityData.MaturityModels = _report.GetMaturityModelData();
            maturityData.information = _report.GetInformation();
            maturityData.AnalyzeMaturityData();


            // null out a few navigation properties to avoid circular references that blow up the JSON stringifier
            maturityData.MaturityModels.ForEach(d =>
            {
                d.MaturityQuestions.ForEach(q =>
                {
                    q.Answer.Assessment = null;
                });
            });

            CrrResultsModel retVal = new CrrResultsModel();
            List<DomainStats> cmmcDataDomainLevelStats = maturityData.MaturityModels.FirstOrDefault(d => d.MaturityModelName == "CRR")?.StatsByDomainAndLevel;
            retVal.EvaluateDataList(cmmcDataDomainLevelStats);
            retVal.TrimToNElements(10);
            retVal.GenerateWidthValues(); //If generating wrong values, check inner method values match the ones set in the css
            return retVal;
        }

        private CrrResultsModel GenerateCrrResults(MaturityReportData data)
        {
            //For Testing

            CrrResultsModel retVal = new CrrResultsModel();
            List<DomainStats> cmmcDataDomainLevelStats = data.MaturityModels.Where(d => d.MaturityModelName == "CRR").First().StatsByDomainAndLevel;
            retVal.EvaluateDataList(cmmcDataDomainLevelStats);
            retVal.TrimToNElements(10);
            retVal.GenerateWidthValues(); //If generating wrong values, check inner method values match the ones set in the css
            return retVal;
        }

        private string GetTotalBarChart()
        {
            string totalBarChartString = string.Empty;
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var totalDistribution = _crr.MIL1FullAnswerDistrib();
            var totalBarChartInput = new BarChartInput() { Height = 50, Width = 110 };
            totalBarChartInput.AnswerCounts = new List<int>
                                        { totalDistribution.Green, totalDistribution.Yellow, totalDistribution.Red };
            ScoreBarChart barChart = new ScoreBarChart(totalBarChartInput);
            totalBarChartString = barChart.ToString();
            return totalBarChartString;
        }

        private string GetMil1PerformanceSummaryLegendData()
        {
            var legend = new MIL1PerformanceSummaryLegend();
            return legend.ToString();
        }

        private DomainSummary[] GetDomainSummaries()
        {
            DomainSummary[] domainSummaries = new DomainSummary[1];
            var heatmapScale = 1.15;
            var XDocument = _crr.XDoc;

            DomainSummary domainSummary = null;
            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _crr.DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 45, Width = 75 };
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                var barChart = new ScoreBarChart(barChartInput);

                XElement mil1 = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                           el.Attribute("label").Value == "MIL-1");
                var mil1Svg = new MilHeatMap(mil1, true, false, 8);
                mil1Svg.Scale(heatmapScale);

                XElement mil2 = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                            el.Attribute("label").Value == "MIL-2");
                var mil2Svg = new MilHeatMap(mil2, true, false, 8);
                mil2Svg.Scale(heatmapScale);

                XElement mil3 = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                           el.Attribute("label").Value == "MIL-3");
                var mil3Svg = new MilHeatMap(mil3, true, false, 8);
                mil3Svg.Scale(heatmapScale);

                XElement mil4 = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                           el.Attribute("label").Value == "MIL-4");
                var mil4Svg = new MilHeatMap(mil4, true, false, 8);
                mil4Svg.Scale(heatmapScale);

                XElement mil5 = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                           el.Attribute("label").Value == "MIL-5");
                var mil5Svg = new MilHeatMap(mil5, true, false, 8);
                mil5Svg.Scale(heatmapScale);

                domainSummary = new DomainSummary()
                {
                    DomainTitle = domain.Attribute("title").Value.Split('(')[0].Trim(),
                    BarChart = barChart.ToString(),
                    MilHeatMapSvg1 = mil1Svg.ToString(),
                    MilHeatMapSvg2 = mil2Svg.ToString(),
                    MilHeatMapSvg3 = mil3Svg.ToString(),
                    MilHeatMapSvg4 = mil4Svg.ToString(),
                    MilHeatMapSvg5 = mil5Svg.ToString()
                };

                
            }
            return domainSummaries;


        }

        private CrrPerformanceAppendixA GetCrrPerformanceAppendixAData()
        {
            CrrPerformanceAppendixA retVal = new CrrPerformanceAppendixA();
            retVal.TotalBarChart = GetTotalBarChart();
            retVal.CrrPerformanceLegend = GetMil1PerformanceSummaryLegendData();
            retVal.DomainSummaryList = GetDomainSummaries();
           

            return retVal;

        }

        
    }
}
