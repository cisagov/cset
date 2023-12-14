using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Set;
using Microsoft.EntityFrameworkCore;
using Org.BouncyCastle.Asn1.Pkcs;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CSETWebCore.Helpers
{
    /// <summary>
    /// THis should probably be renamed.  It's an attempt at
    /// encapsulating the language lookup for requirement text,
    /// question text, etc. in a singleton.
    /// </summary>
    public class LanguageOverlay
    {
        private Dictionary<string, LanguageRequirements> dictReq = new Dictionary<string, LanguageRequirements>();
        private Dictionary<string, LanguageCategories> dictCat = new Dictionary<string, LanguageCategories>();


        public LanguageOverlay()
        {
        }


        public LanguageCategory GetCat(string category, string lang)
        {
            LanguageCategories langPack = null;

            if (lang == "en")
            {
                return null;
            }

            if (!dictCat.ContainsKey(lang))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "CATEGORIES.json"));

                langPack = Newtonsoft.Json.JsonConvert.DeserializeObject<LanguageCategories>(json);

                dictCat.Add(lang, langPack);
            }
            else
            {
                langPack = dictCat[lang];
            }

            return langPack.Categories.FirstOrDefault(x => x.CategoryEn.ToLower() == category.ToLower());
        }


        /// <summary>
        /// Gets the overlay requirement object for the language.
        /// </summary>
        /// <returns></returns>
        public LanguageRequirement GetReq(int requirementId, string lang)
        {
            LanguageRequirements langPack = null;

            if (lang == "en")
            {
                return null;
            }

            if (!dictReq.ContainsKey(lang))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "NEW_REQUIREMENT.json"));

                langPack = Newtonsoft.Json.JsonConvert.DeserializeObject<LanguageRequirements>(json);

                dictReq.Add(lang, langPack);
            }
            else
            {
                langPack = dictReq[lang];
            }

            return langPack.Requirements.FirstOrDefault(x => x.RequirementId == requirementId);
        }
    }
}