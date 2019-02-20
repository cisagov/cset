//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace DataLayerCore.Model
{
    using System;
    
    public partial class usp_GetOverallRankedCategoriesPage_Result
    {
        public string Question_Group_Heading { get; set; }
        public int qc { get; set; }
        public int cr { get; set; }
        public int Total { get; set; }
        public int nuCount { get; set; }
        public int Actualcr { get; set; }
        public decimal prc { get; set; }
        public decimal Percent { get; set; }
    }
}


