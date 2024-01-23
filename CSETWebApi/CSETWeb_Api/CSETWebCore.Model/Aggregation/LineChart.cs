//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class LineChart
    {
        public string reportType { get; set; }

        /// <summary>
        /// The labels for the x-axis.  Typically dates.
        /// </summary>
        public List<string> labels { get; set; }

        public List<ChartDataSet> datasets { get; set; }


        public LineChart()
        {
            this.labels = new List<string>();
            this.datasets = new List<ChartDataSet>();
        }
    }
}