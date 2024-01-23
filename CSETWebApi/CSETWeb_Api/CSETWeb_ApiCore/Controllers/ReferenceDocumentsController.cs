//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using CSETWebCore.DataLayer.Model;
using Microsoft.AspNetCore.StaticFiles;
using Microsoft.AspNetCore.Http;

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
        [Route("api/HasLocalDocuments")]
        public IActionResult HasLocalDocuments()
        {
            var docPath = Path.Combine((string)AppDomain.CurrentDomain.GetData("ContentRootPath"), "Documents", "cag.pdf");
            if (System.IO.File.Exists(docPath))
            {
                return Ok(true);
            }
            else
            {
                return Ok(false);
            }
        }

        /// <summary>
        /// This can find a file in the GEN_FILE table either by
        /// filename or by the file's ID.
        /// </summary>
        /// <param name="file"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ReferenceDocument/{file}")]
        public IActionResult GetByName(string file)
        {
            var hashLocation = file.IndexOf('#');
            if (hashLocation > -1)
            {
                file = file.Substring(0, hashLocation);
            }

            var id = 0;
            if (!int.TryParse(file, out id))
            {
                // if the identifier is not an int, assume it's the filename, and get his gen_file_id
                var f = _context.GEN_FILE.Where(f => f.File_Name == file).FirstOrDefault();
                if (f != null)
                {
                    id = f.Gen_File_Id;
                }
            }


            var files = from a in _context.GEN_FILE
                        join ft1 in _context.FILE_TYPE on a.File_Type_Id equals ft1.File_Type_Id into tt
                        from ft in tt.DefaultIfEmpty()
                        where (a.Gen_File_Id == id) && (a.Is_Uploaded ?? false)
                        select new { a, ft };

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

                string filename = f.a.File_Name;


                // determine the contentType
                var contentType = "application/octet-stream";
                if (f.ft != null && f.ft.Mime_Type != null)
                {
                    contentType = f.ft.Mime_Type;
                }
                else
                {
                    new FileExtensionContentTypeProvider()
                    .TryGetContentType(filename, out contentType);
                }

                var contentDisposition = new ContentDispositionHeaderValue("inline");
                contentDisposition.FileName = filename;
                Response.Headers.Append("Content-Disposition", contentDisposition.ToString());

                return File(stream, contentType);
            }

            return new NotFoundResult();
        }
    }
}
