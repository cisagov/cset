//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Helpers;
using DataLayerCore.Model;
using Hangfire;
using Hangfire.Server;
using Microsoft.EntityFrameworkCore;
using Nelibur.ObjectMapper;
using System;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWeb_Api.Helpers
{
    public static class HangfireExecutor
    {
        [AutomaticRetry(Attempts = 0)]
        public static async Task SaveImport(ExternalStandard externalStandard, PerformContext context)
        {
            var logger = new HangfireLogger(context);
            var result = await externalStandard.ToSet(logger);
            if (result.IsSuccess)
            {
                try
                {
                    using (var db = new CSET_Context())
                    {
                        db.SETS.Add(result.Result);

                        await db.SaveChangesAsync();
                    }
                }
                catch (SqlException e)
                {
                    result.LogError(e.Message);
                }
                catch (Exception e)
                {
                    logger.Log("An error was encountered when adding the module to the database.  Please try again");
                    throw e;
                }
            }
            else
            {
                throw new Exception(String.Join("\r\n", result.ErrorMessages));
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="csetFilePath"></param>
        /// <param name="token"></param>
        /// <param name="processPath"></param>
        /// <param name="apiURL"></param>
        /// <param name="context"></param>
        /// <returns></returns>
        public static async Task ProcessAssessmentImportLegacyAsync(string csetFilePath, string token, string processPath, string apiURL, PerformContext context)
        {
            var logger = new HangfireLogger(context);
            ImportManager manager = new ImportManager();
            await manager.LaunchLegacyCSETProcess(csetFilePath, token, processPath, apiURL);
        }
    }
}

