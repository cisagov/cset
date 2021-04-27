using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Helpers
{
    public class TokenManager : ITokenManager
    {
        private const string _bearerToken = "Bearer ";
        private JwtSecurityToken token = null;
        private string tokenString = null;
        private IHttpContextAccessor _httpContext;
        private readonly ITransactionSecurity _transactionSecurity;

        public TokenManager(IHttpContextAccessor httpContext, ITransactionSecurity transactionSecurity)
        {
            _httpContext = httpContext;
            _transactionSecurity = transactionSecurity;
        }

        public void SetToken(string tokenString)
        {
            this.tokenString = tokenString;
            Init(tokenString);
        }

        public void Init(string tokenString)
        {
            // If no token was provided, do nothing.
            if (string.IsNullOrEmpty(tokenString))
            {
                return;
            }

            if (tokenString.StartsWith(_bearerToken, StringComparison.InvariantCultureIgnoreCase))
            {
                tokenString = tokenString.Substring(_bearerToken.Length);
            }

            if (!_transactionSecurity.IsTokenValid(tokenString))
            {
                throw new Exception("JWT invalid");
            }

            // Convert to token 
            var handler = new JwtSecurityTokenHandler();
            token = handler.ReadJwtToken(tokenString);
        }

        /// <summary>
        /// Creates an instance of TokenManager and populates it with 
        /// the Authorization token in the current HTTP request.
        /// </summary>
        /// <param name="tokenString"></param>
        public TokenManager()
        {
            /* Get the token string from the Authorization header and
               strip off the Bearer prefix if present. */
            
            if (_httpContext.HttpContext != null)
            {
                HttpRequest req = _httpContext.HttpContext.Request; 
                tokenString = req.Headers["Authorization"];
                Init(tokenString);
            }
        }

        /// <summary>
        /// This just wraps the static method of the same name in TransactionSecurity.
        /// To see a list of claims we build into the token, see TransactionSecurity.GenerateToken()
        /// </summary>
        /// <returns></returns>
        public string Payload(string claim)
        {
            return _transactionSecurity.ReadTokenPayload(token, claim);
        }


        /// <summary>
        /// Returns a nullable int for convenience.  It is the consumer's  must know that the value
        /// it is looking for in the payload can be parsed as an int.
        /// </summary>
        /// <param name="claim"></param>
        /// <returns></returns>
        public int? PayloadInt(string claim)
        {
            var val = _transactionSecurity.ReadTokenPayload(token, claim);
            int result;
            bool b = int.TryParse(val, out result);
            if (b) return result;
            return null;
        }
    }
}
