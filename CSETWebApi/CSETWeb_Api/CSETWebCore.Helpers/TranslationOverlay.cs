using CSETWebCore.Model.Question;
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
        /// <summary>
        /// A dictionary of loaded JArray language packs
        /// </summary>
        private Dictionary<string, JArray> dictJA = new Dictionary<string, JArray>();

        /// <summary>
        /// A dictionary of loaded JObject language packs
        /// </summary>
        private Dictionary<string, JObject> dictJO = new Dictionary<string, JObject>();

        /// <summary>
        /// A dictionary of loaded RequirementTranslations language packs
        /// </summary>
        private Dictionary<string, RequirementTranslations> dReq = new Dictionary<string, RequirementTranslations>();

        /// <summary>
        /// A dictionary of loaded GenericTranslation language packs
        /// </summary>
        private Dictionary<string, GenericTranslation> dictGeneric = new Dictionary<string, GenericTranslation>();


        /// <summary>
        /// Intended to return a JObject so that it is very generic.
        /// The caller supplies the key field name and the key value.  A JObject or null is returned.
        /// </summary>
        public JObject GetJObject(string collection, string keyFieldName, string key, string lang)
        {
            JArray langPack = null;

            if (lang == "en")
            {
                return null;
            }

            lang = lang.ToLower();

            var dictKey = $"{lang}|{collection.ToLower()}";

            if (!dictJA.ContainsKey(dictKey))
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
                langPack = dictJA[dictKey];
            }

            var target = langPack.Children().FirstOrDefault(x => x.SelectToken(keyFieldName).Value<string>().Equals(key, StringComparison.InvariantCultureIgnoreCase));

            return (JObject)target;
        }


        /// <summary>
        /// Returns the string value of the property name.  This works on a JSON file
        /// that represents a single object with multiple properties.  
        /// 
        /// This JSON layout is similar to a transloco language file.
        /// 
        /// Returns null if the property is not defined.
        /// </summary>
        /// <returns></returns>
        public string GetPropertyValue(string collection, string propertyName, string lang)
        {
            if (lang == "en")
            {
                return null;
            }

            lang = lang.ToLower();

            var dictKey = $"{lang}|{collection.ToLower()}";

            JObject langPack;
            if (!dictJO.ContainsKey(dictKey))
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
                langPack = dictJO[dictKey];
            }

            // adjust propertyName if segments have spaces to make SelectToken happy
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
        public Model.Question.KeyValuePair GetValue(string collection, string key, string lang)
        {
            GenericTranslation langPack = null;

            // trying to get out cheaply and not waste time looking up English
            if (lang == "en")
            {
                return null;
            }

            lang = lang.ToLower();

            var dictKey = $"{lang}|{collection.ToLower()}";

            if (!dictGeneric.ContainsKey(dictKey))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, $"{collection}.json"));

                if (json == null)
                {
                    return null;
                }

                langPack = Newtonsoft.Json.JsonConvert.DeserializeObject<GenericTranslation>(json);

                dictGeneric.Add(dictKey, langPack);
            }
            else
            {
                langPack = dictGeneric[dictKey];
            }

            
            return langPack.Pairs.FirstOrDefault(x => x.Key.ToLower() == key.ToLower());
        }


        /// <summary>
        /// Gets the overlay requirement object for the language.
        /// </summary>
        /// <returns></returns>
        public RequirementTranslation GetReq(int requirementId, string lang)
        {
            RequirementTranslations langPack = null;

            if (lang == "en")
            {
                return null;
            }

            if (!dReq.TryGetValue(lang, out RequirementTranslations value))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "NEW_REQUIREMENT.json"));

                // safety in case the language pack doesn't exist
                if (json == null)
                {
                    return null;
                }

                langPack = JsonConvert.DeserializeObject<RequirementTranslations>(json);

                dReq.Add(lang, langPack);
            }
            else
            {
                langPack = value;
            }

            return langPack.Requirements.FirstOrDefault(x => x.RequirementId == requirementId);
        }
    }
}