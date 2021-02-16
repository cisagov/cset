//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Helpers;
using System.Configuration;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using Newtonsoft.Json;

namespace CSETWeb_Api
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();
            GlobalConfiguration.Configure(WebApiConfig.Register);
            GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings.ReferenceLoopHandling =
                ReferenceLoopHandling.Ignore;
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            RouteConfig.RegisterRoutes(RouteTable.Routes);
            //BundleConfig.RegisterBundles(BundleTable.Bundles);
            NotificationManager.SetConfigurationManager(new ConfigWrapper());
        }
    }
}


public class ConfigWrapper: IConfigurationManager
{
    public string GetAppSetting(string key)
    {
        return ConfigurationManager.AppSettings[key];
    }

}


