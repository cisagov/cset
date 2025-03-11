//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
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
using System;
using System.IO;
using System.Net.Http;
using System.Net.Http.Headers;
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
        public IActionResult ExportAssessment([FromQuery] string password = "", [FromQuery] string passwordHint = "")
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();

                // determine extension (.csetw, .acet)
                string ext = IOHelper.GetExportFileExtension(_token.Payload(Constants.Constants.Token_Scope));

                AssessmentExportFile result = new AssessmentExportManager(_context).ExportAssessment(assessmentId, ext, password, passwordHint);

                return File(result.FileContents, "application/octet-stream", result.FileName);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return Ok();
        }

        /// <summary>
        /// export assessment and send it to enterprise using enterprise token
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessment/exportandsend")]
        public async Task<IActionResult> ExportAndSendAssessment()
        {
            try
            {
                var assessmentId = _token.AssessmentForUser();

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
                        return Ok();
                    }
                }

                return BadRequest("There was an error sending the assessment to the target URL");
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
        public IActionResult ExportAssessmentAsJson([FromQuery] bool? scrubData, [FromQuery] string password = "", [FromQuery] string passwordHint = "")
        {
            try
            {
                int assessmentId = _token.AssessmentForUser();

                string ext = ".json";

                AssessmentExportFileJson result = new AssessmentExportManager(_context).ExportAssessmentJson(assessmentId, ext, password, passwordHint, scrubData ?? false);

                return File(result.JSON, "application/json", result.FileName);
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
                using (var client = new HttpClient())
                using (var content = new MultipartFormDataContent())
                using (var byteContent = new ByteArrayContent(fileContents))
                {
                    client.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Bearer", _token.GetEnterpriseToken());
                    byteContent.Headers.ContentType = MediaTypeHeaderValue.Parse("multipart/form-data");

                    content.Add(byteContent, "file", "assessment.csetw");
                    var response = await client.PostAsync(targetUrl, content);
                    return response.IsSuccessStatusCode;

                };
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return false;
        }
    }
}
