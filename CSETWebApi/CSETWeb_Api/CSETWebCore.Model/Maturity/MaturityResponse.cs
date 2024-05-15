//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Maturity
{
    public class MaturityResponse
    {
        /// <summary>
        /// The ID of the maturity model.
        /// </summary>
        public int ModelId { get; set; }
        /// <summary>
        /// The name of the maturity model.
        /// </summary>
        public string ModelName { get; set; }

        /// <summary>
        /// The name of the current grouping represented in the response;
        /// </summary>
        public string Title { get; set; }

        /// <summary>
        /// Lists the display names of the maturity levels in this assessment's maturity model.
        /// </summary>
        public List<MaturityLevel> Levels { get; set; } = new List<MaturityLevel>();

        /// <summary>
        /// The target level selected for the assessment.
        /// </summary>
        public int MaturityTargetLevel { get; set; }

        /// <summary>
        /// This is ACET's maturity target level.  It would be nice to combine this into the property above. ^
        /// </summary>
        public int OverallIRP { get; set; }

        /// <summary>
        /// Answer options supported for this maturity model.  
        /// </summary>
        public List<string> AnswerOptions { get; set; } = new List<string>() { "Y", "N", "NA", "A" };

        /// <summary>
        /// If the maturity model refers to 'questions' by another name, this is that name.
        /// </summary>
        public string QuestionsAlias { get; set; }

        /// <summary>
        /// The top level of groupings.  This will usually be Domains.
        /// </summary>
        public List<MaturityGrouping> Groupings { get; set; } = new List<MaturityGrouping>();

        /// <summary>
        /// All known glossary terms for the maturity model.
        /// </summary>
        public List<GlossaryEntry> Glossary { get; set; } = new List<GlossaryEntry>();

        /// <summary>
        /// The description for the maturity model
        /// </summary>
        public string? Description { get; set; }

        /// <summary>
        /// The description for the maturity model
        /// </summary>
        public string? Description_Extended { get; set; }
    }
}