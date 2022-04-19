using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Cis;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Model.CyOTE;

namespace CSETWebCore.Business.CyOTE
{
    public class CyoteQuestionsBusiness
    {
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly int _assessmentId;


        private List<MATURITY_GROUPINGS> allGroupings;

        private List<MATURITY_QUESTIONS> allQuestions;

        private List<ANSWER> allAnswers;

        // This class is designed to be CyOTE specific for now
        private readonly int _maturityModelId = 9;

        public CisQuestions QuestionsModel;


        /// <summary>
        /// Constructor
        /// </summary>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        /// <param name="assessmentId"></param>
        public CyoteQuestionsBusiness(CSETContext context, IAssessmentUtil assessmentUtil, int assessmentId = 0)
        {
            this._context = context;
            this._assessmentUtil = assessmentUtil;
            this._assessmentId = assessmentId;
        }


        /// <summary>
        /// 
        /// </summary>
        public List<Model.Cis.Question> GetTopSubtree(int groupingId)
        {
            Initialize();

            // currently this is assuming that CyOTE questions
            // live under a single grouping record
            var g = allGroupings.First(x => x.Grouping_Id == groupingId);

            List<Model.Cis.Question> resp = new List<Model.Cis.Question>();

            var myQuestions = allQuestions.Where(x => x.Grouping_Id == g.Grouping_Id
                    && x.Parent_Question_Id == null && x.Parent_Option_Id == null)
                .OrderBy(x => x.Sequence)
                .ToList();

             foreach (var q in myQuestions)
            {
                resp.Add(ConvertToQ(q, null));
            }

            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        public Model.Cis.Question GetQuestionBranch(int questionId)
        {
            Initialize();

            var q1 = allQuestions.Where(x => x.Mat_Question_Id == questionId).FirstOrDefault();
            var q2 = ConvertToQ(q1, null);
            return q2;
        }


        /// <summary>
        /// 
        /// </summary>
        private void Initialize()
        {
            QuestionsModel = new CisQuestions
            {
                AssessmentId = this._assessmentId
            };


            allQuestions = _context.MATURITY_QUESTIONS
                .Include(x => x.Maturity_LevelNavigation)
                .Include(x => x.MATURITY_REFERENCE_TEXT)
                .Where(q =>
                _maturityModelId == q.Maturity_Model_Id).ToList();


            allAnswers = _context.ANSWER
                .Where(a => a.Question_Type == Constants.Constants.QuestionTypeMaturity
                    && a.Assessment_Id == this._assessmentId)
                .ToList();


            // Get all subgroupings for this maturity model
            allGroupings = _context.MATURITY_GROUPINGS
                .Include(x => x.Type)
                .Where(x => x.Maturity_Model_Id == _maturityModelId).ToList();
        }


        /// <summary>
        /// 
        /// </summary>
        private void Blah()
        {
            //// are there any questions that belong to this grouping?
            //var myQuestions = allQuestions.Where(x => x.Grouping_Id == sg.Grouping_Id
            //    && x.Parent_Question_Id == null && x.Parent_Option_Id == null).ToList();

            //foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            //{
            //    var answer = allAnswers.FirstOrDefault(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id);

            //    var question = ConvertToQ(myQ, answer);
            //    question.Options = GetOptions(myQ.Mat_Question_Id);
            //    question.Followups = GetFollowupQuestions(myQ.Mat_Question_Id);
            //}
        }


        /// <summary>
        /// Build options for a question.
        /// </summary>
        /// <param name="questionId"></param>
        /// <returns></returns>
        private List<Option> GetOptions(int questionId)
        {
            var opts = _context.MATURITY_ANSWER_OPTIONS.Where(x => x.Mat_Question_Id == questionId)
                .Include(x => x.ANSWER.Where(y => y.Assessment_Id == _assessmentId))
                .OrderBy(x => x.Answer_Sequence)
                .ToList();

            var list = new List<Option>();

            foreach (var o in opts)
            {
                var option = new Option()
                {
                    OptionText = o.Option_Text,
                    OptionId = o.Mat_Option_Id,
                    OptionType = o.Mat_Option_Type,
                    Sequence = o.Answer_Sequence,
                    HasAnswerText = o.Has_Answer_Text,
                    Weight = o.Weight
                };

                var ans = o.ANSWER.FirstOrDefault();
                option.AnswerId = ans?.Answer_Id;
                option.Selected = ans?.Answer_Text == "S";
                option.AnswerText = ans?.Free_Response_Answer;


                // Include questions that are a followup to the OPTION
                var myQuestions = allQuestions.Where(x => x.Parent_Option_Id == o.Mat_Option_Id).ToList();

                foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
                {
                    var question = ConvertToQ(myQ, null);
                    question.Options = GetOptions(myQ.Mat_Question_Id);
                    question.Followups = GetFollowupQuestions(myQ.Mat_Question_Id);
                    question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                    question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;

                    option.Followups.Add(question);
                }

                list.Add(option);
            }

            return list;
        }


        /// <summary>
        /// Get questions that are followups to QUESTIONS
        /// </summary>
        /// <param name="allQuestions"></param>
        /// <param name="parentId"></param>
        /// <returns></returns>
        private List<Model.Cis.Question> GetFollowupQuestions(int parentId)
        {
            var qList = new List<Model.Cis.Question>();

            var myQuestions = allQuestions.Where(x => x.Parent_Question_Id == parentId && x.Parent_Option_Id == null).ToList();

            foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            {
                var answer = allAnswers.FirstOrDefault(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id);

                var question = ConvertToQ(myQ, answer);
                question.Options = GetOptions(myQ.Mat_Question_Id);
                question.Followups = GetFollowupQuestions(myQ.Mat_Question_Id);
                question.QuestionText = myQ.Question_Text.Replace("\r\n", "<br/>").Replace("\n", "<br/>").Replace("\r", "<br/> ");
                question.ReferenceText = myQ.MATURITY_REFERENCE_TEXT.FirstOrDefault()?.Reference_Text;


                qList.Add(question);

                var followups = GetFollowupQuestions(myQ.Mat_Question_Id);
                question.Followups.AddRange(followups);
            }

            return qList;
        }

        /// <summary>
        /// Converts a MATURITY_QUESTIONS and ANSWER
        /// pair into a Question instance.  
        /// Recursing Options and Followups is not done here.
        /// </summary>
        /// <param name="q"></param>
        /// <param name="answer"></param>
        /// <returns></returns>
        private Model.Cis.Question ConvertToQ(MATURITY_QUESTIONS q, ANSWER answer)
        {
            var question = new Model.Cis.Question()
            {
                QuestionId = q.Mat_Question_Id,
                Sequence = q.Sequence,
                DisplayNumber = q.Question_Title,
                QuestionText = q.Question_Text,
                ParentQuestionId = q.Parent_Question_Id,
                QuestionType = q.Mat_Question_Type,
                AnswerText = answer?.Answer_Text,
                AnswerMemo = answer?.Free_Response_Answer
            };

            return question;
        }
    }
}
