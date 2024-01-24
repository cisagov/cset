//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Aggregation
{
    public class usp_getStandardSummaryOverall
    {
        public string Answer_Full_Name { get; set; }
        public string Answer_Text { get; set; }
        public int qc { get; set; }
        public int Total { get; set; }
        public int Percent { get; set; }
    }
}