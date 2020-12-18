//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using DataLayerCore.Model;
using System.Collections.Generic;
using System.Linq;

namespace CSETWeb_Api.BusinessLogic.ReportEngine
{
    public class ACETReportData
    {
        
        public List<RelevantAnswers> DeficiencesList { get; set; }
        public BasicReportData.INFORMATION information { get; set; }
    }
}