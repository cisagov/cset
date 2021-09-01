//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.AdminTab;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Reports;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Authentication;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Model.Password;
using CSETWebCore.Model.User;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;


namespace CSETWebCore.Api.Controllers
{
    public class ResetPasswordController : ControllerBase
    {
        private Regex emailvalidator = new Regex(@"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$");

        private readonly IUserAuthentication _userAuthentication;
        private readonly ITokenManager _tokenManager;
        private readonly CSETContext _context;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IAdminTabBusiness _adminTabBusiness;
        private readonly IReportsDataBusiness _reports;
        private readonly IUserBusiness _userBusiness;
        private readonly INotificationBusiness _notificationBusiness;

        public ResetPasswordController(IUserAuthentication userAuthentication, ITokenManager tokenManager, CSETContext context,
             IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports, IUserBusiness userBusiness, INotificationBusiness notificationBusiness)
        {
            _userAuthentication = userAuthentication;
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
            _userBusiness = userBusiness;
            _notificationBusiness = notificationBusiness;
        }


        [HttpGet]
        [Route("api/ResetPassword/ResetPasswordStatus")]
        [CsetAuthorize]
        public IActionResult GetResetPasswordStatus()
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest("Invalid Model State");
                }
                int userid = _tokenManager.GetUserId();
                var rval = _context.USERS.Where(x => x.UserId == userid).FirstOrDefault();
                if (rval != null)
                {
                    var resetRequired = rval.PasswordResetRequired;
                    return Ok(resetRequired);
                }
                else
                    return BadRequest("Unknown error");

            }
            catch (Exception ce)
            {
                return BadRequest(ce.Message);
            }
        }


        /// <summary>
        /// performs an actual password change
        /// </summary>
        /// <param name="changePass"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/ResetPassword/ChangePassword")]
        [CsetAuthorize]
        public IActionResult PostChangePassword([FromBody] ChangePassword changePass)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest("Invalid Model State");
                }
                if (!emailvalidator.IsMatch(changePass.PrimaryEmail.Trim()))
                {
                    return BadRequest("Invalid PrimaryEmail");
                }

                Login login = new Login()
                {
                    Email = changePass.PrimaryEmail,
                    Password = changePass.CurrentPassword
                };

                LoginResponse resp = _userAuthentication.Authenticate(login);
                if (resp == null)
                {
                    return BadRequest("Current password is invalid. Try again or request a new temporary password.");
                }

                UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness);

                bool rval = resetter.ChangePassword(changePass);
                if (rval)
                {
                    resp.ResetRequired = false;
                    _context.SaveChanges();
                    return Ok("Created Successfully");
                }
                else
                    return BadRequest("Unknown error");

            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpPost]
        [Route("api/ResetPassword/RegisterUser")]
        public IActionResult PostRegisterUser([FromBody] CreateUser user)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest("Invalid Model State");
                }
                if (String.IsNullOrWhiteSpace(user.PrimaryEmail))
                    return BadRequest("Invalid PrimaryEmail");

                if (!emailvalidator.IsMatch(user.PrimaryEmail))
                {
                    return BadRequest("Invalid PrimaryEmail");
                }
                if (!emailvalidator.IsMatch(user.ConfirmEmail.Trim()))
                {
                    return BadRequest("Invalid PrimaryEmail");
                }
                if (user.PrimaryEmail != user.ConfirmEmail)
                    return BadRequest("Invalid PrimaryEmail");

                if (_userBusiness.GetUserDetail(user.PrimaryEmail) != null)
                {
                    return BadRequest("An account already exists for that email address");
                }

                UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness);
                bool rval = resetter.CreateUserSendEmail(user);
                if (rval)
                    return Ok("Created Successfully");
                else
                    return BadRequest("Unknown error");
            }
            catch (Exception e)
            {
                return BadRequest(e);
            }
        }


        [HttpPost]
        [Route("api/ResetPassword")]
        public IActionResult ResetPassword([FromBody] SecurityQuestionAnswer answer)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }
                if (!emailvalidator.IsMatch(answer.PrimaryEmail.Trim()))
                {
                    return BadRequest();
                }

                if (IsSecurityAnswerCorrect(answer))
                {
                    UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness);
                    bool rval = resetter.ResetPassword(answer.PrimaryEmail, "Password Reset", answer.AppCode);
                    if (rval)
                        return Ok();
                    else
                        return BadRequest();
                }

                // return Unauthorized();
                // returning a 401 (Unauthorized) gets caught by the JWT interceptor and dumps the user out, which we don't want.
                return Conflict();

            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpGet]
        [Route("api/ResetPassword/PotentialQuestions")]
        public IActionResult GetPotentialQuestions()
        {
            try
            {
                UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness);
                return Ok(resetter.GetSecurityQuestionList());
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpGet]
        [Route("api/ResetPassword/SecurityQuestions")]
        public IActionResult GetSecurityQuestions([FromQuery] string email, [FromQuery] string appCode)
        {
            try
            {
                if (_context.USERS.Where(x => String.Equals(x.PrimaryEmail, email)).FirstOrDefault() == null)
                { 
                    return BadRequest();
                }


                var q = from b in _context.USER_SECURITY_QUESTIONS
                        join c in _context.USERS on b.UserId equals c.UserId
                        where c.PrimaryEmail == email
                        select new SecurityQuestions()
                        {
                            SecurityQuestion1 = b.SecurityQuestion1,
                            SecurityQuestion2 = b.SecurityQuestion2
                        };

                List<SecurityQuestions> questions = q.ToList();

                //note that you don't have to provide a security question
                //it will just reset if you don't 
                if (questions.Count == 0
                    || (questions[0].SecurityQuestion1 == null && questions[0].SecurityQuestion2 == null))
                {
                    UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness);
                    bool rval = resetter.ResetPassword(email, "Password Reset", appCode);

                    return Ok(new List<SecurityQuestions>());
                }

                return Ok(questions);
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        /// <summary>
        /// Checks the user-supplied question and answer against the stored answer.
        /// </summary>
        /// <param name="answer"></param>
        /// <returns></returns>
        private bool IsSecurityAnswerCorrect(SecurityQuestionAnswer answer)
        {
            var questions = from b in _context.USER_SECURITY_QUESTIONS
                            join c in _context.USERS on b.UserId equals c.UserId
                            where c.PrimaryEmail == answer.PrimaryEmail
                            && (
                                (b.SecurityQuestion1 == answer.QuestionText
                                    && b.SecurityAnswer1 == answer.AnswerText)
                                || (b.SecurityQuestion2 == answer.QuestionText
                                    && b.SecurityAnswer2 == answer.AnswerText)
                                )
                            select b;

            if ((questions != null) && questions.FirstOrDefault() != null)
                return true;
            return false;
        }
    }
}
