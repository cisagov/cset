using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.AdminTab
{
    public class AdminTabData
    {
        public AdminTabData()
        {
            DetailData = new List<FINANCIAL_HOURS_OVERRIDE>();
            ReviewTotals = new List<ReviewTotals>();
        }
        public List<FINANCIAL_HOURS_OVERRIDE> DetailData { get; set; }
        public List<ReviewTotals> ReviewTotals { get; set; }
        public Decimal GrandTotal { get; set; }
        public List<usp_financial_attributes_result> Attributes { get; set; }
    }

    public class ReviewTotals
    {
        public string ReviewType { get; set; }
        public Nullable<decimal> Total { get; set; }
    }
    /// <summary>
    /// Wraps instead of inherits 
    /// please use this to wrap the 
    /// </summary>
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
