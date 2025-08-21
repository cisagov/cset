//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Threading.Tasks;
using CSETWebCore.Model.Authentication;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        LoginResponse Authenticate(Login login);

        Task<LoginResponse> AuthenticateStandalone(Login login, ITokenManager tokenManager);

        LoginResponse AuthenticateAccessKey(AnonymousLogin login);
        string GenerateAccessKey();
    }
}