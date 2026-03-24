//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Authentication;
using System.Security.Claims;
using System.Threading.Tasks;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface IUserAuthentication
    {
        LoginResponse Authenticate(Login login);

        Task<LoginResponse> AuthenticateStandalone(Login login, ITokenManager tokenManager);

        LoginResponse AuthenticateAccessKey(AnonymousLogin login);

        string GenerateAccessKey();

        Task<LoginResponse> ExchangeToken(ClaimsPrincipal user, string tzOffset, string scope);
    }
}