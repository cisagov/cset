using System;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Authentication;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        Task<LoginResponse> Authenticate(Login login);
        Task<LoginResponse> AuthenticateStandalone(Login login, ITokenManager tokenManager);
        Task DetermineIfUpgradedNeededAndDoSo(int newuserID, CSETContext tmpContext);
        bool IsLocalInstallation(String app_code);
    }
}