//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;

namespace CSETWeb_Api.Helpers
{
    public class TokenManager
    {
        /// <summary>
        /// The deserialized instance of the JWT
        /// </summary>
        private JwtSecurityToken token = null;

        /// <summary>
        /// The encoded string as passed in each request
        /// </summary>
        private string tokenString = null;
        

        public String Token
        {
            get
            {
                return tokenString;
            }
        }
        /// <summary>
        /// If the token was sent with the Bearer scheme, this will prefix the actual token.
        /// </summary>
        private const string bearerToken = "Bearer ";


        public TokenManager(String tokenString)
        {
            this.tokenString = tokenString;
            Init(tokenString);
        }

        private void Init(String tokenString)
        {   
            // If no token was provided, do nothing.
            if (string.IsNullOrEmpty(tokenString))
            {
                return;
            }

            if (tokenString.StartsWith(bearerToken, StringComparison.InvariantCultureIgnoreCase))
            {
                tokenString = tokenString.Substring(bearerToken.Length);
            }

            if (!TransactionSecurity.IsTokenValid(tokenString))
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
            if (HttpContext.Current != null)
            {
                HttpRequest req = HttpContext.Current.Request;
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
            return TransactionSecurity.ReadTokenPayload(token, claim);
        }


        /// <summary>
        /// Returns a nullable int for convenience.  It is the consumer's  must know that the value
        /// it is looking for in the payload can be parsed as an int.
        /// </summary>
        /// <param name="claim"></param>
        /// <returns></returns>
        public int? PayloadInt(string claim)
        {
            var val = TransactionSecurity.ReadTokenPayload(token, claim);
            int result;
            bool b = int.TryParse(val, out result);
            if (b) return result;
            return null;
        }
    }
}

