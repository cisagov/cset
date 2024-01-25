//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace CSETWebCore.DataLayer.Model
{
    public class usp_StatementsReviewed_Result
    {
        public int Assessment_Id { get; set; }
        public string Component { get; set; }
        public string ReviewType { get; set; }
        public decimal Hours { get; set; }

        /// <summary>
        /// Answers marked as having been reviewed by the assessor.
        /// </summary>
        public int? ReviewedCount { get; set; }
        public string OtherSpecifyValue { get; set; }
        public int? DomainId { get; set; }
        public int PresentationOrder { get; set; }
        public int? acount { get; set; }
        public decimal? PercentComplete { get; set; }
    }
}
