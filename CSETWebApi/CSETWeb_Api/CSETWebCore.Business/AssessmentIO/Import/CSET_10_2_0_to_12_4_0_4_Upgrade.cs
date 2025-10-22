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
    
    // Mapping dictionaries for sector and size
    private static readonly Dictionary<string, int> AssetValueMapping = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
    {
        { "< $100,000", 1 },
        { "< $1,000,000", 2 },
        { "< $10,000,000", 3 },
        { "> $10,000,000", 4 }
    };

    private static readonly Dictionary<string, int> SizeMapping = new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
    {
        { "Small (1-2 hour) assessment", 1 },
        { "Small", 1 }, 
        { "Medium (1-2 days)", 2 },
        { "Medium", 2 }, 
        { "Large (3+ days)", 3 },
        { "Large", 3 },
        { "1 week", 4 },
        { "2 weeks", 5 },
        { "More than 2 weeks", 6 }
    };

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