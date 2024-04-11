//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Business.Reports
{
    public class AggregationReportData
    {
        public string AggregationName { get; set; }
        public List<BasicReportData.OverallSALTable> SalList { get; set; }
        public List<DocumentLibraryTable> DocumentLibraryTable { get; set; }
        public AggInformation Information { get; set; }
    }
}