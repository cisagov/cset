//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

namespace CSETWebCore.DataLayer.Model
{
    using System;

    public partial class usp_GetOverallRankedCategoriesPage_Result
    {
        public string Question_Group_Heading { get; set; }
        public int QGH_Id { get; set; }
        public int qc { get; set; }
        public int cr { get; set; }
        public int Total { get; set; }
        public int nuCount { get; set; }
        public int Actualcr { get; set; }
        public decimal prc { get; set; }
        public decimal Percent { get; set; }
    }
}


