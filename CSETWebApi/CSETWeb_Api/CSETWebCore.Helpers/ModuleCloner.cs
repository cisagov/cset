using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.DataLayer.Model;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;

namespace CSETWebCore.Helpers
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
        public async Task<bool> CloneModule(string setName, string newSetName)
        {
            this.origSetName = setName;
            this.newSetName = newSetName;

            using (var context = new CSETContext())
            {
                // clone the SETS record
                var origSet = await context.SETS.Where(x => x.Set_Name == this.origSetName).FirstOrDefaultAsync();
                if (origSet == null)
                {
                    return false;
                }

                var copySet = (SETS)context.Entry(origSet).CurrentValues.ToObject();

                copySet.Set_Name = this.newSetName;
                copySet.Full_Name = origSet.Full_Name
                    .Substring(0, Math.Min(origSet.Full_Name.Length, 240))
                    + " (copy)";
                copySet.Is_Custom = true;

                await context.SETS.AddAsync(copySet);
                await context.SaveChangesAsync();


                await CloneRequirements(copySet);

                // indicate that the cloning took place
                return true;
            }
        }


        /// <summary>
        /// Clones requirements and their connecting rows into a new Set.
        /// </summary>
        /// <param name="copySet"></param>
        private async Task CloneRequirements(SETS copySet)
        {
            Dictionary<int, int> requirementIdMap = new Dictionary<int, int>();
            Dictionary<int, int> questionSetIdMap = new Dictionary<int, int>();


            using (var context = new CSETContext())
            {
                var queryReq = from r in context.NEW_REQUIREMENT
                               from rs in context.REQUIREMENT_SETS.Where(x => x.Requirement_Id == r.Requirement_Id
                                  && x.Set_Name == this.origSetName)
                               select new { r, rs };

                var originalRequirements = await queryReq.ToListAsync();



                // Clone NEW_REQUIREMENT and REQUIREMENT_SETS
                foreach (var origRequirement in originalRequirements)
                {
                    var newReq = (NEW_REQUIREMENT)context.Entry(origRequirement.r).CurrentValues.ToObject();
                    newReq.Requirement_Id = 0;
                    await context.NEW_REQUIREMENT.AddAsync(newReq);
                    await context.SaveChangesAsync();

                    requirementIdMap.Add(origRequirement.r.Requirement_Id, newReq.Requirement_Id);


                    var copyReqSet = (REQUIREMENT_SETS)context.Entry(origRequirement.rs).CurrentValues.ToObject();
                    copyReqSet.Requirement_Id = newReq.Requirement_Id;
                    copyReqSet.Set_Name = copySet.Set_Name;

                    await context.REQUIREMENT_SETS.AddAsync(copyReqSet);


                    // Clone SAL levels for requirement
                    var dbRL = await context.REQUIREMENT_LEVELS
                        .Where(x => x.Requirement_Id == origRequirement.r.Requirement_Id).ToListAsync();
                    foreach (REQUIREMENT_LEVELS origLevel in dbRL)
                    {
                        var copyLevel = new REQUIREMENT_LEVELS
                        {
                            Requirement_Id = newReq.Requirement_Id,
                            Standard_Level = origLevel.Standard_Level,
                            Level_Type = origLevel.Level_Type,
                            Id = origLevel.Id
                        };

                        await context.REQUIREMENT_LEVELS.AddAsync(copyLevel);
                    }
                }


                // Clone REQUIREMENT_QUESTIONS_SETS
                var dbRQS = await context.REQUIREMENT_QUESTIONS_SETS.Where(x => x.Set_Name == origSetName).ToListAsync();
                foreach (REQUIREMENT_QUESTIONS_SETS origRQS in dbRQS)
                {
                    var copyRQS = (REQUIREMENT_QUESTIONS_SETS)context.Entry(origRQS).CurrentValues.ToObject();
                    copyRQS.Set_Name = copySet.Set_Name;
                    copyRQS.Requirement_Id = requirementIdMap[copyRQS.Requirement_Id];

                    await context.REQUIREMENT_QUESTIONS_SETS.AddAsync(copyRQS);
                }


                // Clone NEW_QUESTIONS_SETS
                var dbQS = await context.NEW_QUESTION_SETS.Where(x => x.Set_Name == origSetName).ToListAsync();
                foreach (NEW_QUESTION_SETS origQS in dbQS)
                {
                    var copyQS = (NEW_QUESTION_SETS)context.Entry(origQS).CurrentValues.ToObject();
                    copyQS.Set_Name = copySet.Set_Name;
                    // default the identity PK
                    copyQS.New_Question_Set_Id = 0;

                    await context.NEW_QUESTION_SETS.AddAsync(copyQS);
                    await context.SaveChangesAsync();

                    questionSetIdMap.Add(origQS.New_Question_Set_Id, copyQS.New_Question_Set_Id);
                }

                // Clone NEW_QUESTION_LEVELS for the new NEW_QUESTIONS_SETS just created
                var dbQL = from nql in context.NEW_QUESTION_LEVELS
                           join nqs in context.NEW_QUESTION_SETS on nql.New_Question_Set_Id equals nqs.New_Question_Set_Id
                           where nqs.Set_Name == this.origSetName
                           select nql;

                var listQL = await dbQL.ToListAsync();
                foreach (NEW_QUESTION_LEVELS origQL in listQL)
                {
                    var copyQL = (NEW_QUESTION_LEVELS)context.Entry(origQL).CurrentValues.ToObject();
                    copyQL.New_Question_Set_Id = questionSetIdMap[origQL.New_Question_Set_Id];

                    await context.NEW_QUESTION_LEVELS.AddAsync(copyQL);
                }


                // There is no need to clone UNIVERSAL_SUB_CATEGORY_HEADINGS
                // because the classification of a Question with a Question Header and a Subcategory
                // only exists once.  The Set it is tied to is the Set where the original
                // classification was made.  


                // Clone REQUIREMENT_SOURCE_FILES
                var queryRSF = from rsf in context.REQUIREMENT_SOURCE_FILES
                               join rs in context.REQUIREMENT_SETS on rsf.Requirement_Id equals rs.Requirement_Id
                               where rs.Set_Name == this.origSetName
                               select rsf;

                var listRSF = await queryRSF.ToListAsync();
                foreach (var rsf in listRSF)
                {
                    var newRSF = (REQUIREMENT_SOURCE_FILES)context.Entry(rsf).CurrentValues.ToObject();
                    newRSF.Requirement_Id = requirementIdMap[newRSF.Requirement_Id];
                    await context.REQUIREMENT_SOURCE_FILES.AddAsync(newRSF);
                }


                // Clone REQUIREMENT_REFERENCES
                var queryRR = from rr in context.REQUIREMENT_REFERENCES
                              join rs in context.REQUIREMENT_SETS on rr.Requirement_Id equals rs.Requirement_Id
                              where rs.Set_Name == this.origSetName
                              select rr;

                var listRR = await queryRR.ToListAsync();
                foreach (var rr in listRR)
                {
                    var newRR = (REQUIREMENT_REFERENCES)context.Entry(rr).CurrentValues.ToObject();
                    newRR.Requirement_Id = requirementIdMap[newRR.Requirement_Id];
                    await context.REQUIREMENT_REFERENCES.AddAsync(newRR);
                }


                await context.SaveChangesAsync();
            }
        }
    }
}