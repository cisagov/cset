//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Authorization;
using CSETWebCore.Business.Findings;
using CSETWebCore.Business.Maturity;
using CSETWebCore.Business.Question;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Common;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Document;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.Question;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Question;
using CSETWebCore.Model.Findings;
using CSETWebCore.Business.Assessment;
using Microsoft.AspNetCore.Mvc;
using Nelibur.ObjectMapper;
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
        public QuestionResponse GetList([FromQuery] string group)
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
                return resp;
            }
            else
            {
                var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                QuestionResponse resp = rb.GetRequirementsList();
                return resp;
            }
        }


        /// <summary>
        /// Returns a list of all Component questions, both default and overrides.
        /// </summary>
        [HttpPost]
        [Route("api/ComponentQuestionList")]
        public QuestionResponse GetComponentQuestionsList([FromBody] string group)
        {
            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
            QuestionResponse resp = manager.GetResponse();
            return resp;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/QuestionListComponentOverridesOnly")]
        public QuestionResponse GetComponentOverridesList()
        {
            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
            QuestionResponse resp = manager.GetOverrideListOnly();
            return resp;

        }

        /// <summary>
        /// Sets the application mode to be question or requirements based.
        /// </summary>
        /// <param name="mode"></param>
        [HttpPost]
        [Route("api/SetMode")]
        public void SetMode([FromQuery] string mode)
        {
            _questionRequirement.SetApplicationMode(mode);
        }


        /// <summary>
        /// Gets the application mode (question or requirements based).
        /// </summary>
        [HttpGet]
        [Route("api/GetMode")]
        public string GetMode()
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

            return mode;
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
        public int StoreAnswer([FromBody] Answer answer)
        {
            if (answer == null)
            {
                return 0;
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

            int assessmentId = _token.AssessmentForUser();
            string applicationMode = GetApplicationMode(assessmentId);

            if (answer.Is_Component)
            {
                var cb = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
                return cb.StoreAnswer(answer);
            }

            if (answer.Is_Requirement)
            {
                var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                return rb.StoreAnswer(answer);
            }

            if (answer.Is_Maturity)
            {
                var mb = new MaturityBusiness(_context, _assessmentUtil, _adminTabBusiness);
                return mb.StoreAnswer(assessmentId, answer);
            }

            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            return qb.StoreAnswer(answer);
        }


        /// <summary>
        /// Returns the details under a given questions details
        /// </summary>
        [HttpPost, HttpGet]
        [Route("api/Details")]
        public QuestionDetails GetDetails([FromQuery] int QuestionId, bool IsComponent, bool IsMaturity)
        {
            var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            return qb.GetDetails(QuestionId, IsComponent, IsMaturity);
        }


        /// <summary>
        /// Persists a single answer to the SUB_CATEGORY_ANSWERS table for the 'block answer',
        /// and flips all of the constituent questions' answers.
        /// </summary>
        /// <param name="subCatAnswers"></param>
        [HttpPost]
        [Route("api/AnswerSubcategory")]
        public void StoreSubcategoryAnswers([FromBody] SubCategoryAnswers subCatAnswers)
        {
            var qm = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
            qm.StoreSubcategoryAnswers(subCatAnswers);
        }


        /// <summary>
        /// Note that this only populates the summary/title and finding id. 
        /// the rest is populated in a seperate call. 
        /// </summary>
        /// <param name="Answer_Id"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/AnswerAllDiscoveries")]
        public List<Finding> AllDiscoveries([FromQuery] int Answer_Id)
        {
            int assessmentId = _token.AssessmentForUser();

            var fm = new FindingsManager(_context, assessmentId);
            return fm.AllFindings(Answer_Id);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="Answer_Id"></param>
        /// <param name="Finding_id"></param>
        /// <param name="Question_Id"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/GetFinding")]
        public Finding GetFinding([FromQuery] int Answer_Id, int Finding_id, int Question_Id, string QuestionType)
        {
            int assessmentId = _token.AssessmentForUser();

            if (Answer_Id == 0)
            {
                Answer_Id = _questionRequirement.StoreAnswer(new Answer()
                {
                    QuestionId = Question_Id,
                    MarkForReview = false,
                    QuestionType = QuestionType
                });
            }

            var fm2 = new FindingsManager(_context, assessmentId);
            return fm2.GetFinding(Finding_id);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GetImportance")]
        public List<Importance> GetImportance()
        {
            TinyMapper.Bind<IMPORTANCE, Importance>();
            List<Importance> rlist = new List<Importance>();
            foreach (IMPORTANCE import in _context.IMPORTANCE)
            {
                rlist.Add(TinyMapper.Map<IMPORTANCE, Importance>(import));
            }

            return rlist;
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="finding_Id"></param>
        [HttpPost]
        [Route("api/DeleteFinding")]
        public void DeleteFinding([FromBody] int finding_Id)
        {
            int assessmentId = _token.AssessmentForUser();
            var fm = new FindingsManager(_context, assessmentId);

            var f = fm.GetFinding(finding_Id);
            fm.DeleteFinding(f);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="finding"></param>
        [HttpPost]
        [Route("api/AnswerSaveDiscovery")]
        public void SaveDiscovery([FromBody] Finding finding)
        {
            int assessmentId = _token.AssessmentForUser();

            if (finding.IsFindingEmpty())
            {
                DeleteFinding(finding.Finding_Id);
                return;
            }

            var fm = new FindingsManager(_context, assessmentId);
            fm.UpdateFinding(finding);
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="question_id"></param>
        /// <param name="Component_Symbol_Id"></param>
        /// <returns></returns>
        [HttpGet]
        [Route("api/GetOverrideQuestions")]
        public List<Answer_Components_Exploded_ForJSON> GetOverrideQuestions([FromQuery] int question_id, int Component_Symbol_Id)
        {
            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);

            int assessmentId = _token.AssessmentForUser();

            return manager.GetOverrideQuestions(assessmentId, question_id, Component_Symbol_Id);
        }


        /// <summary>
        /// this will explode the provided guid and 
        /// </summary>
        /// <param name="guid"></param>
        /// <param name="ShouldSave">true means explode and save false is delete these questions</param>
        [HttpGet]
        [Route("api/AnswerSaveComponentOverrides")]
        public void SaveComponentOverride([FromQuery] String guid, Boolean ShouldSave)
        {
            int assessmentId = _token.AssessmentForUser();
            string applicationMode = GetApplicationMode(assessmentId);

            var manager = new ComponentQuestionBusiness(_context, _assessmentUtil, _token, _questionRequirement);
            Guid g = new Guid(guid);
            manager.HandleGuid(g, ShouldSave);
        }


        /// <summary>
        /// Changes the title of a stored document.
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="title">The new title</param>
        [HttpPost]
        [Route("api/RenameDocument")]
        public void RenameDocument([FromQuery] int id, string title)
        {
            _document.RenameDocument(id, title);
        }


        /// <summary>
        /// Detaches a stored document from the answer.  
        /// </summary>
        /// <param name="id">The document ID</param>
        /// <param name="answerId">The document ID</param>
        [HttpPost]
        [Route("api/DeleteDocument")]
        public void DeleteDocument([FromQuery] int id, int answerId)
        {
            _document.DeleteDocument(id, answerId);
        }


        /// <summary>
        /// Returns a collection of all 
        /// </summary>
        /// <param name="id">The document ID</param>
        [HttpGet]
        [Route("api/QuestionsForDocument")]
        public List<int> GetQuestionsForDocument([FromQuery] int id)
        {
            return _document.GetQuestionsForDocument(id);
        }


        /// <summary>
        /// Returns a collection of Parameters with assessment-level overrides
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/ParametersForAssessment")]
        public List<ParameterToken> GetDefaultParametersForAssessment()
        {
            var rm = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);

            return rm.GetDefaultParametersForAssessment();
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
    }
}
