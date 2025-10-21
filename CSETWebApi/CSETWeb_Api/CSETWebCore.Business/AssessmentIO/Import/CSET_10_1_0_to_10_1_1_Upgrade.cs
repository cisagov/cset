//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Runtime.InteropServices.JavaScript;
using ClosedXML.Excel;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    internal class CSET_10_1_0_to_10_1_1_Upgrade : ICSETJSONFileUpgrade
    {
        /// <summary>
        /// this is the string we will be upgrading to
        /// </summary>
        static string versionString = "10.1.1";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public string ExecuteUpgrade(string json)
        {
            var j = JObject.Parse(json);
            var documentFile = j["jDOCUMENT_FILE"];
            foreach (var demo in documentFile)
            {
                if (demo["CreatedTimestamp"] == null || demo["CreatedTimestamp"].Type == JTokenType.Null)
                {
                    demo["CreatedTimestamp"] = new DateTime(1900, 1, 1);
                }
                if (demo["UpdatedTimestamp"] == null || demo["UpdatedTimestamp"].Type == JTokenType.Null)
                {
                    demo["UpdatedTimestamp"] = new DateTime(1900, 1, 1);
                }
            }

            return j.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public System.Version GetVersion()
        {
            return ImportUpgradeManager.ParseVersion(versionString);
        }
    }
}
