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
using System.Linq;


namespace CSETWebCore.Api.Controllers
{
    public class AssessmentExportController : ControllerBase
    {
        private ITokenManager _token;
        private CSETContext _context;
        private IHttpContextAccessor _http;


        /// <summary>
        /// Controller
        /// </summary>
        public AssessmentExportController(ITokenManager token, CSETContext context, IHttpContextAccessor http)
        {
            _token = token;
            _context = context;
            _http = http;
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
        /// A special flavor of export created for sharing assessment data by CISA assessors.
        /// Only the JSON content is returned, with a name formmated as {assessment-name}.json
        /// </summary>
        [HttpGet]
        [Route("api/assessment/export/json")]
        public IActionResult ExportAssessmentAsJson([FromQuery] string token, [FromQuery] string password = "", [FromQuery] string passwordHint = "")
        {
            try
            {
                _token.SetToken(token);

                int assessmentId = _token.AssessmentForUser(token);

                string ext = ".json";

                AssessmentExportFile result = new AssessmentExportManager(_context).ExportAssessment(assessmentId, ext, password, passwordHint, true);

                return File(result.FileContents, "application/octet-stream", result.FileName);
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            return null;
        }
    }
}
