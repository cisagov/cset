//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.ModuleIO;
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

            if (externalStandard == null)
            {
                var msg = "Module was not correctly transferred.  Please try again";
                logger.Log(msg);
                throw new Exception(msg);
            }

            try
            {
                ModuleImporter.DoIt(externalStandard);
            }
            catch (Exception exc)
            {
                logger.Log("An error was encountered when adding the module to the database.  Please try again");
                throw exc;
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

