using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.Business.Findings;
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
using CSETWebCore.Model.Findings;
using CSETWebCore.Business.Assessment;
using Nelibur.ObjectMapper;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace CSETWebCore.Api.Controllers
{
    public class AsyncTestController : Controller
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
        public AsyncTestController(ITokenManager token, INotificationBusiness notification,
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



        [HttpGet]
        [Route("api/regular")]
        public IActionResult RegularMethod([FromQuery] string speed)
        {
            var timer = new System.Diagnostics.Stopwatch();
            timer.Start();

            System.Collections.Generic.List<USERS> users = null;
            if (speed.ToUpper() == "LONG")
            {
                users = _context.USERS.ToList();
                System.Threading.Thread.Sleep(TimeSpan.FromSeconds(10));
            }
            else if (speed.ToUpper() == "SHORT")
            {
                users = _context.USERS.ToList();
            }
            else
            {
                int assessmentId = _token.AssessmentForUser();
                string applicationMode = "Q";


                if (applicationMode.ToLower().StartsWith("questions"))
                {
                    var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
                    QuestionResponse resp = qb.GetQuestionList("*");
                    return Ok(resp);
                }
                else
                {
                    var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                    QuestionResponse resp = rb.GetRequirementsList();
                    return Ok(resp);
                }
            }

            timer.Stop();
            return Ok($"Regular {speed}. Duration: {timer.Elapsed.TotalMilliseconds} ms.");
        }



        [HttpGet]
        [Route("api/async_task")]
        public async Task<IActionResult> AsyncTaskMethod([FromQuery] string speed)
        {
            var timer = new System.Diagnostics.Stopwatch();
            timer.Start();

            System.Collections.Generic.List<USERS> users = null;
            if (speed.ToUpper() == "LONG")
            {
                users = _context.USERS.ToList();
                System.Threading.Thread.Sleep(TimeSpan.FromSeconds(10));
            }
            else if (speed.ToUpper() == "SHORT")
            {
                users = _context.USERS.ToList();
            }
            else
            {
                int assessmentId = _token.AssessmentForUser();
                string applicationMode = "R";


                if (applicationMode.ToLower().StartsWith("questions"))
                {
                    var qb = new QuestionBusiness(_token, _document, _htmlConverter, _questionRequirement, _assessmentUtil, _context);
                    QuestionResponse resp = qb.GetQuestionList("*");
                    return Ok(resp);
                }
                else
                {
                    var rb = new RequirementBusiness(_assessmentUtil, _questionRequirement, _context, _token);
                    QuestionResponse resp = rb.GetRequirementsList();
                    return Ok(resp);
                }
            }

            timer.Stop();

            return Ok($"ASYNC_TASK {speed}. Duration: {timer.Elapsed.TotalMilliseconds} ms.");
        }


        public IActionResult Index()
        {
            return View();
        }
    }
}
