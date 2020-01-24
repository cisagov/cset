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
        public LineChart OverallComplianceScore([FromUri] int aggregationId)
        {
            var response = new LineChart();
            response.reportType = "Trend Overall Compliance Score";

            // create the 4 compliance categories
            List<string> lineNames = new List<string>() { "Overall", "Components", "Standards" };
            foreach (string name in lineNames)
            {
                var ds = new ChartDataSet();
                ds.label = name;
                response.datasets.Add(ds);
            }


            // TEMP TEMP TEMP - just return a dummy response until we can get the stored proc 
            //                  modified for the 9.x database.

            var rnd = new Random(DateTime.Now.Millisecond);

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    response.labels.Add(a.Assessment_.Assessment_Date.ToString("d-MMM-yyyy"));

                    foreach (var ds1 in response.datasets)
                    {
                        ds1.data.Add(rnd.Next(0, 100));
                    }
                }
            }

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/top5")]
        public LineChart Top5([FromUri] int aggregationId)
        {
            var response = new LineChart();
            response.reportType = "Top 5 Most Improved Areas";

            // create the 4 compliance categories
            List<string> lineNames = new List<string>() { "System Protection", "Training", "Incident Response", "Physical Security", "Access Control" };
            foreach (string name in lineNames)
            {
                var ds = new ChartDataSet();
                ds.label = name;
                response.datasets.Add(ds);
            }


            // TEMP TEMP TEMP - just return a dummy response until we can get the stored proc 
            //                  modified for the 9.x database.

            var rnd = new Random(DateTime.Now.Millisecond);

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    response.labels.Add(a.Assessment_.Assessment_Date.ToString("d-MMM-yyyy"));

                    foreach (var ds1 in response.datasets)
                    {
                        ds1.data.Add(rnd.Next(0, 100));
                    }
                }
            }

            return response;
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpPost]
        [Route("api/aggregation/analysis/bottom5")]
        public LineChart Bottom5([FromUri] int aggregationId)
        {
            var response = new LineChart();
            response.reportType = "Top 5 Areas of Concern";

            // create the 4 compliance categories
            List<string> lineNames = new List<string>() { "Information Protection", "Communication Protection", "Monitoring & Malware", "Continuity", "Configuration Management" };
            foreach (string name in lineNames)
            {
                var ds = new ChartDataSet();
                ds.label = name;
                response.datasets.Add(ds);
            }


            // TEMP TEMP TEMP - just return a dummy response until we can get the stored proc 
            //                  modified for the 9.x database.

            var rnd = new Random(DateTime.Now.Millisecond);

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    response.labels.Add(a.Assessment_.Assessment_Date.ToString("d-MMM-yyyy"));

                    foreach (var ds1 in response.datasets)
                    {
                        ds1.data.Add(rnd.Next(0, 100));
                    }
                }
            }

            return response;
        }


        /// <summary>
        /// Returns a data structure for the Category Percent Compare chart.
        /// </summary>
        /// <param name="aggregationId"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/categorypercentcompare")]
        public HorizBarChart CategoryPercentCompare([FromUri] int aggregationId)
        {
            var response = new HorizBarChart();
            response.reportType = "Trend Category Percent Comparisons";

            DataTable dt = new DataTable();
            dt.Columns.Add("AssessmentId", typeof(int));
            dt.Columns.Add("Alias");

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                foreach (var a in assessmentList)
                {
                    var row = dt.NewRow();
                    row["AssessmentId"] = a.Assessment_Id;
                    row["Alias"] = a.Alias;
                    dt.Rows.Add(row);

                    var rrr = GetCategoryPercentages(a.Assessment_Id, db);

                    foreach (usp_getStandardsResultsByCategory r in rrr)
                    {
                        if (!dt.Columns.Contains(r.Question_Group_Heading))
                        {
                            dt.Columns.Add(r.Question_Group_Heading, typeof(float));
                        }

                        row[r.Question_Group_Heading] = r.prc;
                    }
                }

                // build the response
                List<string> categories = dt.Columns.Cast<DataColumn>()
                       .OrderBy(x => x.ColumnName)
                       .Select(x => x.ColumnName)
                       .ToList();

                categories.Remove("AssessmentId");
                categories.Remove("Alias");


                foreach (string category in categories)
                {
                    response.categories.Add(category);
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
            }

            return response;
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
        /// Returns answer breakdown for all associated assessments.
        /// </summary>
        /// <param name="aggregationId"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/getanswertotals")]
        public List<AnswerCounts> GetAnswerTotals([FromUri] int aggregationId)
        {
            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
                    .Include(x => x.Assessment_).OrderBy(x => x.Assessment_.Assessment_Date)
                    .ToList();

                List<AnswerCounts> response = new List<AnswerCounts>();

                foreach (var a in assessmentList)
                {
                    db.LoadStoredProc("[dbo].[usp_getStandardSummaryOverall]")
                        .WithSqlParam("assessment_id", a.Assessment_Id)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<usp_getStandardSummaryOverall>();
                            var g = (List<usp_getStandardSummaryOverall>)result;


                            var abc = new AnswerCounts()
                            {
                                AssessmentId = a.Assessment_Id,
                                Alias = a.Alias,
                                Total = g.Max(x => x.Total),
                                Y = g.Where(x => x.Answer_Text == "Y").FirstOrDefault().qc,
                                N = g.Where(x => x.Answer_Text == "N").FirstOrDefault().qc,
                                A = g.Where(x => x.Answer_Text == "A").FirstOrDefault().qc,
                                NA = g.Where(x => x.Answer_Text == "NA").FirstOrDefault().qc,
                                U = g.Where(x => x.Answer_Text == "U").FirstOrDefault().qc
                            };

                            response.Add(abc);
                        });
                }

                return response;
            }
        }


        /// <summary>
        /// Returns answer breakdown for all associated assessments.
        /// </summary>
        /// <param name="aggregationId"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/aggregation/analysis/getbesttoworst")]
        public List<BestToWorstCategory> GetBestToWorst([FromUri] int aggregationId)
        {
            Dictionary<string, List<GetComparisonBestToWorst>> dict = new Dictionary<string, List<GetComparisonBestToWorst>>();

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentList = db.AGGREGATION_ASSESSMENT.Where(x => x.Aggregation_Id == aggregationId)
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

                                    // fudge - make sure that rounding didn't end up with more 100%
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
                    response.Add(new BestToWorstCategory()
                    {
                        Category = k,
                        Assessments = dict[k]
                    });
                }

                return response;
            }
        }
    }


    /// <summary>
    /// Contains an answer breakdown for an assessment.  The Y, N 
    /// fields can hold a question count or a rounded percentage, depending on need.
    /// </summary>
    public class AnswerCounts
    {
        public int AssessmentId { get; set; }
        public string Alias { get; set; }
        public int Total { get; set; }
        public int Y { get; set; }
        public int N { get; set; }
        public int NA { get; set; }
        public int A { get; set; }
        public int U { get; set; }
    }


    /// <summary>
    /// 
    /// </summary>
    public class BestToWorstCategory
    {
        public string Category { get; set; }
        public List<GetComparisonBestToWorst> Assessments { get; set; }
    }


}
