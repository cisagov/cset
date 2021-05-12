using System.Collections.Generic;

namespace CSETWebCore.Model.Aggregation
{
    public class ChartDataSet
    {
        public string label { get; set; }
        public List<float> data { get; set; }

        public ChartDataSet()
        {
            this.data = new List<float>();
        }
    }
}