//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using System;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web.Http;
using Hangfire;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSET_Main.Common;
using CSETWeb_Api.Versioning;
using CSETWeb_Api.BusinessLogic.Helpers.upload;

namespace CSETWeb_Api.Controllers
{

    public class AssessmentImportController : ApiController
    {   
        [HttpPost]
        [CSETAuthorize]
        [Route("api/ImportLegacyAssessment")]
        public async Task<bool> ImportLegacyAssessment()
        {
            TokenManager tm = new TokenManager();
            HttpRequestMessage request = this.Request;
            if (!request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            //string root = System.Web.HttpContext.Current.Server.MapPath("~/App_Data/uploads");
            String appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            String appPath =  System.IO.Path.Combine("DHS","CSET ", VersionHandler.CSETVersionStringStatic);
            String tempDataDirectory = System.IO.Path.Combine(appdatas, appPath, "App_Data/uploads");
            Directory.CreateDirectory(tempDataDirectory);
            string root = tempDataDirectory;

            var provider = new MultipartFormDataStreamProvider(root);

            try
            {
                string csetFilePath = await request.Content.ReadAsMultipartAsync(provider).ContinueWith<string>(o =>
                    {
                        if (o.IsFaulted || o.IsCanceled)
                            throw new HttpResponseException(HttpStatusCode.InternalServerError);
                        string file1 = provider.FileData.First().LocalFileName;
                        return file1;
                    }
                );


                String apiURL = this.Request.RequestUri.ToString().Replace("api/ImportLegacyAssessment", "");
                string processPath = this.GetLegacyImportProcessPath();
                if (processPath.Length > 0)
                {   
                    //var id = BackgroundJob.Enqueue(() => HangfireExecutor.ProcessAssessmentImportLegacyAsync(csetFilePath, tm.Token, processPath, apiURL, null));
                    ImportManager manager = new ImportManager();
                    await manager.LaunchLegacyCSETProcess(csetFilePath, tm.Token, processPath, apiURL);
                }
                else
                {
                    // TODO: Throw an exception or notify caller that process doesn't exist
                    Console.WriteLine("Process doesn't exist...");
                }
            }
            catch (Exception e)
            {
                Console.WriteLine(e.Message);
            }
            return true; // import.RunImport(model, currentUserId, useremail);
        }

        /// <summary>
        /// Gets the path to the Legacy CSET Import process. Checks for both dev and production versions.
        /// </summary>
        /// <returns></returns>
        public string GetLegacyImportProcessPath()
        {
            string returnPath = "";
            DirectoryInfo dir = new FileInfo(AppDomain.CurrentDomain.BaseDirectory).Directory;

            // TODO: Problem: These paths create a dependency and should be some sort of variable for installation as well as debugging. 
            // Also, can the user change the installation directory? If so, this gets messed up...
            string importFile = dir.Parent.Parent.Parent.Parent.FullName + "\\CSETStandAlone\\LegacyCSETImport\\Bin\\Debug\\LegacyCSETImport.exe";
            string importProductionFile = Path.Combine(dir.Parent.FullName,"LegacyCSETImport.exe");

            if (File.Exists(importFile))
            {
                returnPath = importFile;
            }
            else if (File.Exists(importProductionFile))
            {
                returnPath = importProductionFile;
            }
            return returnPath;
        }            

        [HttpPost]
        [Route("api/files/zipImport")]
        public async Task<HttpResponseMessage> UploadToBlob()
        {
            TokenManager tm = new TokenManager();
            int currentUserId = int.Parse(tm.Payload(Constants.Token_UserId));

            
              //Extract the json from the zip file
              //deserialize it to UploadAssessmentModel
              //then for each of the documents in DOCUMENT_FILE
              //get the corresponding answers and 
             
            HttpRequestMessage request = this.Request;
            if (!request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }            
            try
            {
                var streamProvider = new InMemoryMultipartFormDataStreamProvider();
                await Request.Content.ReadAsMultipartAsync<InMemoryMultipartFormDataStreamProvider>(streamProvider);

                using (CSET_Context web = new CSET_Context())
                {
                    //access form data
                    NameValueCollection formData = streamProvider.FormData;
                    foreach (HttpContent ctnt in streamProvider.Files)
                    {
                        if (ctnt.Headers.ContentDisposition.FileName.EndsWith(".cset")){
                            return Request.CreateResponse(HttpStatusCode.OK, "Legacy 8.1 or earlier .cset files must be imported from the desktop version");
                        }
                        // You would get hold of the inner memory stream here              
                        byte[] zipFileToDatabase = ctnt.ReadAsByteArrayAsync().Result;
                        //var id = BackgroundJob.Enqueue(() => HangfireExecutor.SaveAssessmentImportAsync(zipFileToDatabase, currentUserId, null));
                        ImportManager manager = new ImportManager();
                        await manager.ProcessCSETAssessmentImport(zipFileToDatabase, currentUserId);
                    }
                }
            }
            catch (System.Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e);
            }

            return Request.CreateResponse(HttpStatusCode.OK, "Assessment was successfully imported");
        }

        private string getPath(String MyPath)
        {
            String MyPathWithoutDriveOrNetworkShare = MyPath;
            if (Path.IsPathRooted(MyPath))
            {
                if (MyPath.IndexOf(":") == 1) { MyPathWithoutDriveOrNetworkShare = MyPath.Substring(3); }
                if (MyPath.IndexOf("\\\\") == 0) { MyPathWithoutDriveOrNetworkShare = MyPath.Substring(2); }
            }
            return MyPathWithoutDriveOrNetworkShare.Replace('\\', '/');
        }

        [HttpGet]
        [CSETAuthorize]
        [Route("api/LegacyImportIsInstalled")]
        public bool LegacyImportIsInstalled()
        {
            return this.GetLegacyImportProcessPath().Length > 0;
        }


    }

}


