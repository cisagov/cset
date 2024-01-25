//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.DatabaseManager;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Reflection;
using CSETWebCore.DataLayer.Model;
using System.Net;
using Microsoft.Data.SqlClient;
using System.Data;
using static System.Runtime.InteropServices.JavaScript.JSType;
using System.Diagnostics;
using UpgradeLibrary.Upgrade;
using CSETWebCore.Api.Controllers;
using CSETWebCore.Business.AssessmentIO.Export;
using Microsoft.AspNetCore.Http;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Authentication;
using CSETWebCore.Helpers;
using CSETWebCore.Business.Maturity;
using DocumentFormat.OpenXml.InkML;
using System.Configuration;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;

namespace CSETWebCore.DatabaseManager.Tests
{
    [TestClass()]
    public class ImportExportTests
    {
        private CSETContext? context;
        private TokenManager? tokenManager;
        private LocalInstallationHelper? localHelper;
        private PasswordHash? passwordHash;
        private IConfiguration? config;

        [TestInitialize()]
        public void Initialize()
        {
            var builder = new ConfigurationBuilder()
               .AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
            var configuration = builder.Build();

            var optionsBuilder = new DbContextOptionsBuilder<CSETContext>();
            optionsBuilder.UseSqlServer(configuration.GetConnectionString("CSET_DB"));
            this.context = new CSETContext(configuration);

            var host = CreateDefaultBuilder().Build();
            using IServiceScope serviceScope = host.Services.CreateScope();
            IServiceProvider provider = serviceScope.ServiceProvider;

            tokenManager = provider.GetRequiredService<TokenManager>();
            localHelper = provider.GetRequiredService<LocalInstallationHelper>();
            passwordHash = provider.GetRequiredService<PasswordHash>();
            config = configuration;

        }

        [TestMethod()]
        public void ImportAllAssessmentsTest()
        {
            string clientCode = "DHS";
            string appCode = "CSET";
            DbManager manager = new DbManager(new Version("12.0.1.3"), clientCode, appCode);
        }

        [TestMethod()]
        public void ExportAllAssessmentsTest()
        {
            //setup a copy file
            //setup a destination file            
            UserAuthentication userAuth = new UserAuthentication(passwordHash, null, localHelper, tokenManager, null, config, context);
            Login login = new Login { Email = null, Password = null, TzOffset = "300", Scope = "CSET" };

            string loginToken = userAuth.AuthenticateStandalone(login, tokenManager).Token;

#pragma warning disable CS8602 // Dereference of a possibly null reference.
            var assessments = context.ASSESSMENTS.Select(x => x.Assessment_Id).AsEnumerable();
#pragma warning restore CS8602 // Dereference of a possibly null reference.

            for (int i = 0; i < assessments.Count(); i++)
            {
                int assess_Id = assessments.ElementAt(i);

            }

            //run the same test twice and make sure that the number increment works
            //string mdf = $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}\\CSETWeb.mdf";
            //string ldf = $"{Environment.GetFolderPath(Environment.SpecialFolder.UserProfile)}\\CSETWeb_log.ldf";
            //string conString = "Server=(localdb)\\mssqllocaldb;Integrated Security=true;AttachDbFileName=" + mdf;
            //using (SqlConnection conn = new SqlConnection(conString))
            //{
            //    conn.Open();
            //    SqlCommand cmd = conn.CreateCommand();

            //cmd.CommandText = "INSERT INTO [dbo].[ASSESSMENT_CONTACTS]\r\n           " +
            //    "([Assessment_Id]\r\n\t\t    " +
            //    ",[PrimaryEmail]\r\n           " +
            //    ",[FirstName]\r\n           " +
            //    ",[LastName]\r\n           " +
            //    ",[Invited]\r\n           " +
            //    ",[AssessmentRoleId]\r\n           " +
            //    ",[UserId])\r\n" +
            //    "select distinct e.* from assessment_contacts d right join (\r\n" +
            //        "select a.assessment_id,c.* from assessments a, (\r\n" +
            //        "SELECT \r\n       " +
            //        "[PrimaryEmail]\r\n      " +
            //        ",[FirstName]\r\n      " +
            //        ",[LastName]\r\n      " +
            //        ",[Invited]\r\n      " +
            //        ",[AssessmentRoleId]\r\n      " +
            //        ",[UserId]\t  \r\n  " +
            //        "FROM [dbo].[ASSESSMENT_CONTACTS]\r\n  " +
            //        "where assessment_contact_id = 31331\r\n" +
            //    ") c ) e on d.assessment_id=e.assessment_id and d.userid = e.userid\r\n" +
            //    "where d.assessment_id is null";

            //cmd.CommandText = "select * from ASSESSMENTS;";
            //SqlDataReader reader = cmd.ExecuteReader();
            //while (reader.Read())
            //{
            //    Assert.IsNotNull(reader.GetInt32(0)); //checks assess_id
            //    Assert.IsNotNull(reader.GetInt32(2)); //checks creator_id
            //    var context = new CSETContext();

            //    var tokenManager = new TokenManager(null,null,null, context);
            //    string token = tokenManager.GenerateToken(reader.GetInt32(2), null, "360", -1, null, null, "CSET");

            //    //var tokenControl = new AuthController(null, null, null);

            //    var exportControl = new AssessmentExportController(null, context, null);
            //    //var loginObject = new Login("email", "pass", "offset", "scope");

            //    //string tokenString = tokenControl.IssueToken(reader.GetInt32(0), -1, "*default*", 5000).ToString();
            //    exportControl.ExportAssessment(token);

            //}

            //manager.


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
                    services.AddDbContext<CSETContext>(
                        options => options.UseSqlServer("name=ConnectionStrings:CSETWeb"));
                    services.AddTransient<IResourceHelper, ResourceHelper>();
                    services.AddTransient<ILocalInstallationHelper, LocalInstallationHelper>();
                    services.AddTransient<IHttpContextAccessor, HttpContextAccessor>();
                });
        }

    }
}