using CSETWebCore.Model.Authentication;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        LoginResponse Authenticate(Login login);
        LoginResponse AuthenticateStandalone(Login login, ITokenManager tokenManager);
        string GenerateAccessKey();
    }
}