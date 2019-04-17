//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessManagers;
using DataLayerCore.Model;

namespace CSETWeb_Api.Helpers
{
    /// <summary>
    /// Provides authorization verification.
    /// </summary>
    public class Auth
    {
        /// <summary>
        /// Returns the current userid from the authentication token.
        /// </summary>
        /// <returns></returns>
        public static int GetUserId() {
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            return userId;            
        }


        /// <summary>
        /// Checks to see if the current user is authorized to access the current assessment.  
        /// The userid and assessmentid are obtained from the current request token.
        /// </summary>
        /// <returns></returns>
        public static int AssessmentForUser()
        {
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

            return AssessmentForUser(userId, assessmentId);
        }

        public static int AssessmentForUser(String tokenString)
        {
            TokenManager tm = new TokenManager(tokenString);
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

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
        public static int AssessmentForUser(int userId, int? assessmentId)
        {
            if (assessmentId == null)
            {
                Throw401();
            }

            using (var db = new CSET_Context())
            {
                int hits = db.ASSESSMENT_CONTACTS.Where(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId).Count();
                if (hits == 0)
                {
                    Throw401();                    
                }
            }

            //AssessmentManager.TouchAssessment();

            return (int)assessmentId;
        }


        /// <summary>
        /// Throws a 401 Unauthorized HTTP exception if the current user is not
        /// an "admin" contact on the current Assessment.
        /// </summary>
        public static void AuthorizeAdminRole()
        {
            TokenManager tm = new TokenManager();
            int userId = Auth.GetUserId();
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);

            if (assessmentId == null)
            {
                Throw401();
            }

            using (var db = new CSET_Context())
            {
                var myAdminConnections = db.ASSESSMENT_CONTACTS.Where(
                        ac => ac.UserId == userId
                        && ac.Assessment_Id == assessmentId 
                        && ac.AssessmentRoleId == 2)
                        .ToList();
                
                if (myAdminConnections.Count == 0)
                {
                    Throw401();
                }
            }
        }


        /// <summary>
        /// Returns a boolean indicating if the current user is the only Admin contact on the 
        /// current Assessment and there is at least one User role contact.
        /// </summary>
        /// <returns></returns>
        public static bool AmILastAdminWithUsers(int assessmentId)
        {
            TokenManager tm = new TokenManager();
            int userId = Auth.GetUserId();

            using (var db = new CSET_Context())
            {
                var adminConnections = db.ASSESSMENT_CONTACTS.Where(                        
                        ac => ac.Assessment_Id == assessmentId 
                        && ac.AssessmentRoleId == 2)
                        .ToList();


                var userConnections = db.ASSESSMENT_CONTACTS.Where(
                        ac => ac.Assessment_Id == assessmentId
                        && ac.AssessmentRoleId == 1)
                        .ToList();

                // Return a boolean indicating whether I am the last Admin and there is more than one User
                return (adminConnections.Count == 1
                    && adminConnections.First().UserId == userId
                    && userConnections.Count > 0);
            }
        }


        /// <summary>
        /// Throws a 401 Unauthorized HTTP exception
        /// </summary>
        private static void Throw401()
        {
            var resp = new HttpResponseMessage(HttpStatusCode.Unauthorized)
            {
                Content = new StringContent("User not authorized for assessment"),
                ReasonPhrase = "The current user is not authorized to access the target assessment"
            };
            throw new HttpResponseException(resp);
        }

        /// <summary>
        /// Throws an exception if not valid (I hope)
        /// </summary>
        /// <returns></returns>
        public static bool IsAuthenticated()
        {
            TokenManager tm = new TokenManager();
            int userId = (int)tm.PayloadInt(Constants.Token_UserId);

            return true;
        }
    }
}

