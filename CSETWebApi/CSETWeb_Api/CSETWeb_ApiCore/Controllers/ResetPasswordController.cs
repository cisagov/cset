//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
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
using Microsoft.Extensions.Configuration;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;
using CSETWebCore.Model.Auth;
using CSETWebCore.Api.Models;
using NLog;
using Microsoft.AspNetCore.Hosting;

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
        private readonly IConfiguration _configuration;
        private readonly IWebHostEnvironment _webHost;

        public ResetPasswordController(IUserAuthentication userAuthentication, ITokenManager tokenManager, CSETContext context,
             IAssessmentUtil assessmentUtil, IAdminTabBusiness adminTabBusiness, IReportsDataBusiness reports,
             IUserBusiness userBusiness, INotificationBusiness notificationBusiness, IConfiguration configuration, IWebHostEnvironment webHost)
        {
            _userAuthentication = userAuthentication;
            _tokenManager = tokenManager;
            _context = context;
            _assessmentUtil = assessmentUtil;
            _adminTabBusiness = adminTabBusiness;
            _reports = reports;
            _userBusiness = userBusiness;
            _notificationBusiness = notificationBusiness;
            _configuration = configuration;
            _webHost = webHost;
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

                var userId = _tokenManager.GetUserId();
                var rval = _context.USERS.Where(x => x.UserId == userId).FirstOrDefault();
                if (rval != null)
                {
                    var resetRequired = rval.PasswordResetRequired;
                    return Ok(resetRequired);
                }


                // if an access key is used, there is no password to expire
                if (_tokenManager.GetAccessKey() != null)
                {
                    return Ok(false);
                }

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
                    return Ok(
                        new PasswordResponse()
                        {
                            IsValid = false,
                            Message = "Invalid Model State"
                        });
                }
                if (!emailvalidator.IsMatch(changePass.PrimaryEmail.Trim()))
                {
                    return Ok(
                        new PasswordResponse()
                        {
                            IsValid = false,
                            Message = "Invalid Primary Email"
                        });
                }

                Login login = new Login()
                {
                    Email = changePass.PrimaryEmail,
                    Password = changePass.CurrentPassword
                };

                LoginResponse resp = _userAuthentication.Authenticate(login);
                if (resp == null)
                {
                    return Ok(
                        new PasswordResponse()
                        {
                            IsValid = false,
                            Message = "current invalid"
                        });
                }

                UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);

                // does this new password follow the complexity rules?
                PasswordResponse respComplex = resetter.ComplexityRulesMet(changePass);
                if (!respComplex.PasswordContainsLower || !respComplex.PasswordContainsUpper || !respComplex.PasswordLengthMet ||
                    !respComplex.PasswordContainsSpecial || !respComplex.PasswordNotReused)
                {
                    respComplex.IsValid = false;
                    respComplex.Message = "rules not satisfied";
                    return Ok(respComplex);
                }


                bool rval = resetter.ChangePassword(changePass);
                if (rval)
                {
                    resp.ResetRequired = false;
                    _context.SaveChanges();
                    return Ok(new PasswordResponse()
                    {
                        IsValid = true,
                        Message = "Created Successfully"
                    });
                }
                else
                    return Ok(new PasswordResponse()
                    {
                        IsValid = false,
                        Message = "Unknown error"
                    });
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpPost]
        [Route("api/ResetPassword/CheckPassword")]
        public IActionResult CheckPassword([FromBody] ChangePassword changePass)
        {
            UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);

            // does this new password follow the complexity rules?
            if (changePass.NewPassword == null)
            {
                return Ok(new PasswordResponse
                {
                    PasswordLengthMin = resetter.PasswordLengthMin,
                    PasswordLengthMax = resetter.PasswordLengthMax,
                    NumberOfHistoricalPasswords = resetter.NumberOfHistoricalPasswords,
                    PasswordLengthMet = false,
                    PasswordContainsNumbers = false,
                    PasswordContainsLower = false,
                    PasswordContainsUpper = false,
                    PasswordContainsSpecial = false,
                    PasswordNotReused = false
                });
            }

            PasswordResponse complexEnough = resetter.ComplexityRulesMet(changePass);
            return Ok(complexEnough);
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
                {
                    return BadRequest("missing email");
                }

                if (!emailvalidator.IsMatch(user.PrimaryEmail))
                {
                    return BadRequest("invalid email format");
                }

                if (!emailvalidator.IsMatch(user.ConfirmEmail.Trim()))
                {
                    return BadRequest("invalid email format");
                }

                if (user.PrimaryEmail != user.ConfirmEmail)
                {
                    return BadRequest("emails do not match");
                }

                if (_userBusiness.GetUserDetail(user.PrimaryEmail) != null)
                {
                    return BadRequest("account already exists");
                }

                // Validate the email against an allowlist (if defined by the host)
                var securityManager = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);
                if (!securityManager.EmailIsAllowed(user.PrimaryEmail, _webHost))
                {
                    return BadRequest("email not allowed");
                }

                var resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);

                var gp = new CSETGlobalProperties(_context);
                var beta = gp.GetBoolProperty("IsCsetOnlineBeta") ?? false;

                if (beta)
                {
                    LogManager.GetCurrentClassLogger().Info("CreateUser - CSET is set to 'online beta' mode - no email sent to new user");

                    // create the user but DO NOT send the temp password email (test/beta)
                    var rval = resetter.CreateUser(user, false);
                    if (rval)
                    {
                        return Ok("waiting-for-approval");
                    }
                }
                else
                {
                    // create the user and send the temp password email immediately (production)
                    var rval = resetter.CreateUser(user, true);
                    if (rval)
                    {
                        return Ok("created-and-email-sent");
                    }
                }

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
                answer.PrimaryEmail = answer.PrimaryEmail.Trim();

                if (!ModelState.IsValid)
                {
                    return BadRequest(ModelState);
                }

                if (!emailvalidator.IsMatch(answer.PrimaryEmail))
                {
                    return BadRequest();
                }

                if (!_userBusiness.GetUserDetail(answer.PrimaryEmail).IsActive)
                {
                    return BadRequest("user inactive");
                }

                if (IsSecurityAnswerCorrect(answer))
                {
                    UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);
                    bool rval = resetter.ResetPassword(answer.PrimaryEmail, "Password Reset", answer.AppName);

                    if (rval)
                    {
                        return Ok();
                    }
                    else
                    {
                        return BadRequest();
                    }
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
        public IActionResult GetPotentialQuestions([FromQuery] string lang)
        {
            try
            {
                UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);
                return Ok(resetter.GetSecurityQuestionList(lang));
            }
            catch (Exception e)
            {
                return BadRequest(e.Message);
            }
        }


        [HttpGet]
        [Route("api/ResetPassword/SecurityQuestions")]
        public IActionResult GetSecurityQuestions([FromQuery] string email, [FromQuery] string appName)
        {
            try
            {
                email = email.Trim();

                var user = _context.USERS.Where(x => String.Equals(x.PrimaryEmail, email)).FirstOrDefault();

                if (user == null)
                {
                    return BadRequest();
                }

                if (!user.IsActive)
                {
                    return BadRequest("user inactive");
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
                    UserAccountSecurityManager resetter = new UserAccountSecurityManager(_context, _userBusiness, _notificationBusiness, _configuration);
                    bool rval = resetter.ResetPassword(email, "Password Reset", appName);

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
