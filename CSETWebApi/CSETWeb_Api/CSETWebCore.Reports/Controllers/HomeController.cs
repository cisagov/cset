using CSETWebCore.Reports.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Components.RenderTree;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using IronPdf;
using iText.Html2pdf;
using iText.IO.Source;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Routing;

namespace CSETWebCore.Reports.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IViewEngine _engine;

        public HomeController(ILogger<HomeController> logger, IViewEngine engine)
        {
            _logger = logger;
            _engine = engine;
        }

        public IActionResult Index()
        {
            ViewData.Model = GetCssLinks();
            return View();
        }

        public IActionResult Privacy()
        {
            return View();
        }

        public IActionResult CRRCoverSheet() 
        {
            return View(new CRRCoverSheetModel());    
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        [HttpGet]
        [Route("getPdf")]
        public async Task<IActionResult> CreatePdf(string view)
        {
            var report = await CreateHtmlString(view);
            ByteArrayOutputStream output = new ByteArrayOutputStream();
            HtmlConverter.ConvertToPdf(report, output);
            
            return File(output.GetBuffer(),"application/pdf", "test.pdf");
        }

        private async Task<string> CreateHtmlString(string view)
        {
            ViewData.Model = GetCssLinks();
            await using var sw = new StringWriter();
            var viewResult = _engine.FindView(ControllerContext, view, false);
            var viewContext = new ViewContext(ControllerContext, viewResult.View,
                ViewData, TempData, sw, new HtmlHelperOptions());
            await viewResult.View.RenderAsync(viewContext);
            string report = sw.GetStringBuilder().ToString();
           
            return report;
        }

        private Dictionary<string, string> GetCssLinks()
        {
            var links = new Dictionary<string, string>();
            var url = string.Format("{0}://{1}", Request.Scheme, Request.Host.ToUriComponent());
            links.Add("bootstrap", url + "/css/site.css");
            return links;
        }
    }
}
