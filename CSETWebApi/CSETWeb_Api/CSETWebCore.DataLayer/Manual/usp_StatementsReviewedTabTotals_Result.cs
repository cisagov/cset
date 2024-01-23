//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace CSETWebCore.DataLayer.Model
{
    public class usp_StatementsReviewedTabTotals_Result
    {
        public int Assessment_Id { get; set; }
        public string ReviewType { get; set; }
        public decimal? Totals { get; set; }
        public decimal? GrandTotal { get; set; }
    }
}
