using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using IronPdf;
using IronPdf.Rendering;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.Rendering;
using Microsoft.AspNetCore.Mvc.ViewEngines;
using Microsoft.AspNetCore.Mvc.ViewFeatures;

namespace CSETWebCore.Reports.Helper
{
    public static class ReportHelper
    {

        public async static Task<string> RenderRazorViewToString(this Controller controller, string viewName, object model, string baseUrl, IViewEngine engine)
        {
            controller.ViewData.Model = model;
            controller.TempData["links"] = baseUrl;

            using var sw = new StringWriter();
            var viewResult = engine.FindView(controller.ControllerContext, viewName, false);
            controller.ViewData.Model = model;
            var viewContext = new ViewContext(controller.ControllerContext, viewResult.View,
                controller.ViewData, controller.TempData, sw, new HtmlHelperOptions());
            await viewResult.View.RenderAsync(viewContext);

            string report = sw.GetStringBuilder().ToString();
            return report;
        }

        public static PdfDocument RenderPdf(string html, string security, int pageNumber, Dictionary<string, int> margins, bool javaScript = false, string header = null, bool letterScale = true)
        {
            var renderer = new ChromePdfRenderer();

            var footer = new HtmlHeaderFooter()
            {
                MaxHeight = 15,
                HtmlFragment = "<div style=\"padding: 0 3rem 3rem 3rem; font-family:Arial; font-size: 1rem\">" +
                        "<div style=\"float: left;\">" +
                            (security.ToLower() == "none" ? string.Empty : security) +
                        "</div>" +
                        "<div style=\"float: right;\">" +
                            "{page} | CRR Self-Assessment" +
                        "</div>" +
                    "</div>"
            };

            renderer.RenderingOptions.PaperSize = PdfPaperSize.Letter;
            //renderer.RenderingOptions.FitToPaper = true;
            renderer.RenderingOptions.HtmlFooter = footer;
            renderer.RenderingOptions.CssMediaType = PdfCssMediaType.Print;


            if (pageNumber == 0)
            {
                renderer.RenderingOptions.FitToPaper = false;
                renderer.RenderingOptions.HtmlFooter = new HtmlHeaderFooter()
                {
                    MaxHeight = 15,
                    HtmlFragment = "<div style=\"padding: 0 0 3rem 3rem; font-family:Arial; font-size: 1rem;\">" +
                        "<div style=\"float: left;\">" +
                            (security.ToLower() == "none" ? string.Empty : security) +
                        "</div>" +
                    "</div>"
                };
            }
            

            
            renderer.RenderingOptions.FirstPageNumber = pageNumber++;
            renderer.RenderingOptions.MarginTop = margins["top"];
            renderer.RenderingOptions.MarginBottom = margins["bottom"];
            renderer.RenderingOptions.MarginLeft = margins["left"];
            renderer.RenderingOptions.MarginRight = margins["right"];


            if(header != null)
            {
                var headerBinary = File.ReadAllBytes("wwwroot/images/CRR/CRR_logo.png");
                var headerURI = @"data:image/png;base64," + Convert.ToBase64String(headerBinary);
                var headerHtml = String.Format("<img src='{0}' style=\"width: 20%; height: auto; padding: 45px 50px;\">", headerURI);

                var headerString = "<div style=\"font-family: Arial; font-weight: bold; font-size: 12pt; width: 30%; height: auto; padding: 55px 35px;\">" + header + "</div>";

                renderer.RenderingOptions.HtmlHeader = new HtmlHeaderFooter()
                {
                    MaxHeight = 25,
                    HtmlFragment = "<div style=\"display: flex; justify-content: space-between; align-self: flex-end;\">"
                        + headerHtml + headerString
                        + "</div>"
                };
            }

            // Only enable JavaScript options where it's needed
            if(javaScript)
            {
                renderer.RenderingOptions.EnableJavaScript = true;
                renderer.RenderingOptions.RenderDelay = 500;
            }
            

            
            var pdf = renderer.RenderHtmlAsPdf(html);

            return pdf;
        }

        public static PdfDocument MergePdf(List<PdfDocument> pdfs)
        {
            var merged = PdfDocument.Merge(pdfs);
            return merged;
        }

        public static List<string> GetReportList(string report)
        {
            var pages = ReadResource.ReadResourceByKey("reports.json", report);
            return pages.Split(',').ToList();
        }

        public static string GetCoverSheet()
        {
            var coverSheet = ReadResource.ReadResourceByKey("reports.json", "coverSheet");
            return coverSheet;
        }

        public static List<string> GetMarginPages()
        {
            var marginPages = ReadResource.ReadResourceByKey("reports.json", "marginPages");
            return marginPages.Split(',').ToList();
        }

        public static List<string> GetJSPages()
        {
            var marginPages = ReadResource.ReadResourceByKey("reports.json", "javaScriptPages");
            return marginPages.Split(',').ToList();
        }
        public static List<string> GetAssessmentPages()
        {
            var marginPages = ReadResource.ReadResourceByKey("reports.json", "assessmentPages");
            return marginPages.Split(',').ToList();
        }

        public static string GetReportName(string report)
        {
            string reportName = $"{report}_{DateTime.Now.ToString("yyyyMMddHHmmss")}.pdf";
            return reportName;
        }
    }
}