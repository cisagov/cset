//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;

namespace CSETWebCore.Model.Analysis
{
    public class ChartData
    {
        //this is hokey sorry
        //but check this list if it is not empty then use this
        //list otherwise user the rest of the data
        public List<ChartData> dataSets { get; set; }


        public string label { get; set; }
        public string backgroundColor { get; set; }
        public string borderColor { get; set; }
        public string borderWidth { get; set; }
        public List<double> data { get; set; } = [];
        public List<String> Labels { get; set; } = [];
        public List<string> EnglishLabels { get; set; } = [];
        public int ComponentCount { get; set; }
        public List<DataRows> DataRows { get; set; } = [];
        public List<DataRowsPie> DataRowsPie { get; set; } = [];
        public List<string> Colors { get; set; } = [];

        public ChartData()
        {
            data = new List<double>();
            Labels = new List<string>();
            EnglishLabels = new List<string>();
            dataSets = new List<ChartData>();
            DataRows = new List<DataRows>();
        }
    }
}