using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using CSETWebCore.DataLayer;
using CSETWebCore.Interfaces.Helpers;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;

namespace CSETWebCore.Helpers
{
    public class TokenManager : ITokenManager
    {
        private const string _bearerToken = "Bearer ";
        private JwtSecurityToken token = null;
        private string tokenString = null;
        private IHttpContextAccessor _httpContext;
        private readonly IConfiguration _configuration;
        private readonly IUtilities _utilities;

        private CSETContext _context;
        private string secret = null;
        //private readonly ITransactionSecurity _transactionSecurity;



        /// <summary>
        /// Creates an instance of TokenManager and populates it with 
        /// the Authorization token in the current HTTP request.
        /// </summary>
        public TokenManager(IHttpContextAccessor httpContext, IConfiguration configuration, 
            IUtilities utilities, CSETContext context)
        {
            _httpContext = httpContext;
            _configuration = configuration;
            _utilities = utilities;
            _context = context;

            /* Get the token string from the Authorization header and
               strip off the Bearer prefix if present. */
            if (_httpContext.HttpContext != null)
            {
                HttpRequest req = _httpContext.HttpContext.Request;
                tokenString = req.Headers["Authorization"];
                Init(tokenString);
            }
        }


        public void SetToken(string tokenString)
        {
            this.tokenString = tokenString;
            Init(tokenString);
        }


        public void Init(string tokenString)
        {
            // If no token was provided, do nothing.
            if (string.IsNullOrEmpty(tokenString))
            {
                return;
            }

            if (tokenString.StartsWith(_bearerToken, StringComparison.InvariantCultureIgnoreCase))
            {
                tokenString = tokenString.Substring(_bearerToken.Length);
            }

            if (!IsTokenValid(tokenString))
            {
                throw new Exception("JWT invalid");
            }

            // Convert to token 
            var handler = new JwtSecurityTokenHandler();
            token = handler.ReadJwtToken(tokenString);
        }


        /// <summary>
        /// This just wraps the static method of the same name in TransactionSecurity.
        /// To see a list of claims we build into the token, see TransactionSecurity.GenerateToken()
        /// </summary>
        /// <returns></returns>
        public string Payload(string claim)
        {
            return ReadTokenPayload(token, claim);
        }


        /// <summary>
        /// Returns a nullable int for convenience.  It is the consumer's  must know that the value
        /// it is looking for in the payload can be parsed as an int.
        /// </summary>
        /// <param name="claim"></param>
        /// <returns></returns>
        public int? PayloadInt(string claim)
        {
            var val = ReadTokenPayload(token, claim);
            int result;
            bool b = int.TryParse(val, out result);
            if (b) return result;
            return null;
        }


        public string GenerateToken(int userId, string tzOffset, int expSeconds, int? assessmentId, int? aggregationId, string scope)
        {
            // Build securityKey.  For uniqueness, append the user identity (userId)
            var securityKey = new Microsoft
                .IdentityModel.Tokens.SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret() + userId));

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
                { "exp", _utilities.UnixTime() + secondsUntilExpiry },
                { Constants.Constants.Token_UserId, userId },
                { Constants.Constants.Token_TimezoneOffsetKey, tzOffset },
                { "scope", scope}
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

