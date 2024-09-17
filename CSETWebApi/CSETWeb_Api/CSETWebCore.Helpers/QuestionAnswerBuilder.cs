using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Builds a few different incarnations of question objects.
    /// </summary>
    public class QuestionAnswerBuilder
    {
        public static QuestionAnswer BuildQuestionAnswer(MATURITY_QUESTIONS myQ, FullAnswer answer)
        {
            var qa = new QuestionAnswer()
            {
                DisplayNumber = myQ.Question_Title,
                QuestionId = myQ.Mat_Question_Id,
                ParentQuestionId = myQ.Parent_Question_Id,
                Sequence = myQ.Sequence,
                ShortName = myQ.Short_Name,
                QuestionType = "Maturity",
                QuestionText = myQ.Question_Text,

                SecurityPractice = myQ.Security_Practice,
                Outcome = myQ.Outcome,
                Scope = myQ.Scope,
                RecommendedAction = myQ.Recommend_Action,
                RiskAddressed = myQ.Risk_Addressed,
                Services = myQ.Services,
                ImplementationGuides = myQ.Implementation_Guides,

                Answer = answer?.a.Answer_Text,
                AltAnswerText = answer?.a.Alternate_Justification,
                FreeResponseAnswer = answer?.a.Free_Response_Answer,

                Comment = answer?.a.Comment,
                Feedback = answer?.a.FeedBack,
                MarkForReview = answer?.a.Mark_For_Review ?? false,
                Reviewed = answer?.a.Reviewed ?? false,

                Is_Maturity = true,

                MaturityLevel = myQ.Maturity_Level.Level,
                MaturityLevelName = myQ.Maturity_Level.Level_Name,
                SetName = string.Empty
            };

            return qa;
        }


        /// <summary>
        /// Creates an instance of CPG.Question.
        /// </summary>
        /// <param name="myQ"></param>
        /// <param name="answer"></param>
        /// <returns></returns>
        public static Model.Maturity.CPG.Question BuildCpgQuestion(MATURITY_QUESTIONS myQ, FullAnswer answer)
        {
            var q = new Model.Maturity.CPG.Question()
            {
                DisplayNumber = myQ.Question_Title,
                QuestionId = myQ.Mat_Question_Id,
                ParentQuestionId = myQ.Parent_Question_Id,
                Sequence = myQ.Sequence,

                QuestionText = myQ.Question_Text,

                SecurityPractice = myQ.Security_Practice,
                Outcome = myQ.Outcome,
                Scope = myQ.Scope,
                RecommendedAction = myQ.Recommend_Action,
                RiskAddressed = myQ.Risk_Addressed,
                Services = myQ.Services,
                ImplementationGuides = myQ.Implementation_Guides,

                Answer = answer?.a.Answer_Text,

                Comment = answer?.a.Comment
            };

            q.Cost = myQ.MATURITY_QUESTION_PROPS.FirstOrDefault(x => x.PropertyName == "COST")?.PropertyValue;
            q.Impact = myQ.MATURITY_QUESTION_PROPS.FirstOrDefault(x => x.PropertyName == "IMPACT")?.PropertyValue;
            q.Complexity = myQ.MATURITY_QUESTION_PROPS.FirstOrDefault(x => x.PropertyName == "COMPLEXITY")?.PropertyValue;

            return q;
        }
    }
}
