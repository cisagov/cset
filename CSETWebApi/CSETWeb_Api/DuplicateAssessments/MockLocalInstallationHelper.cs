using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;

namespace DuplicateAssessments
{
    internal class MockLocalInstallationHelper : ILocalInstallationHelper
    {
        public void determineIfUpgradedNeededAndDoSo(int newuserID, CSETContext tmpContext)
        {   
        }

        public bool IsLocalInstallation()
        {
            return false;
        }
    }
}