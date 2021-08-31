using CSETWebCore.Reports.Models;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Threading.Tasks;
using CSETWebCore.Authorization;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;
using iText.Html2pdf;
using iText.IO.Source;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Authorization;

namespace CSETWebCore.Reports.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IViewEngine _engine;
        private readonly ITokenManager _token;
        private readonly IAssessmentBusiness _assessment;

        public HomeController(ILogger<HomeController> logger, IViewEngine engine, ITokenManager token, 
            IAssessmentBusiness assessment)
        {
            _logger = logger;
            _engine = engine;
            _token = token;
            _assessment = assessment;
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

        [CsetAuthorize]
        [HttpGet]
        public IActionResult CRRCoverSheet()
        {
            int assessmentId = _token.AssessmentForUser();
            var detail = _assessment.GetAssessmentDetail(assessmentId);
            return View(new CRRCoverSheetModel(detail));
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
