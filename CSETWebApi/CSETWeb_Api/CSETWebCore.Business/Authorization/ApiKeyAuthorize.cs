//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;
using System;

namespace CSETWebCore.Business.Authorization
{
    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Method)]
    public class ApiKeyAuthorize : Attribute, IAuthorizationFilter
    {
        public void OnAuthorization(AuthorizationFilterContext context)
        {
            IApiKeyManager apiKeyManager = (IApiKeyManager)context.HttpContext.RequestServices.GetService(typeof(IApiKeyManager));

            string apiKey = context.HttpContext.Request.Headers[Constants.Constants.API_KEY_HEADER_NAME].ToString();

            if (string.IsNullOrWhiteSpace(apiKey))
            {
                context.Result = new BadRequestResult();
                return;
            }

            if (!apiKeyManager.IsValidApiKey(apiKey))
            {
                context.Result = new UnauthorizedResult();
            }
        }
    }
}
