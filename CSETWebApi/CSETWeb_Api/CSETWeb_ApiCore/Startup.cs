using CSETWebCore.Business.Acet;
using CSETWebCore.Business.AdminTab;
using CSETWebCore.Business.Assessment;
using CSETWebCore.Business.Common;
using CSETWebCore.Business.Contact;
using CSETWebCore.Business.Diagram;
using CSETWebCore.Business.Document;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Notification;
using CSETWebCore.Business.Question;
using CSETWebCore.Business.Sal;
using CSETWebCore.Business.Standards;
using CSETWebCore.Business.User;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.OpenApi.Models;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Acet;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.Sal;
using CSETWebCore.Interfaces.Standards;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using Microsoft.EntityFrameworkCore;

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
            services.AddCors(options =>
            {
                options.AddPolicy("AllowAll",
                    builder =>
                    {
                        builder.AllowAnyOrigin().AllowAnyMethod().AllowAnyHeader();
                    });
            });
            services.AddControllers();
            services.AddHttpContextAccessor();
            services.AddDbContext<CSETContext>(
                options => options.UseSqlServer("name=ConnectionStrings:CSET_DB"));

            //Helpers
            services.AddScoped<IUtilities, Utilities>();
            services.AddScoped<ITransactionSecurity, TransactionSecurity>();
            services.AddScoped<ITokenManager, TokenManager>();
            services.AddScoped<IAuthentication, Authentication>();
            services.AddScoped<IUserAuthentication, UserAuthentication>();
            services.AddScoped<IAssessmentUtil, AssessmentUtil>();
            services.AddScoped<IAuthentication, Authentication>();
            services.AddScoped<IPasswordHash, PasswordHash>();
            services.AddScoped<IResourceHelper, ResourceHelper>();
            
            //Business
            services.AddTransient<IAssessmentBusiness, AssessmentBusiness>();
            services.AddTransient<IHtmlFromXamlConverter, HtmlFromXamlConverter>();
            services.AddTransient<IACETDashboardBusiness, ACETDashboardBusiness>();
            services.AddTransient<IAdminTabBusiness, AdminTabBusiness>();
            services.AddTransient<IContactBusiness, ContactBusiness>();
            services.AddTransient<IMaturityBusiness, MaturityBusiness>();
            services.AddTransient<IQuestionBusiness, QuestionBusiness>();
            services.AddTransient<ISalBusiness, SalBusiness>();
            services.AddTransient<IStandardsBusiness, StandardsBusiness>();
            services.AddTransient<IStandardSpecficLevelRepository, StandardSpecficLevelRepository>();
            services.AddTransient<IQuestionRequirementManager, QuestionRequirementManager>();
            services.AddTransient<IDiagramManager, DiagramManager>();
            services.AddTransient<IDocumentBusiness, DocumentBusiness>();
            services.AddTransient<IAdminTabBusiness, AdminTabBusiness>();
            services.AddTransient<IHtmlFromXamlConverter, HtmlFromXamlConverter>();
            services.AddTransient<INotificationBusiness, NotificationBusiness>();
            services.AddTransient<IParameterContainer, ParameterContainer>();
            services.AddTransient<IQuestionPoco, QuestionPoco>();
            services.AddTransient<ISalBusiness, SalBusiness>();
            services.AddTransient<IUserBusiness, UserBusiness>();


            services.AddSwaggerGen(c =>
            {
                c.SwaggerDoc("v1", new OpenApiInfo { Title = "CSETWeb_ApiCore", Version = "v1" });
            });
        }

        // This method gets called by the runtime. Use this method to configure the HTTP request pipeline.
        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
                app.UseSwagger();
                app.UseSwaggerUI(c => c.SwaggerEndpoint("/swagger/v1/swagger.json", "CSETWeb_ApiCore v1"));
            }

            app.UseHttpsRedirection();

            app.UseRouting();

            app.UseCors("AllowAll");
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
