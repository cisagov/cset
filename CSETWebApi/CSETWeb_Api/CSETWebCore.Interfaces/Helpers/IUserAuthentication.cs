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
       
    }
}