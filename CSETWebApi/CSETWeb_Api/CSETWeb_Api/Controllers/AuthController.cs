//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.Threading.Tasks;
using System.Text.RegularExpressions;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using CSETWeb_Api.BusinessManagers;
using DataLayerCore.Model;
using BusinessLogic.Helpers;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Provides login, token issuance, etc.
    /// </summary>
    public class AuthController : ApiController
    {
        /// <summary>
        /// Authorizes the supplied credentials.
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/auth/login")]
        public LoginResponse Login([FromBody]Login login)
        {
            LoginResponse resp = UserAuthentication.Authenticate(login);
            if (resp != null)
            {
                return resp;
            }

            return new LoginResponse();
        }


        /// <summary>
        /// Attempts to perform a login for a stand-alone single-user implementation.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/auth/login/standalone")]
        public LoginResponse LoginStandalone(Login login)
        {
            LoginResponse resp = UserAuthentication.AuthenticateStandalone(login);
            if (resp != null)
            {
                return resp;
            }
            return new LoginResponse();
        }


        /// <summary>
        /// Returns a token cloned from the requesting token.  The new refresh clone
        /// will have a new expiration timestamp and will optionally contain an
        /// assessment ID in the payload.
        /// </summary>
        /// <returns></returns>
        [CSETAuthorize]
        [Route("api/auth/token")]
        [HttpGet]
        public TokenResponse IssueToken(int assessmentId = -1, string refresh = "*default*", int expSeconds = -1)
        {
            // Get a few claims from the current token
            TokenManager tm = new TokenManager();
            int currentUserId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? currentAssessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
            string scope = tm.Payload(Constants.Token_Scope);

            // If the 'refresh' parm was sent, this is a pure refresh
            if (refresh != "*default*")
            {
                // If the token has an assess ID, validate the user/assessment
                if (currentAssessmentId != null)
                {
                    Auth.AssessmentForUser(currentUserId, (int)currentAssessmentId);
                }
            }
            else
            {
                // If an assessmentId was sent, use that in the new token aftervalidating user/assessment
                if (assessmentId > 0)
                {
                    Auth.AssessmentForUser(currentUserId, assessmentId);
                    currentAssessmentId = assessmentId;
                }
            }

            // If we make it this far, we can issue the new token with what we know to be current and valid
            string token = TransactionSecurity.GenerateToken(
                currentUserId,
                tm.Payload(Constants.Token_TimezoneOffsetKey),
                expSeconds,
                currentAssessmentId,
                scope);

            TokenResponse resp = new TokenResponse
            {
                Token = token
            };

            return resp;
        }
    }


    /// <summary>
    /// Describes a token response.
    /// </summary>
    public class TokenResponse
    {
        /// <summary>
        /// An encoded string representing a JWT.
        /// </summary>
        public string Token;
    }
}


