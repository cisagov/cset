namespace CSETWebCore.DataLayer.Model
{ 
    public partial class usp_GetQuestionsWithFeedback
    {
        public string Feedback { get; set; }
        public string QuestionText { get; set; }
        public int QuestionOrRequirementId { get; set; }
        public int AnswerId { get; set; }
        public string SetName { get; set; }
    }

    public partial class FeedbackDisplayContainer
    {
        public string FeedbackBody  { get; set; }
        public string FeedbackHeader { get; set; }
        public string FeedbackEmailTo { get; set; }
        public string FeedbackEmailSubject { get; set; }
        public string FeedbackEmailBody { get; set; }
    }
}
