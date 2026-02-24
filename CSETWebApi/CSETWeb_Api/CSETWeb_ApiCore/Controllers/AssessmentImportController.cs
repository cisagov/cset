//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
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
using System;
using System.IO;
using System.Threading.Tasks;
using CSETWebCore.Business.Authorization;
using ICSharpCode.SharpZipLib.Zip;


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    public class AssessmentImportController : ControllerBase
    {
        private ITokenManager _tokenManager;
        private CSETContext _context;
        private IImportManager _importManager;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public AssessmentImportController(ITokenManager token, CSETContext context, IImportManager importManager)
        {
            _tokenManager = token;
            _context = context;
            _importManager = importManager;
        }

        [HttpGet]
        [Route("api/assessment/legacy/import/installed")]
        public IActionResult LegacyImportIsInstalled()
        {
            return Ok(false);
        }


        [HttpPost]
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
                await _importManager.ProcessCSETAssessmentImport(target.ToArray(), _tokenManager.GetUserId(), _tokenManager.GetAccessKey(), _context);
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
            if (!MultipartRequestHelper.IsMultipartContentType(Request.ContentType))
            {
                return StatusCode(415);
            }

            var assessmentFile = Request.Form.Files[0];
            var currentUserId = _tokenManager.GetCurrentUserId();
            var accessKey = _tokenManager.GetAccessKey();

            string passwordHint = null;

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

                    // Get the password hint BEFORE attempting import
                    using (Stream fs = new MemoryStream(bytes))
                    {
                        var zip = new ZipFile(fs);

                        foreach (ZipEntry entry in zip)
                        {
                            if (entry.Name.EndsWith(".hint", StringComparison.OrdinalIgnoreCase))
                            {
                                // Extract just the hint part (remove .hint extension)
                                passwordHint = Path.GetFileNameWithoutExtension(entry.Name);
                                break;
                            }
                        }
                    }

                    // overwrite the assessment if instructed in the header
                    bool.TryParse(Request.Headers["x-cset-overwrite"], out bool overwrite);

                    await _importManager.ProcessCSETAssessmentImport(bytes, currentUserId, accessKey, _context, pwd, overwrite);
                }
            }
            catch (Exception e)
            {
                if (e.Message == "No password available for encrypted stream")
                {
                    // Return JSON instead of plain string
                    return StatusCode(423, new
                    {
                        message = "File requires a password",
                        hint = passwordHint ?? ""
                    });
                }
                else if (e.Message == "The password did not match.")
                {
                    // Return JSON instead of plain string
                    return StatusCode(406, new
                    {
                        message = "Invalid password",
                        hint = passwordHint ?? ""
                    });
                }
                else if (e.Message == "Custom module not found")
                {
                    return StatusCode(404, new
                    {
                        message = "Custom module not found"
                    });
                }
                else
                {
                    return BadRequest(e);
                }
            }

            var response = new
            {
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
