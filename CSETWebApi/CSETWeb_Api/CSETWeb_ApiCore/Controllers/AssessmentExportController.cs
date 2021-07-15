//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System.Linq;


namespace CSETWebCore.Api.Controllers
{
    public class AssessmentExportController : ControllerBase
    {
        private CSETContext _context;
        private IHttpContextAccessor _http;


        /// <summary>
        /// Controller
        /// </summary>
        public AssessmentExportController(CSETContext context, IHttpContextAccessor http)
        {
            _context = context;
            _http = http;
        }


        [HttpGet]
        [Route("api/assessment/export")]
        public IActionResult ExportAssessment(string token)
        {
            var tm = new TokenManager(_http, null, _context);
            tm.SetToken(token);

            var assessmentId = int.Parse(tm.Payload(Constants.Constants.Token_AssessmentId));
            var currentUserId = int.Parse(tm.Payload(Constants.Constants.Token_UserId));


            // determine extension (.csetw, .acet)
            var appCode = tm.Payload(Constants.Constants.Token_Scope);
            var ext = IOHelper.GetExportFileExtension(appCode);


            // determine filename
            var filename = $"{assessmentId}{ext}";
            var assessmentName = _context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
            if (!string.IsNullOrEmpty(assessmentName))
            {
                filename = $"{assessmentName}{ext}";
            }


            // export the assessment
            var export = new AssessmentExportManager(_context);
            var result = export.ArchiveStream(assessmentId);

            return File(result, "application/octet-stream", filename);
        }
    }
}
