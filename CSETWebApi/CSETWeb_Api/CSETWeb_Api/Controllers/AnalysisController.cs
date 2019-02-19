//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
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
                      results.Result1 =  handler.ReadToList<GetCombinedOveralls>().ToList();
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
                        else { 
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

                    ChartData red = new ChartData();

                    int rcount = 0;
                    foreach (usp_getRankedCategories c in results.Result2)
                    {
                        if (rcount < 5)
                        {
                            red.data.Add((double)(c.prc ?? 0.0M));
                            red.Labels.Add(c.Question_Group_Heading);
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
                        RedBars = red
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
            ChartData red = null;
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

                    red = new ChartData();
                    foreach (usp_getRankedCategories c in results.Result1)
                    {
                        red.data.Add((double)c.prc);
                        red.Labels.Add(c.Question_Group_Heading);

                    }
                }
            }

            return red;
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
            ChartData red = null;
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

                    red = new ChartData();
                    red.DataRows = new List<DataRows>();
                    int i = 1;
                    foreach (usp_getRankedCategories c in results.Result1)
                    {
                        red.data.Add((double)(c.prc ?? 0));
                        red.Labels.Add(c.Question_Group_Heading);

                        red.DataRows.Add(new DataRows()
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

            return red;
        }

        [HttpGet]
        [Route("api/analysis/StandardsSummaryOverall")]
        public ChartData GetStandardSummaryOverall()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (CSET_Context context = new CSET_Context())
            {
                return GetStandardsSummaryMultiple(context, assessmentId);
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
                if (context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId).Count() > 1)
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
            context.LoadStoredProc("[dbo].[usp_getStandardSummaryOverall]")
          .WithSqlParam("assessment_id", assessmentId)
          .ExecuteStoredProc((handler) =>
          {
              results.Result1 = handler.ReadToList<DataRowsPie>().ToList();

          });
         
            if (results.Count >= 1)
            {
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
                        rows = new List<DataRowsPie>();
                        next = new ChartData()
                        {
                            Colors = Colors,
                            DataRowsPie = rows,
                            borderWidth = "1",
                            label = c.Answer_Full_Name,
                            Labels = Labels,
                            data = data
                        };
                        summary.multipleDataSets.Add(next);
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

          
            if (results.Count >= 1)
            {
                List<DataRowsPie> answerRow = (List<DataRowsPie>)results.Result1;

                // Build the results in a defined answer order
                AddAnswerToStandardsSummary(answerRow, "Y", myChartData);
                AddAnswerToStandardsSummary(answerRow, "N", myChartData);
                AddAnswerToStandardsSummary(answerRow, "NA", myChartData);
                AddAnswerToStandardsSummary(answerRow, "A", myChartData);
                AddAnswerToStandardsSummary(answerRow, "U", myChartData);
            }

            return myChartData;
        }


        private void AddAnswerToStandardsSummary(List<DataRowsPie> answers,
            string answerShortName,
            ChartData myChartData)
        {
            DataRowsPie ans = answers.Find(x => x.Answer_Text == answerShortName);
            myChartData.data.Add((double)(ans.Percent ?? 0));
            myChartData.Labels.Add(ans.Answer_Full_Name);
            myChartData.Colors.Add(answerColorDefs[ans.Answer_Text]);

            myChartData.DataRowsPie.Add(new DataRowsPie()
            {
                Answer_Full_Name = ans.Answer_Full_Name,
                Short_Name = ans.Short_Name,
                Answer_Text = ans.Answer_Text,
                qc = ans.qc,
                Total = ans.Total,
                Percent = ans.Percent
            });
        }


        [HttpGet]
        [Route("api/analysis/ComponentsSummary")]
        public ChartData GetComponentsSummary()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData red = null;
            using (CSET_Context context = new CSET_Context())
            {   
                context.LoadStoredProc("[dbo].[usp_getComponentsSummary]")
                         .WithSqlParam("assessment_Id", assessmentId)
                         .ExecuteStoredProc((handler) =>
                         {
                             var fooResults = handler.ReadToList<usp_getComponentsSummmary>();
                             red = new ChartData();
                             foreach (usp_getComponentsSummmary c in fooResults)
                             {
                                 red.data.Add((double)c.value);
                                 red.Labels.Add(c.Answer_Full_Name);
                             }
                         });
            }

            return red;
        }
        [HttpGet]
        [Route("api/analysis/StandardsResultsByCategory")]
        public ChartData GetStandardsResultsByCategory()
        {

            int assessmentId = Auth.AssessmentForUser();
            ChartData red = new ChartData();
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

                            red.DataRows = new List<DataRows>();
                            foreach (string c in labels)
                            {
                                //    red.data.Add((double) c.prc);
                                red.Labels.Add(c);
                                //    red.DataRows.Add(new DataRows()
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
                                red.multipleDataSets.Add(nextChartData);
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

            return red;
        }

        [HttpGet]
        [Route("api/analysis/StandardsRankedCategories")]
        public ChartData GetStandardsRankedCategories()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData red = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getStandardsRankedCategories]")
                      .WithSqlParam("assessment_Id", assessmentId)
                      .ExecuteStoredProc((handler) =>
                      {
                          var result = handler.ReadToList<usp_getStandardsRankedCategories>();
                          List<double> data = new List<double>();
                          List<DataRows> rows = new List<DataRows>();

                          red = new ChartData();
                          red.DataRows = new List<DataRows>();
                          foreach (usp_getStandardsRankedCategories c in result)
                          {
                              red.data.Add((double)(c.prc ?? 0));
                              red.Labels.Add(c.Question_Group_Heading);
                              red.DataRows.Add(new DataRows()
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

            return red;
        }
        [HttpGet]
        [Route("api/analysis/ComponentsResultsByCategory")]
        public ChartData GetComponentsResultsByCategory()
        {

            int assessmentId = Auth.AssessmentForUser();
            ChartData red = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentsResultsByCategory]")
                      .WithSqlParam("assessment_Id", assessmentId)
                      .ExecuteStoredProc((handler) =>
                      {
                          var result = handler.ReadToList<usp_getComponentsResultsByCategory>();
                          red = new ChartData();
                          foreach (usp_getComponentsResultsByCategory c in result)
                          {
                              red.data.Add((double)c.prc);
                              red.Labels.Add(c.Question_Group_Heading);

                          }
                      });
            }

            return red;
        }
        [HttpGet]
        [Route("api/analysis/ComponentsRankedCategories")]
        public ChartData GetComponentsRankedCategories()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData red = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentsRankedCategories]")
                    .WithSqlParam("assessment_Id", assessmentId)
                    .ExecuteStoredProc((handler) =>
                    {
                        var result = handler.ReadToList<usp_getComponentsRankedCategories>();
                        red = new ChartData();
                        foreach (usp_getComponentsRankedCategories c in result)
                        {
                            red.data.Add((double)c.prc);
                            red.Labels.Add(c.Question_Group_Heading);

                        }
                    });
            }

            return red;
        }
        [HttpGet]
        [Route("api/analysis/ComponentTypes")]
        public ChartData GetComponentTypes()
        {
            int assessmentId = Auth.AssessmentForUser();
            ChartData red = null;
            using (CSET_Context context = new CSET_Context())
            {
                context.LoadStoredProc("[dbo].[usp_getComponentTypes]")
                   .WithSqlParam("assessment_Id", assessmentId)
                   .ExecuteStoredProc((handler) =>
                   {
                       var result = handler.ReadToList<usp_getComponentTypes>();
                       red = new ChartData();
                       foreach (usp_getComponentTypes c in result)
                       {
                           red.data.Add((double)c.Value);
                           red.Labels.Add(c.component_type);

                       }
                   });            
            }

            return red;
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
                    var result = handler.ReadToList<usp_getNetworkWarnings>();
                    
                    foreach (usp_getNetworkWarnings w in result)
                    {
                        wlist.Add(w);
                    }
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


