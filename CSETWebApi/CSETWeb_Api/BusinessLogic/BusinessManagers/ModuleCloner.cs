using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayerCore.Model;
using DataLayerCore;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.BusinessManagers
{
    public class ModuleCloner
    {
        private string origSetName;
        private string newSetName;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        /// <param name="newSetName"></param>
        /// <returns></returns>
        public bool CloneModule(string setName, string newSetName)
        {
            this.origSetName = setName;
            this.newSetName = newSetName;

            using (var db = new CSET_Context())
            {
                // clone the SETS record
                var origSet = db.SETS.Where(x => x.Set_Name == this.origSetName).FirstOrDefault();
                if (origSet == null)
                {
                    return false;
                }

                var copySet = (SETS)db.Entry(origSet).CurrentValues.ToObject();

                copySet.Set_Name = this.newSetName;
                copySet.Full_Name = origSet.Full_Name + " (copy)";
                copySet.Is_Custom = true;

                db.SETS.AddOrUpdate(copySet);
                db.SaveChanges();


                CloneRequirements(copySet);

                // indicate that the cloning took place
                return true;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="copySet"></param>
        private void CloneRequirements(SETS copySet)
        {
            using (var db = new CSET_Context())
            {
                // Iterate through all of the original requirements
                var dbReq = db.NEW_REQUIREMENT
                    .Include(x => x.REQUIREMENT_SETS)
                    .Include(yz => yz.SETs())
                    .Where(z => z.SETs().FirstOrDefault().Set_Name == this.origSetName)
                    .ToList();
                foreach (NEW_REQUIREMENT origReq in dbReq)
                {
                    // Clone REQUIREMENT_SETS
                    var dbReqSets = db.REQUIREMENT_SETS
                        .Where(x => x.Requirement_Id == origReq.Requirement_Id && x.Set_Name == this.origSetName).ToList();
                    foreach (REQUIREMENT_SETS origReqSet in dbReqSets)
                    {
                        var copyReqSet = (REQUIREMENT_SETS)db.Entry(origReqSet).CurrentValues.ToObject();
                        copyReqSet.Set_Name = copySet.Set_Name;
                        copyReqSet.Requirement_Id = origReq.Requirement_Id;

                        db.REQUIREMENT_SETS.Add(copyReqSet);
                    }


                    // Clone SAL levels for requirement
                    var dbRL = db.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == origReq.Requirement_Id).ToList();
                    foreach (REQUIREMENT_LEVELS origLevel in dbRL)
                    {
                        var copyLevel = new REQUIREMENT_LEVELS
                        {
                            Requirement_Id = origReq.Requirement_Id,
                            Standard_Level = origLevel.Standard_Level,
                            Level_Type = origLevel.Level_Type,
                            Id = origLevel.Id
                        };

                        db.REQUIREMENT_LEVELS.Add(copyLevel);
                    }


                    // Clone REQUIREMENT_QUESTIONS_SETS
                    var dbRQS = db.REQUIREMENT_QUESTIONS_SETS.Where(x => x.Set_Name == origSetName).ToList();
                    foreach (REQUIREMENT_QUESTIONS_SETS origRQS in dbRQS)
                    {
                        var copyRQS = new REQUIREMENT_QUESTIONS_SETS
                        {
                            Requirement_Id = origReq.Requirement_Id,
                            Set_Name = copySet.Set_Name,
                            Question_Id = origRQS.Question_Id
                        };

                        db.REQUIREMENT_QUESTIONS_SETS.Add(copyRQS);
                    }

                    // Clone NEW_QUESTIONS_SETS
                    var dbQS = db.NEW_QUESTION_SETS.Where(x => x.Set_Name == origSetName).ToList();
                    foreach (NEW_QUESTION_SETS origQS in dbQS)
                    {
                        var copyQS = new NEW_QUESTION_SETS
                        {
                            // identity column PK will be set by DBMS
                            New_Question_Set_Id = 0,
                            Question_Id = origQS.Question_Id,
                            Set_Name = copySet.Set_Name
                        };

                        db.NEW_QUESTION_SETS.Add(copyQS);
                        db.SaveChanges();


                        // Clone NEW_QUESTION_LEVELS for the new NEW_QUESTIONS_SETS just created
                        var dbQL = db.NEW_QUESTION_LEVELS.Where(x => x.New_Question_Set_Id == origQS.New_Question_Set_Id).ToList();
                        foreach (NEW_QUESTION_LEVELS origQL in dbQL)
                        {
                            var copyQL = (NEW_QUESTION_LEVELS)db.Entry(origQL).CurrentValues.ToObject();
                            copyQL.New_Question_Set_Id = copyQS.New_Question_Set_Id;

                            db.NEW_QUESTION_LEVELS.Add(copyQL);
                        }
                    }


                    db.SaveChanges();
                }
            }
        }
    }
}
