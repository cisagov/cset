//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Models;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic.Helpers.upload;
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using System;
using System.Collections.Generic;
using System.Dynamic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Web.Script.Serialization;

namespace CSETWeb_Api.Controllers
{
    public class ReferenceDocumentsController : ApiController
    {

        [HttpGet]
        [Route("api/ReferenceDocuments/{fileName}")]
        public async Task<HttpResponseMessage> Get(string fileName)
        {
            return await Task.Run(() =>
            {
                var hashLocation = fileName.IndexOf('#');
                if (hashLocation > -1)
                {
                    fileName = fileName.Substring(0, hashLocation);

                }
                var result = new HttpResponseMessage(HttpStatusCode.OK);

                using (var db = new CSET_Context())
                {
                    var files = from a in db.GEN_FILE
                                join f in db.FILE_TYPE on a.File_Type_Id equals f.File_Type_Id
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
                            var apiPath = System.Web.Hosting.HostingEnvironment.MapPath("~");
                            var docPath = Path.Combine(apiPath, "Documents", f.a.File_Name);
                            stream = new FileStream(docPath, FileMode.Open, FileAccess.Read);
                        }

                        result.Content = new StreamContent(stream);
                        result.Content.Headers.ContentType = new MediaTypeHeaderValue(f.f.Mime_Type);
                        return result;
                    }

                    return null;
                }
            });
        }


        [HttpPost]
        [CSETAuthorize]
        [Route("api/ReferenceDocuments")]
        public async Task<HttpResponseMessage> Post()
        {
            try
            {
                // Check if the request contains multipart/form-data.
                if (!Request.Content.IsMimeMultipartContent())
                {
                    throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);

                }
                var provider = new InMemoryMultipartFormDataStreamProvider();
                await Request.Content.ReadAsMultipartAsync<InMemoryMultipartFormDataStreamProvider>(provider);


                //access form data
                var formData = provider.FormData;
                var file = provider.Files.First();

                var serializer = new JavaScriptSerializer();
                var expando = new ExpandoObject();
                foreach (var item in formData.AllKeys)
                {
                    ((IDictionary<string, object>)expando)[item] = formData[item];
                }
                var formDocument = serializer.ConvertToType<ExternalDocument>(expando);
                formDocument.Data = await file.ReadAsByteArrayAsync();
                formDocument.FileSize = file.Headers.ContentLength;
                formDocument.FileName = UnquoteToken(file.Headers.ContentDisposition.FileName);
                var genFile = formDocument.ToGenFile();
                var extension = Path.GetExtension(genFile.File_Name).Substring(1);
                var response = Request.CreateResponse(HttpStatusCode.OK);

                using (CSET_Context db = new CSET_Context())
                {
                    var existingFiles = db.GEN_FILE.Where(s => s.File_Name == genFile.File_Name && (s.Is_Uploaded ?? false)).ToList();
                    if (existingFiles.Any(s => s.Doc_Num == genFile.Doc_Num))
                    {
                        var existingFile = existingFiles.FirstOrDefault(s => s.Doc_Num == genFile.Doc_Num);
                        existingFile.Data = genFile.Data;
                        await db.SaveChangesAsync();
                        return response;
                    }
                    else if (existingFiles.Any())
                    {
                        return Request.CreateErrorResponse(HttpStatusCode.BadRequest, new Exception("Document could not be added.  Please change the file name and try again"));
                    }
                    genFile.File_Type_ = db.FILE_TYPE.Where(s => s.File_Type1 == extension).FirstOrDefault();
                    try
                    {
                        db.FILE_REF_KEYS.Add(new FILE_REF_KEYS { Doc_Num = genFile.Doc_Num });
                        await db.SaveChangesAsync();
                    }
                    catch
                    {
                    }
                    db.GEN_FILE.Add(genFile);
                    await db.SaveChangesAsync();
                }


                return response;
            }
            catch (Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e);

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


