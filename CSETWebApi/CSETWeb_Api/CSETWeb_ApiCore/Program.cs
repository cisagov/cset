using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using System.Reflection;
using CSETWebCore.DatabaseManager;
using System.IO;

namespace CSETWeb_ApiCore
{
    public class Program
    {
        public static void Main(string[] args)
        {
            var log4netRepository = log4net.LogManager.GetRepository(Assembly.GetEntryAssembly());
            log4net.Config.XmlConfigurator.Configure(log4netRepository, new FileInfo("log4net.config"));

            var host = CreateHostBuilder(args).Build();
            
            if (System.Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT") == "Production")
            {
                var config = (IConfigurationRoot)host.Services.GetService(typeof(IConfiguration));
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
                    config.AddJsonFile("appsettings.json", optional: true)
                        .AddJsonFile($"appsettings.{env.EnvironmentName}.json", optional: true);
                })
                .ConfigureWebHostDefaults(webBuilder =>
                {
                    webBuilder.UseStartup<Startup>();
                });
    }
}
