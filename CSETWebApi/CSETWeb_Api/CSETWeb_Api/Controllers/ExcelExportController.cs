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

namespace CSETWeb_Api.Controllers
{
    // [CSETAuthorize]
    public class ExcelExportController : ApiController
    {
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
    }
}


