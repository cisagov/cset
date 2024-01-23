//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Model.AdminTab
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
}