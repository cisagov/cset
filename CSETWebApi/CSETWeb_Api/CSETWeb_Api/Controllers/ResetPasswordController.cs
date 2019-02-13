//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWeb_Api.Helpers;
using DataLayerCore.Model;
using System;
using System.Net;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using System.Linq;
using System.Collections.Generic;
using System.Data.Entity;
using System.Net.Http;
using System.Web.Http.Description;
using CSETWeb_Api.Models;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.BusinessLogic.Models;

namespace CSETWeb_Api.Controllers
{
    public class ResetPasswordController : ApiController
    {
        private Regex emailvalidator = new Regex(@"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$");
        private CsetwebContext db = new CsetwebContext();




        [HttpGet]
        [Route("api/ResetPassword/ResetPasswordStatus")]
        [CSETAuthorize]
        [ResponseType(typeof(UserStatus))]
        public HttpResponseMessage GetResetPasswordStatus()
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Model State");
                }
                int userid = Auth.GetUserId();
                var rval = db.USERS.Where(x => x.UserId == userid).FirstOrDefault();
                if (rval != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, rval.PasswordResetRequired);
                }
                else
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "Unknown error");

            }
            catch (CSETApplicationException ce)
            {
                return Request.CreateResponse(HttpStatusCode.Conflict, ce.Message);
            }
            catch (Exception e)
            {
                return CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }
        }

        /// <summary>
        /// performs an actual password change
        /// </summary>
        /// <param name="changePass"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/ResetPassword/ChangePassword")]
        [CSETAuthorize]
        public async Task<HttpResponseMessage> PostChangePassword([FromBody] ChangePassword changePass)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Model State");
                }
                if (!emailvalidator.IsMatch(changePass.PrimaryEmail.Trim()))
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid PrimaryEmail");
                }

                Login login = new Login()
                {
                    Email = changePass.PrimaryEmail,
                    Password = changePass.CurrentPassword
                };
                LoginResponse resp = UserAuthentication.Authenticate(login);
                if (resp == null)
                {
                    return Request.CreateResponse(HttpStatusCode.Conflict, "Current password is invalid. Try again or request a new temporary password.");
                }

                UserAccountSecurityManager resetter = new UserAccountSecurityManager();

                bool rval = await resetter.ChangePassword(changePass);
                if (rval)
                {
                    resp.PasswordResetRequired = false;
                    await db.SaveChangesAsync();
                    return Request.CreateResponse(HttpStatusCode.OK, "Created Successfully");
                }
                else
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "Unknown error");

            }
            catch (CSETApplicationException ce)
            {
                return Request.CreateResponse(HttpStatusCode.Conflict, ce.Message);
            }
            catch (Exception e)
            {
                return CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }
        }


        [HttpPost]
        [Route("api/ResetPassword/RegisterUser")]
        public async Task<HttpResponseMessage> PostRegisterUser([FromBody] CreateUser user)
        {
            try
            {
                if (!ModelState.IsValid)
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid Model State");
                }
                if (String.IsNullOrWhiteSpace(user.PrimaryEmail))
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid PrimaryEmail");

                if (!emailvalidator.IsMatch(user.PrimaryEmail))
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid PrimaryEmail");
                }
                if (!emailvalidator.IsMatch(user.ConfirmEmail.Trim()))
                {
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid PrimaryEmail");
                }
                if (user.PrimaryEmail != user.ConfirmEmail)
                    return Request.CreateResponse(HttpStatusCode.BadRequest, "Invalid PrimaryEmail");

                if (new UserManager().GetUserDetail(user.PrimaryEmail) != null)
                {
                    return Request.CreateResponse(HttpStatusCode.Conflict, "An account already exists for that email address");
                }

                UserAccountSecurityManager resetter = new UserAccountSecurityManager();
                bool rval = await resetter.CreateUserSendEmail(user);
                if (rval)
                    return Request.CreateResponse(HttpStatusCode.OK, "Created Successfully");
                else
                    return Request.CreateResponse(HttpStatusCode.InternalServerError, "Unknown error");
            }
            catch (CSETApplicationException ce)
            {
                return Request.CreateResponse(HttpStatusCode.Conflict, ce.Message);
            }
            catch (Exception e)
            {
                return CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }
        }


        [HttpPost]
        public async Task<IHttpActionResult> PostResetPassword([FromBody] SecurityQuestionAnswer answer)
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
                    UserAccountSecurityManager resetter = new UserAccountSecurityManager();
                    bool rval = await resetter.ResetPassword(answer.PrimaryEmail, "Password Reset");
                    if (rval)
                        return StatusCode(HttpStatusCode.OK);
                    else
                        return StatusCode(HttpStatusCode.InternalServerError);
                }

                // return Unauthorized();
                // returning a 401 (Unauthorized) gets caught by the JWT interceptor and dumps the user out, which we don't want.
                return Conflict();

            }
            catch (Exception e)
            {
                return (IHttpActionResult)CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }
        }


        [Route("api/ResetPassword/PotentialQuestions")]
        [HttpGet]
        public List<PotentialQuestions> GetPotentialQuestions()
        {
            try
            {
                UserAccountSecurityManager resetter = new UserAccountSecurityManager();
                return resetter.GetSecurityQuestionList();
            }
            catch (Exception e)
            {
                CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
            }
            return new List<PotentialQuestions>();
        }

        [Route("api/ResetPassword/SecurityQuestions")]
        [HttpGet]
        [ResponseType(typeof(List<SecurityQuestions>))]
        public async Task<IHttpActionResult> GetSecurityQuestions([FromUri]string email)
        {
            try
            {
                if (db.USERS.Where(x => String.Equals(x.PrimaryEmail, email)).FirstOrDefault() == null)
                    return Conflict();

                List<SecurityQuestions> questions = await (from b in db.USER_SECURITY_QUESTIONS
                                                           join c in db.USERS on b.UserId equals c.UserId
                                                           where c.PrimaryEmail.Equals(email, StringComparison.CurrentCultureIgnoreCase)
                                                           select new SecurityQuestions()
                                                           {
                                                               SecurityQuestion1 = b.SecurityQuestion1,
                                                               SecurityQuestion2 = b.SecurityQuestion2
                                                           }).ToListAsync<SecurityQuestions>();
                //note that you don't have to provide a security question
                //it will just reset if you don't 
                if (questions.Count <= 0)
                {
                    UserAccountSecurityManager resetter = new UserAccountSecurityManager();
                    bool rval = await resetter.ResetPassword(email, "Password Reset");
                }


                return Ok(questions);
            }
            catch (Exception e)
            {
                CSETWeb_Api.Helpers.ElmahWrapper.LogAndReportException(e, Request, HttpContext.Current);
                return Content(HttpStatusCode.InternalServerError, e.Message);
            }
        }


        /// <summary>
        /// Checks the user-supplied question and answer against the stored answer.
        /// </summary>
        /// <param name="answer"></param>
        /// <returns></returns>
        private bool IsSecurityAnswerCorrect(SecurityQuestionAnswer answer)
        {
            var questions = from b in db.USER_SECURITY_QUESTIONS
                            join c in db.USERS on b.UserId equals c.UserId
                            where c.PrimaryEmail.Equals(answer.PrimaryEmail, StringComparison.CurrentCultureIgnoreCase)
                            && (
                                (b.SecurityQuestion1 == answer.QuestionText
                                    && b.SecurityAnswer1.Equals(answer.AnswerText, StringComparison.InvariantCultureIgnoreCase))
                                || (b.SecurityQuestion2 == answer.QuestionText
                                    && b.SecurityAnswer2.Equals(answer.AnswerText, StringComparison.InvariantCultureIgnoreCase))
                                )
                            select b;

            if ((questions != null) && questions.FirstOrDefault() != null)
                return true;
            return false;
        }
    }
}




