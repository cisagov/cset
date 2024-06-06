//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers.ReportWidgets;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Interfaces.Cmu;
using CSETWebCore.Api.Models;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Reports;
using CSETWebCore.Reports.Models;
using Newtonsoft.Json;
using System.Xml.Linq;
using System.Xml.XPath;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// Common API intended to supply report content for EDM, CRR and IMR.
    /// </summary>
    public class ReportsCmuController : Controller
    {
        private readonly ITokenManager _token;
        private readonly ICmuScoringHelper _scoring;
        private readonly IAssessmentBusiness _assessment;
        private readonly IDemographicBusiness _demographic;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _report;
        private readonly CSETContext _context;

        public ReportsCmuController(ITokenManager token, IAssessmentBusiness assessment,
          IDemographicBusiness demographic, IReportsDataBusiness report,
          IAssessmentUtil assessmentUtil, IAdminTabBusiness admin,
          ICmuScoringHelper cmuScoringHelper, CSETContext context)
        {
            _token = token;
            _assessment = assessment;
            _demographic = demographic;
            _report = report;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = admin;
            _context = context;
            _scoring = cmuScoringHelper;
        }


        /// <summary>
        /// 
        /// -----WARNING ----------------------------------------
        /// 
        /// This is too big and complex to be stringified for the HTTP return.
        /// It never returns.  
        /// 
        /// -----WARNING ----------------------------------------
        /// 
        /// </summary>
        /// <param name="includeResultsStylesheet"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/model")]
        public IActionResult GetModel(bool includeResultsStylesheet = true)
        {
            var assessmentId = _token.AssessmentForUser();

            _scoring.InstantiateScoringHelper(assessmentId);
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            var demographics = _demographic.GetDemographics(assessmentId);
            _report.SetReportsAssessmentId(assessmentId);

            var biz = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
            var modelXml = biz.GetMaturityStructureAsXml(assessmentId, true);

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
        /// Returns name-value pairs indicating the domains
        /// and percentage compliant ('Yes' answers).
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/domaincompliance")]
        public IActionResult GetDomainCompliance()
        {
            var assessmentId = _token.AssessmentForUser();

            _scoring.InstantiateScoringHelper(assessmentId);
            var compliance = _scoring.GetPercentageOfPractice();

            return Ok(compliance);
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
                var barChartInput = new BarChartInput() { Height = 80, Width = 100 };
                barChartInput.IncludePercentFirstBar = true;
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                scoreBarCharts.Add(new ScoreBarChart(barChartInput).ToString());

                var goals = domain.Descendants("Goal");

                foreach (XElement goal in goals)
                {
                    var goalScores = _scoring.GoalAnswerDistrib(domain.Attribute("abbreviation").Value,
                    goal.Attribute("abbreviation").Value);
                    var stackedBarChartInput = new BarChartInput() { Height = 15, Width = 300 };
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
        [Route("api/cmu/getMil1PerformanceBodyCharts")]
        public IActionResult GetMil1PerformanceBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var XDocument = _scoring.XDoc;

            List<string> scoreBarCharts = new List<string>();
            List<object> heatMaps = new List<object>();

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _scoring.MIL1DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
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
        /// Gets the charts for Mil1 Performance Summary and returns them in a list of raw HTML strings.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/getMil1PerformanceSummaryBodyCharts")]
        public IActionResult GetMil1PerformanceSummaryBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var XDocument = _scoring.XDoc;

            List<string> scoreBarCharts = new List<string>();
            List<object> stackedBarCharts = new List<object>();

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _scoring.MIL1DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 50, Width = 75 };
                barChartInput.IncludePercentFirstBar = true;
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                scoreBarCharts.Add(new ScoreBarChart(barChartInput).ToString());

                var goals = domain.Descendants("Mil").FirstOrDefault().Descendants("Goal");

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
        /// Gets the charts for Performance and returns them in a list of raw HTML strings.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/performance")]
        public IActionResult GetPerformanceBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var XDocument = _scoring.XDoc;

            List<string> scoreBarCharts = new List<string>();
            List<object> heatMaps = new List<object>();

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _scoring.DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
                var barChartInput = new BarChartInput() { Height = 80, Width = 100 };
                barChartInput.IncludePercentFirstBar = true;
                barChartInput.AnswerCounts = new List<int> { domainScores.Green, domainScores.Yellow, domainScores.Red };
                scoreBarCharts.Add(new ScoreBarChart(barChartInput).ToString());

                var goals = domain.Descendants("Goal");

                foreach (XElement goal in goals)
                {
                    var questionsHeatMap = new QuestionsHeatMap(goal, false, 12);
                    questionsHeatMap.Scale(1.5);

                    heatMaps.Add(new { Title = goal.Attribute("title").Value, Chart = questionsHeatMap.ToString() });
                }
            }

            return Ok(new { ScoreBarCharts = scoreBarCharts, HeatMaps = heatMaps });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="domain"></param>
        /// <param name="mil"></param>
        /// <param name="scale"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/widget/heatmap")]
        public IActionResult GetHeatmapWidget([FromQuery] string domain, [FromQuery] string mil, [FromQuery] double? scale = null)
        {
            var assessmentId = _token.AssessmentForUser();

            _scoring.InstantiateScoringHelper(assessmentId);


            var xPath = $"//Domain[@abbreviation='{domain}']";
            if (mil != null)
            {
                xPath = $"//Domain[@abbreviation='{domain}']/Mil[@label='{mil}']";
            }

            var xDomain = _scoring.XDoc.XPathSelectElement(xPath);
            if (xDomain == null)
            {
                return NotFound();
            }

            // the MilHeatMap class works for Domains as well.  
            var heatmap = new MilHeatMap(xDomain, true, false);
            if (scale != null)
            {
                heatmap.Scale((double)scale);
            }

            // return the svg
            return Content(heatmap.ToString(), "image/svg+xml");
        }


        /// <summary>
        /// Returns SVG that renders the red/yellow/green legend 
        /// with square blocks for each answer option.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/blocklegend")]
        public IActionResult GetBlockLegend(bool includeGoal = true)
        {
            return Content(new BlockLegend(includeGoal).ToString(), "text/html");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/fullanswerdistrib")]

        public IActionResult GetFullAnswerDistribHtml()
        {
            return Content(GetTotalBarChart(), "text/html");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/mil1fullanswerdistrib")]

        public IActionResult GetMil1FullAnswerDistribHtml()
        {
            return Content(GetMil1TotalBarChart(), "text/html");
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
            var totalBarChartInput = new BarChartInput() { Height = 80, Width = 110, Gap = 10 };
            totalBarChartInput.AnswerCounts = new List<int>
                                        { totalDistribution.Green, totalDistribution.Yellow, totalDistribution.Red };
            ScoreBarChart barChart = new ScoreBarChart(totalBarChartInput);
            totalBarChartString = barChart.ToString();
            return totalBarChartString;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private string GetMil1TotalBarChart()
        {
            string totalBarChartString = string.Empty;
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var totalDistribution = _scoring.MIL1FullAnswerDistrib();
            var totalBarChartInput = new BarChartInput() { Height = 50, Width = 110 };
            totalBarChartInput.AnswerCounts = new List<int>
                                        { totalDistribution.Green, totalDistribution.Yellow, totalDistribution.Red };
            ScoreBarChart barChart = new ScoreBarChart(totalBarChartInput);
            totalBarChartString = barChart.ToString();
            return totalBarChartString;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/mil1PerformanceSummaryLegend")]
        public IActionResult getMil1PerformanceSummaryLegend([FromQuery] string configuration = "")
        {
            return Content(GetPerformanceSummaryLegend(configuration), "text/html");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/mil1PerformanceLegend")]
        public IActionResult GetMil1PerformanceLegend()
        {
            return Content(new MIL1PerformanceLegend().ToString(), "text/html");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/csf")]
        public IActionResult GetCsf()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);


            List<object> funcs = new List<object>();

            foreach (var func in _scoring.XCsf.Descendants("Function"))
            {
                var distFunc = _scoring.CrrReferenceAnswerDistrib(func);

                var bciFunc = new BarChartInput() { Height = 80, Width = 100 };
                bciFunc.IncludePercentFirstBar = true;
                bciFunc.AnswerCounts = new List<int> { distFunc.Green, distFunc.Yellow, distFunc.Red };
                var chartFunc = new ScoreBarChart(bciFunc);

                List<object> cats = new List<object>();
                foreach (var cat in func.Elements())
                {
                    var distCat = _scoring.CrrReferenceAnswerDistrib(cat);

                    var bciCat = new BarChartInput() { Height = 15, Width = 360 };
                    bciCat.IncludePercentFirstBar = true;
                    bciCat.ShowNA = true;
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

            return Ok(new { funcs, _scoring.CsfFunctionColors });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/csfsummarywidget")]
        public IActionResult GetCsfSummaryWidget()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var distAll = _scoring.CrrReferenceAnswerDistrib(_scoring.XCsf.Root);

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
        [Route("api/cmu/csfcatsummary")]
        public IActionResult GetNistCsfCatSummaryBodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);

            XDocument xDoc = _scoring.XCsf;
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
                        distCategory.Height = 15;
                        distCategory.Width = 150;
                        distCategory.HideEmptyChart = true;
                        catChart = new ScoreStackedBarChart(distCategory).ToString();
                    }

                    List<object> subCats = new List<object>();

                    foreach (var subcat in cat.Elements("Subcategory"))
                    {
                        var distSubcategory = GetAnswerDistrib(subcat.Element("References"));
                        distSubcategory.Height = 15;
                        distSubcategory.Width = 260;
                        distSubcategory.ShowNA = true;
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

            return Ok(new { funcs, _scoring.CsfFunctionColors });
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/csfcatperf")]
        public IActionResult GetNistCsfCatPerformanceBodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);

            XDocument xDoc = _scoring.XCsf;
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

                        var block = new NistDomainBlock(mappedQs, true);
                        foreach (string heatmap in block.HeatmapList)
                        {
                            heatMaps.Add(heatmap);
                        }
                    }

                    List<object> subCats = new List<object>();

                    foreach (var subcat in cat.Elements("Subcategory"))
                    {
                        var mappedQs = subcat.Element("References").Elements().ToList();
                        var block = new NistDomainBlock(mappedQs, false);
                        List<string> subCatHeatMaps = [.. block.HeatmapList];
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

            return Ok(new { funcs, _scoring.CsfFunctionColors });
        }

        /// <summary>
        /// Gets the heatmaps for Performance Summary a returns them in a list of raw HTML strings.
        /// these are returned as a list of lists, (10 lists, one for each domain, each containing five heatmaps).
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/getPerformanceSummaryBodyCharts")]
        public IActionResult GetCrrPerformanceSummaryBodyCharts()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var XDocument = _scoring.XDoc;

            List<List<object>> charts = new List<List<object>>();
            foreach (XElement domain in XDocument.Root.Elements())
            {
                List<object> chartList = [];


                // This domain has Mil children
                if (domain.Elements().All(e => e.Name == "Mil"))
                {
                    for (int i = 1; i <= 5; i++)
                    {
                        // look for a Mil child by name: MIL-N
                        XElement mil = domain.Elements().FirstOrDefault(el => el.Attribute("label") != null &&
                        el.Attribute("label").Value == "MIL-" + i);


                        // if we found the Mil element, generate heatmaps for his goals
                        if (mil != null)
                        {
                            if (i == 1)
                            {
                                chartList.Add(new GoalsHeatMap(mil, 26).ToString());
                            }
                            else
                            {
                                var milGoals = mil.Descendants("Goal").FirstOrDefault();
                                chartList.Add(new QuestionsHeatMap(milGoals, true, 26).ToString());
                            }
                        }
                    }
                }

                // This Domain has Goal children
                if (domain.Elements().All(e => e.Name == "Goal"))
                {
                    chartList.Add(new GoalsHeatMap(domain, 26).ToString());
                }


                charts.Add(chartList);
            }

            return Ok(charts);
        }


        [HttpGet]
        [Route("api/cmu/getCrrPerformanceAppendixABodyData")]
        public IActionResult GetCrrPerformanceAppendixABodyData()
        {
            var assessmentId = _token.AssessmentForUser();
            _scoring.InstantiateScoringHelper(assessmentId);
            var XDocument = _scoring.XDoc;

            List<object> bodyData = new List<object>();
            double heatmapScale = 1.15;

            foreach (XElement domain in XDocument.Root.Elements())
            {
                var domainScores = _scoring.DomainAnswerDistrib(domain.Attribute("abbreviation").Value);
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


        /// <summary>
        /// 
        /// </summary>
        private BarChartInput GetDeepAnswerDistrib(XElement element)
        {
            var answeredNo = new List<string>() { "N", "U" };

            var myQs = element.Descendants("CrrReference");

            var distrib = new List<int>
            {
                myQs.Count(x => x.Attribute("answer")?.Value == "Y"),
                myQs.Count(x => x.Attribute("answer")?.Value == "I"),
                myQs.Count(x => answeredNo.Contains(x.Attribute("answer")?.Value))
            };

            var d = new BarChartInput()
            {
                AnswerCounts = distrib
            };

            return d;
        }


        /// <summary>
        /// 
        /// </summary>
        BarChartInput GetAnswerDistrib(XElement element)
        {
            var answeredNo = new List<string>() { "N", "U" };

            if (element == null)
            {
                return new BarChartInput();
            }

            var myQs = element.Elements("CrrReference");

            var distrib = new List<int>
            {
                myQs.Count(x => x.Attribute("answer")?.Value == "Y"),
                myQs.Count(x => x.Attribute("answer")?.Value == "I"),
                myQs.Count(x => answeredNo.Contains(x.Attribute("answer")?.Value))
            };

            var d = new BarChartInput()
            {
                AnswerCounts = distrib
            };

            return d;
        }

        /// <summary>
        /// Gets an SVG of the legend with optional NA configuration.
        /// </summary>
        /// <param name="configuration"></param>
        /// <returns></returns>
        private string GetPerformanceSummaryLegend(string configuration = "")
        {
            var legend = new PerformanceSummaryLegend(configuration);
            return legend.ToString();
        }
    }
}
