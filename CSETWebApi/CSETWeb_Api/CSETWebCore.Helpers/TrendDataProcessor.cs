using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Aggregation;

namespace CSETWebCore.Helpers
{
    public class TrendDataProcessor : ITrendDataProcessor
    {
        public async Task Process(CSETContext context, int aggregationID, LineChart response, string Type)
        {
            var results = await context.usp_GetTop5Areas(aggregationID);
            HashSet<int> labels = new HashSet<int>();

            Dictionary<string, ChartDataSet> datasets = new Dictionary<string, ChartDataSet>();
            foreach (usp_GetTop5Areas_result r in results.Where(x => x.TopBottomType == Type))
            {
                ChartDataSet ds1;
                if (!datasets.TryGetValue(r.Question_Group_Heading, out ds1))
                {
                    var ds = new ChartDataSet();
                    ds.Label = r.Question_Group_Heading;
                    response.datasets.Add(ds);
                    datasets.Add(r.Question_Group_Heading, ds);
                    ds.Data.Add((float)r.percentage);
                }
                else
                {
                    ds1.Data.Add((float)r.percentage);
                }

                if (!labels.Contains(r.Assessment_Id))
                {
                    response.labels.Add(r.Assessment_Date.ToString("d-MMM-yyyy"));
                    labels.Add(r.Assessment_Id);
                }
            }
        }
    }
}