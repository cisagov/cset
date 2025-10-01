//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Assessment;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Malcolm;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Model.Question;
using Microsoft.AspNetCore.Mvc;
using NLog;
using System;
using System.Collections.Generic;
using System.Linq;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class QuestionsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly INotificationBusiness _notification;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly IContactBusiness _contact;
        private readonly IUserBusiness _user;
        private readonly IDocumentBusiness _document;
        private readonly IHtmlFromXamlConverter _htmlConverter;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly CSETContext _context;
        private readonly Hooks _hooks;



        /// <summary>
        /// 
        /// </summary>
        public QuestionsController(ITokenManager token, INotificationBusiness notification,
            IAssessmentUtil assessmentUtil, IAssessmentBusiness assessmentBusiness, IContactBusiness contact, IDocumentBusiness document, IHtmlFromXamlConverter htmlConverter, IQuestionRequirementManager questionRequirement,
            IUserBusiness user, CSETContext context, Hooks hooks)
        {
            _token = token;
            _context = context;
            _hooks = hooks;
            _notification = notification;
            _assessmentUtil = assessmentUtil;
            _assessmentBusiness = assessmentBusiness;
            _contact = contact;
            _user = user;
            _document = document;
            _htmlConverter = htmlConverter;
            _questionRequirement = questionRequirement;
        }


        /// <summary>
        /// Returns a list of all applicable Questions or Requirements for the assessment.
        /// 
        /// A shorter list can be retrieved for a single Question_Group_Heading 
        /// by sending in the 'group' argument.  I'm not sure we need this yet. 
        /// </summary>
        [HttpGet]
        [Route("api/QuestionList")]
        public IActionResult GetList([FromQuery] string group)
        {
            try
            {
                if (group == null)
                {
                    group = "*";
                }

                int assessmentId = _token.AssessmentForUser();
                string applicationMode = GetApplicationMode(assessmentId);


                if (applicationMode.ToLower().StartsWith("questions"))
                {
                    var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
                    QuestionResponse resp = qb.GetQuestionList(group);
                    return Ok(resp);
                }
                else
                {
                    var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                    QuestionResponse resp = rb.GetRequirementsList();
                    return Ok(resp);
                }
            }
            catch (Exception exc)
            {
                LogManager.GetCurrentClassLogger().Error(exc);
                return BadRequest(exc.Message);
            }
        }


        /// <summary>
        /// Returns a list of all Component questions, both default and overrides.
        /// </summary>
        [HttpGet]
        [Route("api/ComponentQuestionList")]
        public IActionResult GetComponentQuestionsList([FromQuery] string skin, string group)
        {
            if (skin == "RENEW")
            {
                new MalcolmBusiness(_context).VerificationAndValidation(_token.AssessmentForUser());
            }
            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
            QuestionResponse resp = manager.GetResponse();

            return Ok(resp);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/QuestionListComponentOverridesOnly")]
        public IActionResult GetComponentOverridesList()
        {
            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
            QuestionResponse resp = manager.GetOverrideListOnly();
            return Ok(resp);

        }


        /// <summary>
        ///
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GetChildAnswers")]
        public IList<GetChildrenAnswersResult> GetChildAnswers([FromQuery] int parentId)
        {
            int assessmentId = _token.AssessmentForUser();
            return _context.Get_Children_Answers(parentId, assessmentId);
        }


        /// <summary>
        /// Sets the application mode to be question or requirements based.
        /// </summary>
        /// <param name="mode"></param>
        [HttpPost]
        [Route("api/SetMode")]
        public IActionResult SetMode([FromQuery] string mode)
        {
            int assessmentId = _token.AssessmentForUser();
            _questionRequirement.InitializeManager(assessmentId);
            _questionRequirement.SetApplicationMode(mode);
            var stats = _hooks.HookQuestionsModeChanged(assessmentId);

            if (stats != null)
            {
                return Ok(new {
                    CompletedCount = stats.CompletedCount,
                    TotalMaturityQuestionsCount = stats.TotalMaturityQuestionsCount ?? 0
                });
            }

            return Ok();
        }


        /// <summary>
        /// Gets the application mode (question or requirements based).
        /// </summary>
        [HttpGet]
        [Route("api/GetMode")]
        public IActionResult GetMode()
        {
            int assessmentId = _token.AssessmentForUser();
            var qm = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            string mode = GetApplicationMode(assessmentId).Trim().Substring(0, 1);

            if (String.IsNullOrEmpty(mode))
            {
                var amd = new AssessmentMode(_context, _token);
                mode = amd.DetermineDefaultApplicationModeAbbrev();
                SetMode(mode);
            }

            return Ok(mode);
        }


        /// <summary>
        /// Determines if the assessment is question or requirements based.
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        protected string GetApplicationMode(int assessmentId)
        {
            var mode = _context.STANDARD_SELECTION.Where(x => x.Assessment_Id == assessmentId).Select(x => x.Application_Mode).FirstOrDefault();

            if (mode == null)
            {
                var amd = new AssessmentMode(_context, _token);
                mode = amd.DetermineDefaultApplicationModeAbbrev();
                SetMode(mode);
            }

            return mode;
        }


        /// <summary>
        /// Persists an answer.  This includes Y/N/NA/A as well as comments and alt text.
        /// </summary>
        [HttpPost]
        [Route("api/AnswerQuestion")]
        public IActionResult StoreAnswer([FromBody] Answer answer)
        {
            int assessmentId = _token.AssessmentForUser();

            var response = new AnswerQuestionResponse
            {
                AnswerId = 0,
                DetailsChanged = false
            };


            if (answer == null)
            {
                return Ok(0);
            }

            if (String.IsNullOrWhiteSpace(answer.QuestionType))
            {
                if (answer.Is_Component)
                    answer.QuestionType = "Component";
                if (answer.Is_Maturity)
                    answer.QuestionType = "Maturity";
                if (answer.Is_Requirement)
                    answer.QuestionType = "Requirement";
                if (answer.Is_Question)
                    answer.QuestionType = "Question";
            }


            // Remember the last-answered question
            var lah = new LastAnsweredHelper(_context);
            lah.Save(assessmentId, _token.GetCurrentUserId(), answer);


            if (answer.Is_Component)
            {
                var cb = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
                var savedComponentAnswer = cb.StoreAnswer(answer);

                _hooks.HookQuestionAnswered(savedComponentAnswer);

                response.AnswerId = (int)savedComponentAnswer.AnswerId;
            }


            if (answer.Is_Requirement)
            {
                var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                var savedRequirementAnswer = rb.StoreAnswer(answer);

                _hooks.HookQuestionAnswered(savedRequirementAnswer);


                response.AnswerId = (int)savedRequirementAnswer.AnswerId;
            }


            if (answer.Is_Maturity)
            {
                var mb = new MaturityBusiness(_context, _assessmentUtil);
                var savedMaturityAnswer = mb.StoreAnswer(assessmentId, answer);

                var detailsChanged = _hooks.HookQuestionAnswered(savedMaturityAnswer);


                response.AnswerId = (int)savedMaturityAnswer.AnswerId;
                response.DetailsChanged = detailsChanged;
            }


            if (answer.QuestionType == "Question")
            {
                var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
                var savedQuestionAnswer = qb.StoreAnswer(answer);

                _hooks.HookQuestionAnswered(savedQuestionAnswer);

                response.AnswerId = (int)savedQuestionAnswer.AnswerId;
            }


            var userId = _token.GetCurrentUserId();
            if (userId != null)
            {
                var completionStats = _assessmentBusiness.GetAssessmentsCompletionForUser((int)userId)
                    .FirstOrDefault(x => x.AssessmentId == assessmentId);

                if (completionStats != null)
                {
                    response.CompletedCount = completionStats.CompletedCount;
                    response.TotalMaturityQuestionsCount = completionStats.TotalMaturityQuestionsCount ?? 0;
                    response.TotalDiagramQuestionsCount = completionStats.TotalDiagramQuestionsCount ?? 0;
                    response.TotalStandardQuestionsCount = completionStats.TotalStandardQuestionsCount ?? 0;
                }
            }

            return Ok(response);
        }


        /// <summary>
        /// Persists multiple answers. It is being build specifically
        /// to handle answer cleanup in CIS but can be enhanced if
        /// other use cases arise.
        /// </summary>
        [HttpPost]
        [Route("api/answerquestions")]
        public IActionResult StoreAnswers([FromBody] List<Answer> answers, [FromQuery] int sectionId = 0)
        {
            if (answers == null || answers.Count == 0)
            {
                return Ok(0);
            }

            int assessmentId = _token.AssessmentForUser();

            var cisBiz = new CisQuestionsBusiness(_context, _assessmentUtil, assessmentId);

            var lah = new LastAnsweredHelper(_context);

            foreach (var answer in answers)
            {
                if (String.IsNullOrWhiteSpace(answer.QuestionType))
                {
                    if (answer.Is_Component)
                        answer.QuestionType = "Component";
                    if (answer.Is_Maturity)
                        answer.QuestionType = "Maturity";
                    if (answer.Is_Requirement)
                        answer.QuestionType = "Requirement";
                    if (!answer.Is_Requirement && !answer.Is_Maturity && !answer.Is_Component)
                        answer.QuestionType = "Question";
                }

                if (answer.Is_Maturity)
                {
                    // save the last answered question
                    lah.Save(assessmentId, _token.GetCurrentUserId(), answer);

                    cisBiz.StoreAnswer(answer);
                }
            }

            // Refresh the section score based on the new answers
            if (answers.Any(x => x.Is_Maturity))
            {
                var scorer = new CisScoring(assessmentId, sectionId, _context);
                var score = scorer.CalculateGroupingScore();
                return Ok(score);
            }

            _hooks.HookQuestionAnswered(answers[0]);

            return Ok();
        }


        /// <summary>
        /// Returns the details under a given questions details
        /// </summary>
        [HttpPost, HttpGet]
        [Route("api/Details")]
        public IActionResult GetDetails([FromQuery] int questionId, [FromQuery] string questionType)
        {
            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            return Ok(qb.GetDetails(questionId, questionType));
        }


        /// <summary>
        /// Persists a single answer to the SUB_CATEGORY_ANSWERS table for the 'block answer',
        /// and flips all of the constituent questions' answers.
        /// </summary>
        /// <param name="subCatAnswers"></param>
        [HttpPost]
        [Route("api/AnswerSubcategory")]
        public IActionResult StoreSubcategoryAnswers([FromBody] SubCategoryAnswers subCatAnswers)
        {
            int assessmentId = _token.AssessmentForUser();
            _questionRequirement.AssessmentId = assessmentId;

            foreach (var ans in subCatAnswers.Answers)
            {
                ans.AssessmentId = assessmentId;
            }

            var qm = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            qm.StoreSubcategoryAnswers(subCatAnswers);

            _hooks.HookQuestionAnswered(subCatAnswers.Answers[0]);

            return Ok();
        }





        /// <summary>
        /// 
        /// </summary>
        /// <param name="question_id"></param>
        /// <param name="Component_Symbol_Id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GetOverrideQuestions")]
        public IActionResult GetOverrideQuestions([FromQuery] int question_id, [FromQuery] int Component_Symbol_Id)
        {
            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);

            int assessmentId = _token.AssessmentForUser();

            return Ok(manager.GetOverrideQuestions(assessmentId, question_id, Component_Symbol_Id));
        }


        /// <summary>
        /// this will explode the provided guid and 
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="ShouldSave">true means explode and save false is delete these questions</param>
        [HttpGet]
        [Route("api/AnswerSaveComponentOverrides")]
        public IActionResult SaveComponentOverride([FromQuery] String guid, [FromQuery] Boolean ShouldSave)
        {
            int assessmentId = _token.AssessmentForUser();
            string applicationMode = GetApplicationMode(assessmentId);

            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);

            Guid g = new Guid(guid);
            manager.HandleGuid(g, ShouldSave);

            return Ok();
        }


        /// <summary>
        /// Changes the title of a stored document.
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="title">The new title</param>
        [HttpPost]
        [Route("api/RenameDocument")]
        public IActionResult RenameDocument([FromQuery] int id, [FromQuery] string title)
        {
            _document.RenameDocument(id, title);
            return Ok();
        }

        /// <summary>
        /// Changes if document is Globally accessible
        /// </summary>
        /// <param name="id"></param>
        /// <param name="isGlobal"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/ChangeGlobal")]
        public IActionResult ChangeGlobal([FromQuery] int id, [FromQuery] Boolean isGlobal)
        {
            _document.ChangeGlobal(id, isGlobal);
            return Ok();
        }


        /// <summary>
        /// Detaches a stored document from the answer.  
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="answerId">The document ID</param>
        [HttpPost]
        [Route("api/DeleteDocument")]
        public IActionResult DeleteDocument([FromQuery] int id, [FromQuery] int questionId)
        {
            int assessmentId = _token.AssessmentForUser();
            _document.DeleteDocument(id, questionId, assessmentId);
            return Ok();
        }


        /// <summary>
        /// Returns a collection of all 
        /// </summary>
        /// <param name="id">The document ID</param>
        [HttpGet]
        [Route("api/QuestionsForDocument")]
        public IActionResult GetQuestionsForDocument([FromQuery] int id)
        {
            return Ok(_document.GetQuestionsForDocument(id));
        }


        /// <summary>
        /// Returns a collection of Parameters with assessment-level overrides
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ParametersForAssessment")]
        public IActionResult GetDefaultParametersForAssessment()
        {
            var rm = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
            var controls = rm.GetControls().Requirements.ToList();

            var parmSub = new ParameterSubstitution(_context, _token);

            return Ok(parmSub.GetDefaultParametersForAssessment(controls));
        }


        /// <summary>
        /// Persists an assessment-level ("global") Parameter change.
        /// </summary>
        [HttpPost]
        [Route("api/SaveAssessmentParameter")]
        public ParameterToken SaveAssessmentParameter([FromBody] ParameterToken token)
        {
            var rm = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);

            return rm.SaveAssessmentParameter(token.Id, token.Substitution);
        }


        /// <summary>
        /// Persists an answer-level ("in-line", "local") Parameter change.
        /// </summary>
        [HttpPost]
        [Route("api/SaveAnswerParameter")]
        public ParameterToken SaveAnswerParameter([FromBody] ParameterToken token)
        {
            var assessmentId = _token.AssessmentForUser();
            _questionRequirement.AssessmentId = assessmentId;

            var parmSub = new ParameterSubstitution(_context, _token);

            return parmSub.SaveAnswerParameter(_questionRequirement, token.RequirementId, token.Id, token.AnswerId, token.Substitution);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/SubGroupingQuestionCount")]
        public List<int> SubGroupingQuestionCount([FromQuery] string[] subGroups, [FromQuery] int modelId)
        {
            int assessmentId = _token.AssessmentForUser();

            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);

            List<int> counts = new List<int>();

            subGroups = subGroups[0].Split(',');

            foreach (string subGroup in subGroups)
            {
                counts.Add(qb.QuestionCountInSubGroup(subGroup, modelId));
            }

            return counts;
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/AllSubGroupingQuestionCount")]
        public IActionResult AllSubGroupingQuestionCount([FromQuery] int modelId, [FromQuery] int groupLevel)
        {
            int assessmentId = _token.AssessmentForUser();

            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);

            return Ok(qb.AllQuestionsInSubGroup(modelId, groupLevel, assessmentId));
        }

        [HttpGet]
        [Route("api/getRegulatoryCitations")]
        public IActionResult GetRegulatoryCitations([FromQuery] int questionId)
        {
            int assessmentId = _token.AssessmentForUser();
            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);

            var resp = qb.GetRegulatoryCitations(questionId);
            return Ok(resp);
        }

        /// <summary>
        /// 
        /// </summary>
        ///
        [HttpPost]
        [Route("api/saveHydroComment")]
        public IActionResult SaveHydroComment([FromBody] HYDRO_DATA_ACTIONS hda)
        {
            int assessmentId = _token.AssessmentForUser();
            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);


            return Ok(qb.SaveHydroComment(hda.Answer, hda.Answer_Id, hda.Progress_Id, hda.Comment));
        }
    }
}
