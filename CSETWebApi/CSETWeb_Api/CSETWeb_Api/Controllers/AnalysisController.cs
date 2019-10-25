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
        [Route("api/analysis/Feedback")]
        public FeedbackDisplayContainer getFeedback()
        {
            int assessmentId = Auth.AssessmentForUser();
            RequirementsManager rm = new RequirementsManager(assessmentId);
            FeedbackDisplayContainer FeedbackResult = new FeedbackDisplayContainer();

            string AssessmentMode = GetAssessmentMode(assessmentId);

            try
            {
                using (CSET_Context context = new CSET_Context())
                {
                    var QuestionsWithFeedbackList = from a in context.Answer_Standards_InScope
                                                    where a.assessment_id == assessmentId &&
                                                    a.mode == AssessmentMode && a.FeedBack != null
                                                    select a;

                    if (QuestionsWithFeedbackList.Count() == 0)
                    {
                        FeedbackResult.FeedbackBody = "No feedback given for this assessment";
                        return FeedbackResult;
                    }

                    string FeedbackSalutations = "Dear PED Module Administrator:";
                    string FeedbackDescription = "The following comments were provided for each of the questions: ";
                    string FeedbackWarning = " *** Required *** Keep This Question ID ***";

                    bool FaaMail = context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected == true
                    && (x.Set_Name == "FAA_MAINT" || x.Set_Name == "FAA")).FirstOrDefault() != null;
                    FeedbackResult.FeedbackHeader = "Submit Feedback to DHS";
                    if (FaaMail) FeedbackResult.FeedbackHeader += " and FAA";

                    string FaaEmail = "FAAPEDModule@faa.gov";
                    string DHSEmail = "cset@dhs.gov";
                    if (FaaMail) FeedbackResult.FeedbackEmailTo = FaaEmail + ";  ";
                    FeedbackResult.FeedbackEmailTo += DHSEmail;

                    FeedbackResult.FeedbackBody = "Please email to: <br/><br/>";
                    FeedbackResult.FeedbackBody += FeedbackResult.FeedbackEmailTo + "<br/><br/><br/>";

                    FeedbackResult.FeedbackBody += FeedbackSalutations + "<br/><br/>";
                    FeedbackResult.FeedbackBody += FeedbackDescription + "<br/><br/>";

                    foreach (Answer_Standards_InScope q in QuestionsWithFeedbackList)
                    {
                        q.Question_Text = rm.ResolveParameters(q.question_or_requirement_id, q.answer_id, q.Question_Text);
                        q.FeedBack = rm.ResolveParameters(q.question_or_requirement_id, q.answer_id, q.FeedBack);
                        FeedbackResult.FeedbackBody += "Users Feedback: <br/>" + q.FeedBack + "<br/><br/>";
                        FeedbackResult.FeedbackBody += q.Question_Text + "<br/><br/>";
                        FeedbackResult.FeedbackBody += FeedbackWarning + "<br/>";
                        FeedbackResult.FeedbackBody += "Question #" + " " + q.mode + ":" + q.question_or_requirement_id + ". <br/><br/><br/>";
                    }

                    FeedbackResult.FeedbackEmailSubject = "CSET Questions Feedback";
                    FeedbackResult.FeedbackEmailBody += FeedbackSalutations + "%0D%0A%0D%0A";
                    FeedbackResult.FeedbackEmailBody += FeedbackDescription + "%0D%0A%0D%0A";

                    foreach (Answer_Standards_InScope q in QuestionsWithFeedbackList)
                    {
                        q.Question_Text = rm.RichTextParameters(q.question_or_requirement_id, q.answer_id, q.Question_Text);
                        q.FeedBack = rm.RichTextParameters(q.question_or_requirement_id, q.answer_id, q.FeedBack);
                        FeedbackResult.FeedbackEmailBody += "Users Feedback: %0D%0A" + q.FeedBack + "%0D%0A";
                        FeedbackResult.FeedbackEmailBody += q.Question_Text + "%0D%0A%0D%0A";
                        FeedbackResult.FeedbackEmailBody += FeedbackWarning + "%0D%0A";
                        FeedbackResult.FeedbackEmailBody += "Question #" + " " + q.mode + ":" + q.question_or_requirement_id + ". %0D%0A%0D%0A%0D%0A";
                    }

                    return FeedbackResult;
                }
            }
            catch (Exception e)
            {
                throw e;
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
                    // for the compliance graph
                    List<Tuple<string, double>> compliance = new List<Tuple<string, double>>();

                    ChartData stand = null;
                    ChartData comp = null;


                    foreach (GetCombinedOveralls c in results.Result1)
                    {
                        string mode = this.GetAssessmentMode(assessmentId);

                        string label = c.StatType;

                        if (c.StatType == "Components")
                        {
                            comp = TransformToChart(c);
                        }

                        if ((c.StatType == "Questions" && mode == "Q")
                            || (c.StatType == "Requirement" && mode == "R"))
                        {
                            stand = TransformToChart(c);
                            label = stand.label;
                        }


                        if ((c.StatType.ToLower() == "overall")
                            || (c.StatType.ToLower() == "components"))
                        {
                            compliance.Add(new Tuple<string, double>(c.StatType, c.Value));
                        }
                        else if ((c.StatType.ToLower() == "questions" && mode == "Q")
                            || (c.StatType.ToLower() == "requirement" && mode == "R"))
                        {
                            // Questions or Requirements are included only if we are in that 'mode', renamed as 'Standards'
                            compliance.Add(new Tuple<string, double>("Standards", c.Value));
                        }
                    }

                    ChartData overallBars = new ChartData()
                    {
                        backgroundColor = "red",
                        borderWidth = "1",
                        label = "overalls"
                    };

                    // order the compliance elements for display
                    var complianceOrdered = new List<Tuple<string, double>>();
                    complianceOrdered.Add(compliance.First(x => x.Item1 == "Overall"));
                    complianceOrdered.Add(compliance.First(x => x.Item1 == "Standards"));
                    complianceOrdered.Add(compliance.First(x => x.Item1 == "Components"));
                    foreach (var j in complianceOrdered)
                    {
                        overallBars.Labels.Add(j.Item1);
                        overallBars.data.Add(j.Item2);
                    }


                    ChartData chartData = new ChartData();

                    foreach (usp_getRankedCategories c in results.Result2.Take(5))
                    {
                        chartData.data.Add((double)(c.prc ?? 0.0M));
                        chartData.Labels.Add(c.Question_Group_Heading);
                    }


                    rval = new FirstPage()
                    {
                        OverallBars = overallBars,
                        StandardsSummaryPie = stand,
                        ComponentSummaryPie = comp,
                        RedBars = chartData
                    };

                }
            }

            return rval;
        }


        [HttpGet]
        [Route("api/analysis/TopCategories")]
        public ChartData GetTopCategories([FromUri] int? total)
        {
            if (total == null)
            {
                total = 10000;
            }

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
                    foreach (usp_getRankedCategories c in results.Result1.Take((int)total))
                    {
                        chartData.data.Add((double)c.prc);
                        chartData.Labels.Add(c.Question_Group_Heading);
                    }
                }
            }

            return chartData;
        }


        /// <summary>
        /// Re-orders the pieces into Y|N|NA|A|U order.
        /// Also adjusts percentages to equal 100.
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

                // adjust the percentages to equal 100% after rounding
                var cAdjusted = new BusinessLogic.Common.PercentageFixer(tempOList[0].Percent,
                    tempOList[1].Percent, tempOList[2].Percent, tempOList[3].Percent, tempOList[4].Percent);

                tempOList[0].Percent = cAdjusted.Y;
                tempOList[1].Percent = cAdjusted.N;
                tempOList[2].Percent = cAdjusted.NA;
                tempOList[3].Percent = cAdjusted.A;
                tempOList[4].Percent = cAdjusted.U;

                orderedList = orderedList.Union(tempOList).ToList();
            }


            r.Result1 = orderedList;
        }


        /// <summary>
        /// Returns a ChartData object with the answer distribution for the StatType.
        /// The answer distribution is ordered and normalized to total 100%,
        /// fixing any rounding anomaly.
        /// </summary>
        /// <param name="c"></param>
        /// <returns></returns>
        private ChartData TransformToChart(GetCombinedOveralls c)
        {
            // adjust the percentages to equal 100% after rounding
            var cAdjusted = new BusinessLogic.Common.PercentageFixer(c.Y, c.N, c.NA, c.A, c.U);


            List<double> data = new List<double>();
            List<String> labels = new List<string>();
            data.Add((int)cAdjusted.Y);
            labels.Add(answerColorDefs["Y"]);
            data.Add((int)cAdjusted.N);
            labels.Add(answerColorDefs["N"]);
            data.Add((int)cAdjusted.NA);
            labels.Add(answerColorDefs["NA"]);
            data.Add((int)cAdjusted.A);
            labels.Add(answerColorDefs["A"]);
            data.Add((int)cAdjusted.U);
            labels.Add(answerColorDefs["U"]);

            return new ChartData()
            {
                label = new List<string>() { "Questions", "Requirements" }.Contains(c.StatType) ? "Standards" : c.StatType,
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
                return GetStandardsSummarySingle(context, assessmentId);
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
                return GetStandardsSummarySingle(context, assessmentId);
            }
        }


        private ChartData GetStandardsSummarySingle(CSET_Context context, int assessmentId)
        {
            ChartData myChartData = null;

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
                myChartData = new ChartData();
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
                            borderWidth = "0",
                            borderColor = "transparent",
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
                    myChartData.data.Add((double)(c.Percent ?? 0));
                    if (!Colors.Contains(answerColorDefs[c.Answer_Text ?? "U"]))
                        Colors.Add(answerColorDefs[c.Answer_Text ?? "U"]);
                    Labels.Add(c.Answer_Full_Name);
                    rows.Add(c);
                }
                myChartData.borderWidth = "0";
                myChartData.borderColor = "transparent";
                myChartData.label = "Standards Summary";
                myChartData.Labels = Labels;
                myChartData.Colors = Colors;

                myChartData.DataRowsPie = rows;
                myChartData.DataRows = new List<DataRows>();
            }

            myChartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "transparent";
            });

            return myChartData;
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
                    chartData = new ChartData
                    {
                        label = data.Answer_Full_Name,
                        backgroundColor = answerColorDefs[data.Answer_Text]
                    };

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
                ds.borderColor = "transparent";
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
                             AddItem("Y",  sortedList, answerTotals);
                             AddItem("N",  sortedList, answerTotals);
                             AddItem("NA", sortedList, answerTotals);
                             AddItem("A",  sortedList, answerTotals);
                             AddItem("U",  sortedList, answerTotals);
                             answerTotals = sortedList;

                             
                             var totalQuestionCount = answerTotals==null?0:answerTotals.Sum(x => x.vcount);

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


                // include component count so front end can know whether components are present
                chartData.ComponentCount = context.Answer_Components_Exploded.Where(a => a.Assessment_Id == assessmentId).Distinct().Count();
            }

            chartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "transparent";
            });

            return chartData;
        }


        private void AddItem(String answerName, List<usp_getComponentsSummmary> sortedList, IList<usp_getComponentsSummmary> unorderedList)
        {
            var element = unorderedList.FirstOrDefault(x => x.Answer_Text == answerName);
            if (element != null) {
                sortedList.Add(element);
            }
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

                                 // adjust the percentages to equal 100% after rounding
                                 var adjTotal = new BusinessLogic.Common.PercentageFixer(total.Y, total.N, total.NA, total.A, total.U);

                                 cdY.data.Add((int)adjTotal.Y);
                                 cdN.data.Add((int)adjTotal.N);
                                 cdNA.data.Add((int)adjTotal.NA);
                                 cdAlt.data.Add((int)adjTotal.A);
                                 cdU.data.Add((int)adjTotal.U);


                                 // create a new DataRows entry with answer percentages for this component
                                 var row = new DataRows
                                 {
                                     title = total.component_type,
                                     yes = adjTotal.Y,
                                     no = adjTotal.N,
                                     na = adjTotal.NA,
                                     alt = adjTotal.A,
                                     unanswered = adjTotal.U,
                                     total = total.Total
                                 };
                                 chartData.DataRows.Add(row);
                             }
                         });
            }

            chartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "transparent";
            });

            return chartData;
        }


        [HttpGet]
        [Route("api/analysis/NetworkWarnings")]
        public List<NETWORK_WARNINGS> GetNetworkWarnings()
        {
            int assessmentId = Auth.AssessmentForUser();
            using (CSET_Context db = new CSET_Context())
            {
                return (List<NETWORK_WARNINGS>)db.NETWORK_WARNINGS
                    .Where(x => x.Assessment_Id == assessmentId)
                    .OrderBy(x => x.Id).ToList();
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


