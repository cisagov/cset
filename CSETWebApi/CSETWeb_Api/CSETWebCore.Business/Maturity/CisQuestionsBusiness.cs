using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Assessment;
using CSETWebCore.Model.Cis;
using CSETWebCore.Model.Aggregation;
using CSETWebCore.Enum;
using System;
using System.Collections.Generic;
using System.Linq;

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


        public CisQuestions QuestionsModel;


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
                return;
            }

            // is this a radio or checkbox option
            if (dbOption.Mat_Option_Type == "radio")
            {
                StoreAnswerRadio(answer);
            }

            if (dbOption.Mat_Option_Type == "checkbox")
            {
                StoreAnswerCheckbox(answer);
            }

            if (dbOption.Mat_Option_Type == "text-first")
            {
                StoreAnswerCheckbox(answer);
            }
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
            // If this is an unselected radio, do nothing.
            // This method only acts on 
            if (answer.AnswerText == "")
            {
                return;
            }

            // Find the Maturity Question
            var dbOption = _context.MATURITY_ANSWER_OPTIONS.Where(o => o.Mat_Option_Id == answer.OptionId).FirstOrDefault();
            var dbQuestion = _context.MATURITY_QUESTIONS.Where(q => q.Mat_Question_Id == dbOption.Mat_Question_Id).FirstOrDefault();

            if (dbQuestion == null)
            {
                throw new Exception("Unknown question ID: " + answer.QuestionId);
            }


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
            dbAnswer.Mat_Option_Id = answer.OptionId;   // this is the selected option
            dbAnswer.Answer_Text = answer.AnswerText;
            dbAnswer.Alternate_Justification = answer.AltAnswerText;
            dbAnswer.Free_Response_Answer = answer.FreeResponseAnswer;
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
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
                && x.Question_Type == answer.QuestionType).FirstOrDefault();


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
            dbAnswer.Comment = answer.Comment;
            dbAnswer.FeedBack = answer.Feedback;
            dbAnswer.Mark_For_Review = answer.MarkForReview;
            dbAnswer.Reviewed = answer.Reviewed;
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
                var groupings = _context.MATURITY_GROUPINGS.Where(x => x.Maturity_Model_Id == maturityModel).ToList();
                var currentScore = new ChartDataSet();
                hChart.reportTitle = "Ranked Deficiency Report";
                currentScore.label = "Current";
                foreach (var group in groupings)
                {
                    hChart.labels.Add(group.Title);
                    var currentScoring = new CisScoring(_assessmentId, group.Grouping_Id, _context);
                    var baselineScoring = new CisScoring((int)baselineId, group.Grouping_Id, _context);

                    var cScore = currentScoring.CalculateGroupingScore();
                    var bScore = baselineScoring.CalculateGroupingScore();
                    currentScore.backgroundColor.Add(cScore.GroupingScore - bScore.GroupingScore > 0
                        ? "#5cb85c"
                        : "#d9534f");
                    currentScore.data.Add(cScore.GroupingScore - bScore.GroupingScore);
                }

                hChart.datasets.Add(currentScore);

                return hChart;
            }
            return null;
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
    }
}
