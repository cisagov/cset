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
        /// <summary>
        /// The default scope analyzer - everybody is good
        /// </summary>
        public virtual bool IsQuestionInScope(QuestionAnswer qa)
        {
            return true;
        }


        public virtual List<int> QuestionIdsInScope()
        {
            return new List<int>();
        }
    }
}