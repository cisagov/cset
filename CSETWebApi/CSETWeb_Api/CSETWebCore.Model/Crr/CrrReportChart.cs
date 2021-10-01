using System.Collections.Generic;

namespace CSETWebCore.Model.Crr
{
    public class CrrReportChart
    {
        public List<string> Labels { get; set; } = new List<string>();
        public List<int> Values { get; set; } = new List<int>();
    }
}