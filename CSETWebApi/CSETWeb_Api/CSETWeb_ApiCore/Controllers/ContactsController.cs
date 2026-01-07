//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
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


namespace CSETWebCore.Api.Controllers
{
    [CsetAuthorize]
    [ApiController]
    public class ContactsController : ControllerBase
    {
        private readonly ITokenManager _token;
        private readonly INotificationBusiness _notification;
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly IContactBusiness _contactBusiness;
        private readonly IUserBusiness _userBusiness;

        private CSETContext _context;

        public ContactsController(ITokenManager token, INotificationBusiness notification,
            IAssessmentUtil assessmentUtil, IContactBusiness contact, IUserBusiness user, CSETContext context)
        {
            _token = token;
            _context = context;
            _notification = notification;
            _assessmentUtil = assessmentUtil;
            _contactBusiness = contact;
            _userBusiness = user;
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
                ContactList = _contactBusiness.GetContacts(assessmentId),
                CurrentUserRole = _contactBusiness.GetUserRoleOnAssessment(userId, assessmentId) ?? 0
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
            var contacts = _contactBusiness.GetContactsByAssessmentId(id1, id2, id3, id4, id5, id6, id7, id8, id9, id10);
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

            var resp = _contactBusiness.GetContacts(assessmentId).Find(c => c.UserId == currentUserId);
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
            details.Add(_contactBusiness.CreateAndAddContactToAssessment(newContact, false));

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = details,
                CurrentUserRole = _contactBusiness.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), assessmentId) ?? 0
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
            details.Add(_contactBusiness.CreateAndAddContactToAssessment(newContact, true));

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = details,
                CurrentUserRole = _contactBusiness.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), assessmentId) ?? 0
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
                    ContactList = _contactBusiness.GetContacts(contactRemove.AssessmentId),
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


            int currentUserRole = _contactBusiness.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), ac.Assessment_Id) ?? 0;

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
                newList = _contactBusiness.RemoveContact(ac.Assessment_Contact_Id);
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
                ContactList = _contactBusiness.GetContacts(ac.Assessment_Id),
                CurrentUserRole = _contactBusiness.GetUserRoleOnAssessment((int)_token.GetCurrentUserId(), ac.Assessment_Id) ?? 0
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

            var resp = _contactBusiness.SearchContacts(currentUserId, searchParms);
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
            var resp = _contactBusiness.GetAllRoles();
            return Ok(resp);
        }


        [HttpGet]
        [Route("api/contacts/GetUserInfo")]
        public IActionResult GetUpdateUser()
        {
            _token.IsAuthenticated();
            var userId = _token.GetUserId();

            var resp = _userBusiness.GetUserInfo(userId);
            return Ok(resp);
        }


        /// <summary>
        /// Updates a contact's detail information.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/update")]
        public IActionResult PostUpdateContact([FromBody] CreateUser userBeingUpdated)
        {
            // verify that the user is allowed to make this update
            try
            {
                _token.AuthorizeAdminRole();
            }
            catch
            {
                return Forbid();
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

            int userid = 0;
            if (_token.IsAuthenticated())
            {
                userid = (int)_token.GetUserId();
            }

            try
            {
                _contactBusiness.UpdateUserContact(assessmentId, userid, userBeingUpdated);
            }
            catch (Exception exc)
            {
                return BadRequest(exc.Message);
            }

            return Ok();
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
        public IActionResult ValidateMyRemoval()
        {
            int assessmentId = _token.AssessmentForUser();
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
                group = ac.Last_Q_Answered.Split(',').ToList().Find(x => x.StartsWith("MG:"));

                if (group != null)
                {
                    group = group.Replace("MG:", "");
                    int groupInt = Convert.ToInt32(group);
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
