//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.BusinessLogic.AssessmentIO;
using CSETWeb_Api.BusinessLogic.AssessmentIO.Export;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    public class AssessmentExportController : ApiController
    {
        [HttpGet]
        [Route("api/assessment/export")]
        public Task<HttpResponseMessage> ExportAssessment(string token)
        {
            var tm = new TokenManager(token);
            var assessmentId = Auth.AssessmentForUser(token);

            var appCode = tm.Payload("scope");
            var ext = IOHelper.GetFileExtension(appCode);

            using (var context = new CSET_Context())
            {
                var filename = $"{assessmentId}{ext}";
                var assessmentName = context.INFORMATION.Where(x => x.Id == assessmentId).FirstOrDefault()?.Assessment_Name;
                if (!string.IsNullOrEmpty(assessmentName))
                    filename = $"{assessmentName}{ext}";

                var export = new AssessmentExportManager(context);
                var result = Request.CreateResponse(HttpStatusCode.OK);
                result.Content = new StreamContent(export.ArchiveStream(assessmentId));
                result.Content.Headers.ContentType = new MediaTypeHeaderValue("application/octet-stream");
                result.Content.Headers.Add("content-disposition", $@"attachment; filename=""{filename}""");
                return Task.FromResult(result);
            }
        }
    }
}
