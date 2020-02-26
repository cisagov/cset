//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;
using DataLayerCore.Manual;
using DataLayerCore.Model;
using Snickler.EFCore;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class AggregationReportData
    {
        public string AggregationName { get; set; }
        public List<BasicReportData.OverallSALTable> SalList { get; set; }
        public List<DocumentLibraryTable> DocumentLibraryTable { get; set; }
    }
}
