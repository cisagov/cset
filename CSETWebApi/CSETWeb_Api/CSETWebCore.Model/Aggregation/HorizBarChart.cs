//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class HorizBarChart
    {
        public string ReportTitle { get; set; }
        public List<string> Labels { get; set; }

        public List<ChartDataSet> Datasets { get; set; } = new List<ChartDataSet>();

        public HorizBarChart()
        {
            this.Labels = new List<string>();
            this.Datasets = new List<ChartDataSet>();
        }
    }
}