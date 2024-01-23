//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    internal class CSET_09_0_0_to_09_0_1_Upgrade : ICSETJSONFileUpgrade
    {

        /// <summary>
        /// this is the string we will be upgrading to
        /// </summary>
        static string versionString = "9.0.1";

        public string ExecuteUpgrade(string json)
        {
            JObject oAssessment = JObject.Parse(json);

            // do the manipulations here

            return oAssessment.ToString();
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