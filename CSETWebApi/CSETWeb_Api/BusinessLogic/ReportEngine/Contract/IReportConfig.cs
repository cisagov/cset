//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSET_Main.ReportEngine.Contract
{
    public interface IReportConfig
    {
        int GetCount { get; }
        List<string> OutputTypes { get; }
        bool PrintComparison { get; set; }
        bool PrintDetail { get; set; }
        bool PrintDocx { get; set; }
        bool PrintExecutive { get; set; }
        bool PrintComponentsGapAnalysis { get; set; }
        bool PrintPdf { get; set; }
        bool PrintRTF { get; set; }
        bool PrintSecurityPlan { get; set; }
        bool PrintSiteSummary { get; set; }
        bool PrintTrend { get; set; }
    }
}

