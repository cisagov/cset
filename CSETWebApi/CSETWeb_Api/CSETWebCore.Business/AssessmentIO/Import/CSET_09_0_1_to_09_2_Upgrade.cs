//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    internal class CSET_09_0_1_to_09_2_Upgrade : ICSETJSONFileUpgrade
    {
        /// <summary>
        /// this is the string we will be upgrading to
        /// </summary>
        static string versionString = "9.2";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public string ExecuteUpgrade(string json)
        {
            JObject oAssessment = JObject.Parse(json);

            // ANSWER needs a GUID.  Null no longer allowed.
            foreach (var answer in oAssessment.SelectTokens("$.jANSWER").Children())
            {
                var componentGuid = answer.SelectToken("$.Component_Guid");
                if (componentGuid.Value<string>() == null)
                {
                    componentGuid.Replace(Guid.Empty);
                }
            }

            foreach (var answer in oAssessment.SelectTokens("$.jNIST_SAL_QUESTION_ANSWERS").Children())
            {
                var qa = answer.SelectToken("$.Question_Answer");
                switch (qa.Value<string>())
                {
                    case "Y":
                        qa.Replace("Yes");
                        break;
                    case "N":
                    case "U":
                    default:
                        qa.Replace("No");
                        break;
                }
            }

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
