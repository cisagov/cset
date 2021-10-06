using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using IronPdf;
using IronPdf.Rendering;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;

namespace CSETWebCore.Reports.Helper
{
    public static class ReportHelper
    {
        public static async Task<string> RenderRazorViewToString(this Controller controller, string viewName, object model, string baseUrl, IViewEngine engine)
        {
            controller.ViewData.Model = model;
            controller.TempData["links"] = baseUrl;

            await using var sw = new StringWriter();
            var viewResult = engine.FindView(controller.ControllerContext, viewName, false);
            controller.ViewData.Model = model;
            var viewContext = new ViewContext(controller.ControllerContext, viewResult.View,
                controller.ViewData, controller.TempData, sw, new HtmlHelperOptions());
            await viewResult.View.RenderAsync(viewContext);

            string report = sw.GetStringBuilder().ToString();
            return report;
        }

        public static async Task<PdfDocument> RenderPdf(string html, string security, int pagestart)
        {
            var renderer = new ChromePdfRenderer();
            renderer.RenderingOptions.HtmlFooter = new HtmlHeaderFooter()
            {
                MaxHeight = 15,
                HtmlFragment =
                    "<div style=\"padding: 0 3rem\"><span style=\"font-family:Arial; font-size: 1rem\">"
                    + (security.ToLower() == "none" ? string.Empty : security)
                    + "</span><span style=\"font-family:Arial;float: right\">{page} | CRR Self-Assessment</span></div>"
            };
            renderer.RenderingOptions.FirstPageNumber = pagestart++;
            renderer.RenderingOptions.MarginTop = 15;
            //renderer.RenderingOptions.MarginBottom = 15;
            renderer.RenderingOptions.MarginLeft = 15;
            renderer.RenderingOptions.MarginRight = 15;
            renderer.RenderingOptions.EnableJavaScript = true;
            renderer.RenderingOptions.RenderDelay = 1000;
            renderer.RenderingOptions.CssMediaType = PdfCssMediaType.Print;
            var pdf = await renderer.RenderHtmlAsPdfAsync(html);
            return pdf;
        }

        public static async Task<PdfDocument> MergePdf(PdfDocument doc1, PdfDocument doc2)
        {
            var merged = PdfDocument.Merge(doc1, doc2);
            return merged;
        }

        public static List<string> GetReportList(string report)
        {
            var pages = ReadResource.ReadResourceByKey("reports.json", report);
            return pages.Split(',').ToList();
        }
    }
}