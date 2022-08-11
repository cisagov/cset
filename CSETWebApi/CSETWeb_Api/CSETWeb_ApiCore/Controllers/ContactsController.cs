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
using System.Threading.Tasks;

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
        public async Task<IActionResult> GetContactsForAssessment()
        {
            int assessmentId = await _token.AssessmentForUser();
            int userId = _token.GetCurrentUserId();

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = await _contact.GetContacts(assessmentId),
                CurrentUserRole = _contact.GetUserRoleOnAssessment(userId, assessmentId) ?? 0
            };
            return Ok(resp);
        }


        /// <summary>
        /// Returns the ContactDetail for the current user on the specified Assessment.
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        [Route("api/contacts/getcurrent")]
        public async Task<IActionResult> GetCurrentUserContact()
        {
            int assessmentId = await _token.AssessmentForUser();
            int currentUserId = _token.GetUserId();
            var contactList = await _contact.GetContacts(assessmentId);

            var resp = contactList.Find(c => c.UserId == currentUserId);
            return Ok(resp);
        }


        /// <summary>
        /// Persists a single ContactDetail to the database.
        /// </summary>
        /// <param name="newContact"></param>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/addnew")]
        public async Task<IActionResult> CreateAndAddContactToAssessment([FromBody] ContactCreateParameters newContact)
        {
            int assessmentId = await _token.AssessmentForUser();
            string app_code = _token.Payload(Constants.Constants.Token_Scope);

            // Make sure the user is an admin on this assessment
            await _token.AuthorizeAdminRole();

            newContact.AssessmentId = assessmentId;
            newContact.PrimaryEmail = newContact.PrimaryEmail ?? "";

            List<ContactDetail> details = new List<ContactDetail>(1);
            details.Add(await _contact.CreateAndAddContactToAssessment(newContact));

            ContactsListResponse resp = new ContactsListResponse
            {
                ContactList = details,
                CurrentUserRole = _contact.GetUserRoleOnAssessment(_token.GetCurrentUserId(), assessmentId) ?? 0
            };
            return Ok(resp);
        }


        /// <summary>
        /// Removes a Contact/User from an Assessment.
        /// </summary>
        [HttpPost]
        [Route("api/contacts/remove")]
        public async Task<IActionResult> RemoveContactFromAssessment([FromBody] ContactRemoveParameters contactRemove)
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

            int currentUserId = _token.GetUserId();

            ASSESSMENT_CONTACTS ac = null;

            // explicit removal using the ID of the connection 
            if (contactRemove.AssessmentContactId > 0)
            {
                ac = await _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Contact_Id == contactRemove.AssessmentContactId).FirstOrDefaultAsync();

            }

            // implied removal of the current user's connection to the assessment
            if (contactRemove.AssessmentId > 0)
            {
                ac = await _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == contactRemove.AssessmentId && x.UserId == currentUserId).FirstOrDefaultAsync();
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

            int currentUserRole = _contact.GetUserRoleOnAssessment(_token.GetCurrentUserId(), ac.Assessment_Id) ?? 0;

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
                && await _token.AmILastAdminWithUsers(ac.Assessment_Id))
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
                newList = await _contact.RemoveContact(ac.Assessment_Contact_Id);
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
                ContactList = await _contact.GetContacts(ac.Assessment_Id),
                CurrentUserRole = _contact.GetUserRoleOnAssessment(_token.GetCurrentUserId(), ac.Assessment_Id) ?? 0
            };

            return Ok(resp);
        }


        /// <summary>
        /// Searches the database for entries containing the entered text.
        /// </summary>
        /// <param name="searchParms">The parameters for searching a contact</param>
        [HttpPost]
        [Route("api/contacts/search")]
        public async Task<IActionResult> SearchContacts([FromBody] ContactSearchParameters searchParms)
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
        public async Task<IActionResult> InviteContacts([FromBody] ContactInviteParameters inviteParms)
        {
            int assessmentId = await _token.AssessmentForUser();
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

                    var invited = await  _context.ASSESSMENT_CONTACTS.Where(x => x.PrimaryEmail == invitee && x.Assessment_Id == assessmentId).FirstOrDefaultAsync();
                    invited.Invited = true;
                    await _context.SaveChangesAsync();
                    await _assessmentUtil.TouchAssessment(invited.Assessment_Id);

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
        public async Task<IActionResult> GetAllRoles()
        {
            var resp = _contact.GetAllRoles();
            return Ok(resp);
        }

        [HttpGet]
        [Route("api/contacts/GetUserInfo")]
        public async Task<IActionResult> GetUpdateUser()
        {
            _token.IsAuthenticated();
            int userId = _token.GetUserId();

            var resp = _user.GetUserInfo(userId);
            return Ok(resp);
        }

        /// <summary>
        /// Updates a user's detail information.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/UpdateUser")]
        public async Task<IActionResult> PostUpdateUser([FromBody] CreateUser userBeingUpdated)
        {
            int userid = 0;
            if (_token.IsAuthenticated())
            {
                userid = _token.GetUserId();
            }

            // If an edit is happening to a brand-new user, it is possible that the UI does not yet
            // know its UserId. In that case we will attempt to determine it via the primary email.

            if (userBeingUpdated.UserId == 0 || userBeingUpdated.UserId == 1)
            {
                var u = await _context.USERS.Where(x => x.PrimaryEmail == userBeingUpdated.saveEmail).FirstOrDefaultAsync();
                if (u != null)
                {
                    userBeingUpdated.UserId = u.UserId;
                }
            }

            int assessmentId = -1;

            try
            {
                assessmentId = await _token.AssessmentForUser();
            }
            catch (Exception exc)
            {
                // The user is not currently 'in' an assessment

                log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");
            }

            if (userid != userBeingUpdated.UserId)
            {
                if (assessmentId >= 0)
                {
                    // Updating a Contact in the context of the current Assessment.  
                    (_token).AuthorizeAdminRole();

                    int newUserId = userBeingUpdated.UserId;

                    // If there is already a user with the same email as the newly updated email, use that existing user's id to connect them
                    // to the assessment after editing a contact
                    var existingUser = await _context.USERS.Where(x => x.PrimaryEmail == userBeingUpdated.PrimaryEmail).FirstOrDefaultAsync();
                    if (existingUser != null) 
                    {
                        newUserId = existingUser.UserId;
                    }

                    ContactDetail updatedContact = new ContactDetail
                    {
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

                    await _contact.UpdateContact(updatedContact, userBeingUpdated.UserId);
                    _assessmentUtil.TouchAssessment(assessmentId);

                    return Ok(updatedContact);
                }

                return Unauthorized();
            }
            else
            {
                // Updating myself

                // update user detail                    
                var user = await _context.USERS.Where(x => x.UserId == userBeingUpdated.UserId).FirstOrDefaultAsync();
                user.FirstName = userBeingUpdated.FirstName;
                user.LastName = userBeingUpdated.LastName;
                user.PrimaryEmail = userBeingUpdated.PrimaryEmail;


                // update my email address on any ASSESSMENT_CONTACTS
                var myACs = await _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userBeingUpdated.UserId).ToListAsync();
                foreach (var ac in myACs)
                {
                    ac.PrimaryEmail = userBeingUpdated.PrimaryEmail;
                }

                await _context.SaveChangesAsync();


                // update security questions/answers
                var sq = await _context.USER_SECURITY_QUESTIONS.Where(x => x.UserId == userid).FirstOrDefaultAsync();
                if (sq == null)
                {
                    sq = new USER_SECURITY_QUESTIONS
                    {
                        UserId = userid
                    };
                    await _context.USER_SECURITY_QUESTIONS.AddAsync(sq);
                   await _context.SaveChangesAsync();
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
                    await _context.SaveChangesAsync();
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

                    log4net.LogManager.GetLogger(this.GetType()).Error($"... {exc}");
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
        /// Checks to see if the user can remove themself from an Assessment.  If they are
        /// the only ADMIN and there are any USERs on the Assessment, then 
        /// it is not allowed.
        /// </summary>
        /// <returns></returns>
        [HttpPost]
        [Route("api/contacts/ValidateRemoval")]
        public async Task<IActionResult> ValidateMyRemoval(int assessmentId)
        {
            _token.IsAuthenticated();
            if (await _token.AmILastAdminWithUsers(assessmentId))
            {
                return Ok(false);
            }

            return Ok(true);
        }
    }
}
