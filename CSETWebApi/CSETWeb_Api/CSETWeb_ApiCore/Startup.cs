//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Api.Error;
using CSETWebCore.Business.Aggregation;
using CSETWebCore.Business.Analytics;
using CSETWebCore.Business.Assessment;
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.Business.Common;
using CSETWebCore.Business.Contact;
using CSETWebCore.Business.Demographic;
using CSETWebCore.Business.Demographic.Import;
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.Document;
using CSETWebCore.Business.FileRepository;
using CSETWebCore.Business.Framework;
using CSETWebCore.Business.GalleryParser;
using CSETWebCore.Business.Malcolm;
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
using CSETWebCore.Business.Version;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Aggregation;
using CSETWebCore.Interfaces.Analytics;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Cmu;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Demographic;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.FileRepository;
using CSETWebCore.Interfaces.Framework;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Malcolm;
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
using CSETWebCore.Interfaces.Version;
using CSETWebCore.Model.Auth;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Rewrite;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.FileProviders;
using Microsoft.Extensions.Hosting;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;


namespace CSETWeb_ApiCore
{
    public class Startup
    {
        private readonly IWebHostEnvironment _env;

        public Startup(IConfiguration configuration, IWebHostEnvironment env)
        {
            Configuration = configuration;
            _env = env;
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
                            .AllowAnyHeader()
                            .WithExposedHeaders("content-disposition");
                    });

                o.AddPolicy(
                    name: "DynamicOrigins",
                    builder =>
                {
                    var allowedOrigins = Configuration
                        .GetSection("Cors:AllowedOrigins")
                        .Get<string[]>();

                    builder.WithOrigins(allowedOrigins)
                          .AllowAnyMethod()
                          .WithHeaders("content-type", "authorization", "noauth", "cset-noauth", "cset-scope", "cset-tzoffset", "expseconds", "remoteauthorization", "refresh", "accept", "assessmentid", "aggregationid", "pwd")
                          .WithExposedHeaders("content-disposition");
                });
            });

           

            var authBuilder = services.AddAuthentication(options =>
            {
                options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
                options.DefaultScheme = JwtBearerDefaults.AuthenticationScheme;
            })
            .AddJwtBearer(options =>
            {
                options.SaveToken = true;
                options.RequireHttpsMetadata = false;
                options.TokenValidationParameters = new TokenValidationParameters()
                {
                    ValidateIssuer = false,
                    ValidateAudience = false
                };
            });


            // Configure OIDC authentication if configured to do so
            var authSettings = Configuration.GetSection("Auth").Get<AuthSettings>();

            if (authSettings.OIDC?.Authority != null)
            {
                authBuilder.AddJwtBearer("OIDC", options =>
                {
                    options.Authority = authSettings.OIDC.Authority;
                    options.Audience = authSettings.OIDC.Audience;
                    options.RequireHttpsMetadata = !_env.IsDevelopment();

                    options.Events = new JwtBearerEvents
                    {
                        OnAuthenticationFailed = ctx =>
                        {
                            Console.WriteLine($"OIDC auth failed: {ctx.Exception}");
                            return Task.CompletedTask;
                        },
                        OnTokenValidated = ctx =>
                        {
                            Console.WriteLine("OIDC token validated successfully");
                            return Task.CompletedTask;
                        }
                    };
                });
            }


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
            services.AddTransient<ICmuScoringHelper, CmuScoringHelper>();
            services.AddTransient<IApiKeyManager, ApiKeyManager>();
            services.AddTransient<IImportManager, ImportManager>();
            services.AddTransient<IDemographicsImportManager, DemographicsImportManager>();
            services.AddTransient<ILocalInstallationHelper, LocalInstallationHelper>();
            services.AddTransient<IUserAuthentication, UserAuthentication>();
            services.AddTransient<IUserBusiness, UserBusiness>();
            services.AddTransient<IUtilities, Utilities>();
            services.AddTransient<ITrendDataProcessor, TrendDataProcessor>();
            services.AddTransient<IReportsDataBusiness, ReportsDataBusiness>();
            services.AddTransient<IAggregationBusiness, AggregationBusiness>();
            services.AddTransient<IFrameworkBusiness, FrameworkBusiness>();
            services.AddTransient<IModuleBuilderBusiness, ModuleBuilderBusiness>();
            services.AddTransient<IFlowDocManager, FlowDocManager>();
            services.AddTransient<IFileRepository, FileRepository>();
            services.AddTransient<IDataHandling, DataHandling>();
            services.AddTransient<IGalleryState, GalleryState>();
            services.AddTransient<IGalleryEditor, GalleryEditor>();
            services.AddTransient<IMalcolmBusiness, MalcolmBusiness>();
            services.AddTransient(provider =>
                new JSONAssessmentExportManager(
                    provider.GetRequiredService<IAssessmentBusiness>(),
                    provider.GetRequiredService<IContactBusiness>(),
                    provider.GetRequiredService<IReportsDataBusiness>(),
                    provider.GetRequiredService<IQuestionBusiness>(),
                    provider.GetRequiredService<IAssessmentUtil>(),
                    provider.GetRequiredService<IQuestionRequirementManager>(),
                    provider.GetRequiredService<ITokenManager>(),
                    provider.GetRequiredService<ICisDemographicBusiness>(),
                    provider.GetRequiredService<CSETContext>()
                ));
            services.AddScoped<IVersionBusiness, VersionBusiness>();
            services.AddScoped<Hooks>();

            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "CSETWeb_ApiCore", Version = "v1" });
                c.ResolveConflictingActions(apiDescription => apiDescription.First());

                // Include 'SecurityScheme' to use JWT Authentication
                var jwtSecurityScheme = new OpenApiSecurityScheme
                {
                    BearerFormat = "JWT",
                    Name = "JWT Authentication",
                    In = ParameterLocation.Header,
                    Type = SecuritySchemeType.Http,
                    Scheme = JwtBearerDefaults.AuthenticationScheme,
                    Description = "Put **_ONLY_** your JWT Bearer token on textbox below!",

                    Reference = new OpenApiReference
                    {
                        Id = JwtBearerDefaults.AuthenticationScheme,
                        Type = ReferenceType.SecurityScheme
                    }
                };

                c.AddSecurityDefinition(jwtSecurityScheme.Reference.Id, jwtSecurityScheme);

                c.AddSecurityRequirement(new OpenApiSecurityRequirement
                {
                    { jwtSecurityScheme, Array.Empty<string>() }
                });
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
            app.ConfigureExceptionHandler();
            app.UseRouting();
            app.UseCors("DynamicOrigins");
            app.UseAuthentication();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
