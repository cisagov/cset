using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.Models;

namespace CSETWeb_Api.BusinessLogic.Models
{
    /// <summary>
    /// 
    /// </summary>
    public class MaturityResponse
    {
        /// <summary>
        /// Lists the display names of the maturity levels in this assessment's maturity model.
        /// </summary>
        public List<MaturityLevel> MaturityLevels;

        /// <summary>
        /// The target level selected for the assessment.
        /// </summary>
        public int MaturityTargetLevel;

        /// <summary>
        /// The top level of groupings.  This will usually be Domains.
        /// </summary>
        public List<MaturityGrouping> Groupings;
    }


    /// <summary>
    /// 
    /// </summary>
    public class MaturityGrouping
    {
        /// <summary>
        /// The type of grouping, e.g., Domain, Goal, Capability, etc.
        /// </summary>
        public string Type;

        /// <summary>
        /// The display title.
        /// </summary>
        public string Title;

        /// <summary>
        /// An optional description.  Usually displayed below the title.
        /// </summary>
        public string Description;

        /// <summary>
        /// Any child groupings below this grouping.
        /// </summary>
        public List<MaturityGrouping> Groupings;

        /// <summary>
        /// The lowest grouping in the hierarchy will hold a collection of questions.
        /// </summary>
        public List<QuestionAnswer> Questions;
    }
}
