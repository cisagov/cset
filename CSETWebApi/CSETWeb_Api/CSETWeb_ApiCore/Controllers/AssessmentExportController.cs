//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.AssessmentIO;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using NLog;
using System;
using System.IO;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;


namespace CSETWebCore.Api.Controllers
{
    public class AssessmentExportController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;
        private IHttpContextAccessor _http;
        private readonly IConfiguration _configuration;


        /// <summary>
        /// Controller
        /// </summary>
        public AssessmentExportController(ITokenManager token, CSETContext context, 
            IHttpContextAccessor http, IConfiguration configuration)
        {
            _token = token;
            _context = context;
            _http = http;
            _configuration = configuration;
        }


        [HttpGet]
        [Route("api/assessment/export")]
        public IActionResult ExportAssessment([FromQuery] string token, [FromQuery] string password = "", [FromQuery] string passwordHint = "")
        {
            try
            {
                _token.SetToken(token);

                int assessmentId = _token.AssessmentForUser(token);

                // determine extension (.csetw, .acet)
                string ext = IOHelper.GetExportFileExtension(_token.Payload(Constants.Constants.Token_Scope));

                AssessmentExportFile result = new AssessmentExportManager(_context).ExportAssessment(assessmentId, ext, password, passwordHint);

                return File(result.FileContents, "application/octet-stream", result.FileName);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }
        
        [HttpGet]
        [Route("api/assessment/exportAndSend")]
        public async Task<IActionResult> ExportAndSendAssessment([FromQuery] string token)
        {
            try
            {
                _token.SetToken(token);

                int assessmentId = _token.AssessmentForUser(token);
                string url = _configuration["AssessmentUploadUrl"];
                // Export the assessment
                if (!string.IsNullOrEmpty(url))
                {
                    var exportManager = new AssessmentExportManager(_context);
                    var exportFile = exportManager.ExportAssessment(assessmentId, ".zip", string.Empty, string.Empty);

                    string ext = IOHelper.GetExportFileExtension(_token.Payload(Constants.Constants.Token_Scope));

                    AssessmentExportFile result =
                        new AssessmentExportManager(_context).ExportAssessment(assessmentId, ext, string.Empty,
                            string.Empty);
                    byte[] fileContents;
                    using (var memoryStream = new MemoryStream())
                    {
                        result.FileContents.CopyTo(memoryStream);
                        fileContents = memoryStream.ToArray();
                    }

                    bool isSuccess = await SendFileToApi($"{url}/api/assessment/import", fileContents, result.FileName);
                    if (isSuccess)
                    {
                        return Ok("Assessment uploaded successfully");
                    }
                }

                return StatusCode(500, "There was an error sending the assessment to the target URL.");
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                return StatusCode(500, exc.Message);
            }
        }


        /// <summary>
        /// A special flavor of export created for sharing assessment data by CISA assessors.
        /// Only the JSON content is returned, with a name formmated as {assessment-name}.json
        /// </summary>
        [HttpGet]
        [Route("api/assessment/export/json")]
        public IActionResult ExportAssessmentAsJson([FromQuery] string token, [FromQuery] bool? scrubData, [FromQuery] string password = "", [FromQuery] string passwordHint = "")
        {
            try
            {
                _token.SetToken(token);

                int assessmentId = _token.AssessmentForUser(token);

                string ext = ".json";

               

                AssessmentExportFile result = new AssessmentExportManager(_context).ExportAssessment(assessmentId, ext, password, passwordHint, true, scrubData: true);

                return File(result.FileContents, "application/octet-stream", result.FileName);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }
        
        /// <summary>
        /// Send file to external API
        /// </summary>
        /// <param name="targetUrl"></param>
        /// <param name="fileContents"></param>
        /// <param name="fileName"></param>
        /// <returns></returns>
        private async Task<bool> SendFileToApi(string targetUrl, byte[] fileContents, string fileName)
        {
            try
            {
                ;
                using (var client = new System.Net.Http.HttpClient())
                {
                    var content = new System.Net.Http.ByteArrayContent(fileContents);
                    content.Headers.Add("Content-Type", "application/octet-stream");
                    content.Headers.Add("Content-Disposition", $"attachment; filename=\"{fileName}\"");
                    content.Headers.Add("Authorization", $"Bearer {_token.GetToken()}");

                    var response = await client.PostAsync(targetUrl, content);
                    return response.IsSuccessStatusCode;
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return false;
        }
    }
}
