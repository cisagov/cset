//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Clones a SET.  If called as "non custom", the IDs
    /// for the new requirements are below the 1000000 mark.
    /// </summary>
    public class ModuleCloner
    {
        private readonly CSETContext _context;

        private string _sourceSetName;
        private string _newSetName;

        private bool _isCustom = true;


        /// <summary>
        /// 
        /// </summary>
        /// <param name="context"></param>
        /// <param name="custom"></param>
        public ModuleCloner(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="setName"></param>
        /// <param name="newSetName"></param>
        /// <returns></returns>
        public SETS CloneModule(string setName, string newSetName, bool isCustom = true)
        {
            _sourceSetName = setName;
            _newSetName = newSetName;
            _isCustom = isCustom;


            // Clones to a "custom" set will have 
            if (!_isCustom)
            {
                //PrepSeeds(_sourceSetName);
            }


            // clone the SETS record
            var origSet = _context.SETS.Where(x => x.Set_Name == _sourceSetName).FirstOrDefault();
            if (origSet == null)
            {
                return null;
            }

            var copySet = (SETS)_context.Entry(origSet).CurrentValues.ToObject();

            copySet.Set_Name = _newSetName;
            copySet.Full_Name = origSet.Full_Name
                .Substring(0, Math.Min(origSet.Full_Name.Length, 240))
                + " (copy)";
            copySet.Is_Custom = _isCustom;

            try
            {
                _context.SETS.Add(copySet);
                _context.SaveChanges();
            }
            catch (Exception ex)
            {
                throw new Exception("ModuleCloner threw an exception", ex);
            }


            CloneRequirements(copySet);

            // indicate that the cloning took place
            return copySet;
        }


        /// <summary>
        /// Clones requirements and their connecting rows into a new Set.
        /// </summary>
        /// <param name="copySet"></param>
        private void CloneRequirements(SETS copySet)
        {
            Dictionary<int, int> requirementIdMap = new Dictionary<int, int>();
            Dictionary<int, int> questionSetIdMap = new Dictionary<int, int>();


            var queryReq = from r in _context.NEW_REQUIREMENT
                           from rs in _context.REQUIREMENT_SETS.Where(x => x.Requirement_Id == r.Requirement_Id
                              && x.Set_Name == _sourceSetName)
                           select new { r, rs };

            var originalRequirements = queryReq.ToList();


            // Set seed for N_R records
            var seedNR = FindSeed("NEW_REQUIREMENT", "Requirement_Id", originalRequirements.Count());
            SetSeed("NEW_REQUIREMENT", "Requirement_Id", seedNR);


            try
            {
                // Clone NEW_REQUIREMENT and REQUIREMENT_SETS
                foreach (var origRequirement in originalRequirements)
                {
                    var newReq = (NEW_REQUIREMENT)_context.Entry(origRequirement.r).CurrentValues.ToObject();
                    newReq.Requirement_Id = 0;
                    newReq.Original_Set_Name = copySet.Set_Name;

                    _context.NEW_REQUIREMENT.Add(newReq);


                    _context.SaveChanges();


                    requirementIdMap.Add(origRequirement.r.Requirement_Id, newReq.Requirement_Id);


                    var copyReqSet = (REQUIREMENT_SETS)_context.Entry(origRequirement.rs).CurrentValues.ToObject();
                    copyReqSet.Requirement_Id = newReq.Requirement_Id;
                    copyReqSet.Set_Name = copySet.Set_Name;

                    _context.REQUIREMENT_SETS.Add(copyReqSet);


                    // Clone SAL levels for requirement
                    var dbRL = _context.REQUIREMENT_LEVELS
                        .Where(x => x.Requirement_Id == origRequirement.r.Requirement_Id).ToList();
                    foreach (REQUIREMENT_LEVELS origLevel in dbRL)
                    {
                        var copyLevel = new REQUIREMENT_LEVELS
                        {
                            Requirement_Id = newReq.Requirement_Id,
                            Standard_Level = origLevel.Standard_Level,
                            Level_Type = origLevel.Level_Type,
                            Id = origLevel.Id
                        };

                        _context.REQUIREMENT_LEVELS.Add(copyLevel);
                    }


                    // Clone PARAMETER_REQUIREMENTS
                    var dbPR = _context.PARAMETER_REQUIREMENTS.Where(x => x.Requirement_Id == origRequirement.r.Requirement_Id).ToList();

                    foreach (PARAMETER_REQUIREMENTS origPR in dbPR)
                    {
                        var copyPR = new PARAMETER_REQUIREMENTS
                        {
                            Requirement_Id = newReq.Requirement_Id,
                            Parameter_Id = origPR.Parameter_Id
                        };

                        _context.PARAMETER_REQUIREMENTS.Add(copyPR);
                    }
                }


                // Clone REQUIREMENT_QUESTIONS_SETS
                var dbRQS = _context.REQUIREMENT_QUESTIONS_SETS.Where(x => x.Set_Name == _sourceSetName).ToList();
                foreach (REQUIREMENT_QUESTIONS_SETS origRQS in dbRQS)
                {
                    var copyRQS = (REQUIREMENT_QUESTIONS_SETS)_context.Entry(origRQS).CurrentValues.ToObject();
                    copyRQS.Set_Name = copySet.Set_Name;
                    copyRQS.Requirement_Id = requirementIdMap[copyRQS.Requirement_Id];

                    _context.REQUIREMENT_QUESTIONS_SETS.Add(copyRQS);
                }


                // Clone NEW_QUESTIONS_SETS
                var dbQS = _context.NEW_QUESTION_SETS.Where(x => x.Set_Name == _sourceSetName).ToList();


                // Set seed for N_Q_S records
                var seedNQS = FindSeed("NEW_QUESTION_SETS", "New_Question_Set_Id", dbQS.Count());
                SetSeed("NEW_QUESTION_SETS", "New_Question_Set_Id", seedNQS);


                foreach (NEW_QUESTION_SETS origQS in dbQS)
                {
                    var copyQS = (NEW_QUESTION_SETS)_context.Entry(origQS).CurrentValues.ToObject();
                    copyQS.Set_Name = copySet.Set_Name;
                    // default the identity PK
                    copyQS.New_Question_Set_Id = 0;

                    _context.NEW_QUESTION_SETS.Add(copyQS);
                    _context.SaveChanges();

                    questionSetIdMap.Add(origQS.New_Question_Set_Id, copyQS.New_Question_Set_Id);
                }

                // Clone NEW_QUESTION_LEVELS for the new NEW_QUESTIONS_SETS just created
                var dbQL = from nql in _context.NEW_QUESTION_LEVELS
                           join nqs in _context.NEW_QUESTION_SETS on nql.New_Question_Set_Id equals nqs.New_Question_Set_Id
                           where nqs.Set_Name == _sourceSetName
                           select nql;

                var listQL = dbQL.ToList();
                foreach (NEW_QUESTION_LEVELS origQL in listQL)
                {
                    var copyQL = (NEW_QUESTION_LEVELS)_context.Entry(origQL).CurrentValues.ToObject();
                    copyQL.New_Question_Set_Id = questionSetIdMap[origQL.New_Question_Set_Id];

                    _context.NEW_QUESTION_LEVELS.Add(copyQL);
                }


                // There is no need to clone UNIVERSAL_SUB_CATEGORY_HEADINGS
                // because the classification of a Question with a Question Header and a Subcategory
                // only exists once.  The Set it is tied to is the Set where the original
                // classification was made.  


                // Clone REQUIREMENT_REFERENCES
                var queryRSF = from rsf in _context.REQUIREMENT_REFERENCES
                               join rs in _context.REQUIREMENT_SETS on rsf.Requirement_Id equals rs.Requirement_Id
                               where rs.Set_Name == _sourceSetName
                               select rsf;

                var listRSF = queryRSF.ToList();
                foreach (var rsf in listRSF)
                {
                    var newRSF = (REQUIREMENT_REFERENCES)_context.Entry(rsf).CurrentValues.ToObject();
                    newRSF.Requirement_Id = requirementIdMap[newRSF.Requirement_Id];
                    _context.REQUIREMENT_REFERENCES.Add(newRSF);
                }


                // Clone REQUIREMENT_REFERENCE_TEXT
                var queryRRT = from rrt in _context.REQUIREMENT_REFERENCE_TEXT
                               join rs in _context.REQUIREMENT_SETS on rrt.Requirement_Id equals rs.Requirement_Id
                               where rs.Set_Name == _sourceSetName
                               select rrt;

                var listRRT = queryRRT.ToList();
                foreach (var rrt in listRRT)
                {
                    var newRRT = (REQUIREMENT_REFERENCE_TEXT)_context.Entry(rrt).CurrentValues.ToObject();
                    newRRT.Requirement_Id = requirementIdMap[newRRT.Requirement_Id];
                    _context.REQUIREMENT_REFERENCE_TEXT.Add(newRRT);
                }


                _context.SaveChanges();
            }
            catch (Exception)
            {
                throw;
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="identityColumnName"></param>
        /// <returns></returns>
        private int FindSeed(string tableName, string identityColumnName, int recordsNeeded)
        {
            var gaps = FindGaps(tableName, identityColumnName, 1000000)
                    .Where(x => x.GapSize >= recordsNeeded).OrderBy(x => x.GapSize).ToList();

            var newSeed = 1000000;
            if (gaps.Count > 0)
            {
                newSeed = gaps.FirstOrDefault().GapStart;
            }

            NLog.LogManager.GetCurrentClassLogger().Info($"Calculated new seed value of {newSeed} for table {tableName}");

            return newSeed;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="identityColumnName"></param>
        /// <param name="newSeed"></param>
        private void SetSeed(string tableName, string identityColumnName, int seedValue)
        {
            if (!System.Text.RegularExpressions.Regex.IsMatch(tableName, @"^[a-zA-Z0-9_]+$"))
            {
                throw new ArgumentException("Invalid table name", nameof(tableName));
            }
            if (!System.Text.RegularExpressions.Regex.IsMatch(identityColumnName, @"^[a-zA-Z0-9_]+$"))
            {
                throw new ArgumentException("Invalid column name", nameof(identityColumnName));
            }

            // Reseed multiple times for stubborn cases
            // Table name is validated above with regex, so it's safe to use in the SQL string.
            // The seedValue is passed as a parameter to prevent SQL injection.
            var sql = string.Format("DBCC CHECKIDENT ('{0}', RESEED, {{0}})", tableName);
#pragma warning disable EF1002 // Table name validated with regex above
            _context.Database.ExecuteSqlRaw(sql, seedValue);
            _context.Database.ExecuteSqlRaw(sql, seedValue);
            _context.Database.ExecuteSqlRaw(sql, seedValue);
#pragma warning restore EF1002

            NLog.LogManager.GetCurrentClassLogger().Info($"Attempted to reseed table {tableName} to identity {seedValue}");
        }


        /// <summary>
        /// Find contiguous runs of unused identity values in a table.  
        /// </summary>
        /// <param name="tableName"></param>
        /// <param name="identityColumnName"></param>
        /// <returns></returns>
        private List<GapResult> FindGaps(string tableName, string identityColumnName, int start = 0)
        {
            var sql = "SELECT " +
                $"{identityColumnName} + 1 AS GapStart, " +
                "next_id - 1 AS GapEnd, " +
                $"next_id - {identityColumnName} - 1 AS GapSize " +
                "FROM ( " +
                    "SELECT " +
                    $"{identityColumnName}, " +
                    $"LEAD({identityColumnName}) OVER (ORDER BY {identityColumnName}) AS next_id " +
                    "FROM ( " +
                        $"SELECT {identityColumnName} FROM {tableName} WHERE {identityColumnName} >= {start} " +
                        "UNION ALL " +
                        $"SELECT {start} - 1 " +
                    ") anchored " +
                ") subquery " +
                $"WHERE next_id - {identityColumnName} > 1 " +
                "ORDER BY GapStart;";

            var results = new List<GapResult>();
            try
            {
                using (var command = _context.Database.GetDbConnection().CreateCommand())
                {
                    command.CommandText = sql;
                    _context.Database.OpenConnection();

                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            results.Add(new GapResult
                            {
                                GapStart = reader.GetInt32(0),
                                GapEnd = reader.GetInt32(1),
                                GapSize = reader.GetInt32(2)
                            });
                        }
                    }
                }

            }
            catch
            {
                throw;
            }

            return results;
        }
    }


    public class GapResult
    {
        public int GapStart { get; set; }
        public int GapEnd { get; set; }
        public int GapSize { get; set; }
    }
}