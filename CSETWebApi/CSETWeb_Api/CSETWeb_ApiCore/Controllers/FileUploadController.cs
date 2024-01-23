//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.FileRepository;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Model.Document;
using CSETWebCore.Model.Question;
using Microsoft.AspNetCore.Mvc;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using CSETWebCore.Interfaces.Maturity;

namespace CSETWebCore.Api.Controllers
{
    public class FileUploadController : Controller
    {
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IDocumentBusiness _documentManager;
        private readonly IFileRepository _fileRepo;
        private readonly IQuestionRequirementManager _answerManager;
        private readonly IMaturityBusiness _maturityBusiness;

        public FileUploadController(
            ITokenManager tokenManager,
            CSETContext context,
            IDocumentBusiness documentManager,
            IFileRepository fileRepo,
            IQuestionRequirementManager answerManager,
            IMaturityBusiness maturityBusiness
        )
        {
            _tokenManager = tokenManager;
            _context = context;
            _documentManager = documentManager;
            _fileRepo = fileRepo;
            _answerManager = answerManager;
            _maturityBusiness = maturityBusiness;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>        
        [HttpPost]
        [Route("/api/files/blob/create/")]
        public async Task<IActionResult> Upload()
        {
            const string key_questionId = "questionId";
            const string key_answerId = "answerId";
            const string key_title = "title";
            const string key_questionType = "questionType";

            var assessmentId = _tokenManager.AssessmentForUser();
            _documentManager.SetUserAssessmentId(assessmentId);

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

            _documentManager.AddDocument(result.FormNameValues[key_title], answerId, result);

            // returns all documents for the answer to account for updating duplicate docs
            // not the most efficient, but there are lots of shenanigans involved in keeping
            // the frontend for this synced
            return Ok(_documentManager.GetDocumentsForAnswer(answerId));
        }
    }
}
