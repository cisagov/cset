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
using System.Net.Http;
using System.Net.Http.Headers;
using System.Net.Mime;
using System.Threading.Tasks;
using DocumentFormat.OpenXml.Office2010.PowerPoint;
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
        
        /// <summary>
        /// export assessment and send it to enterprise using enterprise token
        /// </summary>
        /// <param name="token"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/assessment/exportAndSend")]
        public async Task<IActionResult> ExportAndSendAssessment([FromQuery] string token)
        {
            try
            {
                var assessmentId = _token.AssessmentForUser();
                _token.SetEnterpriseToken(token);
                
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
                
                using(var client = new HttpClient())
                using(var content = new MultipartFormDataContent())
                using (var byteContent = new ByteArrayContent(fileContents))
                {
                    client.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Bearer", _token.GetEnterpriseToken());
                    byteContent.Headers.ContentType = MediaTypeHeaderValue.Parse("multipart/form-data");
                    
                    content.Add(byteContent, "file", "assessment.csetw");
                    var response = await client.PostAsync(targetUrl, content);
                    return response.IsSuccessStatusCode;

                }

                ;
                /*using (var client = new System.Net.Http.HttpClient())
                {
                    using(var client = httpClient)
                        
                    
                    var content = new System.Net.Http.ByteArrayContent(fileContents);
                    client.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Bearer", _token.GetEnterpriseToken());
                    
                    content.Headers.Add("Content-Type", "multipart/form-data");
                    content.Headers.Add("Content-Disposition", $"attachment; filename=\"{fileName}\"");
                    //content.Headers.Add("Authorization", $"Bearer {_token.GetEnterpriseToken()}");
                    
                    var response = await client.PostAsync(targetUrl, content);
                    return response.IsSuccessStatusCode;
                }*/
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return false;
        }
    }
}
