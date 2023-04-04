//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class AssessmentSelection
    {
        public int AssessmentId { get; set; }
        public bool Selected { get; set; }
        public string Alias { get; set; }
    }
}