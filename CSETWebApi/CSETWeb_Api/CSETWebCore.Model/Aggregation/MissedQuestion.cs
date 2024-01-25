//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class MissedQuestion
    {
        public int QuestionId { get; set; }
        public string Category { get; set; }
        public string Subcategory { get; set; }
        public string QuestionText { get; set; }
    }
}