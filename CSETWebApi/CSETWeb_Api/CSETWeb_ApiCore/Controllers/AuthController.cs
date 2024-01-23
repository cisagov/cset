//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Business.Authorization;
using CSETWebCore.Helpers;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Auth;
using CSETWebCore.Model.Authentication;
using Microsoft.AspNetCore.Mvc;
using System;

namespace CSETWebCore.Api.Controllers
{
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly IUserAuthentication _userAuthentication;
        private readonly ILocalInstallationHelper _localInstallationHelper;
        private readonly ITokenManager _tokenManager;
        private static readonly object _locker = new object();
        static readonly NLog.Logger _logger = NLog.LogManager.GetCurrentClassLogger();


        /// <summary>
        /// Constructor.
        /// </summary>
        public AuthController(IUserAuthentication userAuthentication, ITokenManager tokenManager, ILocalInstallationHelper localInstallationHelper)
        {
            _userAuthentication = userAuthentication;
            _localInstallationHelper = localInstallationHelper;
            _tokenManager = tokenManager;
        }


        /// <summary>
        /// Authorizes the supplied credentials.
        /// </summary>
        /// <param name="login"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/auth/login")]
        public IActionResult Login([FromBody] Login login)
        {
            LoginResponse resp = _userAuthentication.Authenticate(login);

            if (resp == null)
            {
                return BadRequest(new LoginResponse());
            }

            if (resp.IsPasswordExpired)
            {
                return BadRequest(resp);
            }

            return Ok(resp);
        }


        /// <summary>
        /// Attempts to perform a login for a stand-alone single-user implementation.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/auth/login/standalone")]
        public IActionResult LoginStandalone([FromBody] Login login)
        {
            try
            {
                _tokenManager.GenerateSecret();
                lock (_locker)
                {
                    LoginResponse resp = _userAuthentication.AuthenticateStandalone(login, _tokenManager);
                    if (resp != null)
                    {
                        return Ok(resp);
                    }

                    resp = new LoginResponse()
                    {
                        LinkerTime = new Helpers.BuildNumberHelper().GetLinkerTime()
                    };
                    return Ok(resp);
                }
            }
            catch (Exception exc)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                _logger.Error(exc.Message);
                return StatusCode(500);
            }
        }


        /// <summary>
        /// Tells the client if this is a local installation.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/auth/islocal")]
        public IActionResult IsLocalInstallation()
        {
            return Ok(_localInstallationHelper.IsLocalInstallation());
        }


        /// <summary>
        /// Returns a token cloned from the requesting token.  The new refresh clone
        /// will have a new expiration timestamp and will optionally contain an
        /// assessment ID in the payload.
        /// </summary>
        /// <returns></returns>
        [CsetAuthorize]
        [HttpGet]
        [Route("api/auth/token")]
        public IActionResult IssueToken([FromQuery] int assessmentId = -1, [FromQuery] int aggregationId = -1, [FromQuery] string refresh = "*default*", [FromQuery] int expSeconds = -1)
        {
            int? currentUserId = _tokenManager.PayloadInt(Constants.Constants.Token_UserId);
            string accessKey = _tokenManager.Payload(Constants.Constants.Token_AccessKey);
            int? currentAssessmentId = _tokenManager.PayloadInt(Constants.Constants.Token_AssessmentId);
            int? currentAggregationId = _tokenManager.PayloadInt(Constants.Constants.Token_AggregationId);
            string scope = _tokenManager.Payload(Constants.Constants.Token_Scope);


            // If the 'refresh' parm was sent, this is a pure refresh
            if (refresh != "*default*")
            {
                // If the token has an assess ID, validate the user/assessment
                if (currentAssessmentId != null)
                {
                    _tokenManager.AssessmentForUser(currentUserId, accessKey, (int)currentAssessmentId);
                }
            }
            else
            {
                // If an assessmentId was sent, use that in the new token after validating user/assessment
                if (assessmentId > 0)
                {
                    _tokenManager.AssessmentForUser(currentUserId, accessKey, assessmentId);
                    currentAssessmentId = assessmentId;
                }

                if (aggregationId > 0)
                {
                    currentAggregationId = aggregationId;
                }
            }

            // If we make it this far, we can issue the new token with what we know to be current and valid
            string token = _tokenManager.GenerateToken(
                currentUserId,
                accessKey,
                _tokenManager.Payload(Constants.Constants.Token_TimezoneOffsetKey),
                expSeconds,
                currentAssessmentId,
                currentAggregationId,
                scope);

            TokenResponse resp = new TokenResponse
            {
                Token = token
            };

            return Ok(resp);
        }

        [CsetAuthorize]
        [HttpGet]
        [Route("api/auth/accesskey")]
        /// <summary>
        /// Generates an access key for an anonymous user
        /// </summary>
        public IActionResult GetAccessKey()
        {
            var x = _userAuthentication.GenerateAccessKey();
            return Ok(x);
        }


        [HttpPost]
        [Route("api/auth/login/accesskey")]
        public IActionResult LoginWithAccessKey([FromBody] AnonymousLogin login)
        {
            LoginResponse resp = _userAuthentication.AuthenticateAccessKey(login);

            if (resp == null)
            {
                return BadRequest(new LoginResponse());
            }

            return Ok(resp);
        }


        [HttpGet]
        [Route("api/IsRunning")]
        /// <summary>
        /// Simple endpoint to check if API is running
        /// </summary>
        public IActionResult IsRunning()
        {
            return Ok();
        }
    }
}
