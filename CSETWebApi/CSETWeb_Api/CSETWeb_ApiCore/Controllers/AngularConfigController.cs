//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Linq;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using System.Text.Json;
using Newtonsoft.Json.Linq;
using DocumentFormat.OpenXml.InkML;


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
                Console.WriteLine("Reading the path test");
                if (System.IO.File.Exists(Path.Combine(_webHost.ContentRootPath, "WebApp/index.html")))
                {
                    Console.WriteLine(Path.Combine(_webHost.ContentRootPath, "WebApp/index.html"));

                    //process this as if we are running internally else do what ever used to be the case
                    //in this case they are running together and we can just replace the config document. 
                    var jd = processUpdatedJson(HttpContext.Request);
                    return Ok(jd);
                }
                Console.WriteLine("Path didn't exist");

                return Ok(processConfig(HttpContext.Request.Host, HttpContext.Request.Scheme));
            }
            catch (Exception)
            {
                return BadRequest("assets/config.json file not found");
            }
        }


        [HttpPost]
        [Route("api/assets/changeConnectionString")]
        public string ChangeConnectionString([FromBody] string connString)
        {
            try
            {
                string currDirectory = Directory.GetCurrentDirectory();
                string appSettingsPath = currDirectory + "\\appsettings.json";

                if (System.IO.File.Exists(appSettingsPath))
                {
                    JObject document = JObject.Parse(System.IO.File.ReadAllText(appSettingsPath));
                    JToken element = document["ConnectionStrings"];

                    string previousConnString = element["CSET_DB"].ToString();
                    element["CSET_DB"] = connString;
                    document["ConnectionStrings"].Replace(element);

                    System.IO.File.WriteAllText(appSettingsPath, document.ToString());

                    return previousConnString;
                }
                else
                {
                    return "Error: \"appsettings.json\" could not be found";
                }
            }
            catch (Exception ex)
            {
                return "Error: something went wrong with changing the connection string in \"appsettings.json\". " + ex.Message;
            }
        }


        [HttpGet]
        [Route("api/assets/getConnectionString")]
        public string GetConnectionString()
        {
            try
            {
                string currDirectory = Directory.GetCurrentDirectory();
                string appSettingsPath = currDirectory + "\\appsettings.json";

                if (System.IO.File.Exists(appSettingsPath))
                {
                    JObject document = JObject.Parse(System.IO.File.ReadAllText(appSettingsPath));
                    JToken element = document["ConnectionStrings"];

                    return element["CSET_DB"].ToString();
                }
                else
                {
                    return "Error: \"appsettings.json\" could not be found";
                }
            }
            catch (Exception ex)
            {
                return "Error: something went wrong with getting the connection string in \"appsettings.json\". " + ex.Message;
            }
        }


        Newtonsoft.Json.Linq.JObject processUpdatedJson(HttpRequest context)
        {
            string webpath = _webHost.ContentRootPath;
            if (!webpath.Contains("WebApp"))
            {
                webpath = Path.Combine(_webHost.ContentRootPath, "WebApp");
            }

            var path = Path.Combine(webpath, "assets", "settings", "config.json");
            //if the files are there then assume we are running together
            //replace and return it. 

            if (System.IO.File.Exists(path))
            {
                JObject document = JObject.Parse(System.IO.File.ReadAllText(path));

                document.Add("rewrittenByRedirect", "true");

                JToken element = document["app"];
                element["host"] = context.Host.Host;
                if (String.IsNullOrWhiteSpace(context.Headers["X-Forwarded-Proto"]))
                {
                    element["protocol"] = context.Scheme;
                    string port = "443";
                    if ((context.Host.Port == 80) || (context.Host.Port == 443))
                        port = "";
                    else
                        port = (context.Host.Port == null) ? "" : context.Host.Port.ToString();
                    element["port"] = port;
                }
                else
                {
                    element["protocol"] = context.Headers["X-Forwarded-Proto"].ToString();
                    element["port"] = context.Headers["X-Forwarded-Port"].ToString();
                }

                element = document["api"];
                element["host"] = context.Host.Host;
                if (String.IsNullOrWhiteSpace(context.Headers["X-Forwarded-Proto"]))
                {
                    element["protocol"] = context.Scheme;
                    string port = "443";
                    if ((context.Host.Port == 80) || (context.Host.Port == 443))
                        port = "";
                    else
                        port = (context.Host.Port == null) ? "" : context.Host.Port.ToString();
                    element["port"] = port;
                }
                else
                {
                    element["protocol"] = context.Headers["X-Forwarded-Proto"].ToString();
                    element["port"] = context.Headers["X-Forwarded-Port"].ToString();
                }

                element = document["library"];
                element["host"] = context.Host.Host;
                if (String.IsNullOrWhiteSpace(context.Headers["X-Forwarded-Proto"]))
                {
                    element["protocol"] = context.Scheme;
                    string port = "443";
                    if ((context.Host.Port == 80) || (context.Host.Port == 443))
                        port = "";
                    else
                        port = (context.Host.Port == null) ? "" : context.Host.Port.ToString();
                    element["port"] = port;
                }
                else
                {
                    element["protocol"] = context.Headers["X-Forwarded-Proto"].ToString();
                    element["port"] = context.Headers["X-Forwarded-Port"].ToString();
                }

                Console.Write(document.ToString());
                return document;
            }
            throw new Exception("Cannot Find config file" + path);
        }




        private JsonElement processConfig(HostString newBase, string scheme)
        {
            _webHost.WebRootPath = Path.Combine(_webHost.ContentRootPath, "../../../CSETWebNg/src");
            var path = Path.Combine(_webHost.WebRootPath, "assets/settings/config.json");
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
                            string findString = root.GetProperty("app").GetProperty("url").ToString();
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


        private Uri newUri(HostString newBase, string scheme, string oldUri)
        {
            //set the hostname and port to the same as the new base return the new uri
            UriBuilder tmp = new UriBuilder(oldUri);
            tmp.Host = newBase.Host;
            if ((newBase.Port == 80) || (newBase.Port == 443))
                tmp.Port = -1;
            else
                tmp.Port = newBase.Port ?? 80;
            tmp.Scheme = scheme;

            return tmp.Uri;
        }
    }
}
