//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.ExportCSV;
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
        private readonly IHttpContextAccessor _http;
        private CSETContext _context;
        private ExcelExporter _exporter;

        private string excelContentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
        private string excelExtension = ".xlsx";

        public ExcelExportController(ITokenManager token, IDataHandling data, IMaturityBusiness maturity,
            IHttpContextAccessor http, CSETContext context)
        {
            _token = token;
            _data = data;
            _maturity = maturity;
            _http = http;
            _context = context;
            _exporter = new ExcelExporter(_context, _data, _http, _token);
        }


        /// <summary>
        /// Exports an assessment into a spreadsheet with 1 row per answer.
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessment/export/excel")]
        public IActionResult GetExcelExport()
        {
            var currentUserId = _token.GetUserId();
            int assessmentId = _token.AssessmentForUser();
            string appName = _token.Payload(Constants.Constants.Token_Scope);

            _context.FillEmptyMaturityQuestionsForAnalysis(assessmentId);
            _context.FillEmptyQuestionsForAnalysis(assessmentId);
            _context.FillNetworkDiagramQuestions(assessmentId);


            var stream = _exporter.ExportToCSV(assessmentId);
            stream.Flush();
            stream.Seek(0, System.IO.SeekOrigin.Begin);

            return File(stream, excelContentType, GetFilename(assessmentId, appName));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        private string GetFilename(int assessmentId, string appName)
        {
            string filename = $"ExcelExport{excelExtension}";

            var assessmentName = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
            if (!string.IsNullOrEmpty(assessmentName))
            {
                filename = $"{appName} Export - {assessmentName}{excelExtension}";
            }

            return filename;
        }
    }
}
