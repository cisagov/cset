using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Linq;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using Microsoft.AspNetCore.Hosting;


namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class AngularConfigController : ControllerBase
    {
        private readonly IWebHostEnvironment _webHost;
        public AngularConfigController(IWebHostEnvironment webHost)
        {
            _webHost = webHost;
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
        [Route("Reports/api/assets/config")]
        public IActionResult GetConfigURLRewrite(HttpRequestMessage requestMessage)
        {
            try
            {
                return Ok(processConfig(requestMessage.RequestUri));
            }
            catch (Exception ex)
            {
                return BadRequest("assets/config.json file not found");
            }
        }


        private JObject processConfig(Uri newBase)
        {
            var path = Path.Combine(_webHost.WebRootPath, "assets/config.json");
            if (System.IO.File.Exists(path))
            {
                string contents = System.IO.File.ReadAllText(path);
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
                var reportPath = Path.Combine(_webHost.WebRootPath, "/reports/index.html");
                if (System.IO.File.Exists(reportPath))
                {
                    reportsUrl += reportsUrl.EndsWith("reports/", StringComparison.CurrentCultureIgnoreCase) ? "" : "reports/";
                }
                jObject["reportsUrl"] = newUri(newBase, reportsUrl);
                return jObject;
            }
            throw new Exception("assets/config.json file not found");
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
