using System;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Model.Authentication;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        LoginResponse Authenticate(Login login);
        LoginResponse AuthenticateStandalone(Login login, ITokenManager tokenManager);
        void determineIfUpgradedNeededAndDoSo(int newuserID, CSETContext tmpContext);
        bool IsLocalInstallation(String app_code);
    }
}