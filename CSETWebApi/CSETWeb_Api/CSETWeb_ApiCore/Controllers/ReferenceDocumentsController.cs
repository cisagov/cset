using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class ReferenceDocumentsController : ControllerBase
    {
        private readonly CSETContext _context;

        public ReferenceDocumentsController(CSETContext context)
        {
            _context = context;
        }

        [HttpGet]
        [Route("api/ReferenceDocuments/{fileName}")]

        public IActionResult Get(string fileName)
        {
            var hashLocation = fileName.IndexOf('#');
            if (hashLocation > -1)
            {
                fileName = fileName.Substring(0, hashLocation);

            }
            var result = new HttpResponseMessage(HttpStatusCode.OK);


            var files = from a in _context.GEN_FILE
                        join f in _context.FILE_TYPE on a.File_Type_Id equals f.File_Type_Id
                        where (a.File_Name == fileName) && (a.Is_Uploaded ?? false)
                        select new { a, f };

            foreach (var f in files.ToList())
            {
                Stream stream;


                // use binary data if available, otherwise get physical file
                if (f.a.Data != null)
                {
                    stream = new MemoryStream(f.a.Data);
                }
                else
                {
                    var docPath = Path.Combine((string)AppDomain.CurrentDomain.GetData("ContentRootPath"), "Documents", f.a.File_Name);
                    stream = new FileStream(docPath, FileMode.Open, FileAccess.Read);
                }

                return new FileStreamResult(stream, f.f.Mime_Type);
            }

            return new NotFoundResult();
        }

        
        [HttpPost]
        [CsetAuthorize]
        [Route("api/ReferenceDocuments")]

        public async Task<IActionResult> Post(IFormFile formFile)
        {
            try
            {
                //TODO:File upload
                //// Check if the request contains multipart/form-data.
                //if (formFile == null)
                //{
                //    return BadRequest("Could not upload file");

                //}
                //var provider = new InMemoryMultipartFormDataStreamProvider();
                //await Request.Content.ReadAsMultipartAsync<InMemoryMultipartFormDataStreamProvider>(provider);


                ////access form data
                //var formData = provider.FormData;
                //var file = provider.Files.First();

                //var serializer = new JavaScriptSerializer();
                //var expando = new ExpandoObject();
                //foreach (var item in formData.AllKeys)
                //{
                //    ((IDictionary<string, object>)expando)[item] = formData[item];
                //}
                //var formDocument = serializer.ConvertToType<ExternalDocument>(expando);
                //formDocument.Data = await file.ReadAsByteArrayAsync();
                //formDocument.FileSize = file.Headers.ContentLength;
                //formDocument.FileName = UnquoteToken(file.Headers.ContentDisposition.FileName);
                //var genFile = formDocument.ToGenFile();
                //var extension = Path.GetExtension(genFile.File_Name).Substring(1);
                //var response = Request.CreateResponse(HttpStatusCode.OK);

                //var existingFiles = _context.GEN_FILE.Where(s => s.File_Name == genFile.File_Name && (s.Is_Uploaded ?? false)).ToList();
                //if (existingFiles.Any(s => s.Doc_Num == genFile.Doc_Num))
                //{
                //    var existingFile = existingFiles.FirstOrDefault(s => s.Doc_Num == genFile.Doc_Num);
                //    existingFile.Data = genFile.Data;
                //    await _context.SaveChangesAsync();
                //    return response;
                //}
                //else if (existingFiles.Any())
                //{
                //    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, new Exception("Document could not be added.  Please change the file name and try again"));
                //}
                //genFile.File_Type_ = _context.FILE_TYPE.Where(s => s.File_Type1 == extension).FirstOrDefault();
                //try
                //{
                //    _context.FILE_REF_KEYS.Add(new FILE_REF_KEYS { Doc_Num = genFile.Doc_Num });
                //    await _context.SaveChangesAsync();
                //}
                //catch
                //{
                //}
                //_context.GEN_FILE.Add(genFile);
                //await _context.SaveChangesAsync();


                //    return response;
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest(e);

            }
        }
        private static string UnquoteToken(string token)
        {
            if (String.IsNullOrWhiteSpace(token))
            {
                return token;
            }

            if (token.StartsWith("\"", StringComparison.Ordinal) && token.EndsWith("\"", StringComparison.Ordinal) && token.Length > 1)
            {
                return token.Substring(1, token.Length - 2);
            }

            return token;
        }
    }
}
