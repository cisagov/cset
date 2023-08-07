//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Import;
using CSETWebCore.DataLayer.Model;
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
using Ionic.Zip;
using System.Collections.Generic;
using System.Net.Http;

namespace CSETWebCore.Api.Controllers
{
    public class AssessmentImportController : ControllerBase
    {
        private ITokenManager _tokenManager;
        private CSETContext _context;
        private IAssessmentUtil _assessmentUtil;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public AssessmentImportController(ITokenManager token, CSETContext context, IAssessmentUtil assessmentUtil)
        {
            _tokenManager = token;
            _context = context;
            _assessmentUtil = assessmentUtil;
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
        public async Task<IActionResult> ImportLegacyAssessment()
        {
            // For now only allowing 1 uploaded file
            if (Request.Form.Files.Count > 1)
            {
                return BadRequest("Only a single assessment may be imported at a time.");
            }

            var assessmentFile = Request.Form.Files[0];

            var target = new MemoryStream();
            assessmentFile.CopyTo(target);

            try
            {
                var manager = new ImportManager(_tokenManager, _assessmentUtil, _context);
                await manager.ProcessCSETAssessmentImport(target.ToArray(), _tokenManager.GetUserId(), _tokenManager.GetAccessKey(), _context);
            }
            catch (Exception)
            {
                return StatusCode(500, "There was an error processing the uploaded assessment.");
            }

            return Ok(true);
        }


        [HttpPost]
        [Route("api/assessment/import")]
        public async Task<IActionResult> ImportAssessment([FromHeader] string pwd)
        {
            // should be multipart
            if (!MultipartRequestHelper.IsMultipartContentType(Request.ContentType))
            {
                // unsupported media type
                return StatusCode(415);
            }

            var currentUserId = _tokenManager.GetCurrentUserId();
            var accessKey = _tokenManager.GetAccessKey();

            ZipEntry hint = null;
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

                    // Get the password hint, if there is one.
                    using (Stream fs = new MemoryStream(bytes))
                    {
                        MemoryStream ms = new MemoryStream();
                        ZipFile zip = ZipFile.Read(fs);

                        foreach (ZipEntry entry in zip)
                        {
                            if (entry.FileName.Contains(".hint"))
                            {
                                hint = entry;
                            }
                        }
                    }


                    var manager = new ImportManager(_tokenManager, _assessmentUtil, _context);
                    await manager.ProcessCSETAssessmentImport(bytes, currentUserId, accessKey, _context, pwd);
                }
            }
            catch (Exception e)
            {
                var returnMessage = "";

                if (e.Message == "Exception of type 'Ionic.Zip.BadPasswordException' was thrown.")
                {
                    returnMessage = (hint == null) ? "Bad Password Exception" : "Bad Password Exception - " + hint.FileName;                    
                    return StatusCode(423, returnMessage);
                }
                else if (e.Message == "The password did not match.")
                {
                    returnMessage = (hint == null) ? "Invalid Password" : "Invalid Password - " + hint.FileName;
                    return StatusCode(406, returnMessage);
                }
                else
                {
                    return BadRequest(e);
                }
            }

            var response = new {
                Message = "Assessment was successfully imported"
            };

            return Ok(response);
        }


        [HttpPost]
        [Route("api/import/AWWA")]
        public IActionResult ImportAwwaSpreadsheet()
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
                    var importState = manager.ProcessSpreadsheetImport(bytes, assessmentId);
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
