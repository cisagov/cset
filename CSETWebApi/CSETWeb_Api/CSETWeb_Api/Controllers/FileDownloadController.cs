//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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
        private readonly FileRepository _fileRepository = new FileRepository();

        public FileDownloadController()
        {
        }

        [HttpGet]
        [Route("api/files/download/{id}")]
        public Task<HttpResponseMessage> Download(int id, string token)
        {
            var result = default(HttpResponseMessage);
            using (var context = new CSET_Context())
            {
                foreach (var f in context.DOCUMENT_FILE.Where(x => x.Document_Id == id))
                {
                    var stream = new MemoryStream(f.Data);
                    result.Content = new StreamContent(stream);
                    result.Content.Headers.ContentType = new MediaTypeHeaderValue(f.ContentType);
                    result.Content.Headers.Add("content-disposition", "attachment; filename=\"" + f.Name + "\"");
                    result = Request.CreateResponse(HttpStatusCode.OK);
                }
            }
            return Task.FromResult(result);
        }
    }
}
