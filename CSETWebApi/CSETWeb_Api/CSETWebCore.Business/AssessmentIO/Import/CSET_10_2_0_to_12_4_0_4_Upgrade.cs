//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 

using System;
using System.Collections.Generic;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import;

internal class CSET_10_2_0_to_12_4_0_4_Upgrade : ICSETJSONFileUpgrade
{
    /// <summary>
    ///     this is the string we will be upgrading to
    /// </summary>
    private static readonly string versionString = "12.4.0.4";

    public string ExecuteUpgrade(string json)
    {
        // Document file column changes
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

    public System.Version GetVersion()
    {
        return ImportUpgradeManager.ParseVersion(versionString);
    }

}