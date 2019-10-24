using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessLogic.ImportAssessment;
using CSETWeb_Api.BusinessLogic.Version;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
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
            upgraders.Add("9.0", new CSET90_to_901Upgrade());
            upgraders.Add("9.0.1", new CSET901_to_92Upgrade());
        }
         

        /// <summary>
        /// 
        /// </summary>
        /// <param name="json"></param>
        /// <returns></returns>
        public string Upgrade(string json)
        {
            JObject j = JObject.Parse(json);

            
            // Determine the version of the data
            String str_version = (string) j.SelectToken("jCSET_VERSION[0].Version_Id");
            if (str_version == null)
            {
                throw new ApplicationException("Version could not be identifed corrupted assessment json");
            }
            System.Version version = ConvertFromIntToVersion(str_version);
                
            while (!VersionIsLatest(version))
            {
                ICSETJSONFileUpgrade fileUpgrade =  upgraders[version.ToString()];
                json = fileUpgrade.ExecuteUpgrade(json);
                str_version = fileUpgrade.GetVersion();
                version = new System.Version(str_version);
            }
            return json;
        }

        private System.Version ConvertFromIntToVersion(String v)
        {
            int version;
            if (int.TryParse(v, out version))
            {
                return new System.Version(version, 0);
            }
            return new System.Version(v);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private bool VersionIsLatest(System.Version v)
        {   
            return VersionInjected.Version == v;
        }


    }
}

