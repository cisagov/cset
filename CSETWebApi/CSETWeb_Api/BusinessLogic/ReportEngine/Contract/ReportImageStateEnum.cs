//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSET_Main.ReportEngine.Contract
{
    [Flags]
    public enum ReportImageStateEnum
    {
        None = 0x0,    
        Executive = 0x1,
        SiteSummary =0x2,
        Detail = 0x4,
        SecurityPlan = 0x8,
        Trend = 0x10,
        Compare = 0x20
    }
}


