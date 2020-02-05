//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http.Headers;
using System.Web.Http;
using System.Web.Http.Cors;

namespace CSETWeb_Api
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Configure the CORS parameters
            string allowedOrigin = ConfigurationManager.AppSettings["CORS Allowed Origin"];
            var cors = new EnableCorsAttribute(allowedOrigin, "*", "*");

            config.EnableCors(cors);


            // Web API configuration and services
            config.Formatters.JsonFormatter.SupportedMediaTypes.Add(new MediaTypeHeaderValue("text/html"));
            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{email}",
                defaults: new { email = RouteParameter.Optional }
            );
        }
    }
}


