using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;


namespace CSETWebCore.Business.Authorization
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class CsetAuthorize : Attribute, IAuthorizationFilter
    {
        public CsetAuthorize()
        {
        }

        public void OnAuthorization(AuthorizationFilterContext context)
        {
            string tokenString = context.HttpContext.Request.Scheme;
            System.Diagnostics.Debug.WriteLine(tokenString);

            var authHeader = context.HttpContext.Request.Headers["Authorization"];

            if (authHeader.Count == 0)
            {
                return;
            }

            var authHeaderValue = authHeader.ToString().Split(" ");
            if (authHeaderValue.Length == 2 && authHeaderValue[0].ToLower() == "bearer")
            {
                tokenString = authHeaderValue[1];
            }
            else
            {
                tokenString = authHeaderValue[0];
            }

            if (!string.IsNullOrEmpty(tokenString))
            {
                if (!IsTokenValid(tokenString).Result)
                {
                    context.Result = new UnauthorizedResult();
                }
            }
        }


        private async Task<bool> IsTokenValid(string tokenString)
        {
            JwtSecurityToken token = null;

            try
            {
                var handler = new JwtSecurityTokenHandler();

                // Convert to token so that we can read the user to use in the signing key test
                token = handler.ReadJwtToken(tokenString);

                // Configure expected validation parameters
                var parms = new Microsoft.IdentityModel.Tokens.TokenValidationParameters()
                {
                    RequireExpirationTime = true,
                    ValidAudience = "CSET_AUD",
                    ValidIssuer = "CSET_ISS",
                    IssuerSigningKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret().Result + token.Payload[CSETWebCore.Constants.Constants.Token_UserId]))
                };

                Microsoft.IdentityModel.Tokens.SecurityToken validatedToken;
                var principal = handler.ValidateToken(tokenString, parms, out validatedToken);
            }
            catch (ArgumentException ae)
            {
                return false;
            }
            catch (Exception e)
            {
                return false;
            }


            // see if the token has expired
            if (token.ValidTo < DateTime.UtcNow)
            {
                return false;
            }

            return true;
        }

        private async Task<string> GetSecret()
        {
            var context = new CSETContext();

            string secret = null;

            var taskInst = await context.INSTALLATION.FirstOrDefaultAsync();
            if (taskInst != null)
            {
                secret = taskInst.JWT_Secret;
                return taskInst.JWT_Secret;
            }


            // This is the first run of CSET -- generate a new secret and installation identifier
            string newSecret = null;
            string newInstallID = null;

            var byteArray = new byte[(int)Math.Ceiling(130 / 2.0)];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(byteArray);
                newSecret = String.Concat(Array.ConvertAll(byteArray, x => x.ToString("X2")));
            }

            newInstallID = Guid.NewGuid().ToString();


            // Store the new secret and installation ID
            var installRec = new INSTALLATION
            {
                JWT_Secret = newSecret,
                Generated_UTC = DateTime.UtcNow,
                Installation_ID = newInstallID
            };
            context.INSTALLATION.Add(installRec);

            context.SaveChanges();
            return newSecret;

        }
    }
}