//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Models;
using CSETWeb_Api.BusinessManagers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace CSETWeb_Api.Controllers
{
    /// <summary>
    /// Manages contacts for an assessment.
    /// </summary>
    [CSETAuthorize]
    public class ContactsController : ApiController
    {
        /// <summary>
        /// Returns a collection of ContactDetails for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/contacts")]
        public ContactsListResponse GetContactsForAssessment()
        {
            int assessmentId = Auth.AssessmentForUser();
            int userId = TransactionSecurity.CurrentUserId;

            ContactsManager contactManager = new ContactsManager();
            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = contactManager.GetContacts(assessmentId),
                CurrentUserRole = contactManager.GetUserRoleOnAssessment(userId, assessmentId) ?? 0
            };
            return resp;
        }


        /// <summary>
        /// Returns the ContactDetail for the current user on the specified Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/contacts/getcurrent")]
        public ContactDetail GetCurrentUserContact()
        {
            int assessmentId = Auth.AssessmentForUser();
            int currentUserId = Auth.GetUserId();

            ContactsManager contactManager = new ContactsManager();
            return contactManager.GetContacts(assessmentId).Find(c => c.UserId == currentUserId);
        }


        /// <summary>
        /// Persists a single ContactDetail to the database.
        /// </summary>
        /// <param name="newContact"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/addnew")]
        public ContactsListResponse CreateAndAddContactToAssessment([FromBody]ContactCreateParameters newContact)
        {
            int assessmentId = Auth.AssessmentForUser();
            TokenManager tm = new TokenManager();
            string app_code = tm.Payload(Constants.Token_Scope);

            // Make sure the user is an admin on this assessment
            Auth.AuthorizeAdminRole();

            newContact.AssessmentId = assessmentId;
            newContact.PrimaryEmail = newContact.PrimaryEmail ?? "";

            ContactsManager cm = new ContactsManager();
            List<ContactDetail> details = new List<ContactDetail>(1);
            details.Add(cm.CreateAndAddContactToAssessment(newContact));

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = details,
                CurrentUserRole = cm.GetUserRoleOnAssessment(TransactionSecurity.CurrentUserId, assessmentId) ?? 0
            };
            return resp;
        }


        /// <summary>
        /// Removes a Contact/User from an Assessment.
        /// </summary>
        [HttpPost]
        [Route("api/contacts/remove")]
        public ContactsListResponse RemoveContactFromAssessment([FromBody]ContactRemoveParameters contactRemove)
        {
            if (contactRemove == null)
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The input parameters are not valid"),
                    ReasonPhrase = "The input parameters are not valid"
                };
                throw new HttpResponseException(err);
            }

            int assessmentId = contactRemove.Assessment_ID == 0 ? Auth.AssessmentForUser() : contactRemove.Assessment_ID;
            int currentUserId = Auth.GetUserId();
            if (contactRemove.UserId == 0)
                contactRemove.UserId = currentUserId;

            // Determine the current user's role.  
            ContactsManager cm = new ContactsManager();
            int currentUserRole = cm.GetUserRoleOnAssessment(TransactionSecurity.CurrentUserId, assessmentId) ?? 0;

            // If they are a USER and are trying to remove anyone but themself, forbid it
            if (currentUserRole == (int)ContactsManager.ContactRole.RoleUser && contactRemove.UserId != currentUserId)
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The current user does not have administrative authority for the Assessment."),
                    ReasonPhrase = "The only contact that a user role can remove is themself."
                };
                throw new HttpResponseException(err);
            }

            // Do not allow the user to remove themself if they are the last Admin on the assessment and there are other users
            if (contactRemove.UserId == currentUserId
                && Auth.AmILastAdminWithUsers(assessmentId))
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The current user is the only Administrator contact on the Assessment"),
                    ReasonPhrase = "An Assessment must have at least one Administrator contact."
                };
                throw new HttpResponseException(err);
            }

            List<ContactDetail> newList;

            try
            {
                newList = cm.RemoveContact(contactRemove.UserId, assessmentId);
            }
            catch (NoSuchUserException)
            {
                // This could happen if they try to remove a contact that wasn't on the assessment.  
                // It's not critical.

                //Are we sure this is the ONLY CASE that could ever happen? 
                //changing it to catch specific instance just in case there could be 
                //anything else that could ever happen 
            }

            ContactsManager contactManager = new ContactsManager();
            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = contactManager.GetContacts(assessmentId),
                CurrentUserRole = contactManager.GetUserRoleOnAssessment(TransactionSecurity.CurrentUserId, assessmentId) ?? 0
            };

            return resp;
        }


        /// <summary>
        /// Searches the database for entries containing the entered text.
        /// </summary>
        /// <param name="searchParms">The parameters for searching a contact</param>
        [HttpPost]
        [Route("api/contacts/search")]
        public IEnumerable<ContactSearchResult> SearchContacts([FromBody]ContactSearchParameters searchParms)
        {
            TokenManager tm = new TokenManager();
            int currentUserId = int.Parse(tm.Payload(Constants.Token_UserId));

            ContactsManager cm = new ContactsManager();
            return cm.SearchContacts(currentUserId, searchParms);
        }


        /// <summary>
        /// Sends email invitations to join a CSET assessment.
        /// </summary>
        [HttpPost]
        [Route("api/contacts/invite")]
        public Dictionary<string, Boolean> InviteContacts([FromBody]ContactInviteParameters inviteParms)
        {
            int assessmentId = Auth.AssessmentForUser();

            NotificationManager nm = new NotificationManager();
            Dictionary<string, Boolean> success = new Dictionary<string, bool>();
            foreach (string invitee in inviteParms.InviteeList)
            {
                try
                {
                    nm.InviteToAssessment(new ContactCreateParameters()
                    {
                        Body = inviteParms.Body,
                        PrimaryEmail = invitee,
                        Subject = inviteParms.Subject,
                        AssessmentId = assessmentId
                    });
                    using (CSET_Context db = new CSET_Context())
                    {
                        var invited = db.ASSESSMENT_CONTACTS.Where(x => x.PrimaryEmail == invitee && x.Assessment_Id == assessmentId).FirstOrDefault();
                        invited.Invited = true;
                        db.SaveChanges();
                        CSETWeb_Api.BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(invited.Assessment_Id);
                    }
                    success.Add(invitee, true);
                }
                catch
                {
                    success.Add(invitee, false);
                }
            }
            return success;
        }


        /// <summary>
        /// Returns a list of all available Roles.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/contacts/allroles")]
        public object GetAllRoles()
        {
            ContactsManager cm = new ContactsManager();
            return cm.GetAllRoles();
        }

        [HttpGet]
        [Route("api/contacts/GetUserInfo")]
        public CreateUser GetUpdateUser()
        {
            Auth.IsAuthenticated();
            int userId = Auth.GetUserId();

            UserManager um = new UserManager();
            return um.GetUserInfo(userId);
        }

        /// <summary>
        /// Updates a user's detail information.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/UpdateUser")]
        public void PostUpdateUser([FromBody] CreateUser userBeingUpdated)
        {
            int userid = 0;
            if (Auth.IsAuthenticated())
            {
                userid = Auth.GetUserId();
            }

            // If an edit is happening to a brand-new user, it is possible that the UI does not yet
            // know its UserId. In that case we will attempt to determine it via the primary email.
            using (CSET_Context context = new CSET_Context())
            {
                if (userBeingUpdated.UserId == 0 || userBeingUpdated.UserId == 1)
                {
                    var u = context.USERS.Where(x => x.PrimaryEmail == userBeingUpdated.saveEmail).FirstOrDefault();
                    if (u != null)
                    {
                        userBeingUpdated.UserId = u.UserId;
                    }
                }
            }

            int assessmentId = -1;

            try
            {
                assessmentId = Auth.AssessmentForUser();
            }
            catch (HttpResponseException)
            {
                // The user is not currently 'in' an assessment
            }

            if (userid != userBeingUpdated.UserId)
            {
                if (assessmentId >= 0)
                {
                    // Updating a Contact in the context of the current Assessment.  
                    Auth.AuthorizeAdminRole();

                    ContactsManager cm = new ContactsManager();
                    cm.UpdateContact(new ContactDetail
                    {
                        AssessmentId = assessmentId,
                        AssessmentRoleId = userBeingUpdated.AssessmentRoleId,
                        FirstName = userBeingUpdated.FirstName,
                        LastName = userBeingUpdated.LastName,
                        PrimaryEmail = userBeingUpdated.PrimaryEmail,
                        UserId = userBeingUpdated.UserId
                    });
                    BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(assessmentId);
                }
            }
            else
            {
                // Updating myself
                using (CSET_Context context = new CSET_Context())
                {
                    // update user detail                    
                    var user = context.USERS.Where(x => x.UserId == userBeingUpdated.UserId).FirstOrDefault();
                    user.FirstName = userBeingUpdated.FirstName;
                    user.LastName = userBeingUpdated.LastName;
                    user.PrimaryEmail = userBeingUpdated.PrimaryEmail;


                    // update my email address on any ASSESSMENT_CONTACTS
                    var myACs = context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userBeingUpdated.UserId).ToList();
                    foreach (var ac in myACs)
                    {
                        ac.PrimaryEmail = userBeingUpdated.PrimaryEmail;
                    }

                    context.SaveChanges();


                    // update security questions/answers
                    var sq = context.USER_SECURITY_QUESTIONS.Where(x => x.UserId == userid).FirstOrDefault();
                    if (sq == null)
                    {
                        sq = new USER_SECURITY_QUESTIONS
                        {
                            UserId = userid
                        };
                        context.USER_SECURITY_QUESTIONS.Attach(sq);
                        context.SaveChanges();
                    }
                    sq.SecurityQuestion1 = NullIfEmpty(userBeingUpdated.SecurityQuestion1);
                    sq.SecurityAnswer1 = NullIfEmpty(userBeingUpdated.SecurityAnswer1);
                    sq.SecurityQuestion2 = NullIfEmpty(userBeingUpdated.SecurityQuestion2);
                    sq.SecurityAnswer2 = NullIfEmpty(userBeingUpdated.SecurityAnswer2);

                    // don't store a question or answer without its partner
                    if (sq.SecurityQuestion1 == null || sq.SecurityAnswer1 == null)
                    {
                        sq.SecurityQuestion1 = null;
                        sq.SecurityAnswer1 = null;
                    }
                    if (sq.SecurityQuestion2 == null || sq.SecurityAnswer2 == null)
                    {
                        sq.SecurityQuestion2 = null;
                        sq.SecurityAnswer2 = null;
                    }

                    // delete or add/update the record
                    if (sq.SecurityQuestion1 != null || sq.SecurityQuestion2 != null)
                    {
                        context.USER_SECURITY_QUESTIONS.AddOrUpdate(sq, x => x.UserId);
                    }
                    else
                    {
                        // both questions are null -- remove the record                                                
                        context.USER_SECURITY_QUESTIONS.Remove(sq);
                    }

                    try
                    {
                        context.SaveChanges();
                        // Only touch the assessment if the user is currently in one.
                        if (assessmentId >= 0)
                        {
                            BusinessLogic.Helpers.AssessmentUtil.TouchAssessment(assessmentId);
                        }
                    }
                    catch (DbUpdateConcurrencyException)
                    {
                        // this can happen if there is no USER_SECURITY_QUESTIONS record
                        // but the code tries to delete it.
                    }
                }
            }
        }


        /// <summary>
        /// Returns null if the target string is empty or just spaces.
        /// </summary>
        /// <param name="s"></param>
        /// <returns></returns>
        private string NullIfEmpty(string s)
        {
            if (s != null && s.Trim().Length == 0)
            {
                return null;
            }

            return s;
        }


        /// <summary>
        /// Checks to see if the user can remove themself from an Assessment.  If they are
        /// the only ADMIN and there are any USERs on the Assessment, then 
        /// it is not allowed.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/ValidateRemoval")]
        public bool ValidateMyRemoval([FromUri] int assessmentId)
        {
            Auth.IsAuthenticated();
            if (Auth.AmILastAdminWithUsers(assessmentId))
            {
                return false;
            }

            return true;
        }
    }


    /// <summary>
    /// Defines the response for a "get contacts" call.
    /// </summary>
    public class ContactsListResponse
    {
        /// <summary>
        /// The list of candidate contacts
        /// </summary>
        public IEnumerable<ContactDetail> ContactList;

        /// <summary>
        /// The user's role in the current assessment
        /// </summary>
        public int CurrentUserRole = 0;
    }


    /// <summary>
    /// Defines the values required to invite a group of users to CSET.
    /// </summary>
    public class ContactInviteParameters
    {
        /// <summary>
        /// The subject of the invitation email.
        /// </summary>
        public string Subject;

        /// <summary>
        /// The message body of the invitation email.
        /// </summary>
        public string Body;

        /// <summary>
        /// A list of the invitees' email addresses.
        /// </summary>
        public List<string> InviteeList;
    }
}


