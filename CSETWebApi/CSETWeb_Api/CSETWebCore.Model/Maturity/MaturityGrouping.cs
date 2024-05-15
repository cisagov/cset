//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Question;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityGrouping
    {
        public int GroupingID { get; set; }

        /// <summary>
        /// The type of grouping, e.g., Domain, Goal, Capability, etc.
        /// </summary>
        public string GroupingType { get; set; }

        /// <summary>
        /// The display title.
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// An optional abbreviation.  Created for EDM domains.
        /// </summary>
        public string Abbreviation { get; set; }

        /// <summary>
        /// An optional description.  Usually displayed below the title.
        /// </summary>
        public string Description { get; set; }

        /// <summary>
        /// An optional description.  Usually displayed below the title.
        /// </summary>
        public string Description_Extended { get; set; }

        /// <summary>
        /// an optional remark for each domain in the model
        /// </summary>
        public string DomainRemark { get; set; }

        /// <summary>
        /// Any child groupings below this grouping.
        /// </summary>
        public List<MaturityGrouping> SubGroupings { get; set; } = new List<MaturityGrouping>();

        /// <summary>
        /// The lowest grouping in the hierarchy will hold a collection of questions.
        /// </summary>
        public List<QuestionAnswer> Questions { get; set; } = new List<QuestionAnswer>();
    }
}