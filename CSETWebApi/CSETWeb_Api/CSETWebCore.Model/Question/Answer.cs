//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;

namespace CSETWebCore.Model.Question
{
    public class Answer
    {
        public int QuestionId { get; set; }

        /// <summary>
        /// The sequential number that was assigned when the question list was built.
        /// </summary>
        public string QuestionNumber { get; set; }

        public int? OptionId { get; set; }

        public string AnswerText { get; set; }
        public string AltAnswerText { get; set; }
        public string FreeResponseAnswer { get; set; }
        public string Comment { get; set; }
        public string Feedback { get; set; }
        public bool MarkForReview { get; set; }
        public Guid ComponentGuid { get; set; }

        /// <summary>
        /// Indicates an answer that has been reviewed.  
        /// This field was added for NCUA/ACET support.
        /// </summary>
        public bool Reviewed { get; set; }

        public string QuestionType { get; set; }

        public bool Is_Requirement
        {
            get
            {
                return this.QuestionType == "Requirement";
            }
            set
            {
                if (value)
                    this.QuestionType = "Requirement";
            }
        }

        public bool Is_Component
        {
            get
            {
                return this.QuestionType == "Component";
            }
            set
            {
                if (value)
                    this.QuestionType = "Component";
            }
        }

        public bool Is_Maturity
        {
            get
            {
                return this.QuestionType == "Maturity";
            }
            set
            {
                if (value)
                    this.QuestionType = "Maturity";
            }
        }
    }
}
