namespace CSETWebCore.DataLayer.Model
{
    using System;
    
    public partial class usp_GetRankedQuestions_Result
    {
        public string Standard { get; set; }
        public string Category { get; set; }
        public Nullable<long> Rank { get; set; }
        public string QuestionText { get; set; }

        /// <summary>
        /// The ID of the related question.  Null if this is a requirement.
        /// </summary>
        public Nullable<int> QuestionId { get; set; }

        /// <summary>
        /// The ID of the related requirement.  Null if this is a question.
        /// </summary>
        public Nullable<int> RequirementId { get; set; }

        /// <summary>
        /// The question or requirement that the answer is tied to
        /// </summary>
        public int QuestionOrRequirementID { get; set; }
        public int AnswerID { get; set; }

        public string AnswerText { get; set; }
        public string Level { get; set; }
        public string QuestionRef { get; set; }
    }
}
