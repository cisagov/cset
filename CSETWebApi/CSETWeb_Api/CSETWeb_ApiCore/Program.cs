//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Logging;
using System.Reflection;
using CSETWebCore.DatabaseManager;
using System.IO;
using System;
using NLog.Web;



namespace CSETWeb_ApiCore
{
    public class Program
    {
        public static void Main(string[] args)
        {
            #region log4net - can we deprecate this later?
            var log4netRepository = log4net.LogManager.GetRepository(Assembly.GetEntryAssembly());
            log4net.Config.XmlConfigurator.Configure(log4netRepository, new FileInfo("log4net.config"));

            // debug - where are all the appenders?
            var appenders = log4netRepository.GetAppenders();
            #endregion




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
            .ConfigureLogging(logging =>
            {
                //logging.AddConfiguration(hostingContext.Configuration.GetSection("Logging")); //logging settings under appsettings.json
                //logging.AddConsole(); //Adds a console logger named 'Console' to the factory.
                //logging.AddDebug(); //Adds a debug logger named 'Debug' to the factory.
                //logging.AddEventSourceLogger(); //Adds an event logger named 'EventSource' to the factory.
                // Enable NLog as one of the Logging Provider                   logging.AddNLog(); 
                logging.ClearProviders();
                logging.AddNLogWeb();
                logging.SetMinimumLevel(Microsoft.Extensions.Logging.LogLevel.Information);
            }).UseNLog()
            .ConfigureWebHostDefaults(webBuilder =>
            {
                webBuilder.UseStartup<Startup>();
            });
    }
}
