//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Net;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Filters;

namespace CSETWebCore.Helpers
{
    public class ValidateMimeMultipartContentFilter : ActionFilterAttribute
    {
        public override void OnActionExecuting(ActionExecutingContext actionContext)
        {

            if (!MultipartRequestHelper.IsMultipartContentType(actionContext.HttpContext.Request.ContentType))
            {
                throw new Exception(HttpStatusCode.UnsupportedMediaType.ToString());
            }
        }

        public override void OnActionExecuted(ActionExecutedContext actionExecutedContext)
        {

        }
    }
}