            try
            {
                var handler = new JwtSecurityTokenHandler();

                // Convert to token so that we can read the user to use in the signing key test
                token = handler.ReadJwtToken(tokenString);

                // Configure expected validation parameters
                var parms = new Microsoft.IdentityModel.Tokens.TokenValidationParameters()
                {
                    RequireExpirationTime = true,
                    ValidAudience = "CSET_AUD",
                    ValidIssuer = "CSET_ISS",
                    IssuerSigningKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret() + token.Payload[Constants.Constants.Token_UserId]))
                };

                Microsoft.IdentityModel.Tokens.SecurityToken validatedToken;
                var principal = handler.ValidateToken(tokenString, parms, out validatedToken);
            }
            catch (ArgumentException argExc)
            {
                // the encoded JWT string is not valid because it couldn't be decoded for whatever reason
                //ElmahWrapper.LogAndReportException(argExc, null, null);
                return false;
            }
            catch (Exception exc)
            {
                // Something failed, likely in the validation.  The debugger shows a SecurityTokenInvalidSignatureException
                // but that class is not found in Microsoft.IdentityModel.Tokens, or anywhere.
                //ElmahWrapper.LogAndReportException(exc, null, null);

                return false;
            }


            // see if the token has expired
            if (token.ValidTo < DateTime.UtcNow)
            {
                return false;
            }

            return true;
        }


        /// <summary>
        /// Extracts a claim from the token payload
        /// </summary>
        public string ReadTokenPayload(JwtSecurityToken token, string claim)
        {
            try
            {
                string value = token.Payload[claim].ToString();

                return value;
            }
            catch (Exception exc)
            {
                return null;
            }
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the 
        /// specified assessment.  Throws an HttpResponseException if not.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void AuthorizeUserForAssessment(int assessmentId)
        {
            int currentUserId = GetUserId();
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
            int currentUserId = GetUserId();

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


        public int GetCurrentUserId()
        {
            return PayloadInt(Constants.Constants.Token_UserId) ?? 0;
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
        /// </summary>
        /// <returns></returns>
        public string GetSecret()
        {
            if (secret != null)
            {
                return secret;
            }


            var inst = _context.INSTALLATION.FirstOrDefault();
            if (inst != null)
            {
                secret = inst.JWT_Secret;
                return inst.JWT_Secret;
            }


            // This is the first run of CSET -- generate a new secret and installation identifier
            string newSecret = null;
            string newInstallID = null;

            var byteArray = new byte[(int)Math.Ceiling(130 / 2.0)];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(byteArray);
                newSecret = String.Concat(Array.ConvertAll(byteArray, x => x.ToString("X2")));
            }

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
            secret = newSecret;
            return newSecret;

        }


        public int GetUserId()
        {
            int userId = (int)PayloadInt(Constants.Constants.Token_UserId);
            return userId;
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the current assessment.  
        /// The userid and assessmentid are obtained from the current request token.
        /// </summary>
        /// <returns></returns>
        public int AssessmentForUser()
        {
            int userId = (int)PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = PayloadInt(Constants.Constants.Token_AssessmentId);

            return AssessmentForUser(userId, assessmentId);
        }


        public int AssessmentForUser(String tokenString)
        {
            SetToken(tokenString);
            int userId = (int)PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = PayloadInt(Constants.Constants.Token_AssessmentId);

            return AssessmentForUser(userId, assessmentId);
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
        public int AssessmentForUser(int userId, int? assessmentId)
        {
            if (assessmentId == null)
            {
                Throw401();
            }

            int hits = _context.ASSESSMENT_CONTACTS.Count(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId);
            if (hits == 0)
            {
                Throw401();
            }


            //AssessmentManager.TouchAssessment();

            return (int)assessmentId;
        }


        /// <summary>
        /// Throws a 401 Unauthorized HTTP exception if the current user is not
        /// an "admin" contact on the current Assessment.
        /// </summary>
        public void AuthorizeAdminRole()
        {
            int userId = GetUserId();
            int? assessmentId = PayloadInt(Constants.Constants.Token_AssessmentId);

            if (assessmentId == null)
            {
                Throw401();
            }


            var myAdminConnections = _context.ASSESSMENT_CONTACTS.Where(
                    ac => ac.UserId == userId
                    && ac.Assessment_Id == assessmentId
                    && ac.AssessmentRoleId == 2)
                    .ToList();

            if (myAdminConnections.Count == 0)
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
            int userId = GetUserId();

            var adminConnections = _context.ASSESSMENT_CONTACTS.Where(
                    ac => ac.Assessment_Id == assessmentId
                    && ac.AssessmentRoleId == 2)
                    .ToList();


            var userConnections = _context.ASSESSMENT_CONTACTS.Where(
                    ac => ac.Assessment_Id == assessmentId
                    && ac.AssessmentRoleId == 1)
                    .ToList();

            // Return a boolean indicating whether I am the last Admin and there is more than one User
            return (adminConnections.Count == 1
                && adminConnections.First().UserId == userId
                && userConnections.Count > 0);
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
            throw new Exception(resp.Content.ToString());
        }

        /// <summary>
        /// Throws an exception if not valid (I hope)
        /// </summary>
        /// <returns></returns>
        public bool IsAuthenticated()
        {
            int userId = (int)PayloadInt(Constants.Constants.Token_UserId);

            return true;
        }
    }
}
