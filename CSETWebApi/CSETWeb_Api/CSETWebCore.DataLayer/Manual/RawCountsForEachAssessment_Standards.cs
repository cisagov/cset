//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.DataLayer.Model
{
    public class RawCountsForEachAssessment_Standards
    {
        public int Assessment_Id { get; set; }
        public string Question_Group_Heading { get; set; }
        public string Answer_Text { get; set; }
        public int Answer_Count { get; set; }
        public int Total { get; set; }
        public int Percentage { get; set; }
    }
}