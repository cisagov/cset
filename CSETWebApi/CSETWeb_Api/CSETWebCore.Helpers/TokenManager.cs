//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Authentication;
using System.Security.Cryptography;
using System.Text;

namespace CSETWebCore.Helpers
{
    public class TokenManager : ITokenManager
    {
        private const string _bearerToken = "Bearer ";
        private JwtSecurityToken _token = null;
        private string _tokenString = null;

        private IHttpContextAccessor _httpContext;
        private readonly IConfiguration _configuration;
        private readonly ILocalInstallationHelper _localInstallationHelper;

        private CSETContext _context;
        private static string _secret = null;
        private static object _myLockObject = new object();


        /// <summary>
        /// Creates an instance of TokenManager and populates it with 
        /// the Authorization token in the current HTTP request.
        /// </summary>
        public TokenManager(IHttpContextAccessor httpContext, IConfiguration configuration,
            ILocalInstallationHelper localInstallationHelper, CSETContext context)
        {
            _httpContext = httpContext;
            _configuration = configuration;
            _localInstallationHelper = localInstallationHelper;
            _context = context;

            /* Get the token string from the Authorization header and
               strip off the Bearer prefix if present. */
            if (_httpContext.HttpContext != null)
            {
                HttpRequest req = _httpContext.HttpContext.Request;
                if (!string.IsNullOrEmpty(req.Headers["Authorization"]))
                {
                    _tokenString = req.Headers["Authorization"];
                    Init(_tokenString);
                }
            }
        }


        /// <summary>
        /// 
        /// </summary>
        /// <param name="tokenString"></param>
        public void SetToken(string tokenString)
        {
            _tokenString = tokenString;
            Init(tokenString);
        }


        /// <summary>
        /// Initializes the token if it has not been set but there is
        /// a token string.
        /// </summary>
        public void Init()
        {
            if (_token == null && !String.IsNullOrEmpty(_tokenString))
            {
                Init(_tokenString);
            }
        }


        /// <summary>
        /// Using the provided token string, the string is validated and if 
        /// valid (and not expired) the private JwtSecurityToken is set.
        /// </summary>
        /// <param name="tokenString"></param>
        public void Init(string tokenString)
        {
            // If no token was provided, do nothing.
            if (string.IsNullOrEmpty(tokenString))
            {
                Throw401();
            }

            if (tokenString.StartsWith(_bearerToken, StringComparison.InvariantCultureIgnoreCase))
            {
                tokenString = tokenString.Substring(_bearerToken.Length);
            }

            if (!IsTokenValid(tokenString))
            {
                Throw401();
            }

            // Convert to token 
            var handler = new JwtSecurityTokenHandler();
            _token = handler.ReadJwtToken(tokenString);
        }


        /// <summary>
        /// This just wraps the static method of the same name in TransactionSecurity.
        /// To see a list of claims we build into the token, see TransactionSecurity.GenerateToken()
        /// </summary>
        /// <returns></returns>
        public string Payload(string claim)
        {
            return ReadTokenPayload(_token, claim);
        }


        /// <summary>
        /// Returns a nullable int for convenience.  It is the consumer's  must know that the value
        /// it is looking for in the payload can be parsed as an int.
        /// </summary>
        /// <param name="claim"></param>
        /// <returns></returns>
        public int? PayloadInt(string claim)
        {
            var val = ReadTokenPayload(_token, claim);
            int result;
            bool b = int.TryParse(val, out result);
            if (b) return result;
            return null;
        }


        ///// <summary>
        ///// Creates a JWT with payload claims for the specified userid.
        ///// </summary>
        ///// <returns></returns>
        //public string GenerateToken(int userId, string accessKey, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId, string scope)
        //{
        //    return Blah(userId, null, tzOffset, expSeconds, assessmentId, aggregationId, scope);
        //}


        ///// <summary>
        ///// Creates a JWT with payload claims for the specified access key.
        ///// </summary>
        ///// <returns></returns>
        //public string GenerateToken(string accessKey, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId, string scope)
        //{
        //    return Blah(null, accessKey, tzOffset, expSeconds, assessmentId, aggregationId, scope);
        //}


