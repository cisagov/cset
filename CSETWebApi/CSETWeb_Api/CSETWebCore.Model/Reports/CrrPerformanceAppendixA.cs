using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Model.Reports
{
    public class CrrPerformanceAppendixA
    {
        public string TotalBarChart { get; set; }
        public string CrrPerformanceLegend { get; set; }    

        public DomainSummary[] DomainSummaryList { get; set; }  
    }

    public class DomainSummary
    {
        public string DomainTitle { get; set; } 
        public string BarChart { get; set; }    

        public string MilHeatMapSvg1 { get; set; }  

        public string MilHeatMapSvg2 { get; set; }  

        public string MilHeatMapSvg3 { get; set; }

        public string MilHeatMapSvg4 { get; set; }

        public string MilHeatMapSvg5 { get; set; }
    }
}
