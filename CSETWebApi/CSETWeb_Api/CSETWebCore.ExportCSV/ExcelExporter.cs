//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.IO;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.ReportEngine;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.ExportCSV
{
    public class ExcelExporter
    {
        private CSETContext _context;
        private readonly IDataHandling _dataHandling;
        private readonly IHttpContextAccessor _http;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dataHandling"></param>
        /// <param name="maturity"></param>
        /// <param name="acet"></param>
        /// <param name="http"></param>
        public ExcelExporter(CSETContext context, IDataHandling dataHandling, IHttpContextAccessor http)
        {
            _context = context;
            _dataHandling = dataHandling;
            _http = http;
        }


        /// <summary>
        /// Exports a multi-sheet workbook.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public MemoryStream ExportToCSV(int assessment_id)
        {

            var stream = new MemoryStream();
            var answerslist = _context.ANSWER;
            if (answerslist.Count() <= 0)
            {
                return stream;
            }
            CSETtoExcelDataMappings export = new CSETtoExcelDataMappings(assessment_id, _context, _dataHandling);
            export.ProcessTables(stream);
            return stream;
        }


        public MemoryStream ExportToExcellDiagram(int assessmentId)
        {
            var stream = new MemoryStream();
            CSETtoExcelDiagramMappings export = new CSETtoExcelDiagramMappings(_context, _http);
            export.ProcessDiagram(assessmentId, stream);
            return stream;
        }
    }
}