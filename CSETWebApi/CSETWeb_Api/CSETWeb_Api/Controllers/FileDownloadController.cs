//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.Helpers;
using DataAccess;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    public class FileDownloadController : ApiController
    {
        private readonly FileRepository fileRepo = new FileRepository();

        [HttpGet]
        [Route("api/files/download/{id}")]
        public Task<HttpResponseMessage> Download(int id, string token)
        {
            var assessmentId = Auth.AssessmentForUser(token);

            var file = fileRepo.GetFileDescription(id);
            var stream = new MemoryStream(file.Data);
            var fileContent = new StreamContent(stream);
            fileContent.Headers.ContentType = new MediaTypeHeaderValue(file.ContentType);

            var result = Request.CreateResponse(HttpStatusCode.OK);
            result.Content = new MultipartContent { fileContent };
            return Task.FromResult(result);
        }
    }
}
