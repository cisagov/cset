//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using Microsoft.AspNetCore.Mvc;
using CSETWebCore.Business.Authorization;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Enum;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using Microsoft.AspNetCore.Authorization;
using Microsoft.EntityFrameworkCore;
using LogicExtensions;

namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly INotificationBusiness _notification;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IContactBusiness _contact;
        private readonly IUserBusiness _user;

        private CSETContext _context;

        public ContactsController(ITokenManager token, INotificationBusiness notification,
            IAssessmentUtil assessmentUtil, IContactBusiness contact, IUserBusiness user, CSETContext context)
        {
            _token = token;
            _context = context;
            _notification = notification;
            _assessmentUtil = assessmentUtil;
            _contact = contact;
            _user = user;
        }
        /// <summary>
        /// Returns a collection of ContactDetails for the assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/contacts")]
        public IActionResult GetContactsForAssessment()
        {
            int assessmentId = _token.AssessmentForUser();
            var userId = _token.GetCurrentUserId();

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = _contact.GetContacts(assessmentId),
                CurrentUserRole = _contact.GetUserRoleOnAssessment(userId, assessmentId) ?? 0
            };
            return Ok(resp);
        }

        /// <summary>
        /// Returns contacts for the specified assessmentIds
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/contactsById")]
        public IActionResult GetContactsForAssessmentById(int id1, int id2, int id3, int id4, int id5, int id6, int id7, int id8, int id9, int id10)
        {
            var contacts = _contact.GetContactsByAssessmentId(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10);
            return Ok(contacts);
        }

        /// <summary>
        /// Returns the ContactDetail for the current user on the specified Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/contacts/getcurrent")]
        public IActionResult GetCurrentUserContact()
        {
            int assessmentId = _token.AssessmentForUser();
            var currentUserId = _token.GetUserId();

            var resp = _contact.GetContacts(assessmentId).Find(c => c.UserId == currentUserId);
            return Ok(resp);
        }


        /// <summary>
        /// Persists a single ContactDetail to the database.
        /// </summary>
        /// <param name="newContact"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/addnew")]
        public IActionResult CreateAndAddContactToAssessment([FromBody] ContactCreateParameters newContact)
        {
            int assessmentId = _token.AssessmentForUser();
            string app_code = _token.Payload(Constants.Constants.Token_Scope);

            // Make sure the user is an admin on this assessment
            _token.AuthorizeAdminRole();

            newContact.AssessmentId = assessmentId;
            newContact.PrimaryEmail = newContact.PrimaryEmail ?? "";

            List<ContactDetail> details = new List<ContactDetail>(1);
            details.Add(_contact.CreateAndAddContactToAssessment(newContact, false));

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = details,
                CurrentUserRole = _contact.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), assessmentId) ?? 0
            };
            return Ok(resp);
        }

        /// <summary>
        /// Persists a single ContactDetail to the database during a merge.
        /// </summary>
        /// <param name="newContact"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/addnewmergecontact")]
        public IActionResult CreateAndAddContactToAssessmentDuringMerge([FromBody] ContactCreateParameters newContact)
        {
            int assessmentId = _token.AssessmentForUser();
            string app_code = _token.Payload(Constants.Constants.Token_Scope);

            // Make sure the user is an admin on this assessment
            _token.AuthorizeAdminRole();

            newContact.AssessmentId = assessmentId;
            newContact.PrimaryEmail = newContact.PrimaryEmail ?? "";

            List<ContactDetail> details = new List<ContactDetail>(1);
            details.Add(_contact.CreateAndAddContactToAssessment(newContact, true));

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = details,
                CurrentUserRole = _contact.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), assessmentId) ?? 0
            };
            return Ok(resp);
        }


        /// <summary>
        /// Removes a Contact/User from an Assessment.
        /// </summary>
        [HttpPost]
        [Route("api/contacts/remove")]
        public IActionResult RemoveContactFromAssessment([FromBody] ContactRemoveParameters contactRemove)
        {
            if (contactRemove == null)
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The input parameters are not valid"),
                    ReasonPhrase = "The input parameters are not valid"
                };
                return BadRequest(err);
            }

            var currentUserId = _token.GetUserId();

            var accessKey = _token.GetAccessKey();


            // remove the connection between the assessment and the accesskey
            if (currentUserId == null && accessKey != null)
            {
                var bridge = _context.ACCESS_KEY_ASSESSMENT
                    .Where(x => x.Assessment_Id == contactRemove.AssessmentId && x.AccessKey == accessKey)
                    .FirstOrDefault();

                if (bridge != null)
                {
                    _context.ACCESS_KEY_ASSESSMENT.Remove(bridge);
                    _context.SaveChanges();
                }

                ContactsListResponse resp1 = new ContactsListResponse
                {
                    ContactList = _contact.GetContacts(contactRemove.AssessmentId),
                    CurrentUserRole = 0
                };

                return Ok(resp1);
            }


            ASSESSMENT_CONTACTS ac = null;

            // explicit removal using the ID of the connection 
            if (contactRemove.AssessmentContactId > 0)
            {
                ac = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Contact_Id == contactRemove.AssessmentContactId).FirstOrDefault();

            }

            // implied removal of the current user's connection to the assessment
            if (contactRemove.AssessmentId > 0)
            {
                ac = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == contactRemove.AssessmentId && x.UserId == currentUserId).FirstOrDefault();
            }

            if (ac == null)
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The input parameters are not valid"),
                    ReasonPhrase = "The input parameters are not valid"
                };
                return BadRequest(err);
            }


            int currentUserRole = _contact.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), ac.Assessment_Id) ?? 0;

            // If they are a USER and are trying to remove anyone but themself, forbid it
            if (currentUserRole == (int)ContactRole.RoleUser && ac.UserId != currentUserId)
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The current user does not have administrative authority for the Assessment."),
                    ReasonPhrase = "The only contact that a user role can remove is themself."
                };
                return BadRequest(err);
            }

            // Do not allow the user to remove themself if they are the last Admin on the assessment and there are other users
            if (ac.UserId == currentUserId
                && _token.AmILastAdminWithUsers(ac.Assessment_Id))
            {
                var err = new HttpResponseMessage(HttpStatusCode.Unauthorized)
                {
                    Content = new StringContent("The current user is the only Administrator contact on the Assessment"),
                    ReasonPhrase = "An Assessment must have at least one Administrator contact."
                };
                return BadRequest(err);
            }

            List<ContactDetail> newList;

            try
            {
                newList = _contact.RemoveContact(ac.Assessment_Contact_Id);
            }
            catch (Exception)
            {
                return BadRequest("Contact is not included in assesssment");
                // This could happen if they try to remove a contact that wasn't on the assessment.  
                // It's not critical.

                //Are we sure this is the ONLY CASE that could ever happen? 
                //changing it to catch specific instance just in case there could be 
                //anything else that could ever happen 
            }

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = _contact.GetContacts(ac.Assessment_Id),
                CurrentUserRole = _contact.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), ac.Assessment_Id) ?? 0
            };

            return Ok(resp);
        }


        /// <summary>
        /// Searches the database for entries containing the entered text.
        /// </summary>
        /// <param name="searchParms">The parameters for searching a contact</param>
        [HttpPost]
        [Route("api/contacts/search")]
        public IActionResult SearchContacts([FromBody] ContactSearchParameters searchParms)
        {
            int currentUserId = int.Parse(_token.Payload(Constants.Constants.Token_UserId));

            var resp = _contact.SearchContacts(currentUserId, searchParms);
            return Ok(resp);
        }


        /// <summary>
        /// Sends email invitations to join a CSET assessment.
        /// </summary>
        [HttpPost]
        [Route("api/contacts/invite")]
        public IActionResult InviteContacts([FromBody] ContactInviteParameters inviteParms)
        {
            int assessmentId = _token.AssessmentForUser();
            Dictionary<string, Boolean> success = new Dictionary<string, bool>();
            foreach (string invitee in inviteParms.InviteeList)
            {
                try
                {
                    _notification.InviteToAssessment(new ContactCreateParameters()
                    {
                        Body = inviteParms.Body,
                        PrimaryEmail = invitee,
                        Subject = inviteParms.Subject,
                        AssessmentId = assessmentId
                    });

                    var invited = _context.ASSESSMENT_CONTACTS.Where(x => x.PrimaryEmail == invitee && x.Assessment_Id == assessmentId).FirstOrDefault();
                    invited.Invited = true;
                    _context.SaveChanges();
                    _assessmentUtil.TouchAssessment(invited.Assessment_Id);

                    success.Add(invitee, true);
                }
                catch
                {
                    success.Add(invitee, false);
                }
            }

            return Ok(success);
        }


        /// <summary>
        /// Returns a list of all available Roles.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [AllowAnonymous]
        [Route("api/contacts/allroles")]
        public IActionResult GetAllRoles()
        {
            var resp = _contact.GetAllRoles();
            return Ok(resp);
        }

        [HttpGet]
        [Route("api/contacts/GetUserInfo")]
        public IActionResult GetUpdateUser()
        {
            _token.IsAuthenticated();
            var userId = _token.GetUserId();

            var resp = _user.GetUserInfo(userId);
            return Ok(resp);
        }

        /// <summary>
        /// Updates a user's detail information.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/UpdateUser")]
        public IActionResult PostUpdateUser([FromBody] CreateUser userBeingUpdated)
        {
            int userid = 0;
            if (_token.IsAuthenticated())
            {
                userid = (int)_token.GetUserId();
            }

            // If an edit is happening to a brand-new user, it is possible that the UI does not yet
            // know its UserId. In that case we will attempt to determine it via the primary email.

            if (userBeingUpdated.UserId == 0 || userBeingUpdated.UserId == 1)
            {
                var u = _context.USERS.Where(x => x.PrimaryEmail == userBeingUpdated.saveEmail).FirstOrDefault();
                if (u != null)
                {
                    userBeingUpdated.UserId = u.UserId;
                }
                else
                {
                    // This contact's user record does not exist ... create one
                    UserDetail userDetail = new UserDetail
                    {
                        Email = userBeingUpdated.PrimaryEmail,
                        FirstName = userBeingUpdated.FirstName,
                        LastName = userBeingUpdated.LastName,
                        IsSuperUser = false,
                        PasswordResetRequired = true
                    };

                    var uuu = _user.CreateUser(userDetail, _context);
                    userBeingUpdated.UserId = uuu.UserId;
                }

                // save the assessment_contacts record with the new userid before things start getting updated
                var ac = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Contact_Id == userBeingUpdated.AssessmentContactId).FirstOrDefault();
                if (ac != null)
                {
                    ac.UserId = userBeingUpdated.UserId;
                    _context.SaveChanges();
                }
            }

            int assessmentId = -1;

            try
            {
                assessmentId = _token.AssessmentForUser();
            }
            catch (Exception exc)
            {
                // The user is not currently 'in' an assessment

                NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
            }

            if (userid != userBeingUpdated.UserId)
            {
                // I (current user) am updating another contact

                if (assessmentId >= 0)
                {
                    // Updating a Contact in the context of the current Assessment.  
                    (_token).AuthorizeAdminRole();

                    int newUserId = (int)userBeingUpdated.UserId;

                    // If there is already a user with the same email as the newly updated email, use that existing user's id to connect them
                    // to the assessment after editing a contact
                    var existingUser = _context.USERS.Where(x => x.PrimaryEmail == userBeingUpdated.PrimaryEmail).FirstOrDefault();
                    if (existingUser != null)
                    {
                        newUserId = existingUser.UserId;
                    }

                    ContactDetail updatedContact = new ContactDetail
                    {
                        AssessmentContactId = userBeingUpdated.AssessmentContactId,
                        AssessmentId = assessmentId,
                        AssessmentRoleId = userBeingUpdated.AssessmentRoleId,
                        FirstName = userBeingUpdated.FirstName,
                        LastName = userBeingUpdated.LastName,
                        PrimaryEmail = userBeingUpdated.PrimaryEmail,
                        UserId = newUserId,
                        Title = userBeingUpdated.Title,
                        Phone = userBeingUpdated.Phone,
                        CellPhone = userBeingUpdated.CellPhone,
                        ReportsTo = userBeingUpdated.ReportsTo,
                        OrganizationName = userBeingUpdated.OrganizationName,
                        SiteName = userBeingUpdated.SiteName,
                        IsPrimaryPoc = userBeingUpdated.IsPrimaryPoc,
                        IsSiteParticipant = userBeingUpdated.IsSiteParticipant,
                        EmergencyCommunicationsProtocol = userBeingUpdated.EmergencyCommunicationsProtocol
                    };

                    _contact.UpdateContact(updatedContact, (int)userBeingUpdated.UserId);
                    _assessmentUtil.TouchAssessment(assessmentId);

                    return Ok(updatedContact);
                }

                return Unauthorized();
            }
            else
            {
                // I (current user) am updating myself

                // update user detail                    
                var user = _context.USERS.Where(x => x.UserId == userBeingUpdated.UserId).FirstOrDefault();
                user.FirstName = userBeingUpdated.FirstName;
                user.LastName = userBeingUpdated.LastName;
                user.PrimaryEmail = userBeingUpdated.PrimaryEmail;


                // update my email address on any ASSESSMENT_CONTACTS
                var myACs = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userBeingUpdated.UserId).ToList();
                foreach (var ac in myACs)
                {
                    ac.PrimaryEmail = userBeingUpdated.PrimaryEmail;
                }

                _context.SaveChanges();


                // update security questions/answers
                var sq = _context.USER_SECURITY_QUESTIONS.Where(x => x.UserId == userid).FirstOrDefault();
                if (sq == null)
                {
                    sq = new USER_SECURITY_QUESTIONS
                    {
                        UserId = userid
                    };
                    _context.USER_SECURITY_QUESTIONS.Add(sq);
                    _context.SaveChanges();
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
                    _context.USER_SECURITY_QUESTIONS.Update(sq);
                }
                else
                {
                    // both questions are null -- remove the record                                                
                    _context.USER_SECURITY_QUESTIONS.Remove(sq);
                }

                try
                {
                    _context.SaveChanges();
                    // Only touch the assessment if the user is currently in one.
                    if (assessmentId >= 0)
                    {
                        _assessmentUtil.TouchAssessment(assessmentId);
                    }
                }
                catch (DbUpdateConcurrencyException exc)
                {
                    // this can happen if there is no USER_SECURITY_QUESTIONS record
                    // but the code tries to delete it.

                    NLog.LogManager.GetCurrentClassLogger().Error($"... {exc}");
                }

                return Ok();
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
        /// Returns the language for the current user
        /// </summary>
        [HttpGet]
        [Route("api/contacts/userlang")]
        public IActionResult GetUserLanguage()
        {
            int? currentUserId = _token.GetUserId();
            string currentAccessKey = _token.GetAccessKey();

            var user = _context.USERS.FirstOrDefault(x => x.UserId == currentUserId);
            var ak = _context.ACCESS_KEY.FirstOrDefault(x => x.AccessKey == currentAccessKey);

            if (user == null && ak == null)
            {
                throw new KeyNotFoundException($"No user found for ID {(currentUserId != null ? currentUserId : currentAccessKey)}");
            }

            if (user != null && user.Lang == null)
            {
                user.Lang = "en";
                _context.SaveChanges();
            }

            if (ak != null && ak.Lang == null)
            {
                ak.Lang = "en";
                _context.SaveChanges();
            }

            var userLang = new { lang = user != null ? user.Lang : ak.Lang };
            return Ok(userLang);
        }


        /// <summary>
        /// Sets the current user's preferred language
        /// </summary>
        /// <param name="lang"></param>
        [HttpPost]
        [Route("api/contacts/userlang")]
        public IActionResult SaveUserLanguage([FromBody] UserLanguage lang)
        {
            // update the USER
            int? currentUserId = _token.GetUserId();
            string currentAccessKey = _token.GetAccessKey();

            var user = _context.USERS.FirstOrDefault(x => x.UserId == currentUserId);
            var ak = _context.ACCESS_KEY.FirstOrDefault(x => x.AccessKey == currentAccessKey);

            if (user == null && ak == null)
            {
                throw new KeyNotFoundException($"No user found for ID {(currentUserId != null ? currentUserId : currentAccessKey)}");
            }

            if (user != null)
            {
                user.Lang = lang.Lang;
            }

            if (ak != null)
            {
                ak.Lang = lang.Lang;
            }

            _context.SaveChanges();

            return Ok();
        }


        /// <summary>
        /// Checks to see if the user can remove themself from an Assessment.  If they are
        /// the only ADMIN and there are any USERs on the Assessment, then 
        /// it is not allowed.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/ValidateRemoval")]
        public IActionResult ValidateMyRemoval(int assessmentId)
        {
            _token.IsAuthenticated();
            if (_token.AmILastAdminWithUsers(assessmentId))
            {
                return Ok(false);
            }

            return Ok(true);
        }


        /// <summary>
        /// 
        /// </summary>
        [HttpGet]
        [Route("api/contacts/bookmark")]
        public IActionResult GetBookmark()
        {
            int? currentUserId = _token.GetUserId();
            int assessmentId = _token.AssessmentForUser();

            var ac = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == currentUserId && x.Assessment_Id == assessmentId).FirstOrDefault();

            if (ac == null)
            {
                // no contact record - just do nothing
                return Ok();
            }

            var parentGroup = new MATURITY_GROUPINGS();

            // if the group has a parent, find it to append
            if (ac.Last_Q_Answered != null)
            {
                string group = "";
                group = ac.Last_Q_Answered.Split(',').ToList().Find(x => x.StartsWith("MG:")).Replace("MG:", "");

                if (group != null)
                {
                    int groupInt = group.ToInt32();
                    int? parentGroupId = _context.MATURITY_GROUPINGS.Where(x => x.Grouping_Id == groupInt).Select(x => x.Parent_Id).FirstOrDefault();
                    if (parentGroupId != null)
                    {
                        parentGroup = _context.MATURITY_GROUPINGS.Where(x => x.Grouping_Id == parentGroupId).FirstOrDefault();
                    }
                }
            }


            string lastQAnswered = ac.Last_Q_Answered;

            // checking if this is the overall holder group (useless info) or a domain (useful)
            if (parentGroup != null && parentGroup.Parent_Id != null)
            {
                lastQAnswered += ",PG:" + parentGroup.Grouping_Id;
            }

            return Ok(lastQAnswered);
        }
    }
}
