//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Analysis
{
    public class FirstPage
    {
        public ChartData OverallBars { get; set; }
        public ChartData RedBars { get; set; }
        public ChartData StandardsSummaryPie { get; set; }
        public ChartData ComponentSummaryPie { get; set; }
    }
}