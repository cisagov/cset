//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessManagers.Analysis;
using DataLayerCore.Manual;
using System.Collections.Generic;

namespace CSETWeb_Api.Controllers
{
    public class MaturityReportDetailData
    {
        public List<usp_getRRASummaryOverall> RRASummaryOverall { get; set; }        
        public List<usp_getRRASummary> RRASummary { get; set; }
        public List<usp_getRRASummaryByGoal> RRASummaryByGoal { get; set; }
        public List<usp_getRRASummaryByGoalOverall> RRASummaryByGoalOverall { get; set; }
        public ChartData myChartData { get; set; }
    }
}