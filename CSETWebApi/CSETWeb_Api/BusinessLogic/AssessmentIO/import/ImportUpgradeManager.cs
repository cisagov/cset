using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CSETWeb_Api.BusinessLogic.ImportAssessment;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;

namespace CSETWeb_Api.BusinessLogic.BusinessManagers
{
    /// <summary>
    /// Applies incremental upgrades to bring older exported 
    /// data up to date.
    /// </summary>
    class ImportUpgradeManager
    {
        /// <summary>
        /// The list of versions for which incremental updates are supported.
        /// </summary>
        static Dictionary<string, ICSETJSONFileUpgrade> upgraders = new Dictionary<string, ICSETJSONFileUpgrade>();
        
        static ImportUpgradeManager()
        {
            upgraders.Add("9", new CSET90_to_901Upgrade());
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
            String version = (string) j.SelectToken("jCSET_VERSION[0].Version_Id");
            if (version == null)
            {
                throw new ApplicationException("Version could not be identifed corrupted assessment json");
            }
            
            while (!VersionIsLatest(version))
            {
                ICSETJSONFileUpgrade fileUpgrade =  upgraders[version];
                json = fileUpgrade.ExecuteUpgrade(json);
                version = fileUpgrade.GetVersion();
            }
            return json;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        private bool VersionIsLatest(string v)
        {
            return true;
        }


    }
}

