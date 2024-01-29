//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.AdminTab
{
    public class FINANCIAL_HOURS_OVERRIDE
    {
        private usp_StatementsReviewed_Result r;

        public FINANCIAL_HOURS_OVERRIDE(usp_StatementsReviewed_Result r)
        {
            this.r = r;
        }

        public usp_StatementsReviewed_Result Data { get { return r; } }

        /// <summary>
        /// The number of answers marked as Reviewed by the assessor.
        /// </summary>
        public int StatementsReviewed
        {
            get
            {
                return (r.ReviewedCount == null) ? 0 : (int)r.ReviewedCount;
            }
        }
    }
}