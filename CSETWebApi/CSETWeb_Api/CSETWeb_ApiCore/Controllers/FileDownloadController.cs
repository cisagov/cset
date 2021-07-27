using Microsoft.AspNetCore.Mvc;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.FileRepository;
using CSETWebCore.Interfaces.Helpers;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class FileDownloadController : ControllerBase
    {
        private readonly IFileRepository _fileRepo;
        private readonly ITokenManager _token;

        public FileDownloadController(IFileRepository fileRepo, ITokenManager token)
        {
            _fileRepo = fileRepo;
            _token = token;
        }

        [HttpGet]
        [Route("api/files/download/{id}")]
        public IActionResult Download(int id, string token)
        {
            var assessmentId = _token.AssessmentForUser(token);
            var file = _fileRepo.GetFileDescription(id);
            var stream = new MemoryStream(file.Data);

            //var result  = new HttpResponseMessage(HttpStatusCode.OK);
            //result.Content = new StreamContent(stream);
            //result.Content.Headers.ContentType = new MediaTypeHeaderValue(file.ContentType);
            //result.Content.Headers.ContentDisposition = new ContentDispositionHeaderValue("attachment") { FileName = file.Name };
            return File(stream, file.ContentType, file.Name);
        }
    }
}
