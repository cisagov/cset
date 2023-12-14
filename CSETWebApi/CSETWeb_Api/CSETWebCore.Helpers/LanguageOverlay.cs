using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Question;
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
        private Dictionary<string, LanguageRequirements> dict = new Dictionary<string, LanguageRequirements>();


        public LanguageOverlay()
        {
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public LanguageRequirement GetReq(int requirementId, string lang)
        {
            LanguageRequirements langPack = null;

            if (lang == "en")
            {
                return null;
            }

            if (!dict.ContainsKey(lang))
            {
                var rh = new ResourceHelper();
                var json = rh.GetCopiedResource(System.IO.Path.Combine("app_data", "LanguagePacks", lang, "NEW_REQUIREMENT.json"));

                langPack = Newtonsoft.Json.JsonConvert.DeserializeObject<LanguageRequirements>(json);

                dict.Add(lang, langPack);
            }
            else
            {
                langPack = dict[lang];
            }

            return langPack.Requirements.FirstOrDefault(x => x.RequirementId == requirementId);
        }
    }
}