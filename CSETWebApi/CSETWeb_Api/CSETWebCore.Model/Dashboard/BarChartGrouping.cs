using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Dashboard.BarCharts
{

    public class Grouping
    {
        public string Name { get; set; }
        public List<NameValue> Series { get; set; } = [];
    }

    public class NameValue
    {
        public string Name { get; set; }
        public double Value { get; set; }
    }
}
