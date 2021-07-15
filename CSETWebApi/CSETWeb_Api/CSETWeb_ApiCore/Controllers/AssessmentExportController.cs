//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.AssessmentIO.Export;
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
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
        public IActionResult ExportAssessment(string token)
        {
            _token.SetToken(token);
            int assessmentId = _token.AssessmentForUser(token);
            int currentUserId = int.Parse(_token.Payload(Constants.Constants.Token_UserId));


            // determine extension (.csetw, .acet)
            string appCode = _token.Payload(Constants.Constants.Token_Scope);
            string ext = IOHelper.GetExportFileExtension(appCode);


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
