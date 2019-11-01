//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Helpers.upload;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Versioning;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;


namespace CSETWeb_Api.Controllers
{

    public class AssessmentImportController : ApiController
    {
        /// <summary>
        /// Gets the path to the Legacy CSET Import process. Checks for both dev and production versions.
        /// </summary>
        /// <returns></returns>
        private string GetLegacyImportProcessPath()
        {
            var dir = new FileInfo(AppDomain.CurrentDomain.BaseDirectory).Directory;

            // TODO: Problem: These paths create a dependency and should be some sort of variable for installation as well as debugging. 
            // Also, can the user change the installation directory? If so, this gets messed up...
            var importFile = dir.Parent.Parent.Parent.Parent.FullName + "\\CSETStandAlone\\LegacyCSETImport\\Bin\\Debug\\LegacyCSETImport.exe";
            var importProductionFile = Path.Combine(dir.Parent.FullName, "LegacyCSETImport.exe");

            var path = string.Empty;
            if (File.Exists(importFile))
            {
                path = importFile;
            }
            else if (File.Exists(importProductionFile))
            {
                path = importProductionFile;
            }
            return path;
        }

        private bool LegacyImportProcessExists()
        {
            var processPath = GetLegacyImportProcessPath();
            var processExists = !string.IsNullOrEmpty(processPath);
            return processExists;
        }

        [HttpGet]
        [CSETAuthorize]
        [Route("api/assessment/legacy/import/installed")]
        public Task<HttpResponseMessage> LegacyImportIsInstalled()
        {
            return Task.FromResult(Request.CreateResponse(LegacyImportProcessExists()));
        }

        [HttpPost]
        [CSETAuthorize]
        [Route("api/assessment/legacy/import")]
        public async Task<HttpResponseMessage> ImportLegacyAssessment()
        {
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            var appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            var appPath =  Path.Combine("DHS","CSET ", VersionHandler.CSETVersionStringStatic);
            var root = Path.Combine(appdatas, appPath, "App_Data/uploads");
            if (!Directory.Exists(root))
                Directory.CreateDirectory(root);
            var provider = new MultipartFormDataStreamProvider(root);

            try
            {
                var csetFilePath = await Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
                {
                    if (o.IsFaulted || o.IsCanceled)
                        throw new HttpResponseException(HttpStatusCode.InternalServerError);
                    var file = provider.FileData.First();
                    return file.LocalFileName;
                });

                var apiURL = Request.RequestUri.GetLeftPart(UriPartial.Authority).ToString();//.Replace("api/ImportLegacyAssessment", null);
                if (LegacyImportProcessExists())
                {
                    IEnumerable<string> stuff  = this.Request.Headers.GetValues("Authorization");
                    foreach (String auth in stuff)
                    {
                        var tm = new TokenManager(auth);
                        var manager = new ImportManager();
                        await manager.LaunchLegacyCSETProcess(csetFilePath, tm.Token, GetLegacyImportProcessPath(), apiURL);
                    }
                }
                else
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Import process doesn't exist.");
                }
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e.Message);
            }

            return Request.CreateResponse(true);
        }

        [HttpPost]
        [Route("api/assessment/import")]
        public async Task<HttpResponseMessage> ImportAssessment()
        {
            if (!Request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }

            var tm = new TokenManager();
            var currentUserId = int.Parse(tm.Payload(Constants.Token_UserId));

            try
            {
                var streamProvider = new InMemoryMultipartFormDataStreamProvider();
                await Request.Content.ReadAsMultipartAsync(streamProvider);

                using (var web = new CSET_Context())
                {
                    var formData = streamProvider.FormData;
                    foreach (var ctnt in streamProvider.Files)
                    {
                        if (ctnt.Headers.ContentDisposition.FileName.EndsWith(".cset"))
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, "Legacy 8.1 or earlier .cset files must be imported from the desktop version");
                        }

                        var buffer = ctnt.ReadAsByteArrayAsync().Result;
                        var manager = new ImportManager();
                        await manager.ProcessCSETAssessmentImport(buffer, currentUserId);
                    }
                }
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e);
            }

            return Request.CreateResponse(HttpStatusCode.OK, "Assessment was successfully imported");
        }
    }
}
