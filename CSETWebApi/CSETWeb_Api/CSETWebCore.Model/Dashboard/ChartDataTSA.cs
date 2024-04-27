//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using CSETWebCore.DataLayer.Manual;

namespace CSETWebCore.Model.Dashboard
{
    public class ChartDataTSA
    {
        //this is hokey sorry
        //but check this list if it is not empty then use this
        //list otherwise user the rest of the data
        public List<ChartDataTSA> dataSets { get; set; }


        public string label { get; set; }
        public string backgroundColor { get; set; }
        public string type { get; set; }
        public string borderColor { get; set; }
        public string borderWidth { get; set; }
        public List<double> data { get; set; }
        public List<String> Labels { get; set; }
        public int ComponentCount { get; set; }
        public List<DataRowsAnalytics> DataRows { get; set; }
        public List<AnalyticsMinMaxAvgMedianByGroup> DataRowsMaturity { get; set; }
        public List<AnalyticsStandardMinMaxAvg> DataRowsStandard { get; set; }
        //public List<DataRowsPie> DataRowsPie { get; set; }
        public List<string> Colors { get; set; }
        public List<SetStandard> StandardList { get; set; }
        public ChartDataTSA()
        {
            data = new List<double>();
            Labels = new List<string>();
            dataSets = new List<ChartDataTSA>();
            DataRows = new List<DataRowsAnalytics>();
        }
    }
}

