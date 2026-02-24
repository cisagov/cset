//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Business.AssessmentIO.Import
{
    interface ICSETJSONFileUpgrade
    {
        string ExecuteUpgrade(string json);

        System.Version GetVersion();
    }
}
