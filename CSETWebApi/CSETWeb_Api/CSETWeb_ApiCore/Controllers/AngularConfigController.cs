using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Linq;
using System.Net.Http;
using Newtonsoft.Json.Linq;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System.Text.Json;

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
        public IActionResult GetConfigURLRewrite()
        {
            try
            {
                return Ok(processConfig(HttpContext.Request.Host, HttpContext.Request.Scheme));
            }
            catch (Exception ex)
            {
                return BadRequest("assets/config.json file not found");
            }
        }


        private JObject processConfig(HostString newBase, string scheme)
        {
            var path = Path.Combine(_webHost.ContentRootPath, "UI/assets/config.json");
            if (System.IO.File.Exists(path))
            {
                string contents = System.IO.File.ReadAllText(path);
                var jObject = System.Text.Json.JsonDocument.Parse(contents);
                if (jObject["override"] != null)
                    if ((jObject["override"]).ToString().Equals("true", StringComparison.CurrentCultureIgnoreCase))
                        return jObject;

                // get the base appURL 
                // then change it to include the new port.
                string findString = jObject["appUrl"].ToString();
                
                jObject["appUrl"] = newUri(newBase,scheme, (jObject["appUrl"]).ToString());
                jObject["apiUrl"] = newUri(newBase,scheme, (jObject["apiUrl"]).ToString());
                jObject["docUrl"] = newUri(newBase,scheme, (jObject["docUrl"]).ToString());                

                return jObject;
            }
            throw new Exception("assets/config.json file not found");
        }


        private Uri newUri(HostString newBase,string scheme, string oldUri)
        {
            //set the hostname and port to the same as the new base return the new uri
            UriBuilder tmp = new UriBuilder(oldUri);
            tmp.Host = newBase.Host;
            if ((newBase.Port == 80) || (newBase.Port == 443))
                tmp.Port = -1;
            else
                tmp.Port = newBase.Port??80;
            tmp.Scheme = scheme;

            return tmp.Uri;
        }
    }
}
