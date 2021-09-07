using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers.ReportWidgets
{
    public class BarChartInput
    {
        public int Width { get; set; }
        public int Height { get; set; }

        public int Gap { get; set; }

        public List<int> AnswerCounts { get; set; }

        public List<string> BarColors { get; set; }

        public bool IncludePercentFirstBar = false;
    }
}
