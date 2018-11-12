//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.Owin;
using Owin;
using System.Web.Http;
using Microsoft.Owin.Hosting;
using System;
using System.Linq;
using Microsoft.Practices.Unity;
using System.Web.Http.Filters;
using System.Net.Http;
using Unity.Lifetime;
using Unity.Injection;

[assembly: OwinStartup(typeof(Unity.SelfHostWebApiOwin.Startup))]

namespace Unity.SelfHostWebApiOwin
{
    public class Startup
    {
        private static readonly IUnityContainer _container = UnityHelpers.GetConfiguredContainer();

        // Your startup logic
        public static void StartServer()
        {
            string baseAddress = "http://localhost:8081/";
            var startup = _container.Resolve<Startup>();
             //options.ServerFactory = "Microsoft.Owin.Host.HttpListener"
            IDisposable webApplication = WebApp.Start(baseAddress, startup.Configuration);

            try
            {
                Console.WriteLine("Started...");

                Console.ReadKey();
            }
            finally
            {
                webApplication.Dispose();
            }
        }

        // This code configures Web API. The Startup class is specified as a type
        // parameter in the WebApp.Start method.
        public void Configuration(IAppBuilder appBuilder)
        {
            // Configure Web API for self-host. 
            var config = new HttpConfiguration();

			// Add Unity DependencyResolver
            config.DependencyResolver = new Unity.WebApi.UnityDependencyResolver(UnityHelpers.GetConfiguredContainer());

			// Add Unity filters provider
            RegisterFilterProviders(config);

            //config.Routes.MapHttpRoute(
            //    name: "DefaultApi",
            //    routeTemplate: "api/{controller}/{id}",
            //    defaults: new { id = RouteParameter.Optional }
            //);

            // Web API routes
            config.MapHttpAttributeRoutes();

            appBuilder.UseWebApi(config);
        }

        private static void RegisterFilterProviders(HttpConfiguration config)
        {
            // Add Unity filters provider
            var providers = config.Services.GetFilterProviders().ToList();
            //config.Services.Add(typeof(System.Web.Http.Filters.IFilterProvider), new Unity.WebApi.WebApiUnityActionFilterProvider(UnityHelpers.GetConfiguredContainer()));
            var container = UnityHelpers.GetConfiguredContainer(); 
            container.RegisterType<CurrentRequest>(new HierarchicalLifetimeManager());

            container.RegisterType<IOwinContext>(new HierarchicalLifetimeManager(),
                new InjectionFactory(c => c.Resolve<CurrentRequest>().Value.GetOwinContext()));

            config.DependencyResolver = new AspNet.WebApi.UnityHierarchicalDependencyResolver(container);

            var defaultprovider = providers.First(p => p is ActionDescriptorFilterProvider);
            config.Services.Remove(typeof(System.Web.Http.Filters.IFilterProvider), defaultprovider);
        }

    }

    public class CurrentRequest
    {
        public HttpRequestMessage Value { get; set; }
    }

    public class CurrentRequestHandler : DelegatingHandler
    {
        protected async override System.Threading.Tasks.Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, System.Threading.CancellationToken cancellationToken)
        {
            var scope = request.GetDependencyScope();
            var currentRequest = (CurrentRequest)scope.GetService(typeof(CurrentRequest));
            currentRequest.Value = request;
            return await base.SendAsync(request, cancellationToken);
        }
    }
}


