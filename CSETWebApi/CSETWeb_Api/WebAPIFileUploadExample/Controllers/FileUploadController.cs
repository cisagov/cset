//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Http;
using DataAccess;
using DataAccess.Model;

namespace WebAPIFileUploadExample.Controllers
{
    [RoutePrefix("api/test")]
    public class FileUploadController : ApiController
    {
        private readonly IFileRepository _fileRepository;
        private static readonly string ServerUploadFolder = "\\\\N275\\mssqlserver\\WebApiFileTable\\WebApiUploads_Dir"; //Path.GetTempPath();

        public FileUploadController(IFileRepository fileRepository)
        {
            _fileRepository = fileRepository;
        }

        [Route("files")]
        [HttpPost]
        [ValidateMimeMultipartContentFilter]
        public async Task<IEnumerable<FileDescriptionShort>> UploadFiles()
        {
            var streamProvider = new MultipartFormDataStreamProvider(ServerUploadFolder);
            await Request.Content.ReadAsMultipartAsync(streamProvider);

           
            var files =  new FileResult
            {
                FileNames = streamProvider.FileData.Select(entry => entry.LocalFileName.Replace(ServerUploadFolder + "\\","")).ToList(),
                Names = streamProvider.FileData.Select(entry => entry.Headers.ContentDisposition.FileName).ToList(),
                ContentTypes = streamProvider.FileData.Select(entry => entry.Headers.ContentType.MediaType).ToList(),
                Description = streamProvider.FormData["description"],
                CreatedTimestamp = DateTime.UtcNow,
                UpdatedTimestamp = DateTime.UtcNow, 
            };
            return _fileRepository.AddFileDescriptions(files);
        }

        [Route("download/{id}")]
        [HttpGet]
        public HttpResponseMessage Download(int id)
        {
            var fileDescription = _fileRepository.GetFileDescription(id);

            var path = ServerUploadFolder + "\\" + fileDescription.FileName;
            var result = new HttpResponseMessage(HttpStatusCode.OK);
            var stream = new FileStream(path, FileMode.Open);
            result.Content = new StreamContent(stream);
            result.Content.Headers.ContentType = new MediaTypeHeaderValue(fileDescription.ContentType);
            return result;
        }

        [Route("all")]
        [HttpGet]
        public IEnumerable<FileDescriptionShort> GetAllFiles()
        {
            return _fileRepository.GetAllFiles();
        }
    }
}



