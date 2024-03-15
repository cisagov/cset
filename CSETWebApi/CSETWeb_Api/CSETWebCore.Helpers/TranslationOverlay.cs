using CSETWebCore.Model.Question;
using CSETWebCore.Model.Set;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.Linq;


namespace CSETWebCore.Helpers
{
    /// <summary>
    /// Manages translation lookup based on language pack
    /// information stored in App_Data/LanguagePacks.
    /// 
    /// Provides several methods to get at the data, depending on 
    /// how it is stored in the language pack.
    /// </summary>
    public class TranslationOverlay
    {

        #region various dictionaries for lazy loading and caching language packs

        /// <summary>
        /// A dictionary of loaded JArray language packs
        /// </summary>
        private Dictionary<string, JArray> dictJA = [];

        /// <summary>
        /// A dictionary of loaded JObject language packs
        /// </summary>
        private Dictionary<string, JObject> dictJO = [];

        /// <summary>
        /// A dictionary of loaded requirement overlay language packs
        /// </summary>
        private Dictionary<string, List<RequirementOverlay>> dictRequirements = [];

        /// <summary>
        /// A dictionary of loaded maturity grouping overlay language packs
        /// </summary>
        private Dictionary<string, List<MaturityGroupingOverlay>> dictGroupings = [];

        /// <summary>
        /// A dictionary of loaded maturity question overlay language packs
        /// </summary>
        private Dictionary<string, List<MaturityQuestionOverlay>> dictQuestions = [];

        /// <summary>
        /// A dictionary of loaded KeyValueOverlay language packs
        /// </summary>
        private Dictionary<string, List<KeyValueOverlay>> dictGeneric = [];


        #endregion



        /// <summary>
        /// Intended to return a JObject so that it is very generic.
        /// The caller supplies the key field name and the key value.  A JObject or null is returned.
        /// </summary>
        public JObject GetJObject(string collection, string keyFieldName, string key, string lang)
        {
            // get out cheaply - don't waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            JArray langPack = null;

            lang = lang.ToLower();

            var dictKey = $"{lang}|{collection.ToLower()}";

            if (!dictJA.TryGetValue(dictKey, out JArray value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, $"{collection}.json"));

                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<JArray>(json);

                dictJA.Add(dictKey, langPack);
            }
            else
            {
                langPack = value;
            }

            var target = langPack.Children().FirstOrDefault(x => x.SelectToken(keyFieldName).Value<string>().Equals(key, StringComparison.InvariantCultureIgnoreCase));

            return (JObject)target;
        }


        /// <summary>
        /// Returns the string value of the property name.  This works on a JSON file
        /// that represents a SINGLE OBJECT with multiple properties.  
        /// 
        /// This JSON layout is similar to a transloco language file.
        /// 
        /// Returns null if the property is not defined.
        /// </summary>
        /// <returns></returns>
        public string GetPropertyValue(string collection, string propertyName, string lang)
        {
            // get out cheaply - don't waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            lang = lang.ToLower();

            var dictKey = $"{lang}|{collection.ToLower()}";

            JObject langPack;
            if (!dictJO.TryGetValue(dictKey, out JObject value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, $"{collection}.json"));

                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<JObject>(json);

                dictJO.Add(dictKey, langPack);
            }
            else
            {
                langPack = value;
            }

            // adjust propertyName if segments have spaces to make SelectToken() happy
            var segs = propertyName.Split('.');
            for (var i = 0; i < segs.Length; i++)
            {
                if (segs[i].Contains(' '))
                {
                    segs[i] = $"['{segs[i]}']";
                }
            }
            propertyName = string.Join(".", segs);


            return langPack.SelectToken(propertyName)?.Value<string>() ?? null;
        }


        /// <summary>
        /// Generically gets a value for the specified key and collection.
        /// Collection indicates the name of the JSON file.
        /// </summary>
        public KeyValueOverlay GetValue(string collection, string key, string lang)
        {
            // get out cheaply - don't waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            List<KeyValueOverlay> langPack = null;

            lang = lang.ToLower();

            var dictKey = $"{lang}|{collection.ToLower()}";

            if (!dictGeneric.TryGetValue(dictKey, out List<KeyValueOverlay> value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, $"{collection}.json"));

                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<List<KeyValueOverlay>>(json);

                dictGeneric.Add(dictKey, langPack);
            }
            else
            {
                langPack = value;
            }


            return langPack.FirstOrDefault(x => x.Key.ToLower() == key.ToLower());
        }


        /// <summary>
        /// Gets the overlay requirement object for the language.
        /// </summary>
        /// <returns></returns>
        public RequirementOverlay GetRequirement(int requirementId, string lang)
        {
            // get out cheaply - don't waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            List<RequirementOverlay> langPack = null;

            if (!dictRequirements.TryGetValue(lang, out List<RequirementOverlay> value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "NEW_REQUIREMENT.json"));

                // safety in case the language pack doesn't exist
                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<List<RequirementOverlay>>(json);

                dictRequirements.Add(lang, langPack);
            }
            else
            {
                langPack = value;
            }

            return langPack.FirstOrDefault(x => x.RequirementId == requirementId);
        }


        /// <summary>
        /// Gets the overlay maturity grouping object for the language.
        /// </summary>
        /// <param name="groupingId"></param>
        /// <param name="lang"></param>
        /// <returns></returns>
        public MaturityGroupingOverlay GetMaturityGrouping(int groupingId, string lang)
        {
            // get out cheaply - don't waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            List<MaturityGroupingOverlay> langPack = null;

            if (!dictGroupings.TryGetValue(lang, out List<MaturityGroupingOverlay> value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "MATURITY_GROUPINGS.json"));

                // safety in case the language pack doesn't exist
                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<List<MaturityGroupingOverlay>>(json);

                dictGroupings.Add(lang, langPack);
            }
            else
            {
                langPack = value;
            }

            return langPack.FirstOrDefault(x => x.GroupingId == groupingId);
        }


        /// <summary>
        /// Gets the overlay maturity question object for the language.
        /// </summary>
        public MaturityQuestionOverlay GetMaturityQuestion(int questionId, string lang)
        {
            // get out cheaply - don't waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            List<MaturityQuestionOverlay> langPack = null;

            if (!dictQuestions.TryGetValue(lang, out List<MaturityQuestionOverlay> value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "MATURITY_QUESTIONS.json"));

                // safety in case the language pack doesn't exist
                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<List<MaturityQuestionOverlay>>(json);

                dictQuestions.Add(lang, langPack);
            }
            else
            {
                langPack = value;
            }

            return langPack.FirstOrDefault(x => x.MatQuestionId == questionId);
        }
    }

}