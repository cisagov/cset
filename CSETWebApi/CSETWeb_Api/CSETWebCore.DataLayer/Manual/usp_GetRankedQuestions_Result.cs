namespace CSETWebCore.DataLayer.Model
{
    using System;
    
    public partial class usp_GetRankedQuestions_Result
    {
        public string Standard { get; set; }
        public string Category { get; set; }
        public Nullable<long> Rank { get; set; }
        public string QuestionText { get; set; }
        public int AnswerID { get; set; }
        public string AnswerText { get; set; }
        public string Level { get; set; }
        public string QuestionRef { get; set; }
        public int QuestionOrRequirementID { get; set; }
    }
}
