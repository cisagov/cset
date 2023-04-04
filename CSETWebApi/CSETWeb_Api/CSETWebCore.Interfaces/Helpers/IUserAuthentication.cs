//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Authentication;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        LoginResponse Authenticate(Login login);

        LoginResponse AuthenticateStandalone(Login login, ITokenManager tokenManager);

        LoginResponse AuthenticateAccessKey(AnonymousLogin login);
        string GenerateAccessKey();
    }
}