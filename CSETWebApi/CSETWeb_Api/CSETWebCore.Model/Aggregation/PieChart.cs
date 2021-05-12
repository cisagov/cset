using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class PieChart
    {
        public string reportType { get; set; }
        public List<string> labels { get; set; }
        public List<float> data { get; set; }


        public PieChart()
        {
            this.labels = new List<string>();
            this.data = new List<float>();
        }
    }
}