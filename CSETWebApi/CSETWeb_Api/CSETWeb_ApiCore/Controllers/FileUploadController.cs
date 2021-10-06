using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.FileRepository;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    public class FileUploadController : Controller
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IDocumentBusiness _documentManager;
        private readonly IFileRepository _fileRepo;

        public FileUploadController(
            ITokenManager tokenManager,
            CSETContext context,
            IDocumentBusiness documentManager,
            IFileRepository fileRepo
        )
        {
            _tokenManager = tokenManager;
            _context = context;
            _documentManager = documentManager;
            _fileRepo = fileRepo;
        }

        [HttpPost]
        [Route("/api/files/blob/create/")]
        public async Task<IActionResult> Upload()
        {
            const string key_questionId = "questionId";
            const string key_answerId = "answerId";
            const string key_title = "title";
            const string key_maturity = "maturity";

            var assessmentId = _tokenManager.AssessmentForUser();
            _documentManager.SetUserAssessmentId(assessmentId);

            var keyDict = new Dictionary<string, string>();
            keyDict.Add(key_questionId, null);
            keyDict.Add(key_answerId, null);
            keyDict.Add(key_title, null);
            keyDict.Add(key_maturity, null);

            var loader = new FileUploadStream();
            var result = await loader.ProcessUploadStream(HttpContext, keyDict);

            int questionId = int.Parse(result.FormNameValues[key_questionId]);
            int answerId;
            if (!int.TryParse(result.FormNameValues[key_answerId], out answerId))
            {
                bool isMaturity = false;
                bool.TryParse(result.FormNameValues[key_maturity], out isMaturity);

                var answer = new ANSWER
                {
                    Question_Or_Requirement_Id = questionId,
                    Answer_Text = "U",
                    Question_Type = isMaturity ? "Maturity" : ""
                };
                _context.ANSWER.Add(answer);
                _context.SaveChanges();
                answerId = answer.Answer_Id;
            }

            _documentManager.AddDocument(result.FormNameValues[key_title], answerId, result);
            return Ok(_documentManager.GetDocumentsForAnswer(answerId));         
        }
    }
}
