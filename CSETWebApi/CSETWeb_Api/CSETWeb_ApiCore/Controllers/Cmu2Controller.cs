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
            var assessmentId = _token.AssessmentForUser();



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
        /// -----WARNING
        /// 
        /// This is too big and complex to be stringified for the HTTP return.
        /// It never returns.  
        /// 
        /// -----WARNING
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
        /// <returns></returns>
        [HttpGet]
        [Route("api/cmu/widget/blocklegend")]
        public IActionResult GetBlockLegend()
        {
            return Content(new BlockLegend().ToString(), "text/html");
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

            return Ok(new { funcs, _scoring.CsfFunctionColors });
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


    }
}
