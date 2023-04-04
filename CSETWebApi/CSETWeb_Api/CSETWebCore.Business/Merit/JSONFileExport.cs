//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.AccessControl;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace CSETWebCore.Business.Merit
{
    /**
    - create own Business object (stick with pattern)
    - move func. from copy into this class
    - change test harness to point here instead of ReportsBusiness
    - parameterize the UNC path (muct be able to change at runtime) (GLOBAL_PROPERTIES table, NCUAMerit...)
    - 
     */

    public class MeritFileExport
    {
        public bool overwrite { get; set; }
        public string data { get; set; }
        public string guid { get; set; }

    }

    public class JSONFileExport:IJSONFileExport
    {
        public const string MeritExportPathName = "NCUAMeritExportPath";
        public void SendFileToMerit(string filename, string data, string uncPath)
        {
            if (!DoesDirectoryExist(uncPath))
            {
                throw new ApplicationException("the directory Path " + uncPath + " is not available or does not exist");
            }
            var pathToCreate = Path.Combine(uncPath, filename);
            File.WriteAllText(pathToCreate, data);           
        }

        public bool DoesDirectoryExist(string uncPath)
        {   
            return Directory.Exists(uncPath);
        }

        public bool DoesFileExist(string filename, string uncPath)
        {
            string fullPath = Path.Combine(uncPath, filename);
            return File.Exists(fullPath);
        }

        public Guid GetAssessmentGuid(int assessId, CSETContext context)
        {
            var assessInfo = context.ASSESSMENTS.Where(x => x.Assessment_Id == assessId).FirstOrDefault();
            var assessGuid = assessInfo.Assessment_GUID;

            return assessGuid;
        }

        public void SetNewAssessmentGuid(int assessId, Guid newGuid, CSETContext context)
        {
            var assessInfo = context.ASSESSMENTS.Where(x => x.Assessment_Id == assessId).FirstOrDefault();
            assessInfo.Assessment_GUID = newGuid;

            context.SaveChanges();
        }

        public string GetUncPath(CSETContext context)
        {
            GLOBAL_PROPERTIES uncPath = context.GLOBAL_PROPERTIES.Where(x => x.Property == JSONFileExport.MeritExportPathName).FirstOrDefault();
            if(uncPath == null)
            {
                uncPath = new GLOBAL_PROPERTIES()
                {
                    Property = JSONFileExport.MeritExportPathName,
                    Property_Value = "\\\\hqwinfs1\\global\\Field_Staff\\ISE"
                };
                context.GLOBAL_PROPERTIES.Add(uncPath);
                
            }
            if (!DoesDirectoryExist(uncPath.Property_Value))
            {
                var excp = new MERITApplicationException("Directory does not exist or is unavailable:"+ uncPath.Property_Value); 
                excp.Path = uncPath.Property_Value;
                throw excp;
            }
            return uncPath.Property_Value.ToString();
        }

        public void SaveUncPath(string uncPath, CSETContext context)
        {
            if (!DoesDirectoryExist(uncPath))
            {
                throw new ApplicationException("Directory does not exist or is unavailable:" + uncPath);
            }
            var currentUncPath = context.GLOBAL_PROPERTIES.Where(x => x.Property == JSONFileExport.MeritExportPathName).FirstOrDefault();
            if(currentUncPath == null)
            {
                context.GLOBAL_PROPERTIES.Add(new GLOBAL_PROPERTIES()
                {
                    Property = JSONFileExport.MeritExportPathName,
                    Property_Value = uncPath
                });
            }
            else
                currentUncPath.Property_Value = uncPath;

            context.SaveChanges();
        }

    }


}

