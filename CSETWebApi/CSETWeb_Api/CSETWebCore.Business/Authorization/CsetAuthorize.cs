//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Diagnostics.Contracts;

using System.Linq;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using Microsoft.EntityFrameworkCore;


namespace CSETWebCore.Business.Authorization
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class CsetAuthorize : Attribute, IAuthorizationFilter
    {
        public void OnAuthorization(AuthorizationFilterContext context)
        {
            if (SkipAuthorization(context))
            {
                return;
            }

            var svc = context.HttpContext.RequestServices;
            var token = (ITokenManager)svc.GetService(typeof(ITokenManager));
            string tokenString = context.HttpContext.Request.Scheme;
            System.Diagnostics.Debug.WriteLine(tokenString);

            var authHeader = context.HttpContext.Request.Headers["Authorization"];

            if (authHeader.Count == 0)
            {
                context.Result = new UnauthorizedResult();
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

            if (string.IsNullOrEmpty(tokenString) || !token.IsTokenValid(tokenString))
            {
                context.Result = new UnauthorizedResult();
            }
        }

        private bool SkipAuthorization(AuthorizationFilterContext context)
        {
            Contract.Assert(context != null);

            return context.ActionDescriptor.EndpointMetadata.OfType<AllowAnonymousAttribute>().Any();
        }
    }
}