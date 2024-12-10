//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Analysis;
using Microsoft.EntityFrameworkCore;
using Snickler.EFCore;
using CSETWebCore.Business.Authorization;



namespace CSETWebCore.Api.Controllers
{   [CsetAuthorize]
    [ApiController]
    public class AggregationAnalysisController : ControllerBase
    {
        private static object _myLockObject = new object();
        private readonly ITokenManager _tokenManager;
        private readonly ITrendDataProcessor _trendData;
        private CSETContext _context;

        public AggregationAnalysisController(ITokenManager tokenManager, ITrendDataProcessor trendData,
            CSETContext context)
        {
            _tokenManager = tokenManager;
            _trendData = trendData;
            _context = context;
        }

        [HttpPost]
        [Route("api/aggregation/analysis/overallcompliancescore")]
        public IActionResult OverallComplianceScore()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment)
                .Include(x => x.Assessment.STANDARD_SELECTION)
                .OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();


            // build the empty response structure for the assessments we have
            var response = new LineChart
            {
                reportType = "Trend Overall Compliance Score"
            };

            List<string> lineNames = new List<string>() { "Overall", "Components", "Standards" };
            foreach (string name in lineNames)
            {
                var ds = new ChartDataSet
                {
                    Label = name
                };

                response.datasets.Add(ds);

                foreach (var a in assessmentList)
                {
                    ds.Data.Add(0);
                }
            }


