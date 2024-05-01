//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
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
using Ionic.Zip;
using CSETWebCore.Business.Demographic.Import;

namespace CSETWebCore.Api.Controllers
{
    public class DemographicImportController : ControllerBase
    {
        private ITokenManager _tokenManager;
        private CSETContext _context;
        private IDemographicImportManager _demographicImportManager;

        /// <summary>
        /// Constructor.
        /// </summary>
        /// <param name="token"></param>
        /// <param name="context"></param>
        /// <param name="assessmentUtil"></param>
        public DemographicImportController(ITokenManager token, CSETContext context, IDemographicImportManager demographicImportManager)
        {
            _tokenManager = token;
            _context = context;
            _demographicImportManager = demographicImportManager;
        }


        [HttpPost]
        [Route("api/demographics/import")]
        public async Task<IActionResult> ImportDemographic()
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

                    await _demographicImportManager.ProcessCSETDemographicImport(bytes, currentUserId, accessKey, _context);
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

            var response = new
            {
                Message = "Assessment was successfully imported"
            };

            return Ok(response);
        }

    }

}
