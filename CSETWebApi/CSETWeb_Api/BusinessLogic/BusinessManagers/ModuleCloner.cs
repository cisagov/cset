using System;
using System.Collections.Generic;
using System.Data.Entity.Migrations;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using CSETWeb_Api.BusinessLogic.Models;
using DataLayer;

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

            using (var db = new CSETWebEntities())
            {
                // clone the SETS record
                var origSet = db.SETS.Where(x => x.Set_Name == this.origSetName).FirstOrDefault();
                if (origSet == null)
                {
                    return false;
                }

                var copySet = (SET)db.Entry(origSet).CurrentValues.ToObject();

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


        private void CloneRequirements(SET copySet)
        {
            using (var db = new CSETWebEntities())
            {
                // Clone NEW_REQUIREMENT
                var dbReq = db.NEW_REQUIREMENT.Where(x => x.SET.Set_Name == this.origSetName).ToList();
                foreach (NEW_REQUIREMENT origReq in dbReq)
                {
                    var copyReq = (NEW_REQUIREMENT)db.Entry(origReq).CurrentValues.ToObject();
                    copyReq.SET = copySet;

                    db.NEW_REQUIREMENT.Add(copyReq);
                    db.SaveChanges();


                    // Clone REQUIREMENT_SETS
                    var dbReqSets = db.REQUIREMENT_SETS
                        .Where(x => x.Requirement_Id == origReq.Requirement_Id && x.Set_Name == this.origSetName).ToList();
                    foreach (REQUIREMENT_SETS origReqSet in dbReqSets)
                    {
                        var copyReqSet = (REQUIREMENT_SETS)db.Entry(origReqSet).CurrentValues.ToObject();
                        copyReqSet.Set_Name = copySet.Set_Name;
                        copyReqSet.Requirement_Id = copyReq.Requirement_Id;

                        db.REQUIREMENT_SETS.Add(copyReqSet);
                    }
                    db.SaveChanges();


                    // Clone SAL levels for requirement
                    var dbReqLevel = db.REQUIREMENT_LEVELS.Where(x => x.Requirement_Id == origReq.Requirement_Id).ToList();
                    foreach (REQUIREMENT_LEVELS origLevel in dbReqLevel)
                    {
                        var copyLevel = (REQUIREMENT_LEVELS)db.Entry(origLevel).CurrentValues.ToObject();
                        copyLevel.Requirement_Id = copyReq.Requirement_Id;

                        db.REQUIREMENT_LEVELS.Add(copyLevel);
                        db.SaveChanges();
                    }
                }
            }
        }
    }
}
