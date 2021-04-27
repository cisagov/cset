using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;

namespace CSETWebCore.Interfaces.Helpers
{
    public interface ITokenManager
    {
        void SetToken(String tokenString);
        void Init(string tokenString);
        string Payload(string claim);
        int? PayloadInt(string claim);
    }
}
