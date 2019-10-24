using Microsoft.Extensions.Configuration;
using Newtonsoft.Json.Linq;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Text.RegularExpressions;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    class Program
    {
        internal static IConfigurationRoot config;
        internal static readonly string apiUrl = config["apiUrl"];
        internal static readonly string scope = config["scope"];

        static void Main(string[] args)
        {
            config = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", true, true)
                .Build();

            var ht = ArgsToHashtable(args);
            if (ht.ContainsKey("?"))
                ShowHelp();

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
                token = GetToken(email, password);
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

        static Hashtable ArgsToHashtable(string[] args)
        {
            var ht = new Hashtable
            {
                { "notoken", true },
                { "export", false },
                { "import", false }
            };

            var arguments = args ?? new string[] { };
            for (var i = 0; i < arguments.Length; i++)
            {
                var arg = Regex.Replace(arguments[i].ToLower(), "[-:]+", string.Empty);
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

        static string GetToken(string email, string password)
        {
            var req = new WebRequestOptions { UriString = $"{apiUrl}{Urls.login}" };
            var resp = req.Post(new HttpPostPayload
            {
                ContentType = "application/json",
                Data = new Authorize
                {
                    Email = email,
                    Password = password
                }.ToJson()
            }).FromJson<Credential>();
            return resp.Token;
        }

        static List<KeyValuePair<string, byte[]>> Export(string token, string exportdir)
        {
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
                        }
                        catch (WebException ex)
                        {
                            using (var stream = ex.Response.GetResponseStream())
                            {
                                using (var reader = new StreamReader(stream))
                                {
                                    var json = reader.ReadToEnd();
                                    var err = JObject.Parse(json);
                                    throw new Exception(err.Value<string>("Message"),
                                        new Exception(err.Value<string>("ExceptionMessage"), ex)
                                        {
                                            Data =
                                            {
                                                { "Server-ExceptionType", err.Value<string>("ExceptionType") },
                                                { "Server-StackTrace", err.Value<string>("StackTrace") },
                                            }
                                        });
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
