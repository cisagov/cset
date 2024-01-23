//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using CSETWebCore.DatabaseManager;
using System;
using NLog.Web;


namespace CSETWeb_ApiCore
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var host = CreateHostBuilder(args).Build();

            var hostEnvironment = (IHostEnvironment)host.Services.GetService(typeof(IHostEnvironment));
            var config = (IConfiguration)host.Services.GetService(typeof(IConfiguration));

            string isEnterpriseInstallation = config.GetSection("EnterpriseInstallation").Value;

            if (hostEnvironment.EnvironmentName == "Production" && !Convert.ToBoolean(isEnterpriseInstallation))
            {
                string clientCode = config.GetSection("ClientCode").Value;
                string appCode = config.GetSection("AppCode").Value;

                DbManager dbManager = new DbManager(Assembly.GetExecutingAssembly().GetName().Version, clientCode, appCode);
                dbManager.SetupDb();
            }

            host.Run();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        /// <returns></returns>
        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
            .ConfigureLogging(l => { }).UseNLog()
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<Startup>();
            });
    }
}
