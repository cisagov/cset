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
        public string fileName { get; set; }
        public string data { get; set; }
        public string guid { get; set; }

    }

    public class FileExistsInfo
    {
        public string guid { get; set; }
        public bool exists { get; set; }

    }

    public class JSONFileExport:IJSONFileExport
    {
        public void SendFileToMerit(string filename, string data, string uncPath, bool overwrite)
        {
            var pathToCreate = Path.Combine(uncPath, filename);

            // both create or overwrite for now
            if (overwrite)
            {
                try
                {
                    File.WriteAllText(pathToCreate, data);
                }
                catch (Exception ex)
                {

                }
            }
            else
            {
                try
                {
                    
                    File.WriteAllText(pathToCreate, data);
                }
                catch (Exception ex)
                {

                }
            }
            
            

        }


        public FileExistsInfo DoesFileExist(string filename, string uncPath)
        {
            string fullPath = Path.Combine(uncPath, filename);
            bool exists = File.Exists(fullPath);

            FileExistsInfo existsInfo = new FileExistsInfo();
            existsInfo.exists = exists;

            if (exists)
            {
                string jsonString = File.ReadAllText(fullPath);
                using (JsonDocument document = JsonDocument.Parse(jsonString))
                {
                    JsonElement root = document.RootElement;
                    JsonElement metaData = root.GetProperty("metaData");
                    foreach (JsonProperty metaDataProperty in metaData.EnumerateObject())
                    {
                        if (metaDataProperty.NameEquals("guid"))
                        {
                            string guidString = metaDataProperty.Value.ToString();
                            existsInfo.guid = guidString;
                        }
                    }
                }

            }
            return existsInfo;
        }

    }


}

