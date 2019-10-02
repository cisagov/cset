//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.IO;
using System.Linq;
using DataLayerCore;
using DataLayerCore.Model;

namespace ExportCSV
{
    public class ExcelExporter
    {
        /// <summary>
        /// Exports a multi-sheet workbook.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public MemoryStream ExportToCSV(int assessment_id)
        {
            using (CSET_Context assessmentEntity = new CSET_Context())
            {
                var stream = new MemoryStream();
                var answerslist = assessmentEntity.ANSWER;
                if (answerslist.Count() <= 0)
                    return stream;
                CSETtoExcelDataMappings export = new CSETtoExcelDataMappings(assessment_id, assessmentEntity);
                export.ProcessTables(stream);
                return stream;
            }
        }


        /// <summary>
        /// We may export all of the user's assessments.  If that's the case no 
        /// assessement ID parm required.  Maybe a userID instead.
        /// </summary>
        /// <param name="assessment_id"></param>
        /// <returns></returns>
        public MemoryStream ExportToExcelNCUA(int assessmentID)
        {
            using (CSET_Context db = new CSET_Context())
            {
                var stream = new MemoryStream();
                CSETtoExcelNCUAMappings export = new CSETtoExcelNCUAMappings(db);
                export.ProcessAssessment(assessmentID, stream);
                return stream;
            }
        }


        public MemoryStream ExportToExcelAllNCUA(int userID)
        {
            using (CSET_Context db = new CSET_Context())
            {
                var stream = new MemoryStream();
                CSETtoExcelNCUAMappings export = new CSETtoExcelNCUAMappings(db);
                export.ProcessAllAssessmentsForUser(userID, stream);
                return stream;
            }
        }

        public MemoryStream ExportToExcellDiagram(int assessmentId)
        {
            using (CSET_Context db = new CSET_Context())
            {
                var stream = new MemoryStream();
                CSETtoExcelDiagramMappings export = new CSETtoExcelDiagramMappings(db);
                export.ProcessDiagram(assessmentId, stream);
                return stream;
            }

        }
    }
}


