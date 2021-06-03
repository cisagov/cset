using CSETWebCore.ExportCSV;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.ReportEngine;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.Api.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ExcelExportController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IDataHandling _data;
        private readonly IMaturityBusiness _maturity;
        private readonly IACETDashboardBusiness _acet;
        private readonly IHttpContextAccessor _http;
        private CSETContext _context;
        private ExcelExporter _exporter;

        public ExcelExportController(ITokenManager token, IDataHandling data, IMaturityBusiness maturity,
            IACETDashboardBusiness acet, IHttpContextAccessor http, CSETContext context)
        {
            _token = token;
            _data = data;
            _maturity = maturity;
            _acet = acet;
            _http = http;
            _context = context;
            _exporter = new ExcelExporter(_context, _data, _maturity, _acet, _http);
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExport")]
        public HttpResponseMessage GetExcelExport(string token)
        {
            int assessment_id = _token.AssessmentForUser(token);
            var stream = _exporter.ExportToCSV(assessment_id);
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
            int assessment_id = _token.AssessmentForUser(token);
            var stream = _exporter.ExportToExcelNCUA(assessment_id);
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
            int currentUserId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);

            var stream = _exporter.ExportToExcelAllNCUA(currentUserId);
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
