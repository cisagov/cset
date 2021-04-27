using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class Domain
    {
        public string SetName;

        // public string SetFullName;

        public string SetShortName;

        /// <summary>
        /// The text displayed in the TOC.  If this container represents a maturity domain,
        /// it contains the name of the domain.
        /// </summary>
        public string DisplayText;

        /// <summary>
        /// Display text that appears below the domain name.  Not used for ACET but may be used for EDM.
        /// </summary>
        public string DomainText;


        /// <summary>
        /// A list of categories within the domain.  CMMC domains correspond with
        /// categories, so there will be a single category in each CMMC domain.
        /// </summary>
        public List<QuestionGroup> Categories = new List<QuestionGroup>();
    }
}