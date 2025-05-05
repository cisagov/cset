//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.IO;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.ReportEngine;
using Microsoft.AspNetCore.Http;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.ExportCSV
{
    public class ExcelExporter
    {
        private CSETContext _context;
        private readonly IDataHandling _dataHandling;
        private readonly IACETMaturityBusiness _acetMaturity;
        private readonly IACETDashboardBusiness _acet;
        private readonly IHttpContextAccessor _http;
        private readonly ITokenManager _token;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dataHandling"></param>
        /// <param name="maturity"></param>
        /// <param name="acet"></param>
        /// <param name="http"></param>
        ///  /// <param name="token"></param>
        public ExcelExporter(CSETContext context, IDataHandling dataHandling, IACETMaturityBusiness acetMaturity,
            IACETDashboardBusiness acet, IHttpContextAccessor http,ITokenManager token)
        {
            _context = context;
            _dataHandling = dataHandling;
            _acetMaturity = acetMaturity;
            _acet = acet;
            _http = http;
            _token = token;
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
            CSETtoExcelDataMappings export = new CSETtoExcelDataMappings(assessment_id, _context, _dataHandling,_token);
            export.ProcessTables(stream);
            return stream;
        }


        /// <summary>
        /// We may export all of the user's assessments.  If that's the case no 
        /// assessement ID parm required.  Maybe a userID instead.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public MemoryStream ExportToExcelISE(int assessmentID, string type = "ISE")
        {
            var stream = new MemoryStream();
            CSETtoExcelNCUAMappings export = new CSETtoExcelNCUAMappings(_context, _acet, _acetMaturity);
            export.ProcessAssessment(assessmentID, stream, type);
            return stream;

        }


        public MemoryStream ExportToExcelAllNCUA(int userID, string type = "")
        {
            var stream = new MemoryStream();
            CSETtoExcelNCUAMappings export = new CSETtoExcelNCUAMappings(_context, _acet, _acetMaturity);
            export.ProcessAllAssessmentsForUser(userID, stream, type);
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