            // populate percentages in the structure
            for (int i = 0; i < assessmentList.Count; i++)
            {
                var a = assessmentList[i];

                response.labels.Add(a.Assessment.Assessment_Date.ToString("d-MMM-yyyy"));

                _context.LoadStoredProc("[GetCombinedOveralls]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        var procResults = (List<GetCombinedOveralls>)handler.ReadToList<GetCombinedOveralls>();

                        foreach (var procResult in procResults)
                        {
                            var mode = a.Assessment.STANDARD_SELECTION.Application_Mode;

                            string stat = procResult.StatType;

                            // funnel questions and requirements into 'standards' if assessment mode matches
                            if ((mode.StartsWith("Questions") && procResult.StatType == "Questions")
                            || (mode.StartsWith("Requirement") && procResult.StatType == "Requirement"))
                            {
                                stat = "Standards";
                            }

                            var ds = response.datasets.Find(x => x.Label == stat);
                            if (ds != null)
                            {
                                ds.Data[i] = (float)procResult.Value;
                            }
                        }
                    });
            }

            return Ok(response);
        }


        /// <summary>
        /// Calculates the 5 categories whose percentage scores have improved the most
        /// during the last segment of the trend analysis.
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/top5")]
        public IActionResult Top5()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            var response = new LineChart();
            response.reportType = "Top 5 Most Improved Areas";
            _trendData.Process(_context, (int?)aggregationID ?? 0, response, "TOP");

            return Ok(response);
        }


        /// <summary>
        /// Calculates the 5 categories whose percentage scores have decreased the most
        /// during the last segment of the trend analysis.
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/bottom5")]
        public IActionResult Bottom5()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }

            var response = new LineChart();
            response.reportType = "Top 5 Areas of Concern (Bottom 5)";

            _trendData.Process(_context, (int?)aggregationID ?? 0, response, "BOTTOM");

            return Ok(response);
        }


        /// <summary>
        /// Returns a data structure for the Category Percent Compare chart.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/categorypercentcompare")]
        public IActionResult CategoryPercentCompare()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            DataTable dt = new DataTable();
            dt.Columns.Add("AssessmentId", typeof(int));
            dt.Columns.Add("Alias");

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            foreach (var a in assessmentList)
            {
                var row = dt.NewRow();
                row["AssessmentId"] = a.Assessment_Id;
                row["Alias"] = a.Alias;
                dt.Rows.Add(row);

                lock (_myLockObject)
                {
                    var percentages = GetCategoryPercentages(a.Assessment_Id, _context);

                    foreach (usp_getStandardsResultsByCategory pct in percentages)
                    {
                        if (!dt.Columns.Contains(pct.Question_Group_Heading))
                        {
                            dt.Columns.Add(pct.Question_Group_Heading, typeof(float));
                        }

                        row[pct.Question_Group_Heading] = pct.prc;
                    }
                }
            }

            // build the response
            List<string> categories = dt.Columns.Cast<DataColumn>()
                   .OrderBy(x => x.ColumnName)
                   .Select(x => x.ColumnName)
                   .ToList();

            categories.Remove("AssessmentId");
            categories.Remove("Alias");


            var response = new HorizBarChart();
            response.ReportTitle = "Category Percent Comparisons";

            foreach (string category in categories)
            {
                response.Labels.Add(category);
            }

            foreach (DataRow rowAssessment in dt.Rows)
            {
                var ds = new ChartDataSet();
                response.Datasets.Add(ds);
                ds.Label = rowAssessment["Alias"].ToString();

                foreach (string category in categories)
                {
                    ds.Data.Add(rowAssessment[category] != DBNull.Value ? (float)rowAssessment[category] : 0f);
                }
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns the category percentages for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="db"></param>
        private List<usp_getStandardsResultsByCategory> GetCategoryPercentages(int assessmentId, CSETContext db)
        {
            List<usp_getStandardsResultsByCategory> response = null;

            lock (_myLockObject)
            {
                db.LoadStoredProc("[usp_getStandardsResultsByCategory]")
                            .WithSqlParam("assessment_Id", assessmentId)
                            .ExecuteStoredProc((handler) =>
                            {
                                var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                                var labels = (from usp_getStandardsResultsByCategory an in result
                                              orderby an.Question_Group_Heading
                                              select an.Question_Group_Heading).Distinct().ToList();


                                response = (List<usp_getStandardsResultsByCategory>)result;
                            });
            }

            return response;
        }


        /// <summary>
        /// Returns average overall scores.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/overallaverages")]
        public IActionResult GetOverallAverages()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
           
            var response = new HorizBarChart();
            response.ReportTitle = "Overall Average Summary";


            Dictionary<string, List<double>> dict = new Dictionary<string, List<double>>
            {
                ["Questions"] = new List<double>(),
                ["Requirement"] = new List<double>(),
                ["Overall"] = new List<double>(),
                ["Components"] = new List<double>()
            };

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[GetCombinedOveralls]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        var procResults = (List<GetCombinedOveralls>)handler.ReadToList<GetCombinedOveralls>();

                        foreach (var procResult in procResults)
                        {
                            if (dict.ContainsKey(procResult.StatType))
                            {
                                dict[procResult.StatType].Add(procResult.Value);
                            }
                        }
                    });
            }

            var ds = new ChartDataSet();
            response.Datasets.Add(ds);

            response.Labels.Add("Overall");
            ds.Data.Add((float)dict["Overall"].DefaultIfEmpty(0).Average());

            response.Labels.Add("Standards");
            ds.Data.Add(
                (float)dict["Questions"].DefaultIfEmpty(0).Average()
                + (float)dict["Requirement"].DefaultIfEmpty(0).Average());

            response.Labels.Add("Components");
            ds.Data.Add((float)dict["Components"].DefaultIfEmpty(0).Average());

            return Ok(response);
        }


        [HttpPost]
        [Route("api/aggregation/analysis/standardsanswers")]
        public IActionResult GetStandardsAnswerDistribution()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }

            // create place to accumulate percentages for each answer
            var dict = new Dictionary<string, List<decimal>>();
            var answerNames = new List<string>() { "Y", "N", "NA", "A", "U" };
            foreach (string a in answerNames)
            {
                dict.Add(a, new List<decimal>());
            }

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[usp_getStandardSummaryOverall]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        var procResults = (List<usp_getStandardSummaryOverall>)handler.ReadToList<usp_getStandardSummaryOverall>();

                        foreach (var procResult in procResults)
                        {
                            if (dict.ContainsKey(procResult.Answer_Text))
                            {
                                dict[procResult.Answer_Text].Add(procResult.Percent);
                            }
                        }
                    });
            }


            var response = new PieChart();
            response.reportType = "Overall Summary - Standards Answers";
            response.labels.AddRange(answerNames);
            foreach (string a in answerNames)
            {
                response.data.Add((float)dict[a].DefaultIfEmpty(0).Average());
            }

            return Ok(response);
        }


        [HttpPost]
        [Route("api/aggregation/analysis/componentsanswers")]
        public IActionResult GetComponentsAnswerDistribution()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }

            // create place to accumulate percentages for each answer
            var dict = new Dictionary<string, List<decimal>>();
            var answerNames = new List<string>() { "Y", "N", "NA", "A", "U" };
            foreach (string a in answerNames)
            {
                dict.Add(a, new List<decimal>());
            }

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[usp_GetComponentsSummary]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        var procResults = (List<usp_getComponentsSummmary>)handler.ReadToList<usp_getComponentsSummmary>();

                        foreach (var procResult in procResults)
                        {
                            if (dict.ContainsKey(procResult.Answer_Text))
                            {
                                dict[procResult.Answer_Text].Add(procResult.value);
                            }
                        }
                    });
            }

            var response = new PieChart();
            response.reportType = "Overall Summary - Standards Answers";
            response.labels.AddRange(answerNames);
            foreach (string a in answerNames)
            {
                response.data.Add((float)dict[a].DefaultIfEmpty(0).Average());
            }

            return Ok(response);
        }


        [HttpPost]
        [Route("api/aggregation/analysis/categoryaverages")]
        public IActionResult GetCategoryAverages()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            var dict = new Dictionary<string, List<decimal>>();

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[usp_getStandardsResultsByCategory]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        // usp_getStandardsResultsByCategory 15
                        var procResults = (List<usp_getStandardsResultsByCategory>)handler.ReadToList<usp_getStandardsResultsByCategory>();

                        foreach (var procResult in procResults)
                        {
                            if (!dict.ContainsKey(procResult.Question_Group_Heading))
                            {
                                dict.Add(procResult.Question_Group_Heading, new List<decimal>());
                            }
                            if (procResult.Actualcr > 0)
                            {
                                dict[procResult.Question_Group_Heading].Add(procResult.prc);
                            }
                        }
                    });
            }

            var catList = dict.Keys.ToList();
            catList.Sort();


            var response = new HorizBarChart();
            var ds = new ChartDataSet();
            response.Datasets.Add(ds);
            response.Labels.AddRange(catList);
            foreach (string cat in catList)
            {
                ds.Data.Add((float)dict[cat].DefaultIfEmpty(0).Average());
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns answer breakdown for all associated assessments.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/getanswertotals")]
        public IActionResult GetAnswerTotals()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            List<AnswerCounts> response = new List<AnswerCounts>();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[usp_getStandardSummaryOverall]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        var results = (List<usp_getStandardSummaryOverall>)handler.ReadToList<usp_getStandardSummaryOverall>();

                        var ansCount = new AnswerCounts()
                        {
                            AssessmentId = a.Assessment_Id,
                            Alias = a.Alias,
                            Total = results.Max(x => x.Total),
                            Y = results.Where(x => x.Answer_Text == "Y").FirstOrDefault().qc,
                            N = results.Where(x => x.Answer_Text == "N").FirstOrDefault().qc,
                            A = results.Where(x => x.Answer_Text == "A").FirstOrDefault().qc,
                            NA = results.Where(x => x.Answer_Text == "NA").FirstOrDefault().qc,
                            U = results.Where(x => x.Answer_Text == "U").FirstOrDefault().qc
                        };

                        response.Add(ansCount);
                    });
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns an answer breakdown for all associated maturity-based assessments in the
        /// aggregation.  This logic is flexible for models that have their own answer option lists.
        /// In other words, no "Y", "N", "A" assumption is made.
        /// </summary>
        /// <param name="aggregationID"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/maturity/answertotals")]
        public IActionResult GetMaturityAnswerTotalsFlexible()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }
            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            List<AnswerCountsGeneric> response = new List<AnswerCountsGeneric>();

            foreach (var a in assessmentList)
            {
                var mm = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == a.Assessment.Assessment_Id)
                    .Include(x => x.model)
                    .FirstOrDefault();


                // create a list of applicable answer options
                var answerOrder = mm.model.Answer_Options.Split(',').ToList();
                answerOrder.Add("U");


                _context.LoadStoredProc("[usp_GetMaturityAnswerTotals]")
                   .WithSqlParam("assessment_id", a.Assessment_Id)
                   .ExecuteStoredProc((handler) =>
                   {
                       var results = (List<AnswerCountsAndPercentages>)handler.ReadToList<AnswerCountsAndPercentages>();


                       var acg = new AnswerCountsGeneric();
                       acg.AssessmentId = a.Assessment_Id;
                       acg.ModelId = mm.model_id;
                       acg.Alias = a.Alias;

                       foreach (var item in answerOrder)
                       {
                           var dbResult = results.Where(x => x.Answer_Text == item).FirstOrDefault();

                           acg.AnswerCounts.Add(new AnswerCountsAndPercentages()
                           {
                               Answer_Text = item,
                               QC = dbResult?.QC ?? 0,
                               Total = dbResult?.Total ?? 0,
                               Percent = dbResult?.Percent ?? 0
                           });
                       }

                       response.Add(acg);
                   });
            }

            return Ok(response);
        }



        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/overallcomparison")]
        public IActionResult GetOverallComparison()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var response = new HorizBarChart();
            response.ReportTitle = "Overall Comparison";
            var statTypes = new List<string>() { "Overall", "Standards", "Components" };
            response.Labels.AddRange(statTypes);

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[GetCombinedOveralls]")
                    .WithSqlParam("assessment_id", a.Assessment_Id)
                    .ExecuteStoredProc((handler) =>
                    {
                        var result = handler.ReadToList<GetCombinedOveralls>();
                        var g = (List<GetCombinedOveralls>)result;

                        Dictionary<string, double> dict = new Dictionary<string, double>();
                        dict["Standards"] = 0;

                        foreach (GetCombinedOveralls row in g)
                        {
                            if (row.StatType == "Requirement" || row.StatType == "Questions")
                            {
                                dict["Standards"] += row.Value;
                            }
                            else
                            {
                                dict[row.StatType] = row.Value;
                            }
                        }

                        var ds = new ChartDataSet
                        {
                            Label = a.Alias
                        };
                        response.Datasets.Add(ds);
                        foreach (var statType in statTypes)
                        {
                            ds.Data.Add((float)dict[statType]);
                        }
                    });
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns a bar for each assessment's SAL level in the aggregation.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/salcomparison")]
        public IActionResult GetSalComparison()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();


            var response = new List<SalComparison>();

            foreach (var a in assessmentList)
            {
                var sal = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == a.Assessment_Id).FirstOrDefault();

                if (sal != null)
                {
                    response.Add(new SalComparison()
                    {
                        AssessmentId = a.Assessment_Id,
                        Alias = a.Alias,
                        SalLevel = sal.Selected_Sal_Level
                    });
                }
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns answer breakdown for all associated assessments.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/getbesttoworst")]
        public IActionResult GetBestToWorst()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return Ok();
            }

            Dictionary<string, List<GetComparisonBestToWorst>> dict = new Dictionary<string, List<GetComparisonBestToWorst>>();

            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();

            var response = new List<BestToWorstCategory>();

            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[GetComparisonBestToWorst]")
                        .WithSqlParam("assessment_id", a.Assessment_Id)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<GetComparisonBestToWorst>();
                            foreach (var r in result)
                            {
                                r.AssessmentName = a.Alias;

                                // tweak - make sure that rounding didn't end up with more than 100%
                                var realAnswerPct = r.YesValue + r.NoValue + r.NaValue + r.AlternateValue;
                                if (realAnswerPct + r.UnansweredValue > 100f)
                                {
                                    r.UnansweredValue = 100f - realAnswerPct;
                                }


                                if (!dict.ContainsKey(r.Name))
                                {
                                    dict[r.Name] = new List<GetComparisonBestToWorst>();
                                }
                                dict[r.Name].Add(r);
                            }
                        });
            }

            // repackage the data 
            var keys = dict.Keys.ToList();
            keys.Sort();
            foreach (string k in keys)
            {
                var category = new BestToWorstCategory()
                {
                    Category = k,
                    Assessments = dict[k]
                };

                // sort best to worst
                category.Assessments.Sort((a, b) => (a.YesValue + a.AlternateValue).CompareTo(b.YesValue + b.AlternateValue));
                category.Assessments.Reverse();
                response.Add(category);
            }

            return Ok(response);
        }


        /// <summary>
        /// Returns answer breakdown for all associated maturity assessments.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/maturity/besttoworst")]
        public IActionResult GetMaturityBestToWorst()
        {
            var aggregationID = _tokenManager.PayloadInt("aggreg");

            if (aggregationID == null)
            {
                return Ok();
            }


            BestToWorst response = new BestToWorst();


            var assessmentList = _context.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                .Include(x => x.Assessment).OrderBy(x => x.Assessment.Assessment_Date)
                .ToList();


            // get the answer options for the maturity model so that we can enforce their display order
            var modelId = _context.AVAILABLE_MATURITY_MODELS.FirstOrDefault(x => x.Assessment_Id == assessmentList[0].Assessment_Id).model_id;
            response.ModelId = modelId;

            var model = _context.MATURITY_MODELS.FirstOrDefault(x => x.Maturity_Model_Id == modelId);
            var answerOptions = model.Answer_Options.Split(',').ToList();
            if (!answerOptions.Contains("U"))
            {
                answerOptions.Add("U");
            }
            response.AnswerOptions.AddRange(answerOptions);


            foreach (var a in assessmentList)
            {
                _context.LoadStoredProc("[GetAnswerCountsForGroupings]")
                        .WithSqlParam("assessmentid", a.Assessment_Id)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<Proc_AnswerCounts>();

                            foreach (var r in result)
                            {
                                var groupingTotal = result.Where(x => x.Grouping_Id == r.Grouping_Id).Select(x => x.AnsCount).ToList().Sum();


                                var percent = 0.0;
                                if (groupingTotal > 0)
                                {
                                    percent = ((double)r.AnsCount / (double)groupingTotal) * 100.0;
                                }



                                // Create a home for the grouping, if it doesn't exist yet
                                var g = response.Groupings.FirstOrDefault(x => x.GroupingId == r.Grouping_Id);
                                if (g == null)
                                {
                                    g = new Grouping() { GroupingId = r.Grouping_Id, Title = r.Title };
                                    response.Groupings.Add(g);
                                }


                                var aa = g.Assessments.FirstOrDefault(x => x.AssessmentId == a.Assessment_Id);
                                if (aa == null)
                                {
                                    aa = new AssessmentAlias() { Alias = a.Alias, AssessmentId = a.Assessment_Id };
                                    g.Assessments.Add(aa);
                                }

                                // Add a new answer percentage object and keep the list sorted by answer order
                                var ap = new AnswerPercentage()
                                {
                                    AnswerText = r.Answer_Text,
                                    AnswerIndex = answerOptions.IndexOf(r.Answer_Text),
                                    Percent = percent
                                };
                                aa.Percentages.Add(ap);

                                aa.Percentages.Sort((x, y) => x.AnswerIndex.CompareTo(y.AnswerIndex));
                            }
                        });
            }

            return Ok(response);
        }
    }





    /// <summary>
    /// The model that reflects the result from the stored proc 
    /// that brings back answer counts for each grouping.
    /// </summary>
    public class Proc_AnswerCounts
    {
        public string Title { get; set; }
        public int Grouping_Id { get; set; }
        public int? ParentId { get; set; }
        public string Answer_Text { get; set; }
        public int AnsCount { get; set; }
    }


    public class BestToWorst
    {
        public List<Grouping> Groupings { get; set; } = [];
        public List<string> AnswerOptions { get; set; } = [];
        public int ModelId { get; set; }
    }


    public class Grouping
    {
        public string Title { get; set; }
        public int GroupingId { get; set; }
        public List<AssessmentAlias> Assessments { get; set; } = [];
    }


    public class AssessmentAlias
    {
        public int AssessmentId { get; set; }
        public string Alias { get; set; }
        public List<AnswerPercentage> Percentages { get; set; } = [];
    }


    public class AnswerPercentage
    {
        public string AnswerText { get; set; }
        public int AnswerIndex { get; set; }
        public double Percent { get; set; }
    }


    public class AggBody
    {
        public int AggregationID { get; set; }
    }
}