        /// <summary>
        /// Creates a JWT with payload claims.  
        /// </summary>
        public string GenerateToken(int? userId, string accessKey, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId, string scope)
        {
            // Either a userId or accessKey will be supplied.  Use that identifier
            // in constructing the securityKey.
            string id = "";
            if (userId != null)
            {
                id = userId.ToString();
            }

            if (accessKey != null)
            {
                id = accessKey;
            }

            // Build securityKey.  For uniqueness, append the user identity (userId)
            var securityKey = new Microsoft
                .IdentityModel.Tokens.SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret() + id));

            // Build credentials
            var credentials = new Microsoft.IdentityModel.Tokens.SigningCredentials
                              (securityKey, SecurityAlgorithms.HmacSha256Signature);

            //  Finally create a Token
            var header = new JwtHeader(credentials);

            // Determine the expiration (server time) of the token
            int jwtExpiryMinutes = 60;
            string expMinutesConfig = _configuration["JWTExpiryMinutes"];
            if (expMinutesConfig != null)
            {
                int.TryParse(expMinutesConfig, out jwtExpiryMinutes);
            }

            int secondsUntilExpiry = (jwtExpiryMinutes * 60);

            // If a non-zero expSeconds was provided, override the expiration 
            if (expSeconds > 0)
            {
                secondsUntilExpiry = expSeconds;
            }

            var payload = new JwtPayload
            {
                { "aud", "CSET_AUD" },
                { "iss", "CSET_ISS" },
                { "exp", UnixTime() + secondsUntilExpiry },
                { Constants.Constants.Token_UserId, userId },
                { Constants.Constants.Token_AccessKey, accessKey },
                { Constants.Constants.Token_TimezoneOffsetKey, tzOffset },
                { "scope", scope }
            };



            // Include the current AssessmentId if one was provided
            if (assessmentId != null)
            {
                payload.Add(Constants.Constants.Token_AssessmentId, assessmentId);
            }

            // Include the current AggregationId if one was provided
            if (aggregationId != null)
            {
                payload.Add(Constants.Constants.Token_AggregationId, aggregationId);
            }

            // Build the token
            var secToken = new JwtSecurityToken(header, payload);
            var handler = new JwtSecurityTokenHandler();

