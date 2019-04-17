//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CSET_Main.ReportEngine.Common
{
    public interface IReportStatus
    {
        void SendUpdateMessage(String message);
    }
}


