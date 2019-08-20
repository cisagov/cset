//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.BusinessManagers.Analysis;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessManagers.Analysis;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using Snickler.EFCore;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    [CSETAuthorize]
    public class AnalysisController : ApiController
    {
        static Dictionary<String, String> answerColorDefs = new Dictionary<string, string>();
        static AnalysisController()
        {
            answerColorDefs.Add("U", "#CCCCCC");
            answerColorDefs.Add("Y", "#006000");
            answerColorDefs.Add("A", "#B17300");
            answerColorDefs.Add("NA", "#0063B1");
            answerColorDefs.Add("N", "#990000");
        }

        [HttpGet]
        [Route("api/analysis/RankedQuestions")]
        public List<usp_GetRankedQuestions_Result> GetRankedQuestions()
        {
            int assessmentId = Auth.AssessmentForUser();

            RequirementsManager rm = new RequirementsManager(assessmentId);

            using (CSET_Context context = new CSET_Context())
            {
                var rankedQuestionList = context.usp_GetRankedQuestions(assessmentId).ToList();

                foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
                {
                    q.QuestionText = rm.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);
                }

                return rankedQuestionList;
            }
        }


        [HttpGet]
        [Route("api/analysis/dashboard")]
        public FirstPage GetDashboard()
        {
            int assessmentId = Auth.AssessmentForUser();

            FirstPage rval = null;

            using (CSET_Context context = new CSET_Context())
            {
                var results = new FirstPageMultiResult();
                context.LoadStoredProc("[dbo].[usp_GetFirstPage]")
                  .WithSqlParam("assessment_id", assessmentId)
                  .ExecuteStoredProc((handler) =>
                  {
                      results.Result1 = handler.ReadToList<GetCombinedOveralls>().ToList();
                      handler.NextResult();
                      results.Result2 = handler.ReadToList<usp_getRankedCategories>().ToList();
                  });



                if (results.Count >= 2)
                {
                    List<double> data = new List<double>();
                    List<String> labels = new List<String>();
                    ChartData stand = null;
                    ChartData comp = null;
                    foreach (GetCombinedOveralls c in results.Result1)
                    {
                        // Questions or Requirements are included only if we are in that 'mode'
                        // Do not include 'Framework' entry.
                        string mode = this.GetAssessmentMode(assessmentId);
                        if ((c.StatType.ToLower() == "questions" && mode != "Q")
                            || (c.StatType.ToLower() == "requirement" && mode != "R")
                            || c.StatType.ToLower() == "framework")
                        {
                            // do not include the label and data
                        }
                        else
                        {
                            labels.Add(c.StatType);
                            data.Add(c.Value);
                        }

                        if (c.StatType == "Components")
                        {
                            comp = transformToChart(c);
                        }

                        if ((c.StatType == "Questions" && mode == "Q")
                            || (c.StatType == "Requirement" && mode == "R"))
                        {
                            stand = transformToChart(c);
                        }
                    }
                    ChartData overallBars = new ChartData()
                    {
                        backgroundColor = "red",
                        borderWidth = "1",
                        label = "overalls",
                        Labels = labels,
                        data = data
                    };

                    ChartData chartData = new ChartData();

                    int rcount = 0;
                    foreach (usp_getRankedCategories c in results.Result2)
                    {
                        if (rcount < 5)
                        {
                            chartData.data.Add((double)(c.prc ?? 0.0M));
                            chartData.Labels.Add(c.Question_Group_Heading);
                        }
                        else
                        {
                            break;
                        }
                        rcount++;
                    }


                    rval = new FirstPage()
                    {
                        OverallBars = overallBars,
                        ComponentSummaryPie = comp,
                        StandardsSummaryPie = stand,
                        RedBars = chartData
                    };

                }
            }

            return rval;
        }


        [HttpGet]
        [Route("api/analysis/TopCategories")]
        public ChartData GetTopCategories()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData chartData = null;
            using (CSET_Context context = new CSET_Context())
            {
                var results = new RankedCategoriesMultiResult();
                context.LoadStoredProc("[dbo].[usp_GetRankedCategoriesPage]")
              .WithSqlParam("assessment_id", assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  results.Result1 = handler.ReadToList<usp_getRankedCategories>().ToList();

              });


                if (results.Count >= 1)
                {
                    List<double> data = new List<double>();
                    ChartData overallBars = new ChartData()
                    {
                        backgroundColor = "red",
                        borderWidth = "1",
                        label = "Overall Ranked Categories",
                        data = data
                    };

                    chartData = new ChartData();
                    foreach (usp_getRankedCategories c in results.Result1)
                    {
                        chartData.data.Add((double)c.prc);
                        chartData.Labels.Add(c.Question_Group_Heading);

                    }
                }
            }

            return chartData;
        }


        /// <summary>
        /// Re-orders the pieces into Y|N|NA|A|U order
        /// </summary>
        /// <param name="r"></param>
        void SortIntoAnswerOrder(StandardSummaryOverallMultiResult r)
        {
            var shortName = r.Result1.Select(x => x.Short_Name).Distinct();

            var orderedList = new List<DataRowsPie>();
            foreach (var s in shortName)
            {
                var tempOList = new List<DataRowsPie>
                {
                    r.Result1.Where(p => p.Answer_Text == "Y" && p.Short_Name == s).FirstOrDefault(),
                    r.Result1.Where(p => p.Answer_Text == "N" && p.Short_Name == s).FirstOrDefault(),
                    r.Result1.Where(p => p.Answer_Text == "NA" && p.Short_Name == s).FirstOrDefault(),
                    r.Result1.Where(p => p.Answer_Text == "A" && p.Short_Name == s).FirstOrDefault(),
                    r.Result1.Where(p => p.Answer_Text == "U" && p.Short_Name == s).FirstOrDefault()
                };
                orderedList = orderedList.Union(tempOList).ToList();
            }


            r.Result1 = orderedList;
        }

        private ChartData transformToChart(GetCombinedOveralls c)
        {
            List<double> data = new List<double>();
            List<String> labels = new List<string>();
            data.Add((double)c.Y);
            labels.Add(answerColorDefs["Y"]);
            data.Add((double)c.N);
            labels.Add(answerColorDefs["N"]);
            data.Add((double)c.NA);
            labels.Add(answerColorDefs["NA"]);
            data.Add((double)c.A);
            labels.Add(answerColorDefs["A"]);
            data.Add((double)c.U);
            labels.Add(answerColorDefs["U"]);

            return new ChartData()
            {
                label = c.StatType,
                Labels = labels,
                data = data
            };
        }

        [HttpGet]
        [Route("api/analysis/OverallRankedCategories")]
        public ChartData GetOverallRankedCategories()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData chartData = null;
            using (CSET_Context context = new CSET_Context())
            {
                var results = new RankedCategoriesMultiResult();
                context.LoadStoredProc("[dbo].[usp_GetOverallRankedCategoriesPage]")
              .WithSqlParam("assessment_id", assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  results.Result1 = handler.ReadToList<usp_getRankedCategories>().ToList();
              });


                if (results.Count >= 1)
                {
                    List<double> data = new List<double>();
                    ChartData overallBars = new ChartData()
                    {
                        backgroundColor = "red",
                        borderWidth = "1",
                        label = "Overall Ranked Categories",
                        data = data
                    };

                    chartData = new ChartData();
                    chartData.DataRows = new List<DataRows>();
                    int i = 1;
                    foreach (usp_getRankedCategories c in results.Result1)
                    {
                        chartData.data.Add((double)(c.prc ?? 0));
                        chartData.Labels.Add(c.Question_Group_Heading);

                        chartData.DataRows.Add(new DataRows()
                        {
                            failed = (c.nuCount ?? 0),
                            percent = (c.prc ?? 0),
                            total = (c.qc ?? 0),
                            title = c.Question_Group_Heading,
                            rank = i++
                        });

                    }
                }
            }

            return chartData;
        }

        [HttpGet]
        [Route("api/analysis/StandardsSummaryOverall")]
        public ChartData GetStandardSummaryOverall()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (CSET_Context context = new CSET_Context())
            {
                return getStandardsSummarySingle(context, assessmentId);
            }
        }

        /// <summary>
        /// This may not be called by the UI.... can't find any code that calls it
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analysis/StandardsSummary")]
        public ChartData GetStandardsSummary()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (CSET_Context context = new CSET_Context())
            {
                if (context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).Count() > 1)
                {
                    return GetStandardsSummaryMultiple(context, assessmentId);
                }
                return getStandardsSummarySingle(context, assessmentId);
            }
        }


        private ChartData getStandardsSummarySingle(CSET_Context context, int assessmentId)
        {
            ChartData summary = null;

            var results = new StandardSummaryOverallMultiResult();
            context.LoadStoredProc("[dbo].[usp_getStandardsSummaryPage]")
          .WithSqlParam("assessment_id", assessmentId)
          .ExecuteStoredProc((handler) =>
          {
              results.Result1 = handler.ReadToList<DataRowsPie>().ToList();

          });

            if (results.Count >= 1)
            {
                SortIntoAnswerOrder(results);
                List<double> data = new List<double>();
                List<String> Colors = new List<string>();
                List<string> Labels = new List<string>();
                List<DataRowsPie> rows = new List<DataRowsPie>();
                summary = new ChartData();
                Labels = new List<string>();
                Dictionary<string, ChartData> charts = new Dictionary<string, ChartData>();
                foreach (DataRowsPie c in results.Result1)
                {
                    ChartData next;
                    if (!charts.TryGetValue(c.Answer_Full_Name, out next))
                    {
                        data = new List<double>();
                        next = new ChartData()
                        {
                            Colors = Colors,
                            DataRowsPie = rows,
                            borderWidth = "1",
                            label = c.Answer_Full_Name,
                            Labels = Labels,
                            data = data
                        };
                        charts.Add(c.Answer_Full_Name, next);
                    }
                    else
                    {
                        data = next.data;
                        rows = next.DataRowsPie;
                    }
                    data.Add((double)(c.Percent ?? 0));
                    summary.data.Add((double)(c.Percent ?? 0));
                    if (!Colors.Contains(answerColorDefs[c.Answer_Text ?? "U"]))
                        Colors.Add(answerColorDefs[c.Answer_Text ?? "U"]);
                    Labels.Add(c.Answer_Full_Name);
                    rows.Add(c);
                }
                summary.borderWidth = "1";
                summary.label = "Standards Summary";
                summary.Labels = Labels;
                summary.Colors = Colors;

                summary.DataRowsPie = rows;
                summary.DataRows = new List<DataRows>();
            }


            return summary;
        }


        private ChartData GetStandardsSummaryMultiple(CSET_Context context, int assessmentId)
        {
            ChartData myChartData = new ChartData();
            myChartData.DataRowsPie = new List<DataRowsPie>();
            myChartData.Colors = new List<string>();


            var results = new StandardSummaryOverallMultiResult();
            context.LoadStoredProc("[dbo].[usp_getStandardsSummaryPage]")
            .WithSqlParam("assessment_id", assessmentId)
            .ExecuteStoredProc((handler) =>
            {
                results.Result1 = handler.ReadToList<DataRowsPie>().ToList();

            });
            SortIntoAnswerOrder(results);

            /** 
             * foreach each standard in the list 
             * create a chartdata 
             * foreach record
             *  if the previous does not equal the current then create a new chartdata
             *  add the record to the chart data
             *  
             */

            string previousStandard = "";


            Dictionary<string, ChartData> answers = new Dictionary<string, ChartData>();
            foreach (var data in results.Result1.OrderBy(x => x.Short_Name).ThenBy(x => x.Answer_Order))
            {
                //this only adds the labels
                if (previousStandard != data.Short_Name)
                {
                    myChartData.Labels.Add(data.Short_Name);
                    previousStandard = data.Short_Name;
                }
                ChartData chartData;

                if (!answers.TryGetValue(data.Answer_Full_Name, out chartData))
                {
                    chartData = new ChartData();
                    chartData.label = data.Answer_Full_Name;
                    chartData.backgroundColor = answerColorDefs[data.Answer_Text];

                    myChartData.Colors.Add(answerColorDefs[data.Answer_Text]);

                    myChartData.dataSets.Add(chartData);
                    answers.Add(data.Answer_Full_Name, chartData);
                }

                myChartData.DataRowsPie.Add(data);
                chartData.data.Add((double)(data.Percent ?? 0));
            }

            myChartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "#000000";
            });

            return myChartData;
        }


        [HttpGet]
        [Route("api/analysis/ComponentsSummary")]
        public ChartData GetComponentsSummary()
        {
            int assessmentId = Auth.AssessmentForUser();

            // initialize the response container
            ChartData chartData = new ChartData();
            chartData.Colors = new List<string>();
            chartData.DataRowsPie = new List<DataRowsPie>();

            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentsSummary]")
                         .WithSqlParam("assessment_Id", assessmentId)
                         .ExecuteStoredProc((handler) =>
                         {
                             var answerTotals = handler.ReadToList<usp_getComponentsSummmary>();

                             // re-order the list 
                             var sortedList = new List<usp_getComponentsSummmary>();
                             sortedList.Add(answerTotals.FirstOrDefault(x => x.Answer_Text == "Y"));
                             sortedList.Add(answerTotals.FirstOrDefault(x => x.Answer_Text == "N"));
                             sortedList.Add(answerTotals.FirstOrDefault(x => x.Answer_Text == "NA"));
                             sortedList.Add(answerTotals.FirstOrDefault(x => x.Answer_Text == "A"));
                             sortedList.Add(answerTotals.FirstOrDefault(x => x.Answer_Text == "U"));
                             answerTotals = sortedList;

                             var totalQuestionCount = answerTotals.Sum(x => x.vcount);

                             foreach (usp_getComponentsSummmary c in answerTotals)
                             {
                                 // build DataRowsPie for each answer total
                                 DataRowsPie pie = new DataRowsPie();
                                 pie.Answer_Full_Name = c.Answer_Full_Name;
                                 pie.Short_Name = "";
                                 pie.Answer_Text = c.Answer_Text;
                                 pie.qc = c.vcount;
                                 pie.Total = totalQuestionCount;
                                 pie.Percent = (int)Math.Round(c.value, 0);
                                 chartData.DataRowsPie.Add(pie);

                                 chartData.data.Add((double)c.value);
                                 chartData.Labels.Add(c.Answer_Full_Name);

                                 if (!chartData.Colors.Contains(answerColorDefs[c.Answer_Text ?? "U"]))
                                     chartData.Colors.Add(answerColorDefs[c.Answer_Text ?? "U"]);
                             }
                         });
            }

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/DocumentComments")]
        public List<CommentData> GetDocumentComments()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (CSET_Context context = new CSET_Context())
            {
                var items = from a in context.ASSESSMENTS_REQUIRED_DOCUMENTATION
                            join d in context.REQUIRED_DOCUMENTATION on a.Documentation_Id equals d.Documentation_Id
                            where a.Assessment_Id == assessmentId
                            orderby d.Document_Order
                            select new CommentData() { Number = d.Number, AssociatedHeader = d.Document_Description, Comment = a.Comment, Answer = a.Answer };

                return items.ToList();
            }
        }


        [HttpGet]
        [Route("api/analysis/StandardsResultsByCategory")]
        public ChartData GetStandardsResultsByCategory()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData chartData = new ChartData();

            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getStandardsResultsByCategory]")
                        .WithSqlParam("assessment_Id", assessmentId)
                        .ExecuteStoredProc((handler) =>
                        {
                            var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                            var labels = (from usp_getStandardsResultsByCategory an in result
                                          orderby an.Question_Group_Heading
                                          select an.Question_Group_Heading).Distinct().ToList();

                            chartData.DataRows = new List<DataRows>();
                            foreach (string c in labels)
                            {
                                //    chartData.data.Add((double) c.prc);
                                chartData.Labels.Add(c);
                                //    chartData.DataRows.Add(new DataRows()
                                //    {
                                //        failed =c.yaCount,
                                //        percent = c.prc,
                                //        total = c.Actualcr,
                                //        title = c.Question_Group_Heading                            
                                //   });

                            }

                            ColorsList colors = new ColorsList();

                            var sets = (from usp_getStandardsResultsByCategory an in result
                                        select new { an.Set_Name, an.Short_Name }).Distinct();
                            foreach (var set in sets)
                            {

                                ChartData nextChartData = new ChartData();
                                chartData.dataSets.Add(nextChartData);
                                nextChartData.DataRows = new List<DataRows>();
                                var nextSet = (from usp_getStandardsResultsByCategory an in result
                                               where an.Set_Name == set.Set_Name
                                               orderby an.Question_Group_Heading
                                               select an).ToList();
                                nextChartData.label = set.Short_Name;
                                nextChartData.backgroundColor = colors.getNext(set.Set_Name);
                                foreach (usp_getStandardsResultsByCategory c in nextSet)
                                {
                                    nextChartData.data.Add((double)c.prc);
                                    nextChartData.Labels.Add(c.Question_Group_Heading);
                                    nextChartData.DataRows.Add(new DataRows()
                                    {
                                        failed = c.yaCount,
                                        percent = c.prc,
                                        total = c.Actualcr,
                                        title = c.Question_Group_Heading
                                    });
                                }
                            }

                        });
            }

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/StandardsRankedCategories")]
        public ChartData GetStandardsRankedCategories()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData chartData = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getStandardsRankedCategories]")
                      .WithSqlParam("assessment_Id", assessmentId)
                      .ExecuteStoredProc((handler) =>
                      {
                          var result = handler.ReadToList<usp_getStandardsRankedCategories>();
                          List<double> data = new List<double>();
                          List<DataRows> rows = new List<DataRows>();

                          chartData = new ChartData();
                          chartData.DataRows = new List<DataRows>();
                          foreach (usp_getStandardsRankedCategories c in result)
                          {
                              chartData.data.Add((double)(c.prc ?? 0));
                              chartData.Labels.Add(c.Question_Group_Heading);
                              chartData.DataRows.Add(new DataRows()
                              {
                                  failed = c.nuCount ?? 0,
                                  title = c.Question_Group_Heading,
                                  percent = c.Percent ?? 0,
                                  total = c.qc ?? 0,
                                  rank = c.prc ?? 0

                              });
                          }
                      });

            }

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/ComponentsResultsByCategory")]
        public ChartData GetComponentsResultsByCategory()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData chartData = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentsResultsByCategory]")
                      .WithSqlParam("assessment_Id", assessmentId)
                      .ExecuteStoredProc((handler) =>
                      {
                          var result = handler.ReadToList<usp_getComponentsResultsByCategory>();

                          chartData = new ChartData();

                          foreach (usp_getComponentsResultsByCategory c in result)
                          {
                              chartData.Labels.Add(c.Question_Group_Heading);
                              chartData.data.Add((double)c.percent);
                              chartData.DataRows.Add(new DataRows
                              {
                                  title = c.Question_Group_Heading,
                                  passed = c.passed,
                                  total = c.total,
                                  percent = c.percent
                              });
                          }
                      });
            }

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/ComponentsRankedCategories")]
        public ChartData GetComponentsRankedCategories()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData chartData = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentsRankedCategories]")
                    .WithSqlParam("assessment_Id", assessmentId)
                    .ExecuteStoredProc((handler) =>
                    {
                        var result = handler.ReadToList<usp_getComponentsRankedCategories>();
                        chartData = new ChartData();
                        foreach (usp_getComponentsRankedCategories c in result)
                        {
                            chartData.data.Add((double)c.prc);
                            chartData.Labels.Add(c.Question_Group_Heading);


                            // create a new DataRows entry with answer percentages for this component
                            chartData.DataRows.Add(new DataRows
                            {
                                title = c.Question_Group_Heading,
                                rank = c.prc,
                                failed = c.nuCount,  /// ??????
                                total = c.qc,
                                percent = c.Percent
                            });
                        }
                    });
            }

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/ComponentTypes")]
        public ChartData ComponentTypes()
        {
            int assessmentId = Auth.AssessmentForUser();

            // initialize the response container
            ChartData chartData = new ChartData
            {
                Colors = new List<string>(),
                DataRowsPie = new List<DataRowsPie>()
            };

            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentTypes]")
                         .WithSqlParam("assessment_Id", assessmentId)
                         .ExecuteStoredProc((handler) =>
                         {
                             var componentTotals = handler.ReadToList<usp_getComponentTypes>();

                             var cdY = new ChartData
                             {
                                 label = "Yes",
                                 backgroundColor = answerColorDefs["Y"]
                             };
                             chartData.dataSets.Add(cdY);

                             var cdN = new ChartData
                             {
                                 label = "No",
                                 backgroundColor = answerColorDefs["N"]
                             };
                             chartData.dataSets.Add(cdN);

                             var cdNA = new ChartData
                             {
                                 label = "N/A",
                                 backgroundColor = answerColorDefs["NA"]
                             };
                             chartData.dataSets.Add(cdNA);

                             var cdAlt = new ChartData
                             {
                                 label = "Alt",
                                 backgroundColor = answerColorDefs["A"]
                             };
                             chartData.dataSets.Add(cdAlt);

                             var cdU = new ChartData
                             {
                                 label = "Unanswered",
                                 backgroundColor = answerColorDefs["U"]
                             };
                             chartData.dataSets.Add(cdU);


                             foreach (var total in componentTotals)
                             {
                                 chartData.Labels.Add(total.component_type);

                                 cdY.data.Add((int)total.Y);
                                 cdN.data.Add((int)total.N);
                                 cdNA.data.Add((int)total.NA);
                                 cdAlt.data.Add((int)total.A);
                                 cdU.data.Add((int)total.U);


                                 // create a new DataRows entry with answer percentages for this component
                                 chartData.DataRows.Add(new DataRows
                                 {
                                     title = total.component_type,
                                     yes = total.Y,
                                     no = total.N,
                                     na = total.NA,
                                     alt = total.A,
                                     unanswered = total.U,
                                     total = total.Total
                                 });
                             }
                         });
            }

            chartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "#000000";
            });

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/NetworkWarnings")]
        public List<usp_getNetworkWarnings> GetNetworkWarnings()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (CSET_Context context = new CSET_Context())
            {
                List<usp_getNetworkWarnings> wlist = new List<usp_getNetworkWarnings>();
                context.LoadStoredProc("[dbo].[usp_getNetworkWarnings]")
                .WithSqlParam("assessment_Id", assessmentId)
                .ExecuteStoredProc((handler) =>
                {
                    // TODO:  RKW - Uncomment this once the stored proc is written
                    //var result = handler.ReadToList<usp_getNetworkWarnings>();

                    //foreach (usp_getNetworkWarnings w in result)
                    //{
                    //    wlist.Add(w);
                    //}
                });
                return wlist;
            }
        }


        private string GetAssessmentMode(int assessmentId)
        {
            using (CSET_Context db = new CSET_Context())
            {
                string applicationMode = db.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId)
                .Select(x => x.Application_Mode).FirstOrDefault();

                if (applicationMode.ToLower().StartsWith("questions"))
                {
                    return "Q";
                }
                else if (applicationMode.ToLower().StartsWith("requirements"))
                {
                    return "R";
                }

                // Default to 'questions mode' if not already set
                return "Q";
            }
        }
    }
}


