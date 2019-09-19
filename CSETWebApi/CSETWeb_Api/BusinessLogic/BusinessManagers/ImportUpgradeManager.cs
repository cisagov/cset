using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
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
        private List<string> versionSequence = new List<string>() { "9.0", "9.0.1", "9.0.2" };


        public string Upgrade(string json)
        {
            JObject j = JObject.Parse(json);

            // Determine the version of the data
            JToken versionToken = j.SelectToken("jCSET_VERSION[0].Version_Id");
            if (versionToken == null)
            {
                return json;
            }

            string version = versionToken.Value<string>();

            while (VersionIsLatest(version))
            {
                return json;
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

