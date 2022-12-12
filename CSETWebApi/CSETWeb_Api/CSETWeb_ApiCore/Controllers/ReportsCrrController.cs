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
            var crrStructure = biz.GetMaturityStructure(assessmentId, true);

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
            viewModel.ReportData.Comments = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.Comments);
            viewModel.ReportData.MarkedForReviewList = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.MarkedForReviewList);
            viewModel.ReportData.DeficienciesList = viewModel.ReportData.AddMissingParentsTo(viewModel.ReportData.DeficienciesList);
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

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/reportscrr/widget/mil1PerformanceLegend")]
        public IActionResult GetMil1PerformanceLegend()
        {
            return Content(new MIL1PerformanceLegend().ToString(), "text/html");
        }

        [HttpGet]
        [Route("api/reportscrr/getCrrPerformanceAppendixABodyData")]
        public IActionResult GetCrrPerformanceAppendixABodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);
            var XDocument = _crr.XDoc;

            List<object> bodyData = new List<object>();
            double heatmapScale = 1.15;

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _crr.DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 45, Width = 75 };
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                string barChart = new ScoreBarChart(barChartInput).ToString();

                List<string> heatMaps = new List<string>();

                for (int i = 1; i <= 5; i++)
                {
                    XElement mil = domain.Descendants("Mil").FirstOrDefault(el => el.Attribute("label") != null &&
                    el.Attribute("label").Value == "MIL-" + i);

                    var milSvg = new MilHeatMap(mil, true, false, 8);
                    milSvg.Scale(heatmapScale);
                    heatMaps.Add(milSvg.ToString());
                }

                bodyData.Add(new { ScoreBarChart = barChart, HeatMaps = heatMaps });
            }

            return Ok(bodyData);
        }

        [HttpGet]
        [Route("api/reportscrr/getNistCsfCatSummaryBodyData")]
        public IActionResult GetNistCsfCatSummaryBodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);

            XDocument xDoc = _crr.XCsf;
            var functions = xDoc.Descendants("Function");

            List<object> funcs = new List<object>();
            foreach (var func in functions)
            {
                var distFunc = GetDeepAnswerDistrib(func);

                distFunc.Height = 65;
                distFunc.Width = 150;
                distFunc.IncludePercentFirstBar = true;
                var barChart = new ScoreBarChart(distFunc);

                List<object> cats = new List<object>();
                foreach (var cat in func.Elements("Category"))
                {
                    string catChart = "";

                    if (cat.Element("References") != null)
                    {
                        var distCategory = GetAnswerDistrib(cat.Element("References"));
                        distCategory.Height = 20;
                        distCategory.Width = 150;
                        catChart = new ScoreStackedBarChart(distCategory).ToString();
                    }

                    List<object> subCats = new List<object>();

                    foreach (var subcat in cat.Elements("Subcategory"))
                    {
                        var distSubcategory = GetAnswerDistrib(subcat.Element("References"));
                        distSubcategory.Height = 20;
                        distSubcategory.Width = 230;
                        var chartSubcat = new ScoreStackedBarChart(distSubcategory);
                        subCats.Add(new { ChartSubCat = chartSubcat.ToString(), SubCat = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(subcat)) });
                    }

                    cats.Add(new
                    {
                        Name = cat.Attribute("name").Value,
                        ParentCode = cat.Parent.Attribute("code").Value,
                        Code = cat.Attribute("code").Value,
                        Desc = cat.Attribute("desc").Value,
                        CatChart = catChart,
                        SubCats = subCats
                    });
                }

                funcs.Add(new
                {
                    Function = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(func)),
                    SubCatsCount = func.Descendants("Subcategory").Count(),
                    Chart = barChart.ToString(),
                    Cats = cats
                });
            }

            return Ok(funcs);
        }

        [HttpGet]
        [Route("api/reportscrr/getNistCsfCatPerformanceBodyData")]
        public IActionResult GetNistCsfCatPerformanceBodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _crr.InstantiateScoringHelper(assessmentId);

            XDocument xDoc = _crr.XCsf;
            var functions = xDoc.Descendants("Function");

            List<object> funcs = new List<object>();
            foreach (var func in functions)
            {
                var distFunc = GetDeepAnswerDistrib(func);

                distFunc.Height = 65;
                distFunc.Width = 150;
                distFunc.IncludePercentFirstBar = true;
                var barChart = new ScoreBarChart(distFunc);

                List<object> cats = new List<object>();
                foreach (var cat in func.Elements("Category"))
                {
                    List<string> heatMaps = new List<string>();

                    if (cat.Element("References") != null)
                    {
                        var mappedQs = cat.Element("References").Elements().ToList(); ;

                        var block = new NistDomainBlock(mappedQs);
                        foreach (string heatmap in block.HeatmapList)
                        {
                            heatMaps.Add(heatmap);
                        }
                    }

                    List<object> subCats = new List<object>();

                    foreach (var subcat in cat.Elements("Subcategory")) 
                    {
                        var mappedQs = subcat.Element("References").Elements().ToList();
                        var block = new NistDomainBlock(mappedQs);
                        List<string> subCatHeatMaps = new List<string>();
                        foreach (string heatmap in block.HeatmapList)
                        {
                            subCatHeatMaps.Add(heatmap);
                        }
                        subCats.Add(new { HeatMaps = subCatHeatMaps, SubCat = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(subcat)) });
                    }

                    cats.Add(new
                    {
                        Name = cat.Attribute("name").Value,
                        ParentCode = cat.Parent.Attribute("code").Value,
                        Code = cat.Attribute("code").Value,
                        Desc = cat.Attribute("desc").Value,
                        HeatMaps = heatMaps,
                        SubCats = subCats
                    });
                }

                funcs.Add(new
                {
                    Function = JsonConvert.DeserializeObject(Helpers.CustomJsonWriter.Serialize(func)),
                    SubCatsCount = func.Descendants("Subcategory").Count(),
                    Chart = barChart.ToString(),
                    Cats = cats
                });
            }

            return Ok(funcs);
        }

        private BarChartInput GetDeepAnswerDistrib(XElement element) 
        {
            var answeredNo = new List<string>() { "N", "U" };

            var myQs = element.Descendants("CrrReference");

            var distrib = new List<int>();
            distrib.Add(myQs.Count(x => x.Attribute("answer")?.Value == "Y"));
            distrib.Add(myQs.Count(x => x.Attribute("answer")?.Value == "I"));
            distrib.Add(myQs.Count(x => answeredNo.Contains(x.Attribute("answer")?.Value)));

            var d = new BarChartInput()
            {
                AnswerCounts = distrib
            };

            return d;
        }

        BarChartInput GetAnswerDistrib(XElement element)
        {
            var answeredNo = new List<string>() { "N", "U" };

            if (element == null)
            {
                return new BarChartInput();
            }

            var myQs = element.Elements("CrrReference");

            var distrib = new List<int>();
            distrib.Add(myQs.Count(x => x.Attribute("answer")?.Value == "Y"));
            distrib.Add(myQs.Count(x => x.Attribute("answer")?.Value == "I"));
            distrib.Add(myQs.Count(x => answeredNo.Contains(x.Attribute("answer")?.Value)));

            var d = new BarChartInput()
            {
                AnswerCounts = distrib
            };

            return d;
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
    }
}
