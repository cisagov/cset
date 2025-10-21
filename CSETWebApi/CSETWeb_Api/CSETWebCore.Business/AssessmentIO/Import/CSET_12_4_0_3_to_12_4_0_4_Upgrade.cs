//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    internal class CSET_12_4_0_3_to_12_4_0_4_Upgrade : ICSETJSONFileUpgrade
    {
        /// <summary>
        /// this is the string we will be upgrading to
        /// </summary>
        static string versionString = "12.4.0.4";
        
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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public string ExecuteUpgrade(string json)
        {
            JObject oAssessment = JObject.Parse(json);
            
            // Get the old demographics data
            var demographics = oAssessment["jDEMOGRAPHICS"];
            if (demographics != null && demographics.HasValues)
            {
                // Create the new DETAILS_DEMOGRAPHICS structure
                var newDetailsDemographics = new JArray();

                foreach (var demo in demographics)
                {
                    var id = demo["Assessment_Id"]?.Value<int>() ?? 0;

                    AddDetailsDemographic(newDetailsDemographics, id, "ORG-NAME", demo["OrganizationName"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "BUSINESS-UNIT", demo["Agency"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "ORG-TYPE", demo["OrganizationType"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "SECTOR", demo["SectorId"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "SUBSECTOR", demo["IndustryId"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "POC", demo["PointOfContact"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "SCOPED", demo["IsScoped"]);
                    AddDetailsDemographic(newDetailsDemographics, id, "ASSET-VALUE", demo["AssetValue"], AssetValueMapping);
                    AddDetailsDemographic(newDetailsDemographics, id, "SIZE", demo["Size"], SizeMapping);

                    // Facilitator might be null
                    var facilitator = demo["Facilitator"];
                    if (facilitator != null && facilitator.Type != JTokenType.Null)
                        AddDetailsDemographic(newDetailsDemographics, id, "FACILITATOR", facilitator);
                }

                // Add the new structure and remove the old one
                oAssessment["jDETAILS_DEMOGRAPHICS"] = newDetailsDemographics;
                oAssessment.Remove("jDEMOGRAPHICS");
            }


            bool isAcetPre10_2 = DetermineIfAcetPre10_2(oAssessment);

            var mode = "questions based";
            var jSS = oAssessment.SelectToken("$.jSTANDARD_SELECTION").FirstOrDefault();
            if (jSS != null)
            {
                mode = jSS["Application_Mode"].Value<string>().ToLower();
            }

            // Populate Question_Type on the ANSWER records
            foreach (var answer in oAssessment.SelectTokens("$.jANSWER").Children())
            {
                // create and populate the Question_Type column
                var qType = "Question";

                if (answer["Is_Requirement"].Value<bool>())
                {
                    qType = "Requirement";
                }
                if (answer["Is_Component"].Value<bool>())
                {
                    qType = "Component";
                }
                if (answer["Is_Framework"].Value<bool>())
                {
                    qType = "Framework";
                }

                answer["Question_Type"] = qType;



                // ACET requirement and question IDs get translated 
                // to their corresponding maturity question IDs
                if (isAcetPre10_2)
                {
                    bool isReq = answer["Is_Requirement"].Value<bool>();

                    // process requirement when in requirements mode
                    if (mode == "requirements based" && isReq)
                    {
                        int reqID = answer["Question_Or_Requirement_Id"].Value<int>();

                        if (ImportManagerACET.RequirementToMaturity.Keys.Contains(reqID))
                        {
                            int maturityQuestionID = ImportManagerACET.RequirementToMaturity[reqID];

                            answer["Question_Or_Requirement_Id"] = maturityQuestionID;
                            answer["Question_Type"] = "Maturity";
                        }
                    }

                    // process question when in questions mode
                    if (mode == "questions based" && !isReq)
                    {
                        // The ACET assessment was in questions mode
                        int qID = answer["Question_Or_Requirement_Id"].Value<int>();

                        if (ImportManagerACET.QuestionToMaturity.Keys.Contains(qID))
                        {
                            int maturityQuestionID = ImportManagerACET.QuestionToMaturity[qID];

                            answer["Question_Or_Requirement_Id"] = maturityQuestionID;
                            answer["Question_Type"] = "Maturity";
                        }
                    }

                }
            }


            // set the features for the assessment based on what we know
            var jA = oAssessment.SelectTokens("$.jASSESSMENTS").Children().First();

            int assessmentId = jA["Assessment_Id"].Value<int>();

            jA["UseStandard"] = false;
            jA["UseMaturity"] = false;
            jA["UseDiagram"] = false;

            if (isAcetPre10_2)
            {
                jA["UseMaturity"] = true;

                var j = new JObject();
                j["Assessment_Id"] = assessmentId;
                j["Selected"] = true;
                j["model_id"] = 1;  // hard coded to the ACET model ID for now

                var amm = new JArray(j);

                oAssessment.Add("jAVAILABLE_MATURITY_MODELS", amm);


                // Remove the deprecated ACET "standards" object from the JSON
                var oldAcetStandardRecord = oAssessment.SelectToken("$.jAVAILABLE_STANDARDS")
               .Where(x => x["Set_Name"].Value<string>() == "ACET_V1" && x["Selected"].Value<Boolean>()).FirstOrDefault();
                if (oldAcetStandardRecord != null)
                {
                    ((JObject)oldAcetStandardRecord).Remove();
                }
            }


            // if other standards are selected, set the "Standards" feature
            var jOtherStandards = oAssessment.SelectToken("$.jAVAILABLE_STANDARDS")
                .Where(x => x["Set_Name"].Value<string>() != "ACET_V1" && x["Selected"].Value<bool>()).Any();
            if (jOtherStandards)
            {
                jA["UseStandard"] = true;
            }

            // Set "Diagram" feature
            var jDiagramComponents = oAssessment.SelectTokens("$.jASSESSMENT_DIAGRAM_COMPONENTS[*]").Any();
            if (jDiagramComponents)
            {
                jA["UseDiagram"] = true;
            }



            // Older exports might have NIST_SAL_QUESTION_ANSWERS from other assessments.  
            // Clean that up now to avoid dupe key errors.
            var nistSalAnswers = oAssessment.SelectTokens("jNIST_SAL_QUESTION_ANSWERS[*]").ToList();
            foreach (var ans in nistSalAnswers)
            {
                if (ans["Assessment_Id"].Value<int>() != assessmentId)
                {
                    ((JObject)ans).Remove();
                }
            }

            return oAssessment.ToString();
        }
        
        private void AddDetailsDemographic(JArray array, int assessmentId, string dataItemName, JToken value, Dictionary<string, int> mapping = null)
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


        /// <summary>
        /// Determines if the import is from an older (pre 10.2) version
        /// and if it used the old pseudo-standard "ACET_V1".
        /// </summary>
        /// <returns></returns>
        private bool DetermineIfAcetPre10_2(JObject oAssessment)
        {
            var v = oAssessment.SelectTokens("$.jCSET_VERSION[*].Version_Id").FirstOrDefault().Value<string>();
            var version = ImportUpgradeManager.ParseVersion(v);

            var usesAcetStandard = oAssessment.SelectTokens("$.jAVAILABLE_STANDARDS[*]")
                .Where(x => x["Set_Name"].Value<string>() == "ACET_V1" && x["Selected"].Value<Boolean>()).Any();

            if (version < ImportUpgradeManager.ParseVersion("10.2") && usesAcetStandard)
            {
                return true;
            }

            return false;
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
