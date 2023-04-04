//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;

namespace CSETWebCore.Helpers
{
    public interface ILocalInstallationHelper
    {
        void determineIfUpgradedNeededAndDoSo(int newuserID, CSETContext tmpContext);
        bool IsLocalInstallation();
    }
}