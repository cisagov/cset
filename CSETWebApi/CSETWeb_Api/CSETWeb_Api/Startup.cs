//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Web.Optimization;
using System.Web.Routing;
using CSETWeb_Api.BusinessLogic;
using Hangfire;
using Hangfire.Console;
using Microsoft.Owin;
using Owin;

[assembly: OwinStartup(typeof(CSETWeb_Api.Startup))]

namespace CSETWeb_Api
{
    public class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            //AreaRegistration.RegisterAllAreas();
            //FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            //RouteConfig.RegisterRoutes(RouteTable.Routes);
            //BundleConfig.RegisterBundles(BundleTable.Bundles);
            //NotificationManager.SetConfigurationManager(new ConfigWrapper());
            // For more information on how to configure your application, visit https://go.microsoft.com/fwlink/?LinkID=316888    
            GlobalConfiguration.Configuration.UseSqlServerStorage("HangfireConn").UseConsole();

            app.UseHangfireDashboard();
            app.UseHangfireServer();
            //SwaggerConfig.Register();
            //app.UseWebApi(WebApiConfig.Register());
        }
    }
}


