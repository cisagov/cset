using Microsoft.VisualStudio.TestTools.UnitTesting;
using CSETWebCore.Api.Controllers;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.Extensions.FileProviders;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Api.Controllers.Tests
{
    [TestClass()]
    public class AngularConfigControllerTests
    {
        [TestMethod()]
        public void processUpdatedJsonTest()
        {
            AngularConfigController controller = new AngularConfigController(new TestWebHostEnvironment());
            HttpRequest test = new TestHttpRequest();
            //var doc = controller.processUpdatedJson(test);
            //Assert.IsNotNull(doc);

        }
    }

    class TestHttpRequest : HttpRequest
    {
        public override HttpContext HttpContext => throw new NotImplementedException();

        public override string Method { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override string Scheme { get{ return "http"; } set => throw new NotImplementedException(); }
        public override bool IsHttps { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override HostString Host { get {
                return new HostString("http://localhost"); } set => throw new NotImplementedException(); }
        public override PathString PathBase { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override PathString Path { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override QueryString QueryString { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override IQueryCollection Query { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override string Protocol { get { return "http"; } set => throw new NotImplementedException(); }

        public override IHeaderDictionary Headers { get { return new HeaderDictionary(); } }

        public override IRequestCookieCollection Cookies { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override long? ContentLength { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override string? ContentType { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public override Stream Body { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public override bool HasFormContentType => throw new NotImplementedException();

        public override IFormCollection Form { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public override Task<IFormCollection> ReadFormAsync(CancellationToken cancellationToken = default)
        {
            throw new NotImplementedException();
        }
    }

    class TestWebHostEnvironment : IWebHostEnvironment
    {
        public string WebRootPath { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public IFileProvider WebRootFileProvider { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public string ApplicationName { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public IFileProvider ContentRootFileProvider { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
        public string ContentRootPath { get {return @"C:\src\repos\cset\CSETWebApi\CSETWeb_Api\CSETWeb_ApiCore\WebApp\"; } set => throw new NotImplementedException(); }
        public string EnvironmentName { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }
    }
}