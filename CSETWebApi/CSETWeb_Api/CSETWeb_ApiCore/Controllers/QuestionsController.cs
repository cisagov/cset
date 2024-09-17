//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Observations;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Observations;
using CSETWebCore.Business.Assessment;
using Microsoft.AspNetCore.Mvc;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Business.Malcolm;
using Microsoft.CodeAnalysis.CSharp.Syntax;
using CSETWebCore.Helpers;
using CSETWebCore.Business.Contact;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class QuestionsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly INotificationBusiness _notification;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IContactBusiness _contact;
        private readonly IUserBusiness _user;
        private readonly IDocumentBusiness _document;
        private readonly IHtmlFromXamlConverter _htmlConverter;
        private readonly IQuestionRequirementManager _questionRequirement;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly CSETContext _context;



        /// <summary>
        /// 
        /// </summary>
        public QuestionsController(ITokenManager token, INotificationBusiness notification,
            IAssessmentUtil assessmentUtil, IContactBusiness contact, IDocumentBusiness document, IHtmlFromXamlConverter htmlConverter, IQuestionRequirementManager questionRequirement,
            IAdminTabBusiness adminTabBusiness, IUserBusiness user, CSETContext context)
        {
            _token = token;
            _context = context;
            _notification = notification;
            _assessmentUtil = assessmentUtil;
            _contact = contact;
            _user = user;
            _document = document;
            _htmlConverter = htmlConverter;
            _questionRequirement = questionRequirement;
            _adminTabBusiness = adminTabBusiness;
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
        public IList<GetChildrenAnswersResult> GetChildAnswers([FromQuery] int parentId, [FromQuery] int assessId)
        {
            return _context.Get_Children_Answers(parentId, assessId);
        }

        /// <summary>
        ///
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GetActionItems")]
        public IList<ActionItems> GetActionItems([FromQuery] int parentId, [FromQuery] int finding_id)
        {
            int assessId = _token.AssessmentForUser();
            ObservationsManager fm = new ObservationsManager(_context, assessId);
            return fm.GetActionItems(parentId, finding_id);
        }

        /// <summary>
        /// Sets the application mode to be question or requirements based.
        /// </summary>
        /// <param name="mode"></param>
        [HttpPost]
        [Route("api/SetMode")]
        public IActionResult SetMode([FromQuery] string mode)
        {
            _questionRequirement.InitializeManager(_token.AssessmentForUser());
            _questionRequirement.SetApplicationMode(mode);
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

            var mb = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);

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
                if (!answer.Is_Requirement && !answer.Is_Maturity && !answer.Is_Component)
                    answer.QuestionType = "Question";
            }


            // Save the last answered question
            var lah = new LastAnsweredHelper(_context);
            lah.Save(assessmentId, _token.GetCurrentUserId(), answer);



            if (answer.Is_Component)
            {
                var cb = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
                return Ok(cb.StoreAnswer(answer));
            }

            if (answer.Is_Requirement)
            {
                var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                return Ok(rb.StoreAnswer(answer));
            }

            if (answer.Is_Maturity)
            {
                return Ok(mb.StoreAnswer(assessmentId, answer));
            }

            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            return Ok(qb.StoreAnswer(answer));
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

            return Ok();
        }

        /// <summary>
        /// Persists multiple (all) assessment answers at once
        /// during the ISE assessment merge process. This could probably
        /// be combined with the above function, but I don't have the time
        /// to do so currently
        /// </summary>
        [HttpPost]
        [Route("api/storeAllAnswers")]
        public IActionResult StoreAllAnswers([FromBody] List<Answer> answers)
        {
            int assessmentId = _token.AssessmentForUser();
            int? userId = _token.GetCurrentUserId();

            if (answers == null || answers.Count == 0)
            {
                return Ok(0);
            }

            var lah = new LastAnsweredHelper(_context);

            foreach (var answer in answers)
            {
                // save the last answered question
                lah.Save(assessmentId, userId, answer);

                var mb = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                mb.StoreAnswer(assessmentId, answer);
            }

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

            var qm = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            qm.StoreSubcategoryAnswers(subCatAnswers);
            return Ok();
        }


        /// <summary>
        /// Note that this only populates the summary/title and finding id. 
        /// the rest is populated in a seperate call. 
        /// </summary>
        /// <param name="Answer_Id"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/AnswerAllObservations")]
        public IActionResult AllObservations([FromQuery] int Answer_Id)
        {
            int assessmentId = _token.AssessmentForUser();

            var fm = new ObservationsManager(_context, assessmentId);
            return Ok(fm.AllObservations(Answer_Id));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/GetObservation")]
        public IActionResult GetObservation([FromQuery] int answerId, [FromQuery] int observationId, [FromQuery] int questionId, [FromQuery] string questionType)
        {
            int assessmentId = _token.AssessmentForUser();

            if (answerId == 0)
            {
                _questionRequirement.AssessmentId = assessmentId;
                answerId = _questionRequirement.StoreAnswer(new Answer()
                {
                    QuestionId = questionId,
                    MarkForReview = false,
                    QuestionType = questionType
                });
            }

            var fm2 = new ObservationsManager(_context, assessmentId);
            return Ok(fm2.GetObservation(observationId, answerId));
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/GetAssessmentObservations")]
        public IActionResult GetAssessmentObservations()
        {
            int assessmentId = _token.AssessmentForUser();

            var result = from finding in _context.FINDING
                         join answer in _context.ANSWER
                            on finding.Answer_Id equals answer.Answer_Id
                         join question in _context.MATURITY_QUESTIONS
                            on answer.Question_Or_Requirement_Id equals question.Mat_Question_Id
                         join category in _context.MATURITY_GROUPINGS
                            on question.Grouping_Id equals category.Grouping_Id

                         // the custom order is 'DOR', 'Examiner Finding', 'Supplemental Guidance', 'Non-reportable', and then in order by question number
                         where answer.Assessment_Id == assessmentId
                         orderby finding.Type.StartsWith("Non"), finding.Type.StartsWith("Supplemental"),
                            finding.Type.StartsWith("Examiner"), finding.Type.StartsWith("DOR"), question.Mat_Question_Id
                         select new { finding, answer, question, category };

            return Ok(result.ToList());
        }




        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GetImportance")]
        public IActionResult GetImportance()
        {
            TinyMapper.Bind<IMPORTANCE, Importance>();
            List<Importance> rlist = new List<Importance>();
            foreach (IMPORTANCE import in _context.IMPORTANCE)
            {
                rlist.Add(TinyMapper.Map<IMPORTANCE, Importance>(import));
            }

            return Ok(rlist);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="observationId"></param>
        [HttpPost]
        [Route("api/DeleteObservation")]
        public IActionResult DeleteObservation([FromBody] int observationId)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new ObservationsManager(_context, assessmentId);

            var f = fm.GetObservation(observationId);
            fm.DeleteObservation(f);
            return Ok();
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="obs"></param>
        [HttpPost]
        [Route("api/AnswerSaveObservation")]
        public IActionResult SaveObservation([FromBody] Observation obs, [FromQuery] bool cancel = false, [FromQuery] bool merge = false)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new ObservationsManager(_context, assessmentId);


            if (obs.IsObservationEmpty(cancel))
            {
                fm.DeleteObservation(obs);
                return Ok();
            }

            var id = fm.UpdateObservation(obs, merge);

            return Ok(id);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="obs"></param>
        [HttpPost]
        [Route("api/CopyObservationIntoNewObservation")]
        public IActionResult CopyObservationIntoNewObservation([FromBody] Observation obs, [FromQuery] bool cancel = false)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new ObservationsManager(_context, assessmentId);

            if (obs.IsObservationEmpty(cancel))
            {
                fm.DeleteObservation(obs);
                return Ok();
            }

            var id = fm.UpdateObservation(obs, false);

            return Ok(id);
        }


        /// <summary>
        /// 
        /// </summary>
        ///
        [HttpPost]
        [Route("api/SaveIssueOverrideText")]
        public IActionResult SaveOverrideIssueText([FromBody] ActionItemTextUpdate item)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new ObservationsManager(_context, assessmentId);
            fm.UpdateIssues(item);
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
        /// Detaches a stored document from the answer.  
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="answerId">The document ID</param>
        [HttpPost]
        [Route("api/DeleteDocument")]
        public IActionResult DeleteDocument([FromQuery] int id, [FromQuery] int questionId, [FromQuery] int assessId)
        {
            _document.DeleteDocument(id, questionId, assessId);
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

            return Ok(rm.GetDefaultParametersForAssessment());
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
            var rm = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);

            return rm.SaveAnswerParameter(token.RequirementId, token.Id, token.AnswerId, token.Substitution);
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
