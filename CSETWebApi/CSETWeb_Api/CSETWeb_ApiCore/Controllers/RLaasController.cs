//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Api.Models;
using CSETWebCore.Business.RepositoryLibrary;
using CSETWebCore.Business.RLaaS;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.ResourceLibrary;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.StaticFiles;
using System;
using System.IO;
using System.Linq;
using System.Net.Http.Headers;
using System.Collections.Generic;

using CSETWebCore.Model.ResourceLibrary;
using CSETWebCore.Model.Document;
using System.Threading.Tasks;
using CSETWebCore.Helpers;


namespace CSETWebCore.Api.Controllers
{
    /// <summary>
    /// Resource Library as a Service.  
    /// </summary>
    [ApiController]
    public class RLaasController : ControllerBase
    {
        public CSETContext _context;


        /// <summary>
        /// CTOR
        /// </summary>
        /// <param name="context"></param>
        public RLaasController(CSETContext context)
        {
            _context = context;
        }


        /// <summary>
        /// Returns a FileStreamResult with the binary content
        /// of the requested file.  
        /// </summary>
        /// <param name="fileId"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/rlaas/refdoc/{fileId}")]
        public IActionResult GetDocument(string fileId)
        {
            var manager = new RLaasManager(_context);
            var refDoc = manager.GetDocument(fileId);

            if (refDoc == null)
            {
                return new NotFoundResult();
            }


            string filename = refDoc.GenFile.File_Name;


            // determine the contentType
            var contentType = "application/octet-stream";
            if (refDoc.FileType != null && refDoc.FileType.Mime_Type != null)
            {
                contentType = refDoc.FileType.Mime_Type;
            }
            else
            {
                new FileExtensionContentTypeProvider()
                .TryGetContentType(filename, out contentType);
            }


            // if the requested document is actually a URL there's no content to return
            if (contentType.ToLower() == "url")
            {
                return new NotFoundResult();
            }


            // Build the stream for the document content

            Stream stream;

            // use binary data if available, otherwise get physical file
            if (refDoc.GenFile.Data != null)
            {
                stream = new MemoryStream(refDoc.GenFile.Data);
            }
            else
            {
                var docPath = Path.Combine((string)AppDomain.CurrentDomain.GetData("ContentRootPath"), "Documents", refDoc.GenFile.File_Name);
                stream = new FileStream(docPath, FileMode.Open, FileAccess.Read);
            }


            var contentDisposition = new ContentDispositionHeaderValue("inline");
            contentDisposition.FileName = filename;
            Response.Headers.Append("Content-Disposition", contentDisposition.ToString());

            return File(stream, contentType);
        }


        /// <summary>
        /// Returns a tree structure of document objects.  The tree is
        /// what is shown in the "browse" view of Resource Library.
        /// Documents are categorized 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/rlaas/doctree")]
        public List<SimpleNode> GetTree()
        {
            IResourceLibraryRepository resource = new ResourceLibraryRepository(_context, new CSETGlobalProperties(_context));
            return resource.GetTreeNodes();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>        
        [HttpPost]
        [Route("api/rlaas/docdata")]
        public async Task<IActionResult> Upload()
        {
            const string key_questionId = "questionId";
            const string key_answerId = "answerId";
            const string key_title = "title";
            const string key_questionType = "questionType";


            var manager = new RLaasManager(_context);





            var keyDict = new Dictionary<string, string>();
            keyDict.Add(key_questionId, null);
            keyDict.Add(key_answerId, null);
            keyDict.Add(key_title, null);
            keyDict.Add(key_questionType, null);

            var loader = new FileUploadStream();
            FileUploadStreamResult result = null;

            try
            {
                result = await loader.ProcessUploadStream(HttpContext, keyDict);
            }
            catch
            {
                return StatusCode(400);
            }




            string questionType = result.FormNameValues[key_questionType];

            int questionId;
            if (!int.TryParse(result.FormNameValues[key_questionId], out questionId))
            {
                return StatusCode(400);
            }

            int answerId;
            if (!int.TryParse(result.FormNameValues[key_answerId], out answerId))
            {
                var answerObj = new ANSWER();

                // if no answerId was provided, try to find an answer for this assessment/question
                if (answerId == 0)
                {
                    answerObj = _context.ANSWER.FirstOrDefault(x =>
                        x.Assessment_Id == assessmentId && x.Question_Or_Requirement_Id == questionId);
                }

                if (answerObj == null)
                {
                    var answer = new Answer
                    {
                        QuestionId = questionId,
                        QuestionType = questionType
                    };

                    // 
                    if (questionType.ToLower() == "maturity")
                    {
                        answerId = _maturityBusiness.StoreAnswer(assessmentId, answer);
                    }
                    else
                    {
                        _answerManager.InitializeManager(assessmentId);
                        answerId = _answerManager.StoreAnswer(answer);
                    }
                }
                else
                {
                    answerId = answerObj.Answer_Id;
                }
            }

            manager.StoreGenFileStream(result.FormNameValues[key_title], answerId, result);



            // returns all documents for the answer to account for updating duplicate docs
            // not the most efficient, but there are lots of shenanigans involved in keeping
            // the frontend for this synced
            //return Ok(_documentManager.GetDocumentsForAnswer(answerId));
            return Ok();
        }


       
    }
}
