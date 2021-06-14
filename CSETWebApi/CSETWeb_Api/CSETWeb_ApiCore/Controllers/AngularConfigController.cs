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


        private JsonElement processConfig(HostString newBase, string scheme)
        {
            _webHost.WebRootPath = Path.Combine(_webHost.ContentRootPath, "../../../CSETWebNg/src");
            var path = Path.Combine(_webHost.WebRootPath, "assets/config.json");
            if (System.IO.File.Exists(path))
            {
                string contents = System.IO.File.ReadAllText(path);
                using (MemoryStream memoryStream = new MemoryStream()) 
                {
                    using (Utf8JsonWriter writer = new Utf8JsonWriter(memoryStream)) 
                    {
                        using (JsonDocument jDoc = JsonDocument.Parse(contents))
                        {

                            JsonElement root = jDoc.RootElement.Clone();
                            JsonElement overrideVal;
                            if (root.TryGetProperty("override", out overrideVal) != false)
                                if (overrideVal.ToString().Equals("true", StringComparison.CurrentCultureIgnoreCase))
                                    return root;

                            // get the base appURL 
                            // then change it to include the new port. 
                            string findString = root.GetProperty("appUrl").ToString();
                            string replaceString = newBase + "/";

                            if (findString.SequenceEqual(replaceString))
                                return root;

                            // to edit json values, have to create an entire new JsonDocument since they are read-only
                            writer.WriteStartObject();
                            foreach (var element in root.EnumerateObject())
                            {
                                if (element.Name == "appUrl")
                                {
                                    writer.WritePropertyName(element.Name);
                                    writer.WriteStringValue(newUri(newBase, scheme, root.GetProperty("appUrl").ToString()).ToString());
                                }
                                else if (element.Name == "apiUrl")
                                {
                                    writer.WritePropertyName(element.Name);
                                    writer.WriteStringValue(newUri(newBase, scheme, root.GetProperty("apiUrl").ToString()).ToString());
                                }
                                else if (element.Name == "docUrl")
                                {
                                    writer.WritePropertyName(element.Name);
                                    writer.WriteStringValue(newUri(newBase, scheme, root.GetProperty("docUrl").ToString()).ToString());
                                }
                                // write same value as original config json
                                else
                                {
                                    element.WriteTo(writer);
                                }
                            }
                            writer.WriteEndObject();    
                        }
                        // create new JsonDocument with edited values
                        writer.Flush();
                        string newJson = System.Text.Encoding.UTF8.GetString(memoryStream.ToArray());
                        using JsonDocument newJDoc = JsonDocument.Parse(newJson);
                        return newJDoc.RootElement.Clone();
                    }
                }
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
