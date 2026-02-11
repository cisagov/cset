//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.Business.Analytics;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Model.Analysis;
using CSETWebCore.Model.Question;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using CSETWebCore.Business.Results;



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
        private readonly ComponentTypesBusiness _componentTypesBusiness;
        private readonly ComponentsRankedCategoriesBusiness _componentsRankedCategoriesBusiness;

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
            _componentTypesBusiness = new ComponentTypesBusiness(context);
            _componentsRankedCategoriesBusiness = new ComponentsRankedCategoriesBusiness(context);

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
        public async Task<IActionResult> GetRankedQuestionsAsync()
        {
            var lang = _tokenManager.GetCurrentLanguage();
            var parmSub = new ParameterSubstitution(_context, _tokenManager);

            int assessmentId = _tokenManager.AssessmentForUser();
            _requirement.SetRequirementAssessmentId(assessmentId);

            string mode = GetAssessmentMode(assessmentId);

            var rankedQuestionsBusiness = new RankedQuestionsBusiness(_context);
            var rankedQuestionList = await rankedQuestionsBusiness.GetRankedQuestionsAsync(assessmentId);

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


                q.QuestionText = parmSub.ResolveParameters(q.QuestionOrRequirementID, q.AnswerID, q.QuestionText);
            }

            return Ok(rankedQuestionList);
        }


        [HttpGet]
        [Route("api/analysis/Feedback")]
        public IActionResult GetFeedback()
        {
            var parmSub = new ParameterSubstitution(_context, _tokenManager);

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
                    q.QuestionText = parmSub.ResolveParameters(q.QuestionID, q.AnswerID, q.QuestionText);
                    q.Feedback = parmSub.ResolveParameters(q.QuestionID, q.AnswerID, q.Feedback);
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
                    q.QuestionText = parmSub.RichTextParameters(q.QuestionID, q.AnswerID, q.QuestionText);
                    q.Feedback = parmSub.RichTextParameters(q.QuestionID, q.AnswerID, q.Feedback);
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
        public async Task<IActionResult> GetDashboard()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var assessment = _context.ASSESSMENTS.FirstOrDefault(x => x.Assessment_Id == assessmentId);
            var lang = _tokenManager.GetCurrentLanguage();

            FirstPage rval = null;

            var results = new FirstPageMultiResult();
            _context.Database.AutoTransactionBehavior = AutoTransactionBehavior.Always;

            // Get combined answer distribution statistics using LINQ
            // (replaces usp_GetFirstPage stored procedure call)
            results.Result1 = _context.GetCombinedOveralls(assessmentId);

            // Get ranked categories using LINQ
            // (replaces usp_GetOverallRankedCategoriesPage stored procedure call)
            var rankedCategoriesBusiness = new RankedCategoriesBusiness(_context);
            results.Result2 = await rankedCategoriesBusiness.GetRankedCategoriesAsync(assessmentId);


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

                foreach (RankedCategories c in results.Result2.Take(5))
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
        public async Task<IActionResult> GetTopCategories(int? total)
        {
            if (total == null)
            {
                total = 10000;
            }

            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            ChartData chartData = null;

            var rankedCategoriesBusiness = new RankedCategoriesBusiness(_context);
            var rankedCategories = await rankedCategoriesBusiness.GetRankedCategoriesAsync(assessmentId);

            if (rankedCategories.Any())
            {
                chartData = new ChartData();
                foreach (RankedCategories c in rankedCategories.Take((int)total))
                {
                    chartData.data.Add((double)(c.prc ?? 0));
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
        public async Task<IActionResult> GetOverallRankedCategories()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            ChartData chartData = null;

            // Get ranked categories using LINQ
            // (replaces usp_GetOverallRankedCategoriesPage stored procedure call)
            var rankedCategoriesBusiness = new RankedCategoriesBusiness(_context);
            var rankedCategories = await rankedCategoriesBusiness.GetRankedCategoriesAsync(assessmentId);


            if (rankedCategories.Any())
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
                foreach (RankedCategories c in rankedCategories)
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
        public async Task<IActionResult> GetStandardSummaryOverall()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            return Ok(await GetStandardsSummarySingleAsync(_context, assessmentId));
        }

        /// <summary>
        /// This may not be called by the UI.... can't find any code that calls it
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analysis/StandardsSummary")]
        public async Task<IActionResult> GetStandardsSummary()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            if (_context.AVAILABLE_STANDARDS.Where(x => x.Assessment_Id == assessmentId && x.Selected).Count() > 1)
            {
                return Ok(await GetStandardsSummaryMultipleAsync(_context, assessmentId));
            }
            return Ok(await GetStandardsSummarySingleAsync(_context, assessmentId));
        }


        private async Task<ChartData> GetStandardsSummarySingleAsync(CSETContext context, int assessmentId)
        {
            ChartData myChartData = null;

            var standardsSummaryBusiness = new StandardsSummaryBusiness(context);
            var resultList = await standardsSummaryBusiness.GetStandardsSummaryAsync(assessmentId);

            var results = new StandardSummaryOverallMultiResult { Result1 = resultList };

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


        private async Task<ChartData> GetStandardsSummaryMultipleAsync(CSETContext context, int assessmentId)
        {
            ChartData myChartData = new ChartData();
            myChartData.DataRowsPie = new List<DataRowsPie>();
            myChartData.Colors = new List<string>();

            var standardsSummaryBusiness = new StandardsSummaryBusiness(context);
            var resultList = await standardsSummaryBusiness.GetStandardsSummaryAsync(assessmentId);

            var results = new StandardSummaryOverallMultiResult { Result1 = resultList };

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
        public async Task<IActionResult> GetComponentsSummary()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // initialize the response container
            ChartData chartData = new ChartData();
            chartData.Colors = new List<string>();
            chartData.DataRowsPie = new List<DataRowsPie>();

            // Get components summary using LINQ
            // (replaces usp_getComponentsSummary stored procedure call)
            var componentsSummaryBusiness = new ComponentsSummaryBusiness(_context);
            var answerTotals = await componentsSummaryBusiness.GetComponentsSummaryAsync(assessmentId);

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

            // include component count so front end can know whether components are present
            // Use ASSESSMENT_DIAGRAM_COMPONENTS directly instead of the expensive Answer_Components_Exploded view
            chartData.ComponentCount = await _context.ASSESSMENT_DIAGRAM_COMPONENTS
                .AsNoTracking()
                .Where(adc => adc.Assessment_Id == assessmentId)
                .Join(
                    _context.DIAGRAM_CONTAINER.AsNoTracking(),
                    adc => adc.Layer_Id,
                    dc => dc.Container_Id,
                    (adc, dc) => new { adc, dc })
                .Where(x => x.dc.Visible == true)
                .CountAsync();

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


        /// <summary>
        /// Returns a ChartData object with category scores.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/analysis/StandardsResultsByCategory")]
        public async Task<IActionResult> GetStandardsResultsByCategory()
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            var lang = _tokenManager.GetCurrentLanguage();

            ResultsAnalysisBusiness resultsBusiness = new ResultsAnalysisBusiness(_context, _overlay, lang, _tokenManager);
            var results = await resultsBusiness.ResultsByCategoryAsync(assessmentId);

            return Ok(results);
        }


        [HttpGet]
        [Route("api/analysis/StandardsRankedCategories")]
        public async Task<IActionResult> GetStandardsRankedCategories()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var business = new StandardsRankedCategoriesBusiness(_context);
            var result = await business.GetStandardsRankedCategoriesAsync(assessmentId);

            var chartData = new ChartData();
            chartData.DataRows = new List<DataRows>();

            foreach (var c in result)
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

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/ComponentsResultsByCategory")]
        public async Task<IActionResult> GetComponentsResultsByCategory()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var business = new ComponentsResultsByCategoryBusiness(_context);
            var result = await business.GetComponentsResultsByCategoryAsync(assessmentId);

            var chartData = new ChartData();
            foreach (var c in result)
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

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/ComponentsRankedCategories")]
        public async Task<IActionResult> GetComponentsRankedCategories()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var result = await _componentsRankedCategoriesBusiness.GetComponentsRankedCategoriesAsync(assessmentId);

            var chartData = new ChartData();
            foreach (var c in result)
            {
                chartData.data.Add((double)c.prc);
                chartData.Labels.Add(c.Question_Group_Heading);

                chartData.DataRows.Add(new DataRows
                {
                    title = c.Question_Group_Heading,
                    rank = c.prc,
                    failed = c.nuCount,
                    total = c.qc,
                    percent = c.Percent
                });
            }

            return Ok(chartData);
        }


        [HttpGet]
        [Route("api/analysis/ComponentTypes")]
        public async Task<IActionResult> ComponentTypes()
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            // initialize the response container
            ChartData chartData = new ChartData
            {
                Colors = new List<string>(),
                DataRowsPie = new List<DataRowsPie>()
            };

            var componentTotals = await _componentTypesBusiness.GetComponentTypesAsync(assessmentId);

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
