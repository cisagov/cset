using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Cryptography;
using System.Text;
using CSETWebCore.Interfaces.Assessment;
using CSETWebCore.Interfaces.Helpers;
using DataLayerCore.Model;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions;
using Microsoft.Extensions.Configuration;

namespace CSETWebCore.Helpers
{
    public class TransactionSecurity : ITransactionSecurity
    {
        private readonly IUtilities _utilities;
        private readonly IAssessmentBusiness _assessmentBusiness;
        private readonly IAuthentication _authentication;
        private readonly IConfiguration _configuration;
        private readonly ITokenManager _tokenManager;
        private readonly CSET_Context _context;
        private string secret = null;

        public TransactionSecurity(IUtilities utilities, CSET_Context context, 
            IAssessmentBusiness assessmentBusiness, IAuthentication authentication, IConfiguration configuration,
            ITokenManager tokenManager)
        {
            _context = context;
            _utilities = utilities;
            _assessmentBusiness = assessmentBusiness;
            _authentication = authentication;
            _configuration = configuration;
            _tokenManager = tokenManager;
        }

        /// <summary>
        /// Generates a JWT.  
        /// NOTE:  THIS METHOD DOES NOT AUTHENTICATE USER CREDENTIALS.
        /// Any user authentication must be done prior to calling this method.
        /// 
        /// The expiration time is expressed as a unix/posix integer in UTC.
        /// </summary>
        /// <param name="userId">The user's ID</param>
        /// <param name="tzOffset">The user's timezone offset from UTC in minutes</param>
        /// <param name="expMinutes">
        ///     An optional specification of how long the token is valid (in seconds).  
        ///     Must be positive to be considered.
        /// </param>
        /// <param name="assesmentId">Optionally brands the new token with an assessment ID in the payload</param>
        /// <returns></returns>
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
                { Constants.Token_UserId, userId },
                { Constants.Token_TimezoneOffsetKey, tzOffset },
                { "scope", scope}
            };



            // Include the current AssessmentId if one was provided
            if (assessmentId != null)
            {
                payload.Add(Constants.Token_AssessmentId, assessmentId);
            }

            // Include the current AggregationId if one was provided
            if (aggregationId != null)
            {
                payload.Add(Constants.Token_AggregationId, aggregationId);
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
                    IssuerSigningKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(Encoding.UTF8.GetBytes(GetSecret() + token.Payload[Constants.Token_UserId]))
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
            if (!_assessmentBusiness.IsCurrentUserOnAssessment(assessmentId))
            {
                var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("User not authorized for assessment"),
                    ReasonPhrase = "The current user is not authorized to access the target assessment"
                };
                throw new Exception(resp.Content.ToString());
            }
        }


        /// <summary>
        /// Checks to see if the specified Assessment ID is in the token payload.
        /// Throws a 401 if not.
        /// </summary>
        /// <param name="assessmentId"></param>
        public void ValidateTokenForAssessment(int assessmentId)
        {
            TokenManager tm = new TokenManager();
            _authentication.AssessmentForUser();
            if (tm.PayloadInt(Constants.Token_AssessmentId) != assessmentId)
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
           return _tokenManager.PayloadInt(Constants.Token_UserId) ?? 0;
        }

        public int GetAssessmentId()
        {
            return _tokenManager.PayloadInt(Constants.Token_AssessmentId) ?? 0;
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
    }
}
