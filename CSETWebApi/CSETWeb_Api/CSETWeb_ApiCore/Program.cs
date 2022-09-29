using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using CSETWebCore.DatabaseManager;
using System.IO;
using System;

namespace CSETWeb_ApiCore
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var log4netRepository = log4net.LogManager.GetRepository(Assembly.GetEntryAssembly());
            log4net.Config.XmlConfigurator.Configure(log4netRepository, new FileInfo("log4net.config"));

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

        public static IHostBuilder CreateHostBuilder(string[] args) =>
            Host.CreateDefaultBuilder(args)
                .ConfigureAppConfiguration((hostingContext, config) =>
                {
                    var env = hostingContext.HostingEnvironment;
                    config.AddJsonFile("appsettings.json", optional: false)
                        .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true);
                    config.AddEnvironmentVariables();
                })
                
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
