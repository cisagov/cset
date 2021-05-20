using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Question
{
    public class QuestionAnswer
    {
        /// <summary>
        /// An ordinal number in the case of a Question, and the requirement title/version
        /// in the case of Requirement.
        /// </summary>
        public string DisplayNumber;
        public int QuestionId;

        /// <summary>
        /// Questions that have subparts use this to put the subpart to the parent 
        /// part of the question.
        /// </summary>
        public int? ParentQuestionId;

        public bool IsParentQuestion = false;

        public string QuestionType;
        public string QuestionText;
        public List<ParameterToken> ParmSubs;
        public string StdRefId;
        public string Answer;
        public string AltAnswerText;
        public string Comment;
        public string Feedback;
        public bool MarkForReview;
        public string SetName;

        /// <summary>
        /// Indicates an answer that has been reviewed.  
        /// This field was added for NCUA/ACET support.
        /// </summary>
        public bool Reviewed;
        public bool HasComment { get; set; }
        public bool HasDocument { get; set; }
        public bool HasFeedback { get; set; }
        public int docnum { get; set; }
        public bool HasDiscovery { get; set; }
        public int findingnum { get; set; }
        public int? Answer_Id { get; set; }

        /// <summary>
        /// Indicates the maturity level of the question/requirement/statement.
        /// This is NOT the maturity_level_id from the MATURITY_LEVELS table.
        /// </summary>
        // Randy commenting this out - seems like this should be handled in Maturity public int MaturityLevel { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string MaturityLevelName { get; set; }

        public bool Is_Maturity { get; set; }
        public bool Is_Component { get; set; }
        public Guid ComponentGuid { get; set; }
        public bool Is_Requirement { get; set; }
    }
}