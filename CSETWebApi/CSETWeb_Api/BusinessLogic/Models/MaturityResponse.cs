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
        /// Answer options supported for this maturity model.  
        /// </summary>
        public List<string> AnswerOptions = new List<string>() { "Y", "N", "NA", "A" };

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
        public int GroupingID;

        /// <summary>
        /// The type of grouping, e.g., Domain, Goal, Capability, etc.
        /// </summary>
        public string GroupingType;

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
        public List<MaturityGrouping> SubGroupings = new List<MaturityGrouping>();

        /// <summary>
        /// The lowest grouping in the hierarchy will hold a collection of questions.
        /// </summary>
        public List<QuestionAnswer> Questions = new List<QuestionAnswer>();
    }
}
