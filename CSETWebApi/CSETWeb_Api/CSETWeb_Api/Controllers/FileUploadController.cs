//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Collections.Specialized;
using Microsoft.Data.SqlClient;
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
using CSETWeb_Api.BusinessLogic.Helpers.upload;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataAccess;
using DataAccess.Model;
using CSETWebCore.DataLayer;

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

            string squestion_id = "questionId";
            string sanswerId = "answerId";
            string stitle = "title";
            string bmaturity = "maturity";


            int assessmentId = Auth.AssessmentForUser();
            string fileHash;
            try
            {

                FileUploadStream fileUploader = new FileUploadStream();
                Dictionary<string, string> formValues = new Dictionary<string, string>();
                formValues.Add(squestion_id, null);
                formValues.Add(sanswerId, null);
                formValues.Add(stitle, null);
                formValues.Add(bmaturity, null);


                FileUploadStreamResult streamResult = await fileUploader.ProcessUploadStream(this.Request, formValues);


                // Find or create the Answer for the document to be associated with.  
                // If they are attaching a document to a question that has not yet been answered,
                // the answerId will not be sent in the request.
                int questionId = int.Parse(streamResult.FormNameValues[squestion_id]);
                int answerId;
                bool isAnswerIdProvided = int.TryParse(streamResult.FormNameValues[sanswerId], out answerId);
                string title = streamResult.FormNameValues[stitle];
                bool isMaturity = false;
                bool.TryParse(streamResult.FormNameValues[bmaturity], out isMaturity);

                if (!isAnswerIdProvided)
                {
                    QuestionsManager qm = new QuestionsManager(assessmentId);
                    Answer answer = new Answer();
                    answer.QuestionId = questionId;
                    answer.AnswerText = "U";
                    answer.QuestionType = isMaturity ? "Maturity" : "";
                    answerId = qm.StoreAnswer(answer);
                }
                var dm = new DocumentManager(assessmentId);
                using (CSET_Context db = new CSET_Context())
                {
                    dm.AddDocument(title, answerId, streamResult);
                }

                // Return a current picture of this answer's documents
                return Request.CreateResponse(dm.GetDocumentsForAnswer(answerId));

            }
            catch (System.Exception e)
            {
                return Request.CreateErrorResponse(HttpStatusCode.InternalServerError, e);
            }
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



