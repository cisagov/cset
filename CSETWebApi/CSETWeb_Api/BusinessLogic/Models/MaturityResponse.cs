using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.Models;

namespace CSETWeb_Api.BusinessLogic.Models
{
    public class MaturityDomainRemarks
    {
        public int Group_Id { get; set; }
        public string DomainRemark { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
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


    /// <summary>
    /// 
    /// </summary>
    public class GlossaryEntry
    {
        /// <summary>
        /// A glossary term.
        /// </summary>
        public string Term;

        /// <summary>
        /// The definition for the term.  May contain HTML markup.
        /// </summary>
        public string Definition;
    }
}
