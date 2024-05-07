//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Analysis;
using CSETWebCore.Model.Question;
using Snickler.EFCore;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using DocumentFormat.OpenXml.Spreadsheet;



namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class AnalysisController : ControllerBase
    {
        private CSETContext _context;
        private readonly ITokenManager _tokenManager;
        private readonly IRequirementBusiness _requirement;
        private readonly int _assessmentId;
        private readonly IConfiguration _configuration;

        static Dictionary<String, String> answerColorDefs;
        private TranslationOverlay _overlay;



        /// <summary>
        /// Static controller
        /// </summary>
        static AnalysisController()
        {
            answerColorDefs = AnswerDistribution.AnswerColorDefs;
        }


        public AnalysisController(CSETContext context, ITokenManager tokenManager, IRequirementBusiness requirement, IConfiguration configuration)
        {
            _context = context;
            _tokenManager = tokenManager;
            _requirement = requirement;
            _configuration = configuration;

            _assessmentId = _tokenManager.AssessmentForUser();
            _context.FillEmptyQuestionsForAnalysis(_assessmentId);

            _overlay = new TranslationOverlay();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analysis/answercolors")]
        public IActionResult GetAnswerColors()
        {
            return Ok(answerColorDefs);
        }


        [HttpGet]
        [Route("api/analysis/RankedQuestions")]
        public IActionResult GetRankedQuestions()
        {
            var lang = _tokenManager.GetCurrentLanguage();

            int assessmentId = _tokenManager.AssessmentForUser();
            _requirement.SetRequirementAssessmentId(assessmentId);

            string mode = GetAssessmentMode(assessmentId);

            var rankedQuestionList = _context.usp_GetRankedQuestions(assessmentId).ToList();

            foreach (usp_GetRankedQuestions_Result q in rankedQuestionList)
            {
                // Currently we only translate text for REQUIREMENTS
                if (mode == "R")
                {
                    var reqOverlay = _overlay.GetRequirement(q.QuestionOrRequirementID, lang);
                    if (reqOverlay != null)
                    {
                        q.QuestionText = reqOverlay.RequirementText;

                        var translatedCategory = _overlay.GetPropertyValue("STANDARD_CATEGORY", q.Category.ToLower(), lang);
                        if (translatedCategory != null)
                        {
                            q.Category = translatedCategory;
                        }
                    }
                }


                q.QuestionText = _requirement.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);
            }

            return Ok(rankedQuestionList);
        }


        [HttpGet]
        [Route("api/analysis/Feedback")]
        public IActionResult GetFeedback()
        {
            try
            {
                int assessmentId = _tokenManager.AssessmentForUser();
                _requirement.SetRequirementAssessmentId(assessmentId);

                var lang = _tokenManager.GetCurrentLanguage();

                FeedbackDisplayContainer FeedbackResult = new FeedbackDisplayContainer();

                string AssessmentMode = GetAssessmentMode(assessmentId);

                List<FeedbackQuestion> feedbackQuestions = new List<FeedbackQuestion>();

                // standard questions
                var q1 = from a in _context.Answer_Standards_InScope
                         where a.assessment_id == assessmentId &&
                         a.mode == AssessmentMode && !string.IsNullOrWhiteSpace(a.FeedBack)
                         select new FeedbackQuestion()
                         {
                             AnswerID = a.answer_id,
                             Feedback = a.FeedBack,
                             Mode = a.mode,
                             QuestionID = a.question_or_requirement_id,
                             QuestionText = a.Question_Text
                         };

                feedbackQuestions.AddRange(q1);

                // maturity questions
                var q2 = from a in _context.Answer_Maturity
                         where a.Assessment_Id == assessmentId
                         && !string.IsNullOrWhiteSpace(a.FeedBack)
                         select new FeedbackQuestion()
                         {
                             AnswerID = a.Answer_Id,
                             Feedback = a.FeedBack,
                             Mode = null,
                             QuestionID = a.Question_Or_Requirement_Id,
                             QuestionText = a.Question_Text
                         };

                feedbackQuestions.AddRange(q2);

                // component questions
                var q3 = from a in _context.Answer_Components
                         where a.Assessment_Id == assessmentId
                         && !string.IsNullOrWhiteSpace(a.FeedBack)
                         select new FeedbackQuestion()
                         {
                             AnswerID = a.Answer_Id,
                             Feedback = a.FeedBack,
                             Mode = null,
                             QuestionID = a.Question_Or_Requirement_Id,
                             QuestionText = a.QuestionText
                         };

                feedbackQuestions.AddRange(q3);

                bool FaaMail = _context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected == true
                && (x.Set_Name == "FAA_MAINT" || x.Set_Name == "FAA" || x.Set_Name == "FAA_PED_V2")).FirstOrDefault() != null;

                bool CieMail = _context.AVAILABLE_MATURITY_MODELS.Where(x => x.Assessment_Id == assessmentId && x.Selected && x.model_id == 17).FirstOrDefault() != null;

                string FeedbackSalutations = "Dear " + (FaaMail ? "FAA" : (CieMail ? "CIE" : "CSET")) + " Standards Administrator:";
                string FeedbackDescription = "The following comments were provided for each of the questions: ";
                string FeedbackWarning = " *** Required *** Keep This Question ID ***";


                FeedbackResult.FeedbackHeader = "Submit Feedback to DHS";
                if (FaaMail) FeedbackResult.FeedbackHeader += " and FAA";
                var FaaEmail = _configuration.GetValue<string>("Email:FaaEmail");

                if (CieMail) FeedbackResult.FeedbackHeader += " and CIE";
                var CieEmail = _configuration.GetValue<string>("Email:CieEmail");

                var DHSEmail = _configuration.GetValue<string>("Email:DHSEmail");

                if (FaaMail) FeedbackResult.FeedbackEmailTo = FaaEmail + ";  ";

                if (CieMail) FeedbackResult.FeedbackEmailTo += CieEmail;
                else FeedbackResult.FeedbackEmailTo += DHSEmail;

                FeedbackResult.FeedbackBody = "Please email to: <br/><br/>";
                FeedbackResult.FeedbackBody += FeedbackResult.FeedbackEmailTo + "<br/><br/><br/>";

                FeedbackResult.FeedbackBody += FeedbackSalutations + "<br/><br/>";
                FeedbackResult.FeedbackBody += FeedbackDescription + "<br/><br/>";

                foreach (FeedbackQuestion q in feedbackQuestions)
                {
                    q.QuestionText = _requirement.ResolveParameters(q.QuestionID, q.AnswerID, q.QuestionText);
                    q.Feedback = _requirement.ResolveParameters(q.QuestionID, q.AnswerID, q.Feedback);
                    FeedbackResult.FeedbackBody += "Users Feedback: <br/>" + q.Feedback + "<br/><br/>";
                    FeedbackResult.FeedbackBody += q.QuestionText + "<br/><br/>";
                    FeedbackResult.FeedbackBody += FeedbackWarning + "<br/>";
                    FeedbackResult.FeedbackBody += "Question #" + " " + q.Mode + ":" + q.QuestionID + ". <br/><br/><br/>";
                }

                if (CieMail) FeedbackResult.FeedbackEmailSubject = "CIE-CSET";
                else FeedbackResult.FeedbackEmailSubject = "CSET Questions Feedback";
                FeedbackResult.FeedbackEmailBody += FeedbackSalutations + "%0D%0A%0D%0A";
                FeedbackResult.FeedbackEmailBody += FeedbackDescription + "%0D%0A%0D%0A";

                foreach (FeedbackQuestion q in feedbackQuestions)
                {
                    q.QuestionText = _requirement.RichTextParameters(q.QuestionID, q.AnswerID, q.QuestionText);
                    q.Feedback = _requirement.RichTextParameters(q.QuestionID, q.AnswerID, q.Feedback);
                    FeedbackResult.FeedbackEmailBody += "Users Feedback: %0D%0A" + q.Feedback + "%0D%0A";
                    FeedbackResult.FeedbackEmailBody += q.QuestionText + "%0D%0A%0D%0A";
                    FeedbackResult.FeedbackEmailBody += FeedbackWarning + "%0D%0A";
                    FeedbackResult.FeedbackEmailBody += "Question #" + " " + q.Mode + ":" + q.QuestionID + ". %0D%0A%0D%0A%0D%0A";
                }

                if (feedbackQuestions.Count() == 0)
                {
                    FeedbackResult.FeedbackBody = _overlay.GetPropertyValue("GENERIC", "no feedback", lang) ?? "No feedback given for any questions in this assessment";
                }

                return Ok(FeedbackResult);

            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                throw;
            }

        }


        [HttpGet]
        [Route("api/analysis/dashboard")]
        public IActionResult GetDashboard()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
            var lang = _tokenManager.GetCurrentLanguage();

            FirstPage rval = null;

            var results = new FirstPageMultiResult();
            _context.Database.AutoTransactionBehavior = AutoTransactionBehavior.Always;

            _context.LoadStoredProc("[usp_GetFirstPage]")
              .WithSqlParam("assessment_id", assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  results.Result1 = handler.ReadToList<GetCombinedOveralls>().ToList();
              });


            // Kludge - trying to avoid deadlocks between the two procs
            // Need to fix this properly
            System.Threading.Thread.Sleep(1000);

            _context.LoadStoredProc("[usp_GetOverallRankedCategoriesPage]")
               .WithSqlParam("assessment_id", assessmentId)
               .ExecuteStoredProc((handler) =>
               {
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
                    // ignore stat types if not part of the assessment
                    if ((c.StatType == "Questions" || c.StatType == "Requirement")
                        && !assessment.UseStandard)
                    {
                        continue;
                    }
                    if ((c.StatType == "Components")
                        && !assessment.UseDiagram)
                    {
                        continue;
                    }



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

                var g = compliance.FirstOrDefault(x => x.Item1 == "Overall");
                if (g != null)
                {
                    complianceOrdered.Add(g);
                }

                g = compliance.FirstOrDefault(x => x.Item1 == "Standards");
                if (g != null)
                {
                    complianceOrdered.Add(g);
                }

                g = compliance.FirstOrDefault(x => x.Item1 == "Components");
                if (g != null)
                {
                    complianceOrdered.Add(g);
                }



                foreach (var j in complianceOrdered)
                {
                    string label = j.Item1;

                    overallBars.EnglishLabels.Add(j.Item1);
                    overallBars.Labels.Add(_overlay.GetPropertyValue("GENERIC", j.Item1.ToLower(), lang) ?? j.Item1);
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

            return Ok(rval);
        }


        [HttpGet]
        [Route("api/analysis/TopCategories")]
        public IActionResult GetTopCategories(int? total)
        {
            if (total == null)
            {
                total = 10000;
            }

            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            ChartData chartData = null;

            var results = new RankedCategoriesMultiResult();
            _context.LoadStoredProc("[usp_GetRankedCategoriesPage]")
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
                    chartData.Labels.Add(_overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), lang)?.Value ?? c.Question_Group_Heading);
                }
            }

            return Ok(chartData);
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
                var cAdjusted = new PercentageFixer(tempOList[0].Percent,
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
            var cAdjusted = new PercentageFixer(c.Y, c.N, c.NA, c.A, c.U);


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
        public IActionResult GetOverallRankedCategories()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            ChartData chartData = null;

            var results = new RankedCategoriesMultiResult();
            _context.LoadStoredProc("[usp_GetOverallRankedCategoriesPage]")
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
                    chartData.Labels.Add(_overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), lang)?.Value ?? c.Question_Group_Heading);

                    chartData.DataRows.Add(new DataRows()
                    {
                        failed = (c.nuCount ?? 0),
                        percent = (c.prc ?? 0),
                        total = (c.qc ?? 0),
                        title = _overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), lang)?.Value ?? c.Question_Group_Heading,
                        rank = i++
                    });

                }
            }

            return Ok(chartData);
        }

        [HttpGet]
        [Route("api/analysis/StandardsSummaryOverall")]
        public IActionResult GetStandardSummaryOverall()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(GetStandardsSummarySingle(_context, assessmentId));
        }

        /// <summary>
        /// This may not be called by the UI.... can't find any code that calls it
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analysis/StandardsSummary")]
        public IActionResult GetStandardsSummary()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            if (_context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).Count() > 1)
            {
                return Ok(GetStandardsSummaryMultiple(_context, assessmentId));
            }
            return Ok(GetStandardsSummarySingle(_context, assessmentId));
        }


        private ChartData GetStandardsSummarySingle(CSETContext context, int assessmentId)
        {
            ChartData myChartData = null;

            var results = new StandardSummaryOverallMultiResult();
            context.LoadStoredProc("[usp_getStandardsSummaryPage]")
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
                    if (!charts.TryGetValue(c.Answer_Text, out next))
                    {
                        data = new List<double>();
                        next = new ChartData()
                        {
                            Colors = Colors,
                            DataRowsPie = rows,
                            borderWidth = "0",
                            borderColor = "transparent",
                            label = c.Answer_Text,
                            Labels = Labels,
                            data = data
                        };
                        charts.Add(c.Answer_Text, next);
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
                    Labels.Add(c.Answer_Text);
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


        private ChartData GetStandardsSummaryMultiple(CSETContext context, int assessmentId)
        {
            ChartData myChartData = new ChartData();
            myChartData.DataRowsPie = new List<DataRowsPie>();
            myChartData.Colors = new List<string>();


            var results = new StandardSummaryOverallMultiResult();
            context.LoadStoredProc("[usp_getStandardsSummaryPage]")
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

                if (!answers.TryGetValue(data.Answer_Text, out chartData))
                {
                    chartData = new ChartData
                    {
                        label = data.Answer_Text,
                        backgroundColor = answerColorDefs[data.Answer_Text]
                    };

                    myChartData.Colors.Add(answerColorDefs[data.Answer_Text]);

                    myChartData.dataSets.Add(chartData);
                    answers.Add(data.Answer_Text, chartData);
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
        public IActionResult GetComponentsSummary()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // initialize the response container
            ChartData chartData = new ChartData();
            chartData.Colors = new List<string>();
            chartData.DataRowsPie = new List<DataRowsPie>();


            _context.LoadStoredProc("[usp_getComponentsSummary]")
                     .WithSqlParam("assessment_Id", assessmentId)
                     .ExecuteStoredProc((handler) =>
                     {
                         var answerTotals = handler.ReadToList<usp_getComponentsSummmary>();

                         // re-order the list 
                         var sortedList = new List<usp_getComponentsSummmary>();
                         AddItem("Y", sortedList, answerTotals);
                         AddItem("N", sortedList, answerTotals);
                         AddItem("NA", sortedList, answerTotals);
                         AddItem("A", sortedList, answerTotals);
                         AddItem("U", sortedList, answerTotals);
                         answerTotals = sortedList;


                         var totalQuestionCount = answerTotals == null ? 0 : answerTotals.Sum(x => x.vcount);

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
                             chartData.Labels.Add(c.Answer_Text);

                             if (!chartData.Colors.Contains(answerColorDefs[c.Answer_Text ?? "U"]))
                                 chartData.Colors.Add(answerColorDefs[c.Answer_Text ?? "U"]);
                         }
                     });


            // include component count so front end can know whether components are present
            _context.LoadStoredProc("[usp_getExplodedComponent]")
              .WithSqlParam("assessment_id", assessmentId)
              .ExecuteStoredProc((handler) =>
              {
                  chartData.ComponentCount = handler.ReadToList<usp_getExplodedComponent>().Distinct().Count();
              });

            chartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "transparent";
            });

            return Ok(chartData);
        }


        private void AddItem(String answerName, List<usp_getComponentsSummmary> sortedList, IList<usp_getComponentsSummmary> unorderedList)
        {
            var element = unorderedList.FirstOrDefault(x => x.Answer_Text == answerName);
            if (element != null)
            {
                sortedList.Add(element);
            }
        }


        [HttpGet]
        [Route("api/analysis/DocumentComments")]
        public IActionResult GetDocumentComments()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var items = from a in _context.ASSESSMENTS_REQUIRED_DOCUMENTATION
                        join d in _context.REQUIRED_DOCUMENTATION on a.Documentation_Id equals d.Documentation_Id
                        where a.Assessment_Id == assessmentId
                        orderby d.Document_Order
                        select new CommentData() { Number = d.Number, AssociatedHeader = d.Document_Description, Comment = a.Comment, Answer = a.Answer };

            return Ok(items.ToList());
        }


        [HttpGet]
        [Route("api/analysis/StandardsResultsByCategory")]
        public IActionResult GetStandardsResultsByCategory()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            ChartData chartData = new ChartData();

            _context.LoadStoredProc("[usp_getStandardsResultsByCategory]")
                    .WithSqlParam("assessment_Id", assessmentId)
                    .ExecuteStoredProc((handler) =>
                    {
                        var result = handler.ReadToList<usp_getStandardsResultsByCategory>();
                        var labels = (from usp_getStandardsResultsByCategory an in result
                                      orderby an.Question_Group_Heading
                                      select new { an.Question_Group_Heading, an.QGH_Id }).Distinct().ToList();

                        chartData.DataRows = new List<DataRows>();
                        foreach (var c in labels)
                        {
                            chartData.Labels.Add(_overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), lang)?.Value ??
                                c.Question_Group_Heading);
                        }

                        ColorsList colors = new ColorsList();

                        var sets = (from usp_getStandardsResultsByCategory an in result
                                    select new { an.Set_Name, an.Short_Name }).Distinct();
                        foreach (var set in sets)
                        {
                            ChartData nextChartData = new ChartData();
                            chartData.dataSets.Add(nextChartData);
                            nextChartData.DataRows = [];
                            var nextSet = (from usp_getStandardsResultsByCategory an in result
                                           where an.Set_Name == set.Set_Name
                                           orderby an.Question_Group_Heading
                                           select an).ToList();
                            nextChartData.label = set.Short_Name;
                            nextChartData.backgroundColor = colors.getNext(set.Set_Name);
                            foreach (usp_getStandardsResultsByCategory c in nextSet)
                            {
                                nextChartData.data.Add((double)c.prc);
                                nextChartData.Labels.Add(_overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), lang)?.Value ?? c.Question_Group_Heading);
                                nextChartData.DataRows.Add(new DataRows()
                                {
                                    failed = c.yaCount,
                                    percent = c.prc,
                                    total = c.Actualcr,
                                    title = _overlay.GetValue("QUESTION_GROUP_HEADING", c.QGH_Id.ToString(), lang)?.Value ?? c.Question_Group_Heading
                                });
                            }
                        }

                    });

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/StandardsRankedCategories")]
        public IActionResult GetStandardsRankedCategories()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            ChartData chartData = null;

            _context.LoadStoredProc("[usp_getStandardsRankedCategories]")
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



            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/ComponentsResultsByCategory")]
        public IActionResult GetComponentsResultsByCategory()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            ChartData chartData = null;

            _context.LoadStoredProc("[usp_getComponentsResultsByCategory]")
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

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/ComponentsRankedCategories")]
        public IActionResult GetComponentsRankedCategories()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            ChartData chartData = null;

            _context.LoadStoredProc("[usp_getComponentsRankedCategories]")
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

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/ComponentTypes")]
        public IActionResult ComponentTypes()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // initialize the response container
            ChartData chartData = new ChartData
            {
                Colors = new List<string>(),
                DataRowsPie = new List<DataRowsPie>()
            };

            _context.LoadStoredProc("[usp_getComponentTypes]")
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
                             chartData.Labels.Add(total.Symbol_Name);

                             // adjust the percentages to equal 100% after rounding
                             var adjTotal = new PercentageFixer(total.Y, total.N, total.NA, total.A, total.U);

                             cdY.data.Add((int)adjTotal.Y);
                             cdN.data.Add((int)adjTotal.N);
                             cdNA.data.Add((int)adjTotal.NA);
                             cdAlt.data.Add((int)adjTotal.A);
                             cdU.data.Add((int)adjTotal.U);


                             // create a new DataRows entry with answer percentages for this component
                             var row = new DataRows
                             {
                                 title = total.Symbol_Name,
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

            chartData.dataSets.ForEach(ds =>
            {
                ds.borderWidth = "0";
                ds.borderColor = "transparent";
            });

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/NetworkWarnings")]
        public IActionResult GetNetworkWarnings()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok((List<NETWORK_WARNINGS>)_context.NETWORK_WARNINGS
                .Where(x => x.Assessment_Id == assessmentId)
                .OrderBy(x => x.Id).ToList());
        }


        private string GetAssessmentMode(int assessmentId)
        {
            string applicationMode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId)
                .Select(x => x.Application_Mode).FirstOrDefault();

            if (applicationMode == null)
            {
                return "Q";
            }
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
