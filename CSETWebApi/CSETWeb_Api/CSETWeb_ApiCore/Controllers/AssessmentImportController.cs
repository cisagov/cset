//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Extensions;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.WebUtilities;
using Microsoft.Net.Http.Headers;
using System;
using System.IO;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Net.Http;

namespace CSETWebCore.Api.Controllers
{
    public class AssessmentImportController : ControllerBase
    {
        private TokenManager _tokenManager;
        private CSETContext _context;
        private AssessmentUtil _assessmentUtil;


        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public AssessmentImportController(ITokenManager token, CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _tokenManager = (TokenManager)token;
            _context = context;
            _assessmentUtil = (AssessmentUtil)assessmentUtil;
        }


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
            if (System.IO.File.Exists(importFile))
            {
                path = importFile;
            }
            else if (System.IO.File.Exists(importProductionFile))
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
        //  [CSETAuthorize]
        [Route("api/assessment/legacy/import/installed")]
        public IActionResult LegacyImportIsInstalled()
        {
            return Ok(LegacyImportProcessExists());
        }


        [HttpPost]
        // [CSETAuthorize]
        [Route("api/assessment/legacy/import")]
        public IActionResult ImportLegacyAssessment()
        {
            var multipartBoundary = HttpRequestMultipartExtensions.GetMultipartBoundary(Request);

            if (multipartBoundary == null)
            {
                // unsupported media type
                return StatusCode(415);
            }

            var appdatas = Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData);
            //var appPath = Path.Combine("DHS", "CSET ", VersionHandler.CSETVersionStringStatic);
            //var root = Path.Combine(appdatas, appPath, "App_Data/uploads");
            //if (!Directory.Exists(root))
            //    Directory.CreateDirectory(root);
            //var provider = new MultipartFormDataStreamProvider(root);

            //try
            //{
            //    var csetFilePath = await Request.Content.ReadAsMultipartAsync(provider).ContinueWith(o =>
            //    {
            //        if (o.IsFaulted || o.IsCanceled)
            //            throw new HttpResponseException(HttpStatusCode.InternalServerError);
            //        var file = provider.FileData.First();
            //        return file.LocalFileName;
            //    });

            //    var apiURL = Request.RequestUri.GetLeftPart(UriPartial.Authority).ToString();//.Replace("api/ImportLegacyAssessment", null);
            //    if (LegacyImportProcessExists())
            //    {
            //        IEnumerable<string> stuff = this.Request.Headers.GetValues("Authorization");
            //        foreach (String auth in stuff)
            //        {
            //            var tm = new TokenManager(auth);
            //            var manager = new ImportManager();
            //            await manager.LaunchLegacyCSETProcess(csetFilePath, tm.Token, GetLegacyImportProcessPath(), apiURL);
            //        }
            //    }
            //    else
            //    {
            //        return NotFound("Import process doesn't exist.");
            //    }
            //}
            //catch (Exception e)
            //{
            //    return StatusCode(500, e.Message);
            //}  

            return Ok(true);
        }


        [HttpPost]
        [Route("api/assessment/import")]
        public async Task<IActionResult> ImportAssessment()
        {
            // should be multipart
            if (!MultipartRequestHelper.IsMultipartContentType(Request.ContentType))
            {
                // unsupported media type
                return StatusCode(415);
            }

            var currentUserId = int.Parse(_tokenManager.Payload(Constants.Constants.Token_UserId));

            try
            {
                var formFiles = HttpContext.Request.Form.Files;

                foreach (FormFile file in formFiles)
                {
                    if (file.FileName.EndsWith(".cset"))
                    {
                        return Ok("Legacy 8.1 or earlier .cset files must be imported from the desktop version");
                    }

                    var target = new MemoryStream();
                    file.CopyTo(target);
                    var bytes = target.ToArray();


                    var manager = new ImportManager(_tokenManager, _assessmentUtil);
                    await manager.ProcessCSETAssessmentImport(bytes, currentUserId, _context);
                }
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }


            var response = new {
                Message = "Assessment was successfully imported"
            };

            return Ok(response);
        }


        [HttpPost]
        [Route("api/import/AWWA")]
        public async Task<IActionResult> ImportAwwaSpreadsheet()
        {
            var multipartBoundary = HttpRequestMultipartExtensions.GetMultipartBoundary(Request);

            if (multipartBoundary == null)
            {
                // unsupported media type
                return StatusCode(415);
            }


            var assessmentId = int.Parse(_tokenManager.Payload(Constants.Constants.Token_AssessmentId));

            try
            {
                var formFiles = HttpContext.Request.Form.Files;

                foreach (FormFile file in formFiles)
                {
                    if (!file.FileName.EndsWith(".xlsx")
                            && file.FileName.EndsWith(".xls"))
                    {
                        return Ok(new 
                        {
                            Message = "Only Microsoft Excel spreadsheets can be uploaded."
                        });
                    }

                    var target = new MemoryStream();
                    file.CopyTo(target);
                    var bytes = target.ToArray();


                    var manager = new ImportManagerAwwa(_context);
                    var importState = await manager.ProcessSpreadsheetImport(bytes, assessmentId);
                    if (importState != null)
                    {
                        return StatusCode(500, importState);
                    }
                }
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }

            var response = new
            {
                Message = "Spreadsheet was successfully imported"
            };

            return Ok(response);
        }
    }
}
