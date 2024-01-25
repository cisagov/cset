//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class CategoryContainer
    {
        /// <summary>
        /// The text displayed in the TOC.  If this container represents a maturity domain,
        /// it contains the name of the domain.
        /// </summary>
        public string DisplayText;

        /// <summary>
        /// Corresponds to the StandardCategory of the questions/requirements it encapsulates.
        /// </summary>
        public string AssessmentFactorName;

        /// <summary>
        /// If this is a domain, this indicates if maturity levels should be shown on the requirements page.
        /// </summary>
        public bool ShowMaturityLevels;

        /// <summary>
        /// The list of question groups or categories for the assessment
        /// </summary>
        public List<QuestionGroup> QuestionGroups = new List<QuestionGroup>();
    }
}