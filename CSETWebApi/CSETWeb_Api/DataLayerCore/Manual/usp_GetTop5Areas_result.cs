//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace DataLayerCore.Model
{
    public class usp_GetTop5Areas_result
    {
        public int Assessment_Id { get; set; }
        public string Universal_Sub_Category { get; set; }
        public string Answer_Text { get; set; }
        public int Answer_Count { get; set; }
        public int Total { get; set; }
        public double percentTotal { get; set; }
    }
}