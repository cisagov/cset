using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Helpers
{
    public interface ILocalInstallationHelper
    {
        Task DetermineIfUpgradedNeededAndDoSo(int newuserID);
        bool IsLocalInstallation();
    }
}