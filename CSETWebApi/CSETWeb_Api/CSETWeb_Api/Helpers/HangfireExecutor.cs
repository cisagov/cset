//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
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
using System;
using System.Data.SqlClient;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWeb_Api.Helpers
{
    public static class HangfireExecutor
    {
        [AutomaticRetry(Attempts=0)]
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
                        foreach (var question in result.Result.NEW_REQUIREMENT.SelectMany(s => s.NEW_QUESTIONs()).Where(s=>s.Question_Id!=0).ToList())
                        {
                            db.Entry(question).State = EntityState.Unchanged;
                        }
                        await db.SaveChangesAsync();
                    }
                }
                //catch (DbEntityValidationException e)
                //{
                //    foreach(var error in e.EntityValidationErrors)
                //    {
                //        foreach(var validationError in error.ValidationErrors)
                //        {
                //            result.LogError(validationError.ErrorMessage);
                //        }
                //    }
                //    throw new Exception(String.Join("\r\n", result.ErrorMessages));
                //}
                catch(SqlException e)
                {
                    result.LogError(e.Message);
                }
                catch(Exception e)
                {
                    logger.Log("An error was encountered when adding the module to the database.  Please try again");
                    throw e;
                }
            }
            else
            {
                throw new Exception(String.Join("\r\n",result.ErrorMessages));
            }
        }
        public static async Task ProcessAssessmentImportLegacyAsync(string csetFilePath, string token, string processPath, string apiURL, PerformContext context)
        {
            var logger = new HangfireLogger(context);
            ImportManager manager = new ImportManager();
            await manager.LaunchLegacyCSETProcess(csetFilePath, token, processPath, apiURL);
        }

        //public static async Task SaveAssessmentImportAsync(byte[] zipFileToDatabase, int currentUserId, PerformContext context)
        //{
        //    var logger = new HangfireLogger(context);
        //    ImportManager manager = new ImportManager();
        //    try
        //    {
        //        await manager.ProcessCSETAssessmentImport(zipFileToDatabase, currentUserId);
        //    }catch(Exception e)
        //    {
        //        logger.Log(e.Message);
        //        logger.Log(e.StackTrace);
        //    }
        //}
    }
}

