using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;


namespace CSETWebCore.Business.Authorization
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class CsetAuthorize : Attribute, IAuthorizationFilter
    {
        public async void OnAuthorization(AuthorizationFilterContext context)
        {
            var svc = context.HttpContext.RequestServices;
            var token = (ITokenManager)svc.GetService(typeof(ITokenManager));
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
                var isValid = await token.IsTokenValid(tokenString);
                if (!isValid)
                {
                    context.Result = new UnauthorizedResult();
                }
            }
        }
    }
}