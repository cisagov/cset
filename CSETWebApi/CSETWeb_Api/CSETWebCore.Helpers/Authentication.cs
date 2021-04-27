using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;
using CSETWebCore.Interfaces.Helpers;
using DataLayerCore.Model;

namespace CSETWebCore.Helpers
{
    public class Authentication : IAuthentication
    {
        private readonly CSET_Context _context;
        private readonly ITokenManager _tokenManager;

        public Authentication( CSET_Context context, ITokenManager tokenManager)
        {
            _context = context;
            _tokenManager = tokenManager;
        }
        public int GetUserId()
        {
            int userId = (int)_tokenManager.PayloadInt(Constants.Token_UserId);
            return userId;
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the current assessment.  
        /// The userid and assessmentid are obtained from the current request token.
        /// </summary>
        /// <returns></returns>
        public int AssessmentForUser()
        {
            
            int userId = (int)_tokenManager.PayloadInt(Constants.Token_UserId);
            int? assessmentId = _tokenManager.PayloadInt(Constants.Token_AssessmentId);

            return AssessmentForUser(userId, assessmentId);
        }

        public int AssessmentForUser(String tokenString)
        {
            _tokenManager.SetToken(tokenString);
            int userId = (int)_tokenManager.PayloadInt(Constants.Token_UserId);
            int? assessmentId = _tokenManager.PayloadInt(Constants.Token_AssessmentId);

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
            int? assessmentId = _tokenManager.PayloadInt(Constants.Token_AssessmentId);

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
            int userId = (int)_tokenManager.PayloadInt(Constants.Token_UserId);

            return true;
        }
    }
}
