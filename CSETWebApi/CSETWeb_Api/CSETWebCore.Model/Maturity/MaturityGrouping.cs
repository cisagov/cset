using System.Collections.Generic;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Model.Maturity
{
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
        /// An optional abbreviation.  Created for EDM domains.
        /// </summary>
        public string Abbreviation;

        /// <summary>
        /// An optional description.  Usually displayed below the title.
        /// </summary>
        public string Description;

        /// <summary>
        /// an optional remark for each domain in the model
        /// </summary>
        public string DomainRemark;

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