//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using System.Data.SqlClient;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Cryptography;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataAccess;
using DataAccess.Model;
using DataLayerCore.Model;
using DataLayerCore.Model;

namespace WebAPIFileUploadExample.Controllers
{
    [CSETAuthorize]
    public class FileUploadController : ApiController
    {
        private FileRepository _fileRepository;

        public FileUploadController()
        {
            this._fileRepository = new FileRepository();
        }

       


        [HttpPost]
        [Route("api/files/blob/create")]
        public async Task<HttpResponseMessage> UploadToBlob()
        {
            HttpRequestMessage request = this.Request;
            if (!request.Content.IsMimeMultipartContent())
            {
                throw new HttpResponseException(HttpStatusCode.UnsupportedMediaType);
            }
            int assessmentId = Auth.AssessmentForUser();
            string fileHash;
            try
            {
                var streamProvider = new InMemoryMultipartFormDataStreamProvider();
                await Request.Content.ReadAsMultipartAsync<InMemoryMultipartFormDataStreamProvider>(streamProvider);
                
             
                //access form data
                NameValueCollection formData = streamProvider.FormData;
                 foreach (HttpContent ctnt in streamProvider.Files)
                 {
                    // You would get hold of the inner memory stream here              
                    using (Stream fs = ctnt.ReadAsStreamAsync().Result)
                     {
                         string filename = ctnt.Headers.ContentDisposition.FileName.Trim("\"".ToCharArray());
                         string contentType = ctnt.Headers.ContentType.MediaType;
                         using (BinaryReader br = new BinaryReader(fs))
                         {
                             byte[] bytes = br.ReadBytes((Int32)fs.Length);
                            // Hash the file so that we can determine if it is already attached to another question
                            using (var md5 = MD5.Create())
                            {
                                var hash = md5.ComputeHash(bytes);
                                fileHash = BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();                                
                            }
                            
                            // Find or create the Answer for the document to be associated with.  
                            // If they are attaching a document to a question that has not yet been answered,
                            // the answerId will not be sent in the request.
                            int questionId = int.Parse(streamProvider.FormData["questionId"]);

                            int answerId;
                            bool isAnswerIdProvided = int.TryParse(streamProvider.FormData["answerId"], out answerId);
                            string title = streamProvider.FormData["title"];

                            if (!isAnswerIdProvided)
                            {
                                QuestionsManager qm = new QuestionsManager(assessmentId);
                                Answer answer = new Answer();
                                answer.QuestionId = questionId;
                                answer.AnswerText = "U";
                                answerId = qm.StoreAnswer(answer);
                            }
                            var dm = new DocumentManager(assessmentId);
                            using (CSET_Context db = new CSET_Context())
                            {   
                                dm.AddDocument(title, filename, contentType, fileHash, answerId, bytes);
                            }

                            // Return a current picture of this answer's documents
                            return Request.CreateResponse(dm.GetDocumentsForAnswer(answerId));
                        }
                     }
                 }                
            }
            catch (System.Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e);
            }

            return null;
        }

        [Route("api/files/all")]
        [HttpGet]
        public IEnumerable<FileDescriptionShort> GetAllFiles()
        {
            int assessmentId = Auth.AssessmentForUser();            
            return _fileRepository.GetAllFiles(assessmentId);
        }

     
    }

    

    public class CustomMultipartFormDataStreamProvider : MultipartFormDataStreamProvider
    {
        public CustomMultipartFormDataStreamProvider(string path) : base(path) { }

        public override string GetLocalFileName(HttpContentHeaders headers)
        {
            return headers.ContentDisposition.FileName.Replace("\"", string.Empty);
        }
    }


}



