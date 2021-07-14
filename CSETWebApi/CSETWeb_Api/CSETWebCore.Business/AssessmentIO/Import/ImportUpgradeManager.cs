//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace CSETWebCore.Business.AssessmentIO.Import
{
    /// <summary>
    /// Applies incremental upgrades to bring older exported 
    /// data up to date.
    /// </summary>
    public class ImportUpgradeManager
    {
        /// <summary>
        /// The list of versions for which incremental updates are supported.
        /// </summary>
        static Dictionary<string, ICSETJSONFileUpgrade> upgraders = new Dictionary<string, ICSETJSONFileUpgrade>();

        static ImportUpgradeManager()
        {
            upgraders.Add("9.0.0.0", new CSET_09_0_0_to_09_0_1_Upgrade());
            upgraders.Add("9.0.1.0", new CSET_09_0_1_to_09_2_Upgrade());
            upgraders.Add("9.0.4.0", new CSET_09_0_1_to_09_2_Upgrade());
            upgraders.Add("9.2.0.0", new CSET_09_2_0_to_09_2_1_Upgrade());
            upgraders.Add("9.2.1.0", new CSET_09_2_1_to_09_2_2_Upgrade());
            upgraders.Add("9.2.2.0", new CSET_09_2_2_to_09_2_3_Upgrade());
            upgraders.Add("9.2.3.0", new CSET_09_2_3_to_10_0_0_Upgrade());
            upgraders.Add("10.0.0.0", new CSET_10_0_0_to_10_0_1_Upgrade());
            upgraders.Add("10.0.1.0", new CSET_10_0_1_to_10_1_0_Upgrade());
            upgraders.Add("10.1.0.0", new CSET_10_1_0_to_10_1_1_Upgrade());
            upgraders.Add("10.1.1.0", new CSET_10_1_1_to_10_2_0_Upgrade());
            upgraders.Add("10.2.0.0", null);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public string Upgrade(string json)
        {
            // Determine the latest version supported by this upgrader
            List<System.Version> knownVersions = new List<System.Version>();
            foreach (var u in upgraders)
            {
                knownVersions.Add(ImportUpgradeManager.ParseVersion(u.Key));
            }
            System.Version latestVersion = knownVersions.Max(x => x);


            // Determine the version of the data
            JObject j = JObject.Parse(json);
            JToken versionToken = j.SelectToken("jCSET_VERSION[0].Version_Id");
            if (versionToken == null)
            {
                throw new ApplicationException("Version could not be identifed corrupted assessment json");
            }

            System.Version version = ConvertFromStringToVersion(versionToken.Value<string>());
            version = NormalizeVersion(version);

            // correct version notation if necessary
            if (version == new System.Version("9.21.0.0"))
            {
                version = new System.Version("9.2.1.0");
            }
            if (version == new System.Version("9.23.0.0"))
            {
                version = new System.Version("9.2.3.0");
            }
            if (version == new System.Version("10.11.0.0"))
            {
                version = new System.Version("10.1.1.0");
            }


            while (version < latestVersion)
            {
                ICSETJSONFileUpgrade fileUpgrade = upgraders[version.ToString()];
                if (fileUpgrade != null)
                {
                    json = fileUpgrade.ExecuteUpgrade(json);
                    version = NormalizeVersion(fileUpgrade.GetVersion());
                }
            }

            return json;
        }


        /// <summary>
        /// A wrapper for System.Version.Parse() that can handle 
        /// an input string consisting of just the Major value.
        /// System.Version.Parse() requires 2 to 4 values.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        public static System.Version ParseVersion(string s)
        {
            if (s.Split('.').Length < 2)
            {
                s = s + ".0";
            }

            return NormalizeVersion(System.Version.Parse(s));
        }


        /// <summary>
        /// Returns a "normalized" representation of the Version with
        /// Minor, Build and Revision set to zeroes if not supplied.
        /// </summary>
        /// <param name="v"></param>
        /// <returns></returns>
        public static System.Version NormalizeVersion(System.Version v)
        {
            return new System.Version(
                   v.Major < 0 ? 0 : v.Major,
                   v.Minor < 0 ? 0 : v.Minor,
                   v.Build < 0 ? 0 : v.Build,
                   v.Revision < 0 ? 0 : v.Revision);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="v"></param>
        /// <returns></returns>
        private System.Version ConvertFromStringToVersion(String v)
        {
            // The version string may come in from a float and not be interpreted correctly.  
            // This attempts to turn "9.04" into "9.0.4"
            string[] parts = v.Split(".".ToCharArray());
            if (parts.Length > 1 && parts[1].StartsWith("0"))
            {
                parts[1] = "0." + parts[1].Substring(1);
            }
            v = String.Join(".", parts);
            if (v.EndsWith("."))
            {
                v = v.TrimEnd('.');
            }


            if (int.TryParse(v, out int version))
            {
                return new System.Version(version, 0);
            }
            return new System.Version(v);
        }
    }
}


