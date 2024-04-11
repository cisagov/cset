//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.DataLayer.Model
{
    public class usp_countsForLevelsByGroupMaturityModelResults
    {
        public int GROUPING_ID { get; set; }
        public int Maturity_Level_Id { get; set; }
        public string Answer_Text { get; set; }
        public string Answer_Text2 { get; set; }
        public int answer_count { get; set; }

    }
}