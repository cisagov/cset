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
using System.Threading;
using Newtonsoft.Json;
using System.Threading.Tasks;
using System.Data.SqlClient;
using System.Data;
using System.Net.Http.Json;
using System.Diagnostics;
using System.Text;
using Microsoft.Build.Execution;

namespace CSETWeb_Api.AssessmentIO.TestHarness
{
    class Program
    {
        internal static IConfigurationRoot config;

        private static StringBuilder comparisonOutput = null;
        private static StringBuilder completeComparisonOutput = null;

        static void Main(string[] args)
        {

            config = new ConfigurationBuilder()
                .SetBasePath(Directory.GetCurrentDirectory())
                .AddJsonFile("appsettings.json", true, true)
                .Build();

            initClient();

            //Console.WriteLine("Enter " +
            //    "the directory to export assessments to, " +
            //    "the directory to send the log file to, " +
            //    "the name of the source DB, and the name of the destination DB in the form of:\n " +
            //    "C:\\Users\\MyAccount\\Documents\\INL\\AssessmentsExportedHere " +
            //    "C:\\Users\\MyAccount\\Documents\\INL\\IOComparisonLogFiles " +
            //    "srcDB destDB\n");

            try
            {
                string exportDirectory = config["exportDirectory"];
                string logDirectory = config["logDirectory"];
                string originalDbName = config["originalDbName"];
                string copyDbName = config["copyDbName"];
                //while (string.IsNullOrEmpty(exportDirectory) || string.IsNullOrEmpty(logDirectory) || string.IsNullOrEmpty(originalDbName) || string.IsNullOrEmpty(copyDbName))
                //{
                //    var input = Console.ReadLine().Split(" ");

                //    if (input.Length == 4)
                //    {
                //        exportDirectory = input[0];
                //        logDirectory = input[1];
                //        originalDbName = input[2];
                //        copyDbName = input[3];

                //        if (string.IsNullOrEmpty(exportDirectory) || string.IsNullOrEmpty(logDirectory) || string.IsNullOrEmpty(originalDbName) || string.IsNullOrEmpty(copyDbName))
                //        {
                //            Console.WriteLine("One or more input fields are missing. Please enter all fields separated by spaces:");
                //            Log.Logger.Warning("One or more input fields are missing.");
                //            Log.Logger.Warning($"exportDirectory='{exportDirectory}', logDirectory='{logDirectory}', originalDbName='{originalDbName}', copyDbName='{copyDbName}'.");
                //        }
                //    }
                //    else
                //    {
                //        Console.WriteLine("One or more input fields are missing. Please enter all fields separated by spaces:");
                //        Log.Logger.Warning("One or more input fields are missing.");
                //        Log.Logger.Warning($"exportDirectory='{exportDirectory}', logDirectory='{logDirectory}', originalDbName='{originalDbName}', copyDbName='{copyDbName}'.");
                //    }

                //}

                string username = Environment.UserName;
                string inputEmail = username;

                if (!Directory.Exists(logDirectory))
                {
                    Directory.CreateDirectory(logDirectory);
                }

                Log.Logger = new LoggerConfiguration()
                    .WriteTo.File(logDirectory + "\\IODBComparison." + TimeStamp.Now + ".log")
                    .CreateLogger();

                //string connString = config.GetConnectionString("CSET_DB");
                //SqlConnection conn = new SqlConnection(connString);
                //Console.WriteLine("You typed: " + importDirectory + " "+ inputEmail + " "+ inputPassword);

                //if (!Directory.Exists(importDirectory) && importDirectory != "none")
                //{
                //    Log.Logger.Fatal("The import directory " + importDirectory + " could not be found.");
                //    Console.WriteLine("The import directory could not be found.");
                //    Environment.Exit(-1);
                //}
                //if (string.IsNullOrEmpty(inputEmail) || string.IsNullOrEmpty(inputPassword))
                //{
                //    Log.Logger.Fatal("The user input has missing fields. (importDirectory: " + importDirectory + 
                //        ", exportDirectory: " + exportDirectory +", inputEmail: " + inputEmail + ", inputPassword: " + inputPassword + ")");
                //    Console.WriteLine("Either the email or password is missing.");
                //    Environment.Exit(-1);
                //}
                if (!Directory.Exists(exportDirectory))
                {
                    Log.Logger.Information("Export directory not found. Creating a new export directory with the path: " + exportDirectory);
                    Console.WriteLine("Export directory not found. Creating a new export directory with the path: " + exportDirectory);
                    Directory.CreateDirectory(exportDirectory);
                }

                string originalConnString = "data source=(localdb)\\mssqllocaldb;initial catalog=" + originalDbName + ";persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True";
                string copyConnString = "data source=(localdb)\\mssqllocaldb;initial catalog=" + copyDbName + ";persist security info=True;Integrated Security=SSPI;MultipleActiveResultSets=True";

                // switch DBs
                string apiUrl = config["apiUrl"];

                string originalMdfPath = "C:\\Users\\" + username + "\\" + originalDbName + ".mdf";
                string originalLdfPath = "C:\\Users\\" + username + "\\" + originalDbName + "_log.ldf";

                string copyMdfPath = "C:\\Users\\" + username + "\\" + copyDbName + ".mdf";
                string copyLdfPath = "C:\\Users\\" + username + "\\" + copyDbName + "_log.ldf";

                // if the db has already been copied, clear the db files so a new copy can be made
                if (File.Exists(copyMdfPath) &&
                    File.Exists(copyLdfPath))
                {
                    Console.WriteLine("Copied database files exist at \'" + copyMdfPath + "\' and \'" + copyLdfPath + "\'. Dropping the copied table \'" + copyDbName + "\'.");
                    Log.Logger.Information("Copied database files exist at \'" + copyMdfPath + "\' and \'" + copyLdfPath + "\'. Dropping the copied table \'" + copyDbName + "\'.");

                    using (SqlConnection sqlConnectionDropTable = new SqlConnection(originalConnString))
                    {
                        //
                        sqlConnectionDropTable.Open();

                        // command to count how much to walk the seed back
                        // and to get the last entered identity in the ASSESSMENTS table
                        string dropTableCmd =
                            $"DROP DATABASE IF EXISTS {copyDbName};";

                        SqlCommand sqlCommandDropTable = new SqlCommand(dropTableCmd, sqlConnectionDropTable);
                        IAsyncResult resultDropTable = sqlCommandDropTable.BeginExecuteReader();

                        while (!resultDropTable.IsCompleted)
                        {

                        }

                        using (SqlDataReader reader = sqlCommandDropTable.EndExecuteReader(resultDropTable))
                        {
                            while (reader.Read())
                            {

                            }
                        }
                        Log.Logger.Information($"Database {copyDbName} dropped.");

                        sqlConnectionDropTable.Close();
                        sqlConnectionDropTable.Dispose();
                    }
                }

                // make a copy of the db files
                try
                {
                    Log.Logger.Information("Copying the .mdf file located at \'" + originalMdfPath + "\' to \'" + copyMdfPath + "\'.");
                    File.Copy(originalMdfPath, copyMdfPath);
                    Log.Logger.Information("Copying the .ldf file located at \'" + originalLdfPath + "\' to \'" + copyLdfPath + "\'.");
                    File.Copy(originalLdfPath, copyLdfPath);
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error copying the .mdf and .ldf files. Try running again.");
                    Log.Logger.Fatal("Error copying the .mdf and .ldf files. " + ex.Message);
                    Environment.Exit(1);
                }

                int rowsInAssessment = 0;
                int identityInAssessment = 0;
                int rowsInContacts = 0;
                int identityInContacts = 0;
                int rowsInAnswer = 0;
                int identityInAnswer = 0;
                int rowsInFinding = 0;
                int identityInFinding = 0;
                int rowsInDocument = 0;
                int identityInDocument = 0;
                int rowsInDiagram = 0;
                int identityInDiagram = 0;
                int rowsInIRP = 0;
                int identityInIRP = 0;

                Log.Logger.Information("Starting the reseeding process...");

                SqlConnection sqlConnection = new SqlConnection(originalConnString);

                //
                sqlConnection.Open();

                // command to count how much to walk the seed back
                // and to get the last entered identity in the ASSESSMENTS table
                string getRowCountAssessmentCmd =
                    $"select count(*), MAX(Assessment_Id) from [{originalDbName}].[dbo].[ASSESSMENTS];";

                SqlCommand sqlCommand = new SqlCommand(getRowCountAssessmentCmd, sqlConnection);
                IAsyncResult result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInAssessment = reader.GetValue(0).ParseInt32OrDefault();
                        identityInAssessment = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in ASSESSMENTS: " + rowsInAssessment);
                        Log.Logger.Information("Highest identity in ASSESSMENTS: " + identityInAssessment);
                        Log.Logger.Information($"Reseed value: {identityInAssessment - rowsInAssessment}");
                    }
                }

                // command to count how much to walk the seed back
                // and to get the last entered identity in the ASSESSMENT_CONTACTS table
                string getRowCountContactCmd =
                    $"select count(*), MAX(Assessment_Contact_Id) from [{originalDbName}].[dbo].[ASSESSMENT_CONTACTS];";

                sqlCommand = new SqlCommand(getRowCountContactCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInContacts = reader.GetValue(0).ParseInt32OrDefault();
                        identityInContacts = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in ASSESSMENT_CONTACTS: " + rowsInContacts);
                        Log.Logger.Information("Highest identity in ASSESSMENT_CONTACTS: " + identityInContacts);
                        Log.Logger.Information($"Reseed value: {identityInContacts - rowsInContacts}");
                    }
                }

                // command to count how much to walk the seed back
                // and to get the last entered identity for the ANSWER table
                string getRowCountAnswerCmd =
                    $"select count(*), MAX(Answer_Id) from [{originalDbName}].[dbo].[ANSWER];";

                sqlCommand = new SqlCommand(getRowCountAnswerCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInAnswer = reader.GetValue(0).ParseInt32OrDefault();
                        identityInAnswer = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in ANSWER: " + rowsInAnswer);
                        Log.Logger.Information("Highest identity in ANSWER: " + identityInAnswer);
                        Log.Logger.Information($"Reseed value: {identityInAnswer - rowsInAnswer}");
                    }
                }

                // command to count how much to walk the seed back
                // and to get the last entered identity for the FINDING table
                string getIdentitytAnswerCmd =
                    $"select count(*), MAX(Finding_Id) from [{originalDbName}].[dbo].[FINDING];";

                sqlCommand = new SqlCommand(getIdentitytAnswerCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInFinding = reader.GetValue(0).ParseInt32OrDefault();
                        identityInFinding = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in FINDING: " + rowsInFinding);
                        Log.Logger.Information("Highest identity in FINDING: " + identityInFinding);
                        Log.Logger.Information($"Reseed value: {identityInFinding - rowsInFinding}");
                    }
                }

                // command to count how much to walk the seed back
                // and to get the last entered identity for the DOCUMENT_FILE table
                string getIdentitytDocumentCmd =
                    $"select count(*), MAX(Document_Id) from [{originalDbName}].[dbo].[DOCUMENT_FILE];";

                sqlCommand = new SqlCommand(getIdentitytDocumentCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInDocument = reader.GetValue(0).ParseInt32OrDefault();
                        identityInDocument = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in DOCUMENT_FILE: " + rowsInDocument);
                        Log.Logger.Information("Highest identity in DOCUMENT_FILE: " + identityInDocument);
                        Log.Logger.Information($"Reseed value: {identityInDocument - rowsInDocument}");
                    }
                }

                // command to count how much to walk the seed back
                // and to get the last entered identity for the DOCUMENT_FILE table
                string getIdentitytDiagramCmd =
                    $"select count(*), MAX(Container_Id) from [{originalDbName}].[dbo].[DIAGRAM_CONTAINER];";

                sqlCommand = new SqlCommand(getIdentitytDiagramCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInDiagram = reader.GetValue(0).ParseInt32OrDefault();
                        identityInDiagram = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in DIAGRAM_CONTAINER: " + rowsInDiagram);
                        Log.Logger.Information("Highest identity in DIAGRAM_CONTAINER: " + identityInDiagram);
                        Log.Logger.Information($"Reseed value: {identityInDiagram - rowsInDiagram}");
                    }
                }

                // command to count how much to walk the seed back
                // and to get the last entered identity for the DOCUMENT_FILE table
                string getIdentitytIRPCmd =
                    $"select count(*), MAX(Answer_Id) from [{originalDbName}].[dbo].[ASSESSMENT_IRP];";

                sqlCommand = new SqlCommand(getIdentitytIRPCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        rowsInIRP = reader.GetValue(0).ParseInt32OrDefault();
                        identityInIRP = reader.GetValue(1).ParseInt32OrDefault();
                        Log.Logger.Information("Rows in ASSESSMENT_IRP: " + rowsInIRP);
                        Log.Logger.Information("Highest identity in ASSESSMENT_IRP: " + identityInIRP);
                        Log.Logger.Information($"Reseed value: {identityInIRP - rowsInIRP}");
                    }
                }
                //

                // command to create a new db to copy the original
                string createDbCmd =
                    "CREATE DATABASE " + copyDbName + "  ON (NAME = '" + copyDbName + "_mdf', FILENAME = '" + copyMdfPath + "'), (NAME = '" + copyDbName + "_ldf', FILENAME = '" + copyLdfPath + "') FOR ATTACH;" +
                    "SET QUOTED_IDENTIFIER ON; delete from [" + copyDbName + "].[dbo].[DOCUMENT_FILE]; " +
                    "delete from [" + copyDbName + "].[dbo].MATURITY_DOMAIN_REMARKS; " +
                    "delete from [" + copyDbName + "].[dbo].ASSESSMENT_DIAGRAM_COMPONENTS; " +
                    "delete from [" + copyDbName + "].[dbo].DIAGRAM_CONTAINER; " +
                    "delete from [" + copyDbName + "].[dbo].ACCESS_KEY; " +
                    "delete from [" + copyDbName + "].[dbo].ACCESS_KEY_ASSESSMENT; " +
                    "delete from [" + copyDbName + "].[dbo].[ASSESSMENTS]; " +
                    "delete from [" + copyDbName + "].[dbo].[aggregation_information]; " +
                    "delete from [" + copyDbName + "].[dbo].[DIAGRAM_CONTAINER]; " +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[ASSESSMENTS]', RESEED, " + (identityInAssessment - rowsInAssessment) + "); " +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[ASSESSMENT_CONTACTS]', RESEED, " + (identityInContacts - rowsInContacts) + ");" +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[ANSWER]', RESEED, " + (identityInAnswer - rowsInAnswer) + ");" +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[FINDING]', RESEED, " + (identityInFinding - rowsInFinding) + ");" +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[DOCUMENT_FILE]', RESEED, " + (identityInDocument - rowsInDocument) + ");" +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[DIAGRAM_CONTAINER]', RESEED, " + (identityInDiagram - rowsInDiagram) + ");" +
                    "DBCC CHECKIDENT ('[" + copyDbName + "].[dbo].[ASSESSMENT_IRP]', RESEED, " + (identityInIRP - rowsInIRP) + ");";

                // creates a copy of the db, then clears it of all assessment data

                sqlCommand = new SqlCommand(createDbCmd, sqlConnection);
                result = sqlCommand.BeginExecuteReader();

                while (!result.IsCompleted)
                {

                }

                using (SqlDataReader reader = sqlCommand.EndExecuteReader(result))
                {
                    while (reader.Read())
                    {
                        // Display all the columns.
                        for (int i = 0; i < reader.FieldCount; i++)
                            Console.Write("{0} ", reader.GetValue(i));
                        Console.WriteLine();
                    }
                }

                sqlConnection.Close();

                Console.WriteLine("Start the API, then press the 'Enter' key.");
                Console.ReadLine();

                /*
                var csetWebApiProjPath = config["pathToCsetWebApiCsprojFile"];
                Console.WriteLine("Building CSETWebApi project at the following path: " + csetWebApiProjPath);

                // Build the main CSETWeb API project
                Microsoft.Build.Evaluation.Project p = new Microsoft.Build.Evaluation.Project(csetWebApiProjPath, null, "Current");
                p.SetGlobalProperty("Configuration", "Debug");
                bool buildSuccess = p.Build();

                if (buildSuccess) 
                {
                    Console.WriteLine("Build successful. Running the project...");
                    Process startApi = new Process();
                    startApi.StartInfo.FileName = Path.GetDirectoryName(csetWebApiProjPath) + @"bin\debug\net7.0\CSETWebCore.Api.exe";
                    startApi.StartInfo.UseShellExecute = true;
                    startApi.Start();
                }
                */

                Console.WriteLine("Logging in...");
                Log.Logger.Information("Start of the login process...");
                Task<string> t = Task.Run(() => GetToken(inputEmail, ""));
                t.Wait();
                string token = t.Result;

                Log.Logger.Information("Login complete. Token received from login: " + token);

                Console.WriteLine("Exporting assessments from original DB...");
                Log.Logger.Information("Start of the export process...");

                var fileList = Export(token, exportDirectory);
                Console.WriteLine("Export complete.\n");
                Log.Logger.Information("Export complete.");

                Console.WriteLine("Changing connection string to \'" + copyConnString + "\'");
                Log.Logger.Information("Changing connection string to \'" + copyConnString + "\'");

                // this changes the connection string to the newly created db
                Task<string> task = Task.Run(() => ChangeConnString(copyConnString));
                task.Wait();
                originalConnString = task.Result.Replace("\"", "").Replace("\\\\", "\\"); //returns what the current connection string is

                /** 
                    * sleep is so the appsettings.json can register the connection string change,
                    * otherwise the first import is aimed at the originalDb and the Assessment_Id for the 
                    * comparison is off by 1
                    */
                Thread.Sleep(2000);
                Console.WriteLine("Connection string changed.\n");
                Log.Logger.Information("Connection string changed.");
                // end of switch DBs

                Console.WriteLine("Importing assessments into copied DB...");
                Log.Logger.Information("Start of the import process...");

                // targets the API's export function
                Import(token, exportDirectory, fileList);
                Console.WriteLine("Import complete.\n");
                Log.Logger.Information("Import complete.");

                // switch DBs back to avoid inconveniencing the user
                Log.Logger.Information("Changing the connection string back to: " + originalConnString);
                task = Task.Run(() => ChangeConnString(originalConnString));
                task.Wait();
                copyConnString = task.Result.Replace("\"", "").Replace("\\\\", "\\");

                if (copyConnString == originalConnString)
                {
                    Console.WriteLine($"The original connection string {originalConnString} is the same as the copied DB's connection string ({copyConnString})");
                    Log.Logger.Fatal($"The original connection string {originalConnString} is the same as the copied DB's connection string ({copyConnString})");

                    Environment.Exit(-5);
                }
                // end of switch DBs back

                Console.WriteLine("Success! Starting the comparison process...");
                Log.Logger.Information("Connection string changed back. Starting the comparison process.");

                // start of comparison


                // string projectPath = @$"C:\Users\{username}\Documents\SQLExaminerTest.sdeproj";
                string projectPath = @$"C:\Users\{username}\source\repos\cisagov\cset\test\CSETWeb_Api\AssessmentIO.TestHarness\src\CSETWeb_Api.Assessment.IO.TestHarness\CSETWeb_Api.Assessment.IO.TestHarness\SQLExaminerTest.sdeproj";
                string reportPath = @$"C:\Users\{username}\Documents\reportTest.html";

                using (Process process = new Process())
                {
                    string sqlDECmdPath = "C:\\Program Files (x86)\\SQL Examiner Suite 2023\\SQLDECmd.exe";
                    process.StartInfo.WorkingDirectory = @"C:\";
                    process.StartInfo.FileName = sqlDECmdPath;
                    process.StartInfo.Arguments = "/project:" + projectPath + " /report:" + reportPath + " /ReportOn:Different /Force";
                    process.StartInfo.UseShellExecute = false;

                    process.StartInfo.RedirectStandardOutput = true;
                    comparisonOutput = new StringBuilder();
                    completeComparisonOutput = new StringBuilder();

                    process.OutputDataReceived += ComparisonOutputHandler;
                    process.StartInfo.RedirectStandardOutput = true;
                    process.StartInfo.RedirectStandardError = true;

                    Log.Logger.Information("Using the command line located at \'" + sqlDECmdPath + "\'.");
                    Log.Logger.Information("Starting SQL Data Examiner project located at \'" + projectPath + "\'.");

                    process.Start();

                    process.BeginErrorReadLine();
                    process.BeginOutputReadLine();

                    process.WaitForExit();
                    process.Close();

                    if (comparisonOutput.Length == 0)
                    {
                        Console.WriteLine("No differences found!");
                        Log.Logger.Information("No differences found between the databases.");
                        Log.Logger.Information("The full comparison is below:");
                        Log.Logger.Information(completeComparisonOutput.ToString());
                    } else
                    {
                        Console.WriteLine(comparisonOutput);
                        Log.Logger.Warning("The following differences were found:");
                        Log.Logger.Warning(comparisonOutput.ToString());
                        Log.Logger.Information("The full comparison is below:");
                        Log.Logger.Information(completeComparisonOutput.ToString());
                    }

                    Console.WriteLine("\nA complete difference report can be found here: " + reportPath);
                    Log.Logger.Information("A complete difference report can be found here: " + reportPath);
                }
                
            } catch (Exception ex) { Console.WriteLine(ex.ToString()); }
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
            //var req = new WebRequestOptions { UriString = $"{apiUrl}{Urls.login}" };
            var req1 = new WebRequestOptions { UriString = $"{apiUrl}{Urls.loginStandalone}", Username = email };
            
            HttpResponseMessage response = await client.PostAsJsonAsync(req1.UriString, 
            new Authorize()
            {
                Email = email,
                //Password = password,
                TzOffset = 360
            });
            if (response.IsSuccessStatusCode)
            {
                string json = await response.Content.ReadAsStringAsync();
                var loginResponse = JsonConvert.DeserializeObject<Credential>(json);
                Console.WriteLine("Login successful\n");
                return loginResponse.Token;
            }
            else
            {
                Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
            }
            return "";
        }


        private static async Task<string> ChangeConnString(string connString)
        {
            string apiUrl = config["apiUrl"];
            //var req = new WebRequestOptions { UriString = $"{apiUrl}{Urls.login}" };
            var req1 = new WebRequestOptions { UriString = $"{apiUrl}{Urls.changeConnString}"};

            HttpResponseMessage response = await client.PostAsJsonAsync(req1.UriString,
                connString);

            if (response.IsSuccessStatusCode)
            {
                string json = await response.Content.ReadAsStringAsync();
                //var loginResponse = JsonConvert.DeserializeObject<Credential>(json);
                //Console.WriteLine("Login successful");
                //return loginResponse.Token;
                return json;
            }
            else
            {
                Console.WriteLine("{0} ({1})", (int)response.StatusCode, response.ReasonPhrase);
            }
            return "";
        }


        private static async Task<string> GetConnString()
        {
            string apiUrl = config["apiUrl"];
            var req1 = new WebRequestOptions { UriString = $"{apiUrl}{Urls.getConnString}" };
            Type type = typeof(string);
            var response = await client.GetFromJsonAsync(req1.UriString,
                            type);
            return response.ToString();


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
            if (!Directory.Exists(importdir))
            {
                Console.WriteLine("The import directory \"" + importdir + "\" could not be found.");
                Environment.Exit(-4);
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
                            var log = $"{filename} | \"Assessment was successfully imported\"";
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


        /**
         * This function parses the output of the SQL Examiner project 
         * and only displays differences between tables.
         * 
         */
        private static void ComparisonOutputHandler(object sendingProcess,
            DataReceivedEventArgs outLine)
        {
            // Collect the sort command output.
            if (!string.IsNullOrEmpty(outLine.Data))
            {
                if (outLine.Data != null && outLine.Data.Contains("Comparing"))
                {
                    completeComparisonOutput.Append(Environment.NewLine + $"{outLine.Data}"); //the unparsed output

                    if (!outLine.Data.Contains("only source:0"))
                    {
                        comparisonOutput.Append(Environment.NewLine + $"{outLine.Data}");
                    }
                    else if (!outLine.Data.Contains("different:0"))
                    {
                        comparisonOutput.Append(Environment.NewLine + $"{outLine.Data}");
                    }
                    else if (!outLine.Data.Contains("only target:0"))
                    {
                        comparisonOutput.Append(Environment.NewLine + $"{outLine.Data}");
                    }
                }
                
                //else
                //{
                //    // Add the text to the collected output.
                //    comparisonOutput.Append(Environment.NewLine + $"{outLine.Data}");
                //}

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
