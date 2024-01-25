//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class ChartDataSet
    {
        public string Type { get; set; }
        public string Label { get; set; }
        public List<float> Data { get; set; }
        public List<string> BackgroundColor { get; set; }

        public ChartDataSet()
        {
            this.Data = new List<float>();
            this.BackgroundColor = new List<string>();
        }
    }
}