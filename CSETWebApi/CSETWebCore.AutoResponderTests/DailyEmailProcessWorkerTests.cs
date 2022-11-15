using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.AutoResponder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.DependencyInjection;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Helpers;

namespace CSETWebCore.AutoResponder.Tests
{
    [TestClass()]
    public class DailyEmailProcessWorkerTests
    {
        private CSETContext context;

        [TestInitialize()]
        public void Initialize()
        {
            var builder = new ConfigurationBuilder()
               .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();

            var optionsBuilder = new DbContextOptionsBuilder<CSETContext>();
            optionsBuilder.UseSqlServer(configuration.GetConnectionString("CSET_DB"));
            this.context = new CSETContext(configuration);

        }

        [TestMethod()]
        public void ProcessEmailsTest()
        { 
            var host = CreateDefaultBuilder().Build();          
            using IServiceScope serviceScope = host.Services.CreateScope();
            IServiceProvider provider = serviceScope.ServiceProvider;            
            //do a simple daily first
            //then do the next day and see that the emails do not go out
            //then bring forward the date a week and see that they do go out a second time
            //then bring forward one day and see that they don't go out. 
            //then see that they don't go out on the weekend  -- ? do we care if they go out on the weekend?
            //then bring forward one more week and see it go out
            //finally last bring forward one more week and see that they don't go out. 
            var dailyInstance = provider.GetRequiredService<DailyEmailProcessWorker>();
            
            dailyInstance.NowDate = DateTime.Now;
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(1);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(7);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(8);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(14);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(15);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(21);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(22);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(28);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays(7*6);
            dailyInstance.ProcessEmails();
            
            dailyInstance.NowDate = DateTime.Now.AddDays((7 * 6)+1);
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays((7 * 10));
            dailyInstance.ProcessEmails();

            dailyInstance.NowDate = DateTime.Now.AddDays((7 * 10) + 1);
            dailyInstance.ProcessEmails();
        }

        private IHostBuilder CreateDefaultBuilder()
        {
            return Host.CreateDefaultBuilder()
                .ConfigureAppConfiguration(app =>
                {
                    app.AddJsonFile("appsettings.json");
                })
                .ConfigureServices(services =>
                {
                    services.AddSingleton<WeeklyStatusWorker>();
                    services.AddSingleton<DailyEmailProcessWorker>();
                    services.AddDbContext<CSETContext>(
                        options => options.UseSqlServer("name=ConnectionStrings:CSETWeb"));
                    services.AddTransient<IResourceHelper, ResourceHelper>();
                    services.AddTransient<IEmailHelper, EmailHelper>();

                });
        }
    }
}