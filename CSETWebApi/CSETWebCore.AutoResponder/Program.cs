using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using NLog.Web;
using System.Reflection;

namespace CSETWebCore.AutoResponder
{
    internal class Program
    {

        static Program(){
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="args"></param>
        static void Main(string[] args)
        {
            bool test = false;
            if(args.Length > 1)
            {
                test = true;
            }

            // Setup Host
            var host = CreateDefaultBuilder().Build();
            // Invoke Worker
            using IServiceScope serviceScope = host.Services.CreateScope();
            IServiceProvider provider = serviceScope.ServiceProvider;
            if(DayOfWeek.Monday == DateTime.Now.DayOfWeek || test)
            {
                var workerInstance = provider.GetRequiredService<WeeklyStatusWorker>();
                workerInstance.ProcessEmails();
            }
            var dailyInstance = provider.GetRequiredService<DailyEmailProcessWorker>();
            dailyInstance.ProcessEmails();
            
        }

        static IHostBuilder CreateDefaultBuilder()
        {
            return Host.CreateDefaultBuilder()
                .ConfigureAppConfiguration(app =>
                {
                    app.AddJsonFile("appsettings.json");
                })
                .ConfigureLogging(l => { }).UseNLog()
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

    // Worker.cs
    public class WeeklyStatusWorker
    {
        private readonly IConfiguration configuration;
        private readonly CSETContext _context;
        private readonly IEmailHelper _emailHelper;

        public WeeklyStatusWorker(IConfiguration configuration, CSETContext context, IEmailHelper emailHelper)
        {
            this.configuration = configuration;
            this._context = context;
            this._emailHelper = emailHelper;
        }

        public void ProcessEmails()
        {

            ExcelProcess excel = new ExcelProcess();
#pragma warning disable CS8604 // Possible null reference argument.
            string path = excel.BuildSheet(_context, configuration.GetValue<string>("ExcelWorkBookPassword"));

            foreach(var email in configuration.GetSection("Notifications:Weekly").GetChildren())
            {

                _emailHelper.SendWeekly(path,
                    email.GetValue<string>("email"),
                    email.GetValue<string>("FirstName"),
                    email.GetValue<string>("LastName"));
#pragma warning restore CS8604 // Possible null reference argument.
            }
                


            
        }
        /**
         * I need this to fire up on weekly basis 
         * and run the one query create an excel spreadsheet with items selected
         * create an email with the spreadsheet attached (send to leigh ann)
         * 
         * Create an email with the simple report data (send to Bryan and Emilio)
         * 
         * Create an email for each of the recipients that did not complete the assessment (send to recipient)
         * mark the database for each recipient so that we do not send again. 
         */

      
    }



}
