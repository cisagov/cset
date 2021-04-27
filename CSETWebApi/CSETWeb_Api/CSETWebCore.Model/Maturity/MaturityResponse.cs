using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityResponse
    {
        /// <summary>
        /// The name of the maturity model.
        /// </summary>
        public string ModelName;

        /// <summary>
        /// Lists the display names of the maturity levels in this assessment's maturity model.
        /// </summary>
        public List<MaturityLevel> Levels;

        /// <summary>
        /// The target level selected for the assessment.
        /// </summary>
        public int MaturityTargetLevel;

        /// <summary>
        /// This is ACET's maturity target level.  It would be nice to combine this into the property above. ^
        /// </summary>
        public int OverallIRP;

        /// <summary>
        /// Answer options supported for this maturity model.  
        /// </summary>
        public List<string> AnswerOptions = new List<string>() { "Y", "N", "NA", "A" };

        /// <summary>
        /// If the maturity model refers to 'questions' by another name, this is that name.
        /// </summary>
        public string QuestionsAlias;

        /// <summary>
        /// The top level of groupings.  This will usually be Domains.
        /// </summary>
        public List<MaturityGrouping> Groupings;

        /// <summary>
        /// All known glossary terms for the maturity model.
        /// </summary>
        public List<GlossaryEntry> Glossary;
    }
}