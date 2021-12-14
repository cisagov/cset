using System;
using CSETWebCore.Model.Authentication;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        LoginResponse Authenticate(Login login);
        LoginResponse AuthenticateStandalone(Login login);
        void determineIfUpgradedNeededAndDoSo(int newuserID);
        bool IsLocalInstallation(String app_code);
    }
}