using CSETWebCore.Model.Question;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Maturity
{
    /// <summary>
    /// A generic class that can be subclassed for specific maturity models
    /// if on-the-fly scope decisions are needed for certain questions.
    /// </summary>
    public class QuestionScopeAnalyzer
    {

        // determine the out of scope questions based on the full assessment
        public List<int> OutOfScope = [];


        /// <summary>
        /// 
        /// </summary>
        public QuestionScopeAnalyzer()
        {
            // determine the out of scope questions based on the full assessment
            OutOfScope = OutOfScopeQuestionIds();
        }


        public virtual List<int> OutOfScopeQuestionIds(string techDomain = null)
        {
            return new List<int>();
        }
    }
}