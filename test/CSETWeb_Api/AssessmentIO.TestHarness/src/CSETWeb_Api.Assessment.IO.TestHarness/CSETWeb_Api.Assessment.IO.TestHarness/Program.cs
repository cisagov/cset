using Microsoft.Extensions.Configuration;
using Newtonsoft.Json.Linq;
using Serilog;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text.RegularExpressions;
using System.Threading;
using Newtonsoft.Json;
using System.Threading.Tasks;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    class Program
    {
        internal static IConfigurationRoot config;

        static void Main(string[] args)
        {
            config = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", true, true)
                .Build();

            Log.Logger = new LoggerConfiguration()
                .WriteTo.File($@"logs\CSETWeb_Api.ImportExport.{TimeStamp.Now}.log")
                .CreateLogger();

            var ht = ArgsToHashtable(args);
            if (ht.ContainsKey("?"))
                ShowHelp();

            initClient();
            try
            {
                var export = ht.GetValueOrDefault<bool>("export");
                var import = ht.GetValueOrDefault<bool>("import");
                if (!export && !import)
                {
                    // nothing to do.
                    Console.WriteLine("Please provide an export and/or import directive paramater.");
                    Environment.Exit(-1);
                }

                var token = ht.GetValueOrDefault<string>("token");
                var notoken = ht.GetValueOrDefault<bool>("notoken");
                if (notoken)
                {
                    var email = ht.GetValueOrDefault<string>("email");
                    if (string.IsNullOrEmpty(email))
                    {
                        // no token or email
                        Console.WriteLine("Insufficient authentication paramaters provided.");
                        Environment.Exit(-2);
                    }
                    var password = ht.GetValueOrDefault<string>("password");
                    if (string.IsNullOrEmpty(password))
                    {
                        // no password
                        Console.WriteLine("Insufficient authentication paramaters provided.");
                        Environment.Exit(-3);
                    }
                    Task<string> t = Task.Run(()=> GetToken(email, password));
                    t.Wait();
                    token = t.Result;
                }

                var files = new List<KeyValuePair<string, byte[]>>();
                if (export)
                {
                    var exportdir = ht.GetValueOrDefault<string>("exportdir");
                    files = Export(token, exportdir);
                }

                if (import)
                {
                    var importdir = ht.GetValueOrDefault<string>("importdir");
                    Import(token, importdir, files);
                }
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Exiting with error.");
            }
        }


        static Hashtable ArgsToHashtable(string[] args)
        {
            var ht = new Hashtable
            {
                { "notoken", true },
                { "export", false },
                { "import", false }
            };

            var arguments = (args ?? new string[] { })
                .Select(x => Directory.Exists(x) ? x : Regex.Replace(x.ToLower(), "[:-]+", string.Empty))
                .Where(x => !string.IsNullOrEmpty(x))
                .ToArray();
            for (var i = 0; i < arguments.Length; i++)
            {
                var arg = arguments[i];
                switch (arg)
                {
                    case "token":
                        ht[arg] = arguments[++i];
                        ht["notoken"] = false;
                        break;
                    case "notoken":
                        var token = ht.GetValueOrDefault<string>("token");
                        ht[arg] = string.IsNullOrEmpty(token);
                        break;
                    case "export":
                    case "import":
                        ht[arg] = true;
                        break;
                    case "email":
                    case "password":
                        if (!ht.GetValueOrDefault<bool>("notoken"))
                        {
                            i++;
                            continue;
                        }
                        ht[arg] = arguments[++i];
                        break;
                    case "exportdir":
                        ht[arg] = arguments[++i];
                        ht["export"] = true;
                        break;
                    case "importdir":
                        ht[arg] = arguments[++i];
                        ht["import"] = true;
                        break;
                    case "?":
                    case "help":
                        ht["?"] = true;
                        break;
                }
            }
            return ht;
        }

        static void ShowHelp()
        {
            Console.WriteLine("CSETWeb_Api.AssessmentIO.TestHarness");
            Console.WriteLine("For tesing export and import capabilities of CSETWeb_Api service.");
            Console.WriteLine();
            Console.WriteLine("Paramters:");
            Console.WriteLine("token <value>:     A previously obtained token to use for authentication.");
            Console.WriteLine("email <value>:     The use account email address for which to export/import assessment records.");
            Console.WriteLine("                   Required when token value has not been provided");
            Console.WriteLine("password <value>:  The user account password to use for authentication.");
            Console.WriteLine("                   Required when token value has not been provided and email value has.");
            Console.WriteLine("export:            A directive that indicates that assessments are to be exported.");
            Console.WriteLine("                   Optional when export directory has been provided.");
            Console.WriteLine("exportdir <path>:  The path to save exported assessment files in.");
            Console.WriteLine("import:            A directive that indicates that assessments are to be imported.");
            Console.WriteLine("                   Optional when import directory has been provided.");
            Console.WriteLine("importdir <path>:  The path to load imported assessment files from.");
            Console.WriteLine("                   Use this option to test legacy assessment import.");
            Console.WriteLine("? | help:          Displays this help message.");
            Console.WriteLine();
            Console.WriteLine("When export directive has been provided and no export directory has been set, exports are performed in memory.");
            Console.WriteLine("When import and export directives has been provided and no import directory has been set, imports are performed on those exported in memory.");
            Console.WriteLine();
            Console.WriteLine("Usage:");
            Console.WriteLine("dotnet CSETWeb_Api.AssessmentIO.TestHarness.dll ?");
            Console.WriteLine();
            Console.WriteLine("To export then import all assessments for a given authorizing token. Exports and imports are performed in memory.");
            Console.WriteLine("dotnet CSETWeb_Api.AssessmentIO.TestHarness.dll token <value> export import");
            Console.WriteLine();
            Console.WriteLine("To export all assessments for a given user to a file system directory.");
            Console.WriteLine("dotnet CSETWeb_Api.AssessmentIO.TestHarness.dll email <value> password <value> exportdir <path>");
            Console.WriteLine();
            Console.WriteLine("To import all assessments in a file system directory to a given user's account.");
            Console.WriteLine("dotnet CSETWeb_Api.AssessmentIO.TestHarness.dll email <value> password <value> importdir <path>");
            Environment.Exit(0);
        }

        private static HttpClient client;
        static void initClient()
        {
            var handler = new TimeoutHandler
            {
                InnerHandler = new HttpClientHandler()
            };
            client = new HttpClient(handler);
            client.Timeout = Timeout.InfiniteTimeSpan;
            client.BaseAddress = new Uri(config["apiUrl"]);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        private static async Task<string> GetToken(string email, string password)
        {
            string apiUrl = config["apiUrl"];
            var req = new WebRequestOptions { UriString = $"{apiUrl}{Urls.login}" };

            HttpResponseMessage response = await client.PostAsJsonAsync(req.UriString, 
            new Authorize()
            {
                Email = email,
                Password = password,
                TzOffset = 360
            });
            if (response.IsSuccessStatusCode)
            {
                string json = await response.Content.ReadAsStringAsync();
                var loginResponse = JsonConvert.DeserializeObject<Credential>(json);
                return loginResponse.Token;
            }
            else
            {
                Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
            }
            return "";
        }

        static List<KeyValuePair<string, byte[]>> Export(string token, string exportdir)
        {
            string apiUrl = config["apiUrl"];
            
            var req = new WebRequestOptions
            {
                UriString = $"{apiUrl}{Urls.assessments}",
                Headers = new Dictionary<string, string> { { "Authorization", token } }
            };

            var files = new List<KeyValuePair<string, byte[]>>();
            var assessments = req.Get().FromJson<Assessment[]>();
            foreach (var id in assessments.Select(x => x.AssessmentId))
            {
                req.UriString = $"{apiUrl}{Urls.token}?assessmentid={id}&expSeconds=10";
                var assmt_token = req.Get().FromJson<Credential>().Token;
                if (!string.IsNullOrEmpty(assmt_token))
                {
                    var expreq = new WebRequestOptions { UriString = $"{apiUrl}{Urls.export}?token={assmt_token}" };
                    using (var bs = expreq.GetStream())
                    {
                        var filename = bs.FileName.SanitizePathPart();
                        files.Add(new KeyValuePair<string, byte[]>(filename, bs.Buffer));
                        var log = $"{filename} | \"Assessment was successfully exported\"";
                        Console.WriteLine(log);
                        Log.Information(log);
                    }
                }
            }

            if (!string.IsNullOrEmpty(exportdir))
            {
                var dir = new DirectoryInfo(exportdir);
                if (!dir.Exists)
                    dir.Create();
                dir.Clear();
                foreach (var file in files)
                {
                    var filepath = Path.Combine(exportdir, file.Key.SanitizePathPart());
                    filepath = FileHelper.GetSafeFileName(filepath);
                    File.WriteAllBytes(filepath, file.Value);
                }
            }
            return files;
        }

        static void Import(string token, string importdir, List<KeyValuePair<string, byte[]>> files)
        {
            string apiUrl = config["apiUrl"];
            if (Directory.Exists(importdir))
            {
                files.Clear();
                foreach (var filepath in Directory.GetFiles(importdir, "*.csetw", SearchOption.AllDirectories))
                {
                    var buffer = File.ReadAllBytes(filepath);
                    files.Add(new KeyValuePair<string, byte[]>(Path.GetFileName(filepath), buffer));
                }
            }

            var req = new WebRequestOptions
            {
                UriString = $"{apiUrl}{Urls.import}",
                Headers = new Dictionary<string, string> { { "Authorization", token } }
            };

            foreach (var file in files)
            {
                var filename = file.Key;
                var buffer = file.Value;
                using (var bs = new BlobStream(filename, "application/octet-stream"))
                {
                    bs.Write(buffer, 0, buffer.Length);
                    var content = new Dictionary<string, object> { { "file", bs } };
                    using (var data = MimeMultipartStream.FromContent(content))
                    {
                        try
                        {
                            var resp = req.Post(new HttpPostPayload
                            {
                                ContentType = data.ContentType,
                                Data = data.Buffer
                            });
                            var log = $"{filename} | {resp}";
                            Console.WriteLine(log);
                            Log.Information(log);
                        }
                        catch (WebException ex)
                        {
                            using (var stream = ex.Response.GetResponseStream())
                            {
                                using (var reader = new StreamReader(stream))
                                {
                                    var json = reader.ReadToEnd();
                                    var err = JObject.Parse(json);
                                    var log = $"{filename} | \"Failed to import assessment\"";
                                    Console.WriteLine(log);
                                    Log.Error(ex, log);
                                    Log.Error("Server-Message: {0}", err.Value<string>("Message"));
                                    Log.Error("Server-ExceptionType: {0}", err.Value<string>("ExceptionType"));
                                    Log.Error("Server-ExceptionMessage: {0}", err.Value<string>("ExceptionMessage"));
                                    Log.Error("Server-StackTrace: {0}", err.Value<string>("StackTrace"));
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    class TimeoutHandler : DelegatingHandler
    {
        protected async override Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            using (var cts = GetCancellationTokenSource(request, cancellationToken))
            {
                return await base.SendAsync(
                    request,
                    cts?.Token ?? cancellationToken);
            }
        }

        private CancellationTokenSource GetCancellationTokenSource(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            var timeout = request.GetTimeout() ?? DefaultTimeout;
            if (timeout == Timeout.InfiniteTimeSpan)
            {
                // No need to create a CTS if there's no timeout
                return null;
            }
            else
            {
                var cts = CancellationTokenSource
                    .CreateLinkedTokenSource(cancellationToken);
                cts.CancelAfter(timeout);
                return cts;
            }
        }

        public TimeSpan DefaultTimeout { get; set; } = TimeSpan.FromSeconds(15);

    }

    public static class HttpRequestExtensions
    {
        private static string TimeoutPropertyKey = "RequestTimeout";

        public static void SetTimeout(
            this HttpRequestMessage request,
            TimeSpan? timeout)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            request.Properties[TimeoutPropertyKey] = timeout;
        }

        public static TimeSpan? GetTimeout(this HttpRequestMessage request)
        {
            if (request == null)
                throw new ArgumentNullException(nameof(request));

            if (request.Properties.TryGetValue(
                    TimeoutPropertyKey,
                    out var value)
                && value is TimeSpan timeout)
                return timeout;
            return null;
        }
    }
}
