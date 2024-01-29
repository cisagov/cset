//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Nested;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Enum;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Helpers;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// A structured listing of groupings/questions/options
    /// for the CIS maturity model.
    /// </summary>
    public class CisQuestionsBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly int _assessmentId;

        /// <summary>
        /// The internal ID for the CIS model
        /// </summary>
        private readonly int _cisModelId = 8;


        public NestedQuestions QuestionsModel;


        /// <summary>
        /// Returns a populated instance of the maturity grouping
        /// and question structure for a maturity model.
        /// </summary>
        /// <param name="assessmentId"></param>
        public CisQuestionsBusiness(CSETContext context, IAssessmentUtil assessmentUtil, int assessmentId = 0)
        {
            this._context = context;
            this._assessmentUtil = assessmentUtil;
            this._assessmentId = assessmentId;
        }


        /// <summary>
        /// CIS answers are different than normal maturity answers
        /// because Options are involved.  
        /// </summary>
        public void StoreAnswer(Model.Question.Answer answer)
        {
            var dbOption = _context.MATURITY_ANSWER_OPTIONS.FirstOrDefault(x => x.Mat_Option_Id == answer.OptionId);
            if (dbOption == null)
            {
                // this is an answer to a question that does not have options.  Store it.
                StoreAnswerNoOption(answer);

                return;
            }

            // is this a radio or checkbox option
            if (dbOption.Mat_Option_Type == "radio")
            {
                StoreAnswerRadio(answer);
            }

            if (dbOption.Mat_Option_Type == "checkbox" || dbOption.Mat_Option_Type == "text-first")
            {
                StoreAnswerCheckbox(answer);
            }
        }


        /// <summary>
        /// Stores an answer not defined by an option.  This is the case
        /// with "duration" questions in CIS.
        /// </summary>
        /// <param name="answer"></param>
        private void StoreAnswerNoOption(Model.Question.Answer answer)
        {
            var dbQuestion = _context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == answer.QuestionId).FirstOrDefault();

            ANSWER dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                && x.Question_Or_Requirement_Id == dbQuestion.Mat_Question_Id
                && x.Question_Type == answer.QuestionType).FirstOrDefault();

            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }


            dbAnswer.Assessment_Id = _assessmentId;
            dbAnswer.Question_Or_Requirement_Id = dbQuestion.Mat_Question_Id;
            dbAnswer.Question_Type = answer.QuestionType;
            dbAnswer.Question_Number = 0;
            dbAnswer.Mat_Option_Id = null;
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Component_Guid = answer.ComponentGuid;

            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(_assessmentId);
        }


        /// <summary>
        /// Stores a "Radio" option answer.  Because radio buttons are
        /// single select, only one ANSWER record is stored for the question with the
        /// selected option's ID.
        /// </summary>
        /// <param name="answer"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        private void StoreAnswerRadio(Model.Question.Answer answer)
        {
            // Find the Maturity Question
            var dbOption = _context.MATURITY_ANSWER_OPTIONS.Where(o => o.Mat_Option_Id == answer.OptionId).FirstOrDefault();
            var dbQuestion = _context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == dbOption.Mat_Question_Id).FirstOrDefault();

            if (dbQuestion == null)
            {
                throw new Exception("Unknown question ID: " + answer.QuestionId);
            }


            ANSWER dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                && x.Question_Or_Requirement_Id == dbQuestion.Mat_Question_Id
                && x.Question_Type == answer.QuestionType
                && x.Mat_Option_Id != null).FirstOrDefault();


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }


            dbAnswer.Assessment_Id = _assessmentId;
            dbAnswer.Question_Or_Requirement_Id = dbQuestion.Mat_Question_Id;
            dbAnswer.Question_Type = answer.QuestionType;
            dbAnswer.Question_Number = 0;
            dbAnswer.Mat_Option_Id = answer.OptionId;   // this is the selected option
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Component_Guid = answer.ComponentGuid;

            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(_assessmentId);
        }


        /// <summary>
        /// Stores a "Checkbox" option answer.  Because multiple checkboxes
        /// can be selected, one ANSWER record is stored for each selected
        /// option.  When a checkbox is unselected, the existing ANSWER
        /// record is updated, not deleted.
        /// </summary>
        /// <param name="answer"></param>
        /// <returns></returns>
        /// <exception cref="Exception"></exception>
        private void StoreAnswerCheckbox(Model.Question.Answer answer)
        {
            // Find the Maturity Question
            var dbOption = _context.MATURITY_ANSWER_OPTIONS.Where(o => o.Mat_Option_Id == answer.OptionId).FirstOrDefault();
            var dbQuestion = _context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == dbOption.Mat_Question_Id).FirstOrDefault();

            if (dbQuestion == null)
            {
                throw new Exception("Unknown question ID: " + answer.QuestionId);
            }


            ANSWER dbAnswer = _context.ANSWER.Where(x => x.Assessment_Id == _assessmentId
                && x.Question_Or_Requirement_Id == dbQuestion.Mat_Question_Id
                && x.Mat_Option_Id == answer.OptionId
                && x.Question_Type == answer.QuestionType
                && x.Mat_Option_Id != null).FirstOrDefault();


            if (dbAnswer == null)
            {
                dbAnswer = new ANSWER();
            }


            dbAnswer.Assessment_Id = _assessmentId;
            dbAnswer.Question_Or_Requirement_Id = dbQuestion.Mat_Question_Id;
            dbAnswer.Question_Type = answer.QuestionType;
            dbAnswer.Question_Number = 0;
            dbAnswer.Mat_Option_Id = answer.OptionId;
            dbAnswer.Answer_Text = answer.AnswerText;  // either "S" or "" for a checkbox option answer
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Component_Guid = answer.ComponentGuid;

            _context.ANSWER.Update(dbAnswer);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(_assessmentId);
        }


        /// <summary>
        /// Returns a list of assessments that use the CIS model.
        /// The list is limited to assessments that the current user has access to.
        /// </summary>
        /// <returns></returns>
        public CisAssessmentsResponse GetMyCisAssessments(int assessmentId, int? userId)
        {
            var resp = new CisAssessmentsResponse();


            // Get the baseline assessment if one is selected
            var info = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            if (info != null)
            {
                resp.BaselineAssessmentId = info.Baseline_Assessment_Id;
            }

            // we can expect to find this record for the current user and assessment.
            List<int> ac = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userId)
                .Select(x => x.Assessment_Id).ToList();


            var query = from amm in _context.AVAILABLE_MATURITY_MODELS
                        join a in _context.ASSESSMENTS on amm.Assessment_Id equals a.Assessment_Id
                        join i in _context.INFORMATION on amm.Assessment_Id equals i.Id
                        where amm.model_id == _cisModelId
                            && amm.Selected == true
                            && ac.Contains(a.Assessment_Id)
                        select new { a, i };

            foreach (var l in query.ToList())
            {
                resp.MyCisAssessments.Add(new AssessmentDetail()
                {
                    Id = l.a.Assessment_Id,
                    AssessmentDate = l.a.Assessment_Date,
                    AssessmentName = l.i.Assessment_Name,
                    AssessmentDescription = l.i.Assessment_Description,
                    CreatedDate = l.a.AssessmentCreatedDate,
                    LastModifiedDate = l.a.LastModifiedDate ?? DateTime.MinValue
                });
            }

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public HorizBarChart GetDeficiencyChartData()
        {
            HorizBarChart hChart = new HorizBarChart();
            int? baselineId = null;
            var info = _context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();
            if (info != null)
            {
                baselineId = info.Baseline_Assessment_Id;
            }

            if (baselineId != null)
            {
                int maturityModel = (int)CSETWebCore.Enum.MaturityModel.CIS;
                var groupings = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == maturityModel && x.Title_Prefix != null).ToList();
                var ordered = groupings.OrderBy(x => x.Title_Prefix, new StringNumericComparer());
                var currentScore = new ChartDataSet();
                hChart.ReportTitle = "Ranked Deficiency Report";
                currentScore.Label = "Current";
                foreach (var group in ordered)
                {
                    hChart.Labels.Add(group.Title_Prefix + ". " + group.Title);
                    var currentScoring = new CisScoring(_assessmentId, group.Grouping_Id, _context);
                    var baselineScoring = new CisScoring((int)baselineId, group.Grouping_Id, _context);

                    var cScore = currentScoring.CalculateGroupingScore();
                    var bScore = baselineScoring.CalculateGroupingScore();
                    currentScore.BackgroundColor.Add(cScore.GroupingScore - bScore.GroupingScore > 0
                        ? "#5cb85c"
                        : "#d9534f");
                    currentScore.Data.Add(cScore.GroupingScore - bScore.GroupingScore);
                }

                hChart.Datasets.Add(currentScore);

                return hChart;
            }
            return null;
        }

        public HorizBarChart GetDeficiencyChartDataSd()
        {
            HorizBarChart hChart = new HorizBarChart();
            var info = _context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();
            if (info != null)
            {
                int maturityModel = (int)MaturityModel.SD;
                var groupings = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == maturityModel).ToList();
                var ordered = groupings.OrderBy(x => x.Sequence);
                var currentScore = new ChartDataSet();
                hChart.ReportTitle = "Ranked Deficiency Report";
                currentScore.Label = "Current";
                foreach (var group in groupings)
                {
                    hChart.Labels.Add(group.Sequence + ". " + group.Title);
                }
            }

            return null;
        }

        /// <summary>
        /// Builds a list of horizontal bar chart section scoring data.
        /// </summary>
        /// <returns></returns>
        public CisScoringStructure GetSectionScoringCharts()
        {
            int? baselineId = null;
            var info = _context.INFORMATION.Where(x => x.Id == _assessmentId).FirstOrDefault();
            if (info != null)
            {
                baselineId = info.Baseline_Assessment_Id;
            }


            var rkw = new CisScoringStructure(_assessmentId, _context);
            var jRkw = Newtonsoft.Json.JsonConvert.SerializeObject(rkw);

            return rkw;
        }


        /// <summary>
        /// Persists the baseline assessment ID.  If no baseline
        /// assessment is selected, it is set to null.
        /// </summary>
        public void SaveBaseline(int assessmentId, int? baselineId)
        {
            var info = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault();
            if (info == null)
            {
                return;
            }

            info.Baseline_Assessment_Id = baselineId;
            _context.SaveChanges();
        }


        /// <summary>
        /// Deletes all answers from the destination assessment
        /// and clones all answers from the source assessment
        /// into the destination.
        /// </summary>
        /// <param name="destAssessId"></param>
        /// <param name="sourceAssessId"></param>
        public void ImportCisAnswers(int destAssessId, int sourceAssessId)
        {
            var oldAnswers = _context.ANSWER.Where(x => x.Assessment_Id == destAssessId).ToList();
            _context.ANSWER.RemoveRange(oldAnswers);
            _context.SaveChanges();

            var importedAnswers = _context.ANSWER.Where(x => x.Assessment_Id == sourceAssessId).ToList();
            foreach (var answer in importedAnswers)
            {
                var dbAnswer = new ANSWER
                {
                    Assessment_Id = destAssessId,
                    Question_Or_Requirement_Id = answer.Question_Or_Requirement_Id,
                    Mat_Option_Id = answer.Mat_Option_Id,
                    Question_Type = answer.Question_Type,
                    Question_Number = 0,
                    Answer_Text = answer.Answer_Text,
                    Free_Response_Answer = answer.Free_Response_Answer,
                    Alternate_Justification = answer.Alternate_Justification,
                    Comment = answer.Comment,
                    FeedBack = answer.FeedBack,
                    Mark_For_Review = answer.Mark_For_Review,
                    Reviewed = answer.Reviewed,
                    Component_Guid = answer.Component_Guid
                };

                dbAnswer.Free_Response_Answer = answer.Free_Response_Answer;

                _context.ANSWER.Add(dbAnswer);
            }

            _context.SaveChanges();
        }

        /// <summary>
        /// Get all of the integrity check options.
        /// </summary>
        /// <returns>The list of all options applicable to an integrity check</returns>
        public List<IntegrityCheckOption> GetIntegrityCheckOptions()
        {
            List<IntegrityCheckOption> integrityCheckOptions = new List<IntegrityCheckOption>();

            var integrityCheckDbPairs = _context.MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK.ToList();
            var myAnswers = _context.ANSWER.Where(a => a.Assessment_Id == _assessmentId).ToList();
            var cisQuestions = _context.MATURITY_QUESTIONS.Where(q => q.Maturity_Model_Id == _cisModelId).ToList();

            foreach (var pair in integrityCheckDbPairs)
            {
                // Add the first integrity check option of the pair.
                ProcessIntegrityCheckOption(pair.Mat_Option_Id_1, integrityCheckOptions, integrityCheckDbPairs, myAnswers, cisQuestions);

                // Now add the second option of the pair if not already added.
                ProcessIntegrityCheckOption(pair.Mat_Option_Id_2, integrityCheckOptions, integrityCheckDbPairs, myAnswers, cisQuestions);
            }

            return integrityCheckOptions;
        }

        private void ProcessIntegrityCheckOption(int pairOptionId, List<IntegrityCheckOption> integrityCheckOptions,
            List<MATURITY_ANSWER_OPTIONS_INTEGRITY_CHECK> integrityCheckDbPairs, List<ANSWER> myAnswers, List<MATURITY_QUESTIONS> cisQuestions)
        {

            var query = from mq in _context.MATURITY_QUESTIONS
                        join ma in _context.MATURITY_ANSWER_OPTIONS on mq.Mat_Question_Id equals ma.Mat_Question_Id
                        select new { mq, ma };

            if (!integrityCheckOptions.Exists(opt => opt.OptionId == pairOptionId))
            {
                IntegrityCheckOption newOption = new IntegrityCheckOption { OptionId = pairOptionId };
                newOption.Selected = myAnswers.Find(a => a.Mat_Option_Id == newOption.OptionId)?.Answer_Text == "S";

                foreach (var p in integrityCheckDbPairs)
                {
                    int? optionId = null;

                    if (p.Mat_Option_Id_2 == newOption.OptionId && !newOption.InconsistentOptions.Exists(o => o.OptionId == p.Mat_Option_Id_1))
                    {
                        optionId = p.Mat_Option_Id_1;
                    }
                    else if (p.Mat_Option_Id_1 == newOption.OptionId && !newOption.InconsistentOptions.Exists(o => o.OptionId == p.Mat_Option_Id_2))
                    {
                        optionId = p.Mat_Option_Id_2;
                    }

                    if (optionId != null)
                    {
                        var matQuestion = query.Where(x => x.ma.Mat_Option_Id == optionId).FirstOrDefault().mq;
                        // Try to get the next level up parent question, if available, to make integrity check warnings more clear.
                        string parentQuestionText = cisQuestions.Where(q => q.Mat_Question_Id == matQuestion.Parent_Question_Id).FirstOrDefault()?.Question_Text ?? matQuestion.Question_Text;
                        newOption.InconsistentOptions.Add(
                            new InconsistentOption()
                            {
                                OptionId = (int)optionId,
                                ParentQuestionText = parentQuestionText
                            });
                    }

                }
                integrityCheckOptions.Add(newOption);
            }
        }
    }
}
