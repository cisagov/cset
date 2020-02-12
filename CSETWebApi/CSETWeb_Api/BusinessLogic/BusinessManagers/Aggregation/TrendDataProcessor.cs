//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers.Aggregation
{
    public class TrendDataProcessor
    {
        public TrendDataProcessor()
        {
            /** go through the data for each category 
             * get the first point and second point 
             * add together the yes and all 
             * sort by difference and take the top 5
             * then take the bottom 5
             **/
        }

        public void Process(CSET_Context db, int aggregationID, LineChart response, string Type)
        {
            var results = db.usp_GetTop5Areas(aggregationID);
            HashSet<int> labels = new HashSet<int>();

            Dictionary<string, ChartDataSet> datasets = new Dictionary<string, ChartDataSet>();
            foreach (usp_GetTop5Areas_result r in results.Where(x => x.TopBottomType == Type))
            {
                ChartDataSet ds1;
                if (!datasets.TryGetValue(r.Universal_Sub_Category, out ds1))
                {
                    List<usp_GetTop5Areas_result> clist;
                    var ds = new ChartDataSet();
                    ds.label = r.Universal_Sub_Category;
                    response.datasets.Add(ds);
                    datasets.Add(r.Universal_Sub_Category, ds);
                    ds.data.Add((float)r.percentage);
                }
                else
                {
                    ds1.data.Add((float)r.percentage);
                }
                if (!labels.Contains(r.Assessment_Id))
                {
                    response.labels.Add(r.Assessment_Date.ToString("d-MMM-yyyy"));
                    labels.Add(r.Assessment_Id);
                }
            }
        }

        
    }

    public class TopResult
    {
        public String Category { get; set; }
        public int Assessment_Id { get; set; }
        public double PercentDiff { get; set; }
        public int Total { get; internal set; }
    }
}