//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web.Http;
using CSETWeb_Api.BusinessLogic.Models;
using Microsoft.EntityFrameworkCore;
using CSETWeb_Api.BusinessManagers.Analysis;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers.Aggregation;

namespace CSETWeb_Api.Controllers
{
    //[CSETAuthorize]
    public class AggregationAnalysisController : ApiController
    {
        /// <summary>
        /// 
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/overallcompliancescore")]
        public LineChart OverallComplianceScore()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }


            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_)
                    .Include(x => x.Assessment_.STANDARD_SELECTION)
                    .OrderBy(x => x.Assessment_.Assessment_Date)
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
                        label = name
                    };

                    response.datasets.Add(ds);

                    foreach (var a in assessmentList)
                    {
                        ds.data.Add(0);
                    }
                }


                // populate percentages in the structure
                for (int i = 0; i < assessmentList.Count; i++)
                {
                    var a = assessmentList[i];

                    response.labels.Add(a.Assessment_.Assessment_Date.ToString("d-MMM-yyyy"));

                    db.LoadStoredProc("[dbo].[GetCombinedOveralls]")
                        .WithSqlParam("assessment_id", a.Assessment_Id)
                        .ExecuteStoredProc((handler) =>
                        {
                            var procResults = (List<GetCombinedOveralls>)handler.ReadToList<GetCombinedOveralls>();

                            foreach (var procResult in procResults)
                            {
                                var mode = a.Assessment_.STANDARD_SELECTION.Application_Mode;

                                string stat = procResult.StatType;

                                // funnel questions and requirements into 'standards' if assessment mode matches
                                if ((mode.StartsWith("Questions") && procResult.StatType == "Questions")
                                || (mode.StartsWith("Requirement") && procResult.StatType == "Requirement"))
                                {
                                    stat = "Standards";
                                }

                                var ds = response.datasets.Find(x => x.label == stat);
                                if (ds != null)
                                {
                                    ds.data[i] = (float)procResult.Value;
                                }
                            }
                        });
                }

                return response;
            }
        }


        /// <summary>
        /// Calculates the 5 categories whose percentage scores have improved the most
        /// during the last segment of the trend analysis.
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/top5")]
        public LineChart Top5()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var response = new LineChart();
            response.reportType = "Top 5 Most Improved Areas";

            using (CSET_Context db = new CSET_Context())
            {
                TrendDataProcessor trendData = new TrendDataProcessor();
                trendData.Process(db, aggregationID ?? 0, response, "TOP");
            }

            return response;
        }


        /// <summary>
        /// Calculates the 5 categories whose percentage scores have decreased the most
        /// during the last segment of the trend analysis.
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/bottom5")]
        public LineChart Bottom5()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var response = new LineChart();
            response.reportType = "Top 5 Areas of Concern (Bottom 5)";

            using (CSET_Context db = new CSET_Context())
            {
                TrendDataProcessor trendData = new TrendDataProcessor();
                trendData.Process(db, aggregationID ?? 0, response, "BOTTOM");
            }

            return response;
        }


        /// <summary>
        /// Returns a data structure for the Category Percent Compare chart.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/categorypercentcompare")]
        public HorizBarChart CategoryPercentCompare()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            DataTable dt = new DataTable();
            dt.Columns.Add("AssessmentId", typeof(int));
            dt.Columns.Add("Alias");

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    var row = dt.NewRow();
                    row["AssessmentId"] = a.Assessment_Id;
                    row["Alias"] = a.Alias;
                    dt.Rows.Add(row);

                    var percentages = GetCategoryPercentages(a.Assessment_Id, db);

                    foreach (usp_getStandardsResultsByCategory pct in percentages)
                    {
                        if (!dt.Columns.Contains(pct.Question_Group_Heading))
                        {
                            dt.Columns.Add(pct.Question_Group_Heading, typeof(float));
                        }

                        row[pct.Question_Group_Heading] = pct.prc;
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
                response.reportTitle = "Category Percent Comparisons";

                foreach (string category in categories)
                {
                    response.labels.Add(category);
                }

                foreach (DataRow rowAssessment in dt.Rows)
                {
                    var ds = new ChartDataSet();
                    response.datasets.Add(ds);
                    ds.label = rowAssessment["Alias"].ToString();

                    foreach (string category in categories)
                    {
                        ds.data.Add(rowAssessment[category] != DBNull.Value ? (float)rowAssessment[category] : 0f);
                    }
                }

                return response;
            }
        }


        /// <summary>
        /// Returns the category percentages for an assessment.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="db"></param>
        private List<usp_getStandardsResultsByCategory> GetCategoryPercentages(int assessmentId, CSET_Context db)
        {
            List<usp_getStandardsResultsByCategory> response = null;

            db.LoadStoredProc("[dbo].[usp_getStandardsResultsByCategory]")
                        .WithSqlParam("assessment_Id", assessmentId)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                            var labels = (from usp_getStandardsResultsByCategory an in result
                                          orderby an.Question_Group_Heading
                                          select an.Question_Group_Heading).Distinct().ToList();


                            response = (List<usp_getStandardsResultsByCategory>)result;
                        });

            return response;
        }


        /// <summary>
        /// Returns average overall scores.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/overallaverages")]
        public HorizBarChart GetOverallAverages()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var response = new HorizBarChart();
            response.reportTitle = "Overall Average Summary";


            Dictionary<string, List<double>> dict = new Dictionary<string, List<double>>
            {
                ["Questions"] = new List<double>(),
                ["Requirement"] = new List<double>(),
                ["Overall"] = new List<double>(),
                ["Components"] = new List<double>()
            };


            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[GetCombinedOveralls]")
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
                response.datasets.Add(ds);

                response.labels.Add("Overall");
                ds.data.Add((float)dict["Overall"].DefaultIfEmpty(0).Average());

                response.labels.Add("Standards");
                ds.data.Add(
                    (float)dict["Questions"].DefaultIfEmpty(0).Average()
                    + (float)dict["Requirement"].DefaultIfEmpty(0).Average());
                
                response.labels.Add("Components");
                ds.data.Add((float)dict["Components"].DefaultIfEmpty(0).Average());

                return response;
            }
        }


        [HttpPost]
        [Route("api/aggregation/analysis/standardsanswers")]
        public PieChart GetStandardsAnswerDistribution()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            // create place to accumulate percentages for each answer
            var dict = new Dictionary<string, List<decimal>>();
            var answerNames = new List<string>() { "Yes", "No", "Not Applicable", "Alternate", "Unanswered" };
            foreach (string a in answerNames)
            {
                dict.Add(a, new List<decimal>());
            }

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[usp_getStandardSummaryOverall]")
                        .WithSqlParam("assessment_id", a.Assessment_Id)
                        .ExecuteStoredProc((handler) =>
                        {
                            var procResults = (List<usp_getStandardSummaryOverall>)handler.ReadToList<usp_getStandardSummaryOverall>();

                            foreach (var procResult in procResults)
                            {
                                dict[procResult.Answer_Full_Name].Add(procResult.Percent);
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

                return response;
            }
        }


        [HttpPost]
        [Route("api/aggregation/analysis/componentsanswers")]
        public PieChart GetComponentsAnswerDistribution()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            // create place to accumulate percentages for each answer
            var dict = new Dictionary<string, List<decimal>>();
            var answerNames = new List<string>() { "Yes", "No", "Not Applicable", "Alternate", "Unanswered" };
            foreach (string a in answerNames)
            {
                dict.Add(a, new List<decimal>());
            }


            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[usp_GetComponentsSummary]")
                        .WithSqlParam("assessment_id", a.Assessment_Id)
                        .ExecuteStoredProc((handler) =>
                        {
                            var procResults = (List<usp_getComponentsSummmary>)handler.ReadToList<usp_getComponentsSummmary>();

                            foreach (var procResult in procResults)
                            {
                                dict[procResult.Answer_Full_Name].Add(procResult.value);
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

                return response;
            }
        }


        [HttpPost]
        [Route("api/aggregation/analysis/categoryaverages")]
        public HorizBarChart GetCategoryAverages()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var dict = new Dictionary<string, List<decimal>>();

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[usp_getStandardsResultsByCategory]")
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
            }

            var catList = dict.Keys.ToList();
            catList.Sort();


            var response = new HorizBarChart();
            var ds = new ChartDataSet();
            response.datasets.Add(ds);
            response.labels.AddRange(catList);
            foreach (string cat in catList)
            {
                ds.data.Add((float)dict[cat].DefaultIfEmpty(0).Average());
            }

            return response;
        }


        /// <summary>
        /// Returns answer breakdown for all associated assessments.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/getanswertotals")]
        public List<AnswerCounts> GetAnswerTotals()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                List<AnswerCounts> response = new List<AnswerCounts>();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[usp_getStandardSummaryOverall]")
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

                return response;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/overallcomparison")]
        public HorizBarChart GetOverallComparison()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            var response = new HorizBarChart();
            response.reportTitle = "Overall Comparison";
            var statTypes = new List<string>() { "Overall", "Standards", "Components" };
            response.labels.AddRange(statTypes);


            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[GetCombinedOveralls]")
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
                                label = a.Alias
                            };
                            response.datasets.Add(ds);
                            foreach (var statType in statTypes)
                            {
                                ds.data.Add((float)dict[statType]);
                            }
                        });
                }
            }

            return response;
        }


        /// <summary>
        /// Returns a bar for each assessment's SAL level in the aggregation.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/salcomparison")]
        public List<SalComparison> GetSalComparison()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();


                var response = new List<SalComparison>();

                foreach (var a in assessmentList)
                {
                    var sal = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == a.Assessment_Id).FirstOrDefault();

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

                return response;
            }
        }


        /// <summary>
        /// Returns answer breakdown for all associated assessments.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/getbesttoworst")]
        public List<BestToWorstCategory> GetBestToWorst()
        {
            TokenManager tm = new TokenManager();
            var aggregationID = tm.PayloadInt("aggreg");
            if (aggregationID == null)
            {
                return null;
            }

            Dictionary<string, List<GetComparisonBestToWorst>> dict = new Dictionary<string, List<GetComparisonBestToWorst>>();

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationID)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                var response = new List<BestToWorstCategory>();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[GetComparisonBestToWorst]")
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

                return response;
            }
        }
    }
}
