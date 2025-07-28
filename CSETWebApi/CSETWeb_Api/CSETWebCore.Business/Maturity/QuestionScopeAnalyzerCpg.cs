using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// Handles the determination of questions that are in scope.
    /// </summary>
    public class QuestionScopeAnalyzerCpg : QuestionScopeAnalyzer
    {
        private CSETContext _context;

        private readonly int _assessmentId;
        private string _techDomain;


        public List<int> OutOfScope = [];


        /// <summary>
        /// CTOR
        /// </summary>
        public QuestionScopeAnalyzerCpg(int assessmentId, CSETContext context)
        {
            _assessmentId = assessmentId;
            _context = context;

            // determine the out of scope questions based on the full assessment
            OutOfScope = OutOfScopeQuestionIds();
        }


        /// <summary>
        /// Returns a list of question IDs that are out of scope
        /// </summary>
        /// <returns></returns>
        public override List<int> OutOfScopeQuestionIds(string techDomain = null)
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
