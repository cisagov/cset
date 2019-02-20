//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Newtonsoft.Json.Linq;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    public class AngularConfigController : ApiController
    {
        /// <summary>
        /// NOTE THIS APOLOGY
        /// this call returns the config.json file
        /// but modifies the port to be the current port 
        /// the application is running on.
        /// (IE the file may be different from what is returned)
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assets/config.json")]
        public JObject GetConfig(HttpRequestMessage requestMessage)
        {
            return processConfig(requestMessage.RequestUri);
        }

        /// <summary>
        /// NOTE THIS APOLOGY
        /// this call returns the config.json file
        /// but modifies the port to be the current port 
        /// the application is running on.
        /// (IE the file may be different from what is returned)
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assets/config")]
        public JObject GetConfigURLRewrite(HttpRequestMessage requestMessage)
        {
            return processConfig(requestMessage.RequestUri);
        }

        private JObject processConfig(Uri newBase)
        {
            if (File.Exists(System.Web.Hosting.HostingEnvironment.MapPath("~/assets/config.json")))
            {
                string contents = File.ReadAllText(System.Web.Hosting.HostingEnvironment.MapPath("~/assets/config.json"));
                var jObject = JObject.Parse(contents);
                if (jObject["override"] != null)
                    if ((jObject["override"]).ToString().Equals("true", StringComparison.CurrentCultureIgnoreCase))
                        return jObject;
                // get the base appURL 
                // then change it to include the new port.
                string findString = jObject["appUrl"].ToString();
                string replaceString = newBase.GetLeftPart(UriPartial.Authority) + "/";

                if (findString.SequenceEqual(replaceString))
                    return jObject;

                jObject["appUrl"] = newUri(newBase, (jObject["appUrl"]).ToString());
                jObject["apiUrl"] = newUri(newBase, (jObject["apiUrl"]).ToString());
                jObject["docUrl"] = newUri(newBase, (jObject["docUrl"]).ToString());
                String reportsUrl = (jObject["reportsUrl"]).ToString();
                if (File.Exists(System.Web.Hosting.HostingEnvironment.MapPath("~/reports/index.html")))
                {
                    reportsUrl += reportsUrl.EndsWith("reports/", StringComparison.CurrentCultureIgnoreCase) ? "" : "reports/";
                }
                jObject["reportsUrl"] = newUri(newBase, reportsUrl);
                //jObject["OldDebug"] = contents;
                return jObject;
            }

            throw new HttpException(404, "assets/config.json file not found");
        }

        private Uri newUri(Uri newBase, string oldUri)
        {
            //set the hostname and port to the same as the new base return the new uri
            UriBuilder tmp = new UriBuilder(oldUri);
            tmp.Host = newBase.Host;
            if ((newBase.Port == 80) || (newBase.Port == 443))
                tmp.Port = -1;
            else
                tmp.Port = newBase.Port;
            tmp.Scheme = newBase.Scheme;

            return tmp.Uri; 
        }
    }
}


