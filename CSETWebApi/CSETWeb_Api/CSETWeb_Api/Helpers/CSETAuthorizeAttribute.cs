//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Web.Http;
using System.Web.Http.Controllers;

namespace CSETWeb_Api.Helpers
{
    /// <summary>
    /// [Authorize] attribute that authenticates the security token in the request header. 
    /// </summary>
    public class CSETAuthorize : AuthorizeAttribute
    {
        protected override void HandleUnauthorizedRequest(HttpActionContext actionContext)
        {
            if (actionContext.Request.Headers.Authorization != null)
            {
                // The token will be either in the Scheme attribute, 
                // or if the Scheme is "Bearer" the token will be in the Parameter attribute.
                string tokenString = actionContext.Request.Headers.Authorization.Scheme;
                if (tokenString.Equals("Bearer", System.StringComparison.InvariantCultureIgnoreCase))
                {
                    tokenString = actionContext.Request.Headers.Authorization.Parameter;
                }

                if (!TransactionSecurity.IsTokenValid(tokenString))
                {
                    base.HandleUnauthorizedRequest(actionContext);
                }
            }
            else
            {
                base.HandleUnauthorizedRequest(actionContext);
            }
        }
    }
}

