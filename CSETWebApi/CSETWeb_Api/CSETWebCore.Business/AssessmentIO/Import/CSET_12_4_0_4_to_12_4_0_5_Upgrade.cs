
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

internal class CSET_12_4_0_4_to_12_4_0_5_Upgrade : ICSETJSONFileUpgrade
{
    /// <summary>
    ///     this is the string we will be upgrading to
    /// </summary>
    private static readonly string versionString = "12.4.0.5";

    // Mapping dictionaries for sector and size
    private static readonly Dictionary<string, int> AssetValueMapping =
        new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
        {
            { "< $100,000", 1 },
            { "< $1,000,000", 2 },
            { "< $10,000,000", 3 },
            { "> $10,000,000", 4 }
        };

    private static readonly Dictionary<string, int> SizeMapping =
        new Dictionary<string, int>(StringComparer.OrdinalIgnoreCase)
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
        // Update to DETAILS_DEMOGRAPHICS from DEMOGRAPHICS
        var demographics = j["jDEMOGRAPHICS"];
        if (demographics != null && demographics.HasValues)
        {
            // Create the new DETAILS_DEMOGRAPHICS structure
            var newDetailsDemographics = new JArray();

            foreach (var demo in demographics)
            {
                var assessmentId = demo["Assessment_Id"]?.Value<int>() ?? 0;

                AddDetailsDemographic(newDetailsDemographics, assessmentId, "ORG-NAME", demo["OrganizationName"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "BUSINESS-UNIT", demo["Agency"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "ORG-TYPE", demo["OrganizationType"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "SECTOR", demo["SectorId"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "SUBSECTOR", demo["IndustryId"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "POC", demo["PointOfContact"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "SCOPED", demo["IsScoped"]);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "ASSET-VALUE", demo["AssetValue"],
                    AssetValueMapping);
                AddDetailsDemographic(newDetailsDemographics, assessmentId, "SIZE", demo["Size"], SizeMapping);

                // Facilitator might be null
                var facilitator = demo["Facilitator"];
                if (facilitator != null && facilitator.Type != JTokenType.Null)
                    AddDetailsDemographic(newDetailsDemographics, assessmentId, "FACILITATOR", facilitator);
            }

            // Add the new structure and remove the old one
            j["jDETAILS_DEMOGRAPHICS"] = newDetailsDemographics;
            j.Remove("jDEMOGRAPHICS");
        }

        // Remove ACET Financial tables
        j.Remove("jFINANCIAL_ASSESSMENT_VALUES");
        j.Remove("jFINANCIAL_ATTRIBUTES");
        j.Remove("jFINANCIAL_DOMAIN_FILTERS");
        j.Remove("jFINANCIAL_DOMAIN_FILTERS_V2");
        j.Remove("jFINANCIAL_FFIEC_MAPPINGS");
        j.Remove("jFINANCIAL_HOURS");
        j.Remove("jFINANCIAL_HOURS_COMPONENT");
        j.Remove("jFINANCIAL_QUESTIONS");
        j.Remove("jFINANCIAL_REQUIREMENTS");
        j.Remove("jFINANCIAL_REVIEWTYPE");
        j.Remove("jFINANCIAL_TIERS");
        j.Remove("jFINANCIAL_DETAILS");
        j.Remove("jFINANCIAL_GROUPS");
        j.Remove("jFINANCIAL_ASSESSMENT_FACTORS");
        j.Remove("jFINANCIAL_COMPONENTS");
        j.Remove("jFINANCIAL_DOMAINS");
        j.Remove("jFINANCIAL_MATURITY");
        return j.ToString();
    }

    private void AddDetailsDemographic(JArray array, int assessmentId, string dataItemName, JToken value,
        Dictionary<string, int> mapping = null)
    {
        string stringValue = null;
        int? intValue = null;
        bool? boolValue = null;
        double? floatValue = null;

        if (mapping != null)
        {
            if (value != null && value.Type == JTokenType.String)
            {
                var strValue = value.Value<string>();

                if (!string.IsNullOrEmpty(strValue) && mapping.TryGetValue(strValue, out int mappedId))
                {
                    intValue = mappedId;
                }
            }

        }
        else
        {

            if (value != null && value.Type != JTokenType.Null)
                switch (value.Type)
                {
                    case JTokenType.String:
                        stringValue = value.Value<string>();
                        break;
                    case JTokenType.Integer:
                        intValue = value.Value<int>();
                        break;
                    case JTokenType.Boolean:
                        boolValue = value.Value<bool>();
                        break;
                    case JTokenType.Float:
                        floatValue = value.Value<double>();
                        break;
                }
        }

        var entry = new JObject
        {
            ["Assessment_Id"] = assessmentId,
            ["DataItemName"] = dataItemName,
            ["StringValue"] = stringValue,
            ["IntValue"] = intValue,
            ["FloatValue"] = floatValue,
            ["BoolValue"] = boolValue,
            ["DateTimeValue"] = null
        };

        array.Add(entry);
    }
    
    public System.Version GetVersion()
    {
        return ImportUpgradeManager.ParseVersion(versionString);
    }
}
    