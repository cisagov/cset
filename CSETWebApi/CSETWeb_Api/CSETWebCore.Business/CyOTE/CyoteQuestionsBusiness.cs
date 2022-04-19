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

        private List<MATURITY_QUESTIONS> allQuestions;

        private List<ANSWER> allAnswers;

        private readonly int _maturityModelId;

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
        public List<object> GetTopSubtree()
        {

        }


        /// <summary>
        /// 
        /// </summary>
        private void LoadStructure()
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


            GetSubgroups(QuestionsModel, null, sectionId);
        }


        /// <summary>
        /// 
        /// </summary>
        private void Blah()
        {
            // are there any questions that belong to this grouping?
            var myQuestions = allQuestions.Where(x => x.Grouping_Id == sg.Grouping_Id
                && x.Parent_Question_Id == null && x.Parent_Option_Id == null).ToList();

            foreach (var myQ in myQuestions.OrderBy(s => s.Sequence))
            {
                var answer = allAnswers.FirstOrDefault(x => x.Question_Or_Requirement_Id == myQ.Mat_Question_Id);

                var question = new Model.Cis.Question()
                {
                    QuestionId = myQ.Mat_Question_Id,
                    Sequence = myQ.Sequence,
                    DisplayNumber = myQ.Question_Title,
                    ParentQuestionId = myQ.Parent_Question_Id,
                    QuestionType = myQ.Mat_Question_Type,
                    AnswerText = answer?.Answer_Text,
                    AnswerMemo = answer?.Free_Response_Answer,
                    Options = GetOptions(myQ.Mat_Question_Id),
                    Followups = GetFollowupQuestions(myQ.Mat_Question_Id)
                };

            }
        }
    }
}
