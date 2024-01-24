//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
namespace CSETWebCore.Model.Aggregation
{
    public class analytics_getMinMaxAverageForSectorIndustryGroup
    {
        public string Question_Group_Heading { get; set; }
        public int Min { get; set; }
        public int Max { get; set; }
        public int Average { get; set; }

    }
}