            return handler.WriteToken(secToken);
        }





        /// <summary>
        /// 
        /// </summary>
        /// <param name="tokenString"></param>
        /// <returns></returns>
        public bool IsTokenValid(string tokenString)
        {
            JwtSecurityToken token = null;
            bool isLocal = _localInstallationHelper.IsLocalInstallation();
            try
            {
                var handler = new JwtSecurityTokenHandler();

                // Convert to token so that we can read the user to use in the signing key test
                token = handler.ReadJwtToken(tokenString);

                // Configure expected validation parameters
                var parms = new Microsoft.IdentityModel.Tokens.TokenValidationParameters()
                {
                    RequireExpirationTime = true,
                    ValidateLifetime = !isLocal,
                    ValidAudience = "CSET_AUD",
                    ValidIssuer = "CSET_ISS"
                };

                if (token.Payload[Constants.Constants.Token_UserId] != null)
                {
                    parms.IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret() + token.Payload[Constants.Constants.Token_UserId]));
                }
                else if (token.Payload[Constants.Constants.Token_AccessKey] != null)
                {
                    parms.IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret() + token.Payload[Constants.Constants.Token_AccessKey]));
                }


                var principal = handler
                    .ValidateToken(tokenString, parms, out SecurityToken validatedToken);
            }
            catch (Microsoft.IdentityModel.Tokens.SecurityTokenSignatureKeyNotFoundException stss)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"... {stss}");

                return false;
            }
            catch (ArgumentException argExc)
            {
                // the encoded JWT string is not valid because it couldn't be decoded for whatever reason

                NLog.LogManager.GetCurrentClassLogger().Error($"... {argExc}");

                return false;
            }
            catch (Exception exc)
            {
                // Something failed, likely in the validation.  The debugger shows a SecurityTokenInvalidSignatureException
                // but that class is not found in Microsoft.IdentityModel.Tokens, or anywhere.

                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");

                return false;
            }



            // see if the token has expired (we aren't really concerned with expiration on local installations)
            if (token.ValidTo < DateTime.UtcNow && !isLocal)
            {
                NLog.LogManager.GetCurrentClassLogger().Warn($"TokenManager.IsTokenValid -- the token has expired.  ValidTo={token.ValidTo}, UtcNow={DateTime.UtcNow}");

                return false;
            }

            return true;
        }


        /// <summary>
        /// Extracts a claim from the token payload
        /// </summary>
        public string ReadTokenPayload(JwtSecurityToken token, string claim)
        {
            if (token == null)
            {
                return null;
            }

            if (!token.Payload.ContainsKey(claim))
            {
                return null;
            }

            string value = token?.Payload[claim]?.ToString();
            return value;
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the 
        /// specified assessment.  Throws an HttpResponseException if not.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void AuthorizeUserForAssessment(int assessmentId)
        {
            var currentUserId = GetUserId();
            int countAC = _context.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId
                                                                   && ac.UserId == currentUserId).Count();
            if (!(countAC > 0))
            {
                var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("User not authorized for assessment"),
                    ReasonPhrase = "The current user is not authorized to access the target assessment"
                };
                throw new Exception(resp.Content.ToString());
            }
        }

        public bool IsCurrentUserOnAssessment(int assessmentId)
        {
            var currentUserId = GetUserId();

            int countAC = _context.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId
                                                                   && ac.UserId == currentUserId).Count();

            return (countAC > 0);
        }


        /// <summary>
        /// Checks to see if the specified Assessment ID is in the token payload.
        /// Throws a 401 if not.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void ValidateTokenForAssessment(int assessmentId)
        {
            if (PayloadInt(Constants.Constants.Token_AssessmentId) != assessmentId)
            {
                var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("User not authorized for assessment"),
                    ReasonPhrase = "The current user is not authorized to access the target assessment"
                };
                throw new Exception(resp.Content.ToString());
            }
        }


        public int? GetCurrentUserId()
        {
            return PayloadInt(Constants.Constants.Token_UserId);
        }


        /// <summary>
        /// Determines the language for the current user or access key.
        /// </summary>
        /// <returns></returns>
        public string GetCurrentLanguage()
        {
            var userId = PayloadInt(Constants.Constants.Token_UserId);
            var user = _context.USERS.FirstOrDefault(x => x.UserId == userId);

            var accessKey = Payload(Constants.Constants.Token_AccessKey);
            var ak = _context.ACCESS_KEY.FirstOrDefault(x => x.AccessKey == accessKey);
            var lang = user?.Lang ?? ak?.Lang ?? "en";

            return lang;
        }


        public int GetAssessmentId()
        {
            return PayloadInt(Constants.Constants.Token_AssessmentId) ?? 0;
        }


        public void GenerateSecret()
        {
            GetSecret();
        }


        /// <summary>
        /// Retrieves the JWT secret from the database.  
        /// If the secret is not in the database a new one is generated and persisted.
        /// A unique 'installation ID' is also created and stored.
        /// 
        /// The query has order-by's in case multiple records got into the table
        /// the same record will consistently be read.
        /// </summary>
        /// <returns></returns>
        public string GetSecret()
        {
            if (_secret != null)
            {
                return _secret;
            }

            lock (_myLockObject)
            {
                if (_secret != null)
                {
                    return _secret;
                }

                var inst = _context.INSTALLATION.OrderBy(i => i.Installation_ID).FirstOrDefault();
                if (inst != null)
                {
                    _secret = inst.JWT_Secret;
                    return inst.JWT_Secret;
                }


                // This is the first run of CSET -- generate a new secret and installation identifier
                string newSecret = null;
                string newInstallID = null;

                var byteArray = new byte[(int)Math.Ceiling(130 / 2.0)];
                RandomNumberGenerator.Fill(byteArray);
                newSecret = String.Concat(Array.ConvertAll(byteArray, x => x.ToString("X2")));

                newInstallID = Guid.NewGuid().ToString();


                // Store the new secret and installation ID
                var installRec = new INSTALLATION
                {
                    JWT_Secret = newSecret,
                    Generated_UTC = DateTime.UtcNow,
                    Installation_ID = newInstallID
                };
                _context.INSTALLATION.Add(installRec);

                _context.SaveChanges();
                _secret = newSecret;
                return newSecret;
            }
        }


        public int? GetUserId()
        {
            var uid = PayloadInt(Constants.Constants.Token_UserId);
            return uid;
        }


        public string GetAccessKey()
        {
            var ak = Payload(Constants.Constants.Token_AccessKey);
            return ak;
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the current assessment.  
        /// The userid and assessmentid are obtained from the current request token.
        /// </summary>
        /// <returns></returns>
        public int AssessmentForUser()
        {
            Init();
            int? userId = PayloadInt(Constants.Constants.Token_UserId);
            string accessKey = Payload(Constants.Constants.Token_AccessKey);
            int? assessmentId = PayloadInt(Constants.Constants.Token_AssessmentId);

            return AssessmentForUser(userId, accessKey, assessmentId);
        }


        public int AssessmentForUser(String tokenString)
        {
            SetToken(tokenString);
            int? userId = PayloadInt(Constants.Constants.Token_UserId);
            string accessKey = Payload(Constants.Constants.Token_AccessKey);
            int? assessmentId = PayloadInt(Constants.Constants.Token_AssessmentId);

            return AssessmentForUser(userId, accessKey, assessmentId);
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the current assessment.  
        /// 
        /// Returns the assessmentId obtained from the security token.
        /// 
        /// Throws an HttpResponseException if not.
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="assessmentId"></param>
        public int AssessmentForUser(int? userId, string accessKey, int? assessmentId)
        {
            if (assessmentId == null)
            {
                Throw401();
            }

            int hitsAC = _context.ASSESSMENT_CONTACTS.Count(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId);
            if (hitsAC > 0)
            {
                return (int)assessmentId;
            }

            int hitsAK = _context.ACCESS_KEY_ASSESSMENT.Count(aka => aka.AccessKey == accessKey && aka.Assessment_Id == assessmentId);
            if (hitsAK > 0)
            {
                return (int)assessmentId;
            }

            Throw401();

            return 0;
        }


        /// <summary>
        /// Throws a 401 Unauthorized HTTP exception if the current user is not
        /// an "admin" contact on the current Assessment.
        /// </summary>
        public void AuthorizeAdminRole()
        {
            var userId = GetUserId();
            int? assessmentId = PayloadInt(Constants.Constants.Token_AssessmentId);

            if (assessmentId == null)
            {
                NLog.LogManager.GetCurrentClassLogger().Error($"TokenManager.AuthorizeAdminRole - assessmentId not in token payload");
                Throw401();
            }


            var myAdminConnections = _context.ASSESSMENT_CONTACTS.Where(
                    ac => ac.UserId == userId
                    && ac.Assessment_Id == assessmentId
                    && ac.AssessmentRoleId == 2)
                    .ToList();

            if (myAdminConnections.Count() == 0)
            {
                Throw401();
            }

        }


        /// <summary>
        /// Returns a boolean indicating if the current user is the only Admin contact on the 
        /// current Assessment and there is at least one User role contact.
        /// </summary>
        /// <returns></returns>
        public bool AmILastAdminWithUsers(int assessmentId)
        {
            var userId = GetUserId();

            var adminConnections = _context.ASSESSMENT_CONTACTS.Where(
                    ac => ac.Assessment_Id == assessmentId
                    && ac.AssessmentRoleId == 2)
                    .ToList();


            var userConnections = _context.ASSESSMENT_CONTACTS.Where(
                    ac => ac.Assessment_Id == assessmentId
                    && ac.AssessmentRoleId == 1)
                    .ToList();

            // Return a boolean indicating whether I am the last Admin and there is more than one User
            return (adminConnections.Count() == 1
                && adminConnections.First().UserId == userId
                && userConnections.Count() > 0);
        }


        /// <summary>
        /// Throws a 401 Unauthorized HTTP exception
        /// </summary>
        public void Throw401()
        {
            var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
            {
                Content = new StringContent("User not authorized for assessment"),
                ReasonPhrase = "The current user is not authorized to access the target assessment"
            };
            throw new Exception(resp.Content.ReadAsStringAsync().Result);
        }


        /// <summary>
        /// Throws an exception if not valid (I hope)
        /// </summary>
        /// <returns></returns>
        public bool IsAuthenticated()
        {
            int? userId = PayloadInt(Constants.Constants.Token_UserId);

            return true;
        }

        public int UnixTime()
        {
            TimeSpan t = (DateTime.UtcNow - new DateTime(1970, 1, 1));
            return (int)t.TotalSeconds;
        }
    }
}
