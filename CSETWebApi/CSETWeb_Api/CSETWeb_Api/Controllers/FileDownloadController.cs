//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.Helpers;
using DataAccess;
using DataLayerCore.Model;
using System.IO;
using System.Linq;
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
            var fileDescription = fileRepo.GetFileDescription(id);
            var result = Request.CreateResponse(HttpStatusCode.OK);
            using (var context = new CSET_Context())
            {
                var content = new MultipartContent();
                foreach (var file in context.DOCUMENT_FILE.Where(x => x.Document_Id == id))
                {
                    var stream = new MemoryStream(file.Data);
                    var fileContent = new StreamContent(stream);
                    fileContent.Headers.ContentType = new MediaTypeHeaderValue(file.ContentType);
                    content.Add(fileContent);
                }
                result.Content = content;
            }
            return Task.FromResult(result);
        }
    }
}
