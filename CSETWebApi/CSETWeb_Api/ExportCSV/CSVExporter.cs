//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.IO;
using System.Linq;
using DataLayer;

namespace ExportCSV
{
    public class ExcelExporter
    {
  
        public MemoryStream ExportToCSV(int assessment_id)
        {
            using (CSETWebEntities assessmentEntity = new CSETWebEntities())
            {
                var stream = new MemoryStream();
                var answerslist = assessmentEntity.ANSWERs;
                if (answerslist.Count() <= 0)
                    return stream;
                CSETtoExcelDataMappings export = new CSETtoExcelDataMappings(assessment_id, assessmentEntity);
                export.processTables(stream);
                return stream;
            }
        }

    }
}


