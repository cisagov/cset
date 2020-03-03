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


                        var mySet = new SETS()
                        {
                            Set_Name = "RKW_TEST_1",
                            Short_Name = result.Result.Short_Name,
                            Full_Name = result.Result.Full_Name,
                            Is_Displayed = true,
                            Is_Pass_Fail = false,
                            Set_Category_Id = 2,
                            Standard_ToolTip = "Trying to insert a set",
                            Is_Custom = true,
                            IsEncryptedModule = false,
                            IsEncryptedModuleOpen = true,
                        };
                        db.SETS.Add(mySet);


                        //var myQuestion = new NEW_QUESTION()
                        //{
                        //    Simple_Question = "Randy's new question",
                        //    Std_Ref = "RKW",
                        //    Std_Ref_Number = 1,
                        //    Original_Set_Name = "Randy Original"
                        //};
                        //db.NEW_QUESTION.Add(myQuestion);


                        var myReq = new NEW_REQUIREMENT()
                        {
                            Original_Set_Name = mySet.Set_Name,
                            Requirement_Text = "Randy new requirement",
                            Requirement_Title = "1.1.1",
                            Standard_Category = "Security Guidelines",
                            Standard_Sub_Category = "Secure Disposal Guidelines"
                        };
                        db.NEW_REQUIREMENT.Add(myReq);


                        //foreach (var r in result.Result.NEW_REQUIREMENT)
                        //{
                        //    db.NEW_REQUIREMENT.Add(r);
                        //}



                        // db.SETS.Add(result.Result);

                        foreach (var question in result.Result.NEW_REQUIREMENT.SelectMany(s => s.NEW_QUESTIONs()).Where(s => s.Question_Id != 0).ToList())
                        {
                            db.Entry(question).State = EntityState.Unchanged;
                        }

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

