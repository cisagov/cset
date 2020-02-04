//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.Version;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Versioning;
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
            TransactionSecurity.GenerateSecret();
            GlobalConfiguration.Configuration.UseSqlServerStorage("HangfireConn").UseConsole();
            VersionHandler version = new VersionHandler();
            VersionInjected.VersionString = version.CSETVersionString;
            VersionInjected.Version = VersionHandler.Version;

            app.UseHangfireDashboard();
            app.UseHangfireServer();
            //SwaggerConfig.Register();
            //app.UseWebApi(WebApiConfig.Register());
        }
    }
}


