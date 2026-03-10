//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Aggregation;
using Microsoft.Data.SqlClient;
using Microsoft.Extensions.Logging;
using Snickler.EFCore;

namespace CSETWebCore.Helpers
{
    public class TrendDataProcessor : ITrendDataProcessor
    {
        private const int MaxRetries = 3;
        private const int DeadlockErrorCode = 1205;

        private readonly ILogger<TrendDataProcessor> _logger;

        public TrendDataProcessor(ILogger<TrendDataProcessor> logger)
        {
            _logger = logger;
        }

        public async Task ProcessAsync(CSETContext db, int aggregationID, LineChart response, string type)
        {
            int attempt = 0;

            while (attempt < MaxRetries)
            {
                try
                {
                    var results = new List<usp_GetTop5Areas_result>();
                    db.LoadStoredProc("[usp_GetTop5Areas]")
                        .WithSqlParam("aggregation_id", aggregationID)
                        .ExecuteStoredProc(handler =>
                        {
                            results = handler.ReadToList<usp_GetTop5Areas_result>().ToList();
                        });

                    BuildChartData(results, response, type);

                    return; // success
                }
                catch (SqlException ex) when (ex.Number == DeadlockErrorCode)
                {
                    attempt++;
                    _logger.LogWarning(
                        "Deadlock on usp_GetTop5Areas for aggregationID {Id}. Attempt {Attempt} of {Max}.",
                        aggregationID, attempt, MaxRetries);

                    if (attempt >= MaxRetries)
                    {
                        _logger.LogError(ex,
                            "Max retries reached for aggregationID {Id}. Giving up.", aggregationID);
                        throw;
                    }

                    await Task.Delay(200 * attempt); // back-off: 200ms, 400ms
                }
                catch (Exception ex)
                {
                    _logger.LogError(ex,
                        "Unexpected error in ProcessAsync for aggregationID {Id}.", aggregationID);
                    throw;
                }
            }
        }

        private static void BuildChartData(
            List<usp_GetTop5Areas_result> results, LineChart response, string type)
        {
            var labels = new HashSet<int>();
            var datasets = new Dictionary<string, ChartDataSet>();

            foreach (var r in results.Where(x => x.TopBottomType == type))
            {
                if (!datasets.TryGetValue(r.Question_Group_Heading, out var ds))
                {
                    ds = new ChartDataSet { Label = r.Question_Group_Heading };
                    response.datasets.Add(ds);
                    datasets[r.Question_Group_Heading] = ds;
                }

                ds.Data.Add((float)r.percentage);

                if (labels.Add(r.Assessment_Id))
                {
                    response.labels.Add(r.Assessment_Date.ToString("d-MMM-yyyy"));
                }
            }
        }
    }
}