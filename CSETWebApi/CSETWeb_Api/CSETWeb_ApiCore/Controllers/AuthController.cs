using CSETWebCore.Business.Authorization;
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
        private readonly ITokenManager _tokenManager;
        private static readonly object _locker = new object();
        static readonly log4net.ILog _logger = log4net.LogManager.GetLogger(typeof(AuthController));

        public AuthController(IUserAuthentication userAuthentication, ITokenManager tokenManager)
        {
            _userAuthentication = userAuthentication;
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
            if (resp != null)
            {
                return Ok(resp);
            }

            return BadRequest(new LoginResponse());
        }

        /// <summary>
        /// Attempts to perform a login for a stand-alone single-user implementation.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/auth/login/standalone")]
        public IActionResult LoginStandalone([FromBody] Login login)
        {
            _logger.Info("Logging into standalone...");
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
                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");

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
            string scope = _tokenManager.Payload(Constants.Constants.Token_Scope);
            return Ok(_userAuthentication.IsLocalInstallation(scope));
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
            int currentUserId = (int)_tokenManager.PayloadInt(Constants.Constants.Token_UserId);
            int? currentAssessmentId = _tokenManager.PayloadInt(Constants.Constants.Token_AssessmentId);
            int? currentAggregationId = _tokenManager.PayloadInt(Constants.Constants.Token_AggregationId);
            string scope = _tokenManager.Payload(Constants.Constants.Token_Scope);

            // If the 'refresh' parm was sent, this is a pure refresh
            if (refresh != "*default*")
            {
                // If the token has an assess ID, validate the user/assessment
                if (currentAssessmentId != null)
                {
                    _tokenManager.AssessmentForUser(currentUserId, (int)currentAssessmentId);
                }
            }
            else
            {
                // If an assessmentId was sent, use that in the new token after validating user/assessment
                if (assessmentId > 0)
                {
                    _tokenManager.AssessmentForUser(currentUserId, assessmentId);
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
