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

    public class NameSeries
    {
        public string Name { get; set; }
        public List<NameValue> Series { get; set; } = [];
    }



    /// <summary>
    /// A named series of NameValueCount in the series
    /// </summary>
    public class NameSeriesCount
    {
        public string Name { get; set; }
        public List<NameValueCount> Series { get; set; } = [];

        public List<NameSeriesCount> Subgroups { get; set; } = [];
    }


    /// <summary>
    /// An expanded name-value pair with extra information
    /// </summary>
    public class NameValueCount
    {
        public string Name { get; set; }
        public double Value { get; set; }
        public int Count { get; set; }
    }
}
