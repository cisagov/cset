using CSETWebCore.Business.ACETDashboard;
using CSETWebCore.Business.AdminTab;
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Assessment;
using CSETWebCore.Business.Common;
using CSETWebCore.Business.Contact;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.Document;
using CSETWebCore.Business.FileRepository;
using CSETWebCore.Business.Framework;
using CSETWebCore.Business.IRP;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.ModuleBuilder;
using CSETWebCore.Business.Notification;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.ReportEngine;
using CSETWebCore.Business.Reports;
using CSETWebCore.Business.RepositoryLibrary;
using CSETWebCore.Business.Sal;
using CSETWebCore.Business.Standards;
using CSETWebCore.Business.User;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.FileRepository;
using CSETWebCore.Interfaces.Framework;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.IRP;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.ModuleBuilder;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.ReportEngine;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Interfaces.ResourceLibrary;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Business.GalleryParser;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using System.IO;
using System.Linq;
using CSETWebCore.Interfaces.Crr;
using Newtonsoft.Json;
using Microsoft.AspNetCore.Rewrite;
using CSETWebCore.Interfaces.Analytics;
using CSETWebCore.Business.Analytics;
using System.Text.Json;

namespace CSETWeb_ApiCore
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddCors(o =>
            {
                o.AddPolicy(
                    name: "AllowAll",
                    builder =>
                    {
                        builder.AllowAnyOrigin()
                            .AllowAnyMethod()
                            .AllowAnyHeader();
                    });
            });

            services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            }).AddJwtBearer(options =>
            {
                options.SaveToken = true;
                options.RequireHttpsMetadata = false;
                options.TokenValidationParameters = new TokenValidationParameters()
                {
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });
            services.AddAuthorization();
            services.AddControllers()
                .AddNewtonsoftJson(options =>
                {
                    options.SerializerSettings.ReferenceLoopHandling = ReferenceLoopHandling.Ignore;
                    
                }).AddXmlDataContractSerializerFormatters();
            services.AddHttpContextAccessor();
            services.AddDbContext<CSETContext>(
                options => options.UseSqlServer(Configuration.GetConnectionString("CSET_DB")));

            //Services
            services.AddTransient<IAdminTabBusiness, AdminTabBusiness>();
            services.AddTransient<IAnalyticsBusiness, AnalyticsBusiness>();
            services.AddTransient<IAssessmentBusiness, AssessmentBusiness>();
            services.AddTransient<IAssessmentModeData, AssessmentModeData>();
            services.AddTransient<IAssessmentUtil, AssessmentUtil>();
            services.AddTransient<IContactBusiness, ContactBusiness>();
            services.AddTransient<IDemographicBusiness, DemographicBusiness>();
            services.AddTransient<ICisDemographicBusiness, CisDemographicBusiness>();
            services.AddTransient<IDiagramManager, DiagramManager>();
            services.AddTransient<IDocumentBusiness, DocumentBusiness>();
            services.AddTransient<IHtmlFromXamlConverter, HtmlFromXamlConverter>();
            services.AddTransient<IMaturityBusiness, MaturityBusiness>();
            services.AddTransient<INotificationBusiness, NotificationBusiness>();
            services.AddTransient<IParameterContainer, ParameterContainer>();
            services.AddTransient<IPasswordHash, PasswordHash>();
            services.AddTransient<IQuestionBusiness, QuestionBusiness>();
            services.AddTransient<IQuestionPoco, QuestionPoco>();
            services.AddTransient<IQuestionRequirementManager, QuestionRequirementManager>();
            services.AddTransient<IRequirementBusiness, RequirementBusiness>();
            services.AddTransient<IResourceHelper, ResourceHelper>();
            services.AddTransient<ISalBusiness, SalBusiness>();
            services.AddTransient<IStandardsBusiness, StandardsBusiness>();
            services.AddTransient<IStandardSpecficLevelRepository, StandardSpecficLevelRepository>();
            services.AddTransient<ITokenManager, TokenManager>();
            services.AddTransient<ILocalInstallationHelper, LocalInstallationHelper>();
            services.AddTransient<IUserAuthentication, UserAuthentication>();
            services.AddTransient<IUserBusiness, UserBusiness>();
            services.AddTransient<IUtilities, Utilities>();
            services.AddTransient<ITrendDataProcessor, TrendDataProcessor>();
            services.AddTransient<IACETDashboardBusiness, ACETDashboardBusiness>();
            services.AddTransient<IReportsDataBusiness, ReportsDataBusiness>();
            services.AddTransient<IAggregationBusiness, AggregationBusiness>();
            services.AddTransient<IFrameworkBusiness, FrameworkBusiness>();
            services.AddTransient<IModuleBuilderBusiness, ModuleBuilderBusiness>();
            services.AddTransient<IFlowDocManager, FlowDocManager>();
            services.AddTransient<IFileRepository, FileRepository>();
            services.AddTransient<IDataHandling, DataHandling>();
            services.AddTransient<ICrrScoringHelper, CrrScoringHelper>();
            services.AddTransient<IGalleryState, GalleryState>();
            services.AddTransient<IGalleryEditor, GalleryEditor>();
            services.AddScoped<IIRPBusiness, IRPBusiness>();


            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "CSETWeb_ApiCore", Version = "v1" });
                c.ResolveConflictingActions(apiDescription => apiDescription.First());
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c =>
                {
                    c.SwaggerEndpoint("/swagger/v1/swagger.json", "CSETWeb_ApiCore v1");
                });
            }

            System.AppDomain.CurrentDomain.SetData("ContentRootPath", env.ContentRootPath);
            System.AppDomain.CurrentDomain.SetData("WebRootPath", env.WebRootPath);

            using (StreamReader iisUrlRewriteStreamReader =
            File.OpenText("IISUrlRewrite.xml"))
            {
                var options = new RewriteOptions()
                    .AddIISUrlRewrite(iisUrlRewriteStreamReader);
                 app.UseRewriter(options);
            }

            // Serve up index.html from webapp when root url is hit
            app.UseRewriter(new RewriteOptions().AddRewrite("^$", "index.html", true));
 
            //app.UseHttpsRedirection();
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(
                    Path.Combine(env.ContentRootPath, "Diagram")),
                RequestPath = "/Diagram"
            });
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(
                    Path.Combine(env.ContentRootPath, "Documents")),
                RequestPath = "/Documents"
            });
            app.UseStaticFiles(new StaticFileOptions
            {
                FileProvider = new PhysicalFileProvider(
                    Path.Combine(env.ContentRootPath, "WebApp")),
                RequestPath = ""
            });
            app.UseRouting();
            app.UseCors("AllowAll");
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
