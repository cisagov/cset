//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Question
{
    public class FeedbackQuestion
    {
        public string QuestionText { get; set; }
        public int QuestionID { get; set; }
        public int AnswerID { get; set; }
        public string Feedback { get; set; }
        public string Mode { get; set; }
    }
}