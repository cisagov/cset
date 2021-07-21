//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer;
using CSETWebCore.ExportCSV;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.ReportEngine;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    public class ExcelExportController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly IDataHandling _data;
        private readonly IMaturityBusiness _maturity;
        private readonly IACETDashboardBusiness _acet;
        private readonly IHttpContextAccessor _http;
        private CSETContext _context;
        private ExcelExporter _exporter;

        private string excelContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        private string excelExtension = ".xlsx";

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
        /// Exports an assessment into a spreadsheet with 1 row per answer.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExport")]
        public IActionResult GetExcelExport(string token)
        {
            int assessmentId = _token.AssessmentForUser(token);
            string appCode = _token.Payload(Constants.Constants.Token_Scope);

            var stream = _exporter.ExportToCSV(assessmentId);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);

            return File(stream, excelContentType, GetFilename(assessmentId, appCode));
        }


        /// <summary>
        /// Exports an assessment in a format used by NCUA.  One row for the assessment with select answers in columns
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExportNCUA")]
        public IActionResult GetExcelExportNCUA(string token)
        {
            _token.SetToken(token);
            int assessmentId = _token.AssessmentForUser(token);
            string appCode = _token.Payload(Constants.Constants.Token_Scope);

            var stream = _exporter.ExportToExcelNCUA(assessmentId);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);

            return File(stream, excelContentType, GetFilename(assessmentId, appCode));
        }


        /// <summary>
        /// Generates an Excel spreadsheet with a row for every assessment that
        /// the current user has access to that uses the ACET standard.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ExcelExportAllNCUA")]
        public IActionResult GetExcelExportAllNCUA(string token)
        {
            _token.SetToken(token);
            int currentUserId = (int)_token.PayloadInt(Constants.Constants.Token_UserId);

            var stream = _exporter.ExportToExcelAllNCUA(currentUserId);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);

            return File(stream, excelContentType, $"My Assessments{excelExtension}");
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        private string GetFilename(int assessmentId, string appCode)
        {
            string filename = $"ExcelExport{excelExtension}";

            var assessmentName = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
            if (!string.IsNullOrEmpty(assessmentName))
            {
                filename = $"{appCode} Export - {assessmentName}{excelExtension}";
            }

            return filename;
        }
    }
}
