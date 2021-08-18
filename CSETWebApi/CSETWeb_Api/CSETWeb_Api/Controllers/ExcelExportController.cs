//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using ExportCSV;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    // [CSETAuthorize]
    public class ExcelExportController : ApiController
    {
        private string excelContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        private string excelExtension = ".xlsx";


        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExport")]
        public HttpResponseMessage GetExcelExport(string token)
        {
            TokenManager tm = new TokenManager(token);
            int assessment_id = Auth.AssessmentForUser(token);
            string appCode = tm.Payload(Constants.Token_Scope);

            var stream = new ExcelExporter().ExportToCSV(assessment_id);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(stream)
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue(excelContentType);
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = GetFilename(assessment_id, appCode)
            };

            return result;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExportNCUA")]
        public HttpResponseMessage GetExcelExportNCUA(string token)
        {
            TokenManager tm = new TokenManager(token);
            int assessment_id = Auth.AssessmentForUser(token);
            string appCode = tm.Payload(Constants.Token_Scope);

            var stream = new ExcelExporter().ExportToExcelNCUA(assessment_id);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(stream)
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue(excelContentType);
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = GetFilename(assessment_id, appCode)
            };

            return result;
        }


        /// <summary>
        /// Generates an Excel spreadsheet with a row for every assessment that
        /// the current user has access to that uses the ACET standard.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExportAllNCUA")]
        public HttpResponseMessage GetExcelExportAllNCUA(string token)
        {
            TokenManager tm = new TokenManager(token);
            int currentUserId = (int)tm.PayloadInt(Constants.Token_UserId);

            var stream = new ExcelExporter().ExportToExcelAllNCUA(currentUserId);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(stream)
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue(excelContentType);
            result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment")
            {
                FileName = $"My Assessments{excelExtension}"
            };

            return result;
        }


        /// <summary>
        /// Builds a standardized filename for the Excel export based on assessment name.
        /// </summary>
        /// <returns></returns>
        private string GetFilename(int assessmentId, string appCode)
        {
            string filename = $"ExcelExport{excelExtension}";

            using (CSET_Context db = new CSET_Context())
            {
                var assessmentName = db.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
                if (!string.IsNullOrEmpty(assessmentName))
                {
                    filename = $"{appCode} Export - {assessmentName}{excelExtension}";
                }
            }

            return filename;
        }
    }
}


