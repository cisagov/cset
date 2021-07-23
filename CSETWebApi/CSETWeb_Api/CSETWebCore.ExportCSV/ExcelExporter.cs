using System.IO;
using System.Linq;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.ACETDashboard;
using CSETWebCore.Interfaces.Maturity;
using CSETWebCore.Interfaces.ReportEngine;
using Microsoft.AspNetCore.Http;

namespace CSETWebCore.ExportCSV
{
    public class ExcelExporter
    {
        private CSETContext _context;
        private readonly IDataHandling _dataHandling;
        private readonly IMaturityBusiness _maturity;
        private readonly IACETDashboardBusiness _acet;
        private readonly IHttpContextAccessor _http;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="context"></param>
        /// <param name="dataHandling"></param>
        /// <param name="maturity"></param>
        /// <param name="acet"></param>
        /// <param name="http"></param>
        public ExcelExporter(CSETContext context, IDataHandling dataHandling, IMaturityBusiness maturity,
            IACETDashboardBusiness acet, IHttpContextAccessor http)
        {
            _context = context;
            _dataHandling = dataHandling;
            _maturity = maturity;
            _acet = acet;
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
                return stream;
            CSETtoExcelDataMappings export = new CSETtoExcelDataMappings(assessment_id, _context, _dataHandling);
            export.ProcessTables(stream);
            return stream;
        }


        /// <summary>
        /// We may export all of the user's assessments.  If that's the case no 
        /// assessement ID parm required.  Maybe a userID instead.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public MemoryStream ExportToExcelNCUA(int assessmentID)
        {
            var stream = new MemoryStream();
            CSETtoExcelNCUAMappings export = new CSETtoExcelNCUAMappings(_context, _acet, _maturity);
            export.ProcessAssessment(assessmentID, stream);
            return stream;

        }


        public MemoryStream ExportToExcelAllNCUA(int userID)
        {
            var stream = new MemoryStream();
            CSETtoExcelNCUAMappings export = new CSETtoExcelNCUAMappings(_context, _acet, _maturity);
            export.ProcessAllAssessmentsForUser(userID, stream);
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