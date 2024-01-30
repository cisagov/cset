//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Cmu
{
    public class CmuReportChart
    {
        public List<string> Labels { get; set; } = new List<string>();
        public List<int> Values { get; set; } = new List<int>();
    }
}