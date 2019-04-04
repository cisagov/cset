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
  
        public MemoryStream ExportToCSV(int assessment_id)
        {
            using (CSET_Context assessmentEntity = new CSET_Context())
            {
                var stream = new MemoryStream();
                var answerslist = assessmentEntity.ANSWER;
                if (answerslist.Count() <= 0)
                    return stream;
                CSETtoExcelDataMappings export = new CSETtoExcelDataMappings(assessment_id, assessmentEntity);
                export.processTables(stream);
                return stream;
            }
        }

    }
}


