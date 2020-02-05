//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
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

        public void Process(CSET_Context db, int aggregation_id)
        {
            var results = db.usp_GetTop5Areas(aggregation_id);
            Dictionary<string,List<usp_GetTop5Areas_result>> areadictionary = new Dictionary<string, List<usp_GetTop5Areas_result>>();

            //sum the yes and alts
            //recalc the percent
            //na's are already gone
            List<TopResult> allAreas = new List<TopResult>();
            foreach (usp_GetTop5Areas_result r in results)
            {
                List<usp_GetTop5Areas_result> clist; 

                if(areadictionary.TryGetValue(r.Universal_Sub_Category, out clist)){
                    clist.Add(r);
                }
                else
                {
                    areadictionary.Add(r.Universal_Sub_Category, new List<usp_GetTop5Areas_result>() { r });
                }
            }

            foreach(KeyValuePair<string,List<usp_GetTop5Areas_result>> pair in areadictionary)
            {
                int sum = 0; 
                foreach(var a in pair.Value.Where(x=> x.Answer_Text.ToUpper() == "Y" || x.Answer_Text.ToUpper() == "A"))
                {
                    sum += a.Answer_Count;
                }
                allAreas.Add(new TopResult() { Category = pair.Key, Assessment_Id = pair.Value[0].Assessment_Id, Total = sum });
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