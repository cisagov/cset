//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class Domain
    {
        public string SetName { get; set; }

        // public string SetFullName;

        public string SetShortName { get; set; }

        /// <summary>
        /// The text displayed in the TOC.  If this container represents a maturity domain,
        /// it contains the name of the domain.
        /// </summary>
        public string DisplayText { get; set; }

        /// <summary>
        /// Display text that appears below the domain name.  Not used for ACET but may be used for EDM.
        /// </summary>
        public string DomainText { get; set; }


        /// <summary>
        /// A list of categories within the domain.  CMMC domains correspond with
        /// categories, so there will be a single category in each CMMC domain.
        /// </summary>
        public List<QuestionGroup> Categories { get; set; } = new List<QuestionGroup>();
    }
}