//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace CSETWebCore.Model.Question
{
    public class CompletionCounts
    {
        public int? AssessmentId { get; set; }
        public int? CompletedCount { get; set; }
        public int? TotalMaturityQuestionsCount { get; set; }
        public int? TotalStandardQuestionsCount { get; set; }
        public int? TotalDiagramQuestionsCount { get; set; }
    }
}
