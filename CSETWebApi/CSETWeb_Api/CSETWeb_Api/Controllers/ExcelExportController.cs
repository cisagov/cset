//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using CSETWeb_Api.Helpers;
using ExportCSV; 
using BusinessLogic.Helpers;

namespace CSETWeb_Api.Controllers
{
    // [CSETAuthorize]
    public class ExcelExportController : ApiController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExport")]
        public HttpResponseMessage GetExcelExport(string token)
        {
            int assessment_id = Auth.AssessmentForUser(token);
            var stream = new ExcelExporter().ExportToCSV(assessment_id);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(stream)
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
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
            int assessment_id = Auth.AssessmentForUser(token);
            var stream = new ExcelExporter().ExportToExcelNCUA(assessment_id);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);
            HttpResponseMessage result = new HttpResponseMessage(HttpStatusCode.OK)
            {
                Content = new StreamContent(stream)
            };
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
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
            result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            return result;
        }
    }
}


