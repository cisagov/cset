using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class HorizBarChart
    {
        public string reportTitle { get; set; }
        public List<string> labels { get; set; }

        public List<ChartDataSet> datasets { get; set; }

        public HorizBarChart()
        {
            this.labels = new List<string>();
            this.datasets = new List<ChartDataSet>();
        }
    }
}