//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    interface ICSETJSONFileUpgrade
    {
        string ExecuteUpgrade(string json);

        System.Version GetVersion();
    }
}
