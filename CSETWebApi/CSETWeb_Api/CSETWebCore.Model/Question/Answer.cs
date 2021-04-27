using System;

namespace CSETWebCore.Model.Question
{
    public class Answer
    {
        public int QuestionId;

        /// <summary>
        /// The sequential number that was assigned when the question list was built.
        /// </summary>
        public int QuestionNumber;

        public string AnswerText;
        public string AltAnswerText;
        public string Comment;
        public string Feedback;
        public bool MarkForReview;
        public Guid ComponentGuid;

        /// <summary>
        /// Indicates an answer that has been reviewed.  
        /// This field was added for NCUA/ACET support.
        /// </summary>
        public bool Reviewed;

        public string QuestionType;

        //public bool Is_Requirement;
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

        //public bool Is_Component;
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

        //public bool Is_Maturity;
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
