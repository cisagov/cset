//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class AnswerCounts
    {
        public int AssessmentId { get; set; }
        public string Alias { get; set; }
        public int Total { get; set; }
        public int Y { get; set; }
        public int N { get; set; }
        public int NA { get; set; }
        public int A { get; set; }
        public int U { get; set; }
    }
}