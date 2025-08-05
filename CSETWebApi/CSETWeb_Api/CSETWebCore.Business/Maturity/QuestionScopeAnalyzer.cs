using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Provides a way to exclude certain questions from a model
    /// based on current conditions. 
    /// </summary>
    public class QuestionScopeAnalyzer
    {

        private CSETContext _context;

        private int _assessmentId;
        private string _techDomain;

        // determine the out of scope questions based on the full assessment
        public List<int> OutOfScopeQuestionIds = [];


        /// <summary>
        /// Generic constructor.  Basically excludes nothing.
        /// </summary>
        public QuestionScopeAnalyzer(int assessmentId)
        {
            _assessmentId = assessmentId;
        }


        /// <summary>
        /// A constructor used for CPG 2.0 (model 21) that evaluates the
        /// technology domain of the assessment to exclude IT or OT questions.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <param name="context"></param>
        /// <param name="techDomain"></param>
        public QuestionScopeAnalyzer(int assessmentId, CSETContext context, string techDomain)
        {
            _assessmentId = assessmentId;
            _context = context;
            _techDomain = techDomain;
            OutOfScopeQuestionIds = DetermineScopeForTechnologyDomain(techDomain);
        }


        /// <summary>
        /// Returns a list of question IDs that are out of scope
        /// </summary>
        /// <returns></returns>
        public List<int> DetermineScopeForTechnologyDomain(string techDomain = null)
        {
            // If the caller is not interested in a specific tech domain, use the assessment's value
            if (techDomain == null)
            {
                techDomain = _techDomain;
            }

            if (techDomain == "OT")
            {
                return [.. _context.MATURITY_QUESTION_PROPS
                    .Where(x => x.PropertyName == "IS-IT" && x.PropertyValue == "1")
                    .Select(x => x.Mat_Question_Id)];
            }

            if (techDomain == "IT")
            {
                return [.. _context.MATURITY_QUESTION_PROPS
                    .Where(x => x.PropertyName == "IS-OT" && x.PropertyValue == "1")
                    .Select(x => x.Mat_Question_Id)];
            }

            return new List<int>();
        }
    }
}