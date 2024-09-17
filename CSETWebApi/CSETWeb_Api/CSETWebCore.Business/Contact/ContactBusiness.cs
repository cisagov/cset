//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using CSETWebCore.Interfaces.Contact;
using CSETWebCore.Interfaces.Helpers;
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using CSETWebCore.DataLayer.Model;
using CSETWebCore.Interfaces.Notification;
using CSETWebCore.Interfaces.User;
using CSETWebCore.Helpers;

namespace CSETWebCore.Business.Contact
{
    public class ContactBusiness : IContactBusiness
    {
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ITokenManager _tokenManager;
        private readonly INotificationBusiness _notificationBusiness;
        private readonly IUserBusiness _userBusiness;
        private readonly ILocalInstallationHelper _localInstallationHelper;
        private CSETContext _context;

        public ContactBusiness(CSETContext context, IAssessmentUtil assessmentUtil,
            ITokenManager tokenManager, INotificationBusiness notificationBusiness, IUserBusiness userBusiness,
            ILocalInstallationHelper localInstallationHelper)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _tokenManager = tokenManager;
            _notificationBusiness = notificationBusiness;
            _userBusiness = userBusiness;
            _localInstallationHelper = localInstallationHelper;
        }

        public enum ContactRole { RoleUser = 1, RoleAdmin = 2 }
        /// <summary>
        /// Returns a list of ContactDetail instances for the assessment
        /// </summary>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public List<ContactDetail> GetContacts(int assessmentId)
        {
            // Update the user's preferred name on their contact record
            RefreshContactNameFromUserDetails();

            List<ContactDetail> list = new List<ContactDetail>();


            var query = (from cc in _context.ASSESSMENT_CONTACTS
                         where cc.Assessment_Id == assessmentId
                         select new { cc });

            foreach (var q in query.ToList())
            {
                ContactDetail c = new ContactDetail
                {
                    FirstName = q.cc.FirstName,
                    LastName = q.cc.LastName,
                    PrimaryEmail = q.cc.PrimaryEmail,
                    AssessmentId = q.cc.Assessment_Id,
                    AssessmentRoleId = q.cc.AssessmentRoleId,
                    Invited = q.cc.Invited,
                    UserId = q.cc.UserId ?? null,
                    AssessmentContactId = q.cc.Assessment_Contact_Id,
                    Title = q.cc.Title,
                    Phone = q.cc.Phone,
                    CellPhone = q.cc.Cell_Phone,
                    ReportsTo = q.cc.Reports_To,
                    OrganizationName = q.cc.Organization_Name,
                    SiteName = q.cc.Site_Name,
                    EmergencyCommunicationsProtocol = q.cc.Emergency_Communications_Protocol,
                    IsSiteParticipant = q.cc.Is_Site_Participant,
                    IsPrimaryPoc = q.cc.Is_Primary_POC,
                };

                list.Add(c);
            }

            return list;

        }

        /// <summary>
        /// Returns a list of ContactDetail instances for the assessments specified
        /// </summary>
        /// <returns></returns>
        public List<ContactDetail> GetContactsByAssessmentId(int id1, int id2, int id3 = 0, int id4 = 0, int id5 = 0, int id6 = 0, int id7 = 0, int id8 = 0, int id9 = 0, int id10 = 0)
        {
            List<ContactDetail> list = new List<ContactDetail>();

            var query = (from cc in _context.ASSESSMENT_CONTACTS
                         where cc.Assessment_Id == id1 || cc.Assessment_Id == id2 || cc.Assessment_Id == id3 ||
                               cc.Assessment_Id == id4 || cc.Assessment_Id == id5 || cc.Assessment_Id == id6 ||
                               cc.Assessment_Id == id5 || cc.Assessment_Id == id6 || cc.Assessment_Id == id7 ||
                               cc.Assessment_Id == id8 || cc.Assessment_Id == id9 || cc.Assessment_Id == id10
                         select new { cc });

            foreach (var q in query.ToList())
            {
                ContactDetail c = new ContactDetail
                {
                    FirstName = q.cc.FirstName,
                    LastName = q.cc.LastName,
                    PrimaryEmail = q.cc.PrimaryEmail,
                    AssessmentId = q.cc.Assessment_Id,
                    AssessmentRoleId = q.cc.AssessmentRoleId,
                    Invited = q.cc.Invited,
                    UserId = q.cc.UserId ?? null,
                    AssessmentContactId = q.cc.Assessment_Contact_Id,
                    Title = q.cc.Title,
                    Phone = q.cc.Phone,
                    CellPhone = q.cc.Cell_Phone,
                    ReportsTo = q.cc.Reports_To,
                    OrganizationName = q.cc.Organization_Name,
                    SiteName = q.cc.Site_Name,
                    EmergencyCommunicationsProtocol = q.cc.Emergency_Communications_Protocol,
                    IsSiteParticipant = q.cc.Is_Site_Participant,
                    IsPrimaryPoc = q.cc.Is_Primary_POC,
                };

                list.Add(c);
            }

            return list;

        }

        /// <summary>
        /// Returns a list of contacts that meet the specified search criteria.
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="searchParms"></param>
        /// <returns></returns>
        public IEnumerable<ContactSearchResult> SearchContacts(int userId, ContactSearchParameters searchParms)
        {
            List<ContactSearchResult> results = new List<ContactSearchResult>();

            // A malformed JSON string can result in a null searchParms argument
            if (searchParms == null)
            {
                return results;
            }

            // Get out quick if called with no parms.  Is there any need to call this with no parms?
            if (string.IsNullOrEmpty(searchParms.FirstName)
                && string.IsNullOrEmpty(searchParms.LastName)
                && string.IsNullOrEmpty(searchParms.PrimaryEmail))
            {
                return results;
            }

            // Change any null values to empty strings to make the query more forgiving
            if (searchParms.FirstName == null) searchParms.FirstName = string.Empty;
            if (searchParms.LastName == null) searchParms.LastName = string.Empty;
            if (searchParms.PrimaryEmail == null) searchParms.PrimaryEmail = string.Empty;

            var email = _context.USERS.Where(x => x.UserId == userId).FirstOrDefault();
            if (email == null)
                return results;

            // create a list of user emails already attached to the assessment
            var attachedEmails = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == searchParms.AssessmentId).ToList().Select(x => x.PrimaryEmail);

            var query = from ac in _context.ASSESSMENT_CONTACTS
                        join a in _context.ASSESSMENTS on ac.Assessment_Id equals a.Assessment_Id
                        join myac in _context.ASSESSMENT_CONTACTS on a.Assessment_Id equals myac.Assessment_Id
                        where ac.FirstName.Contains(searchParms.FirstName)
                           && ac.LastName.Contains(searchParms.LastName)
                           && ac.PrimaryEmail.Contains(searchParms.PrimaryEmail)

                           && myac.PrimaryEmail == email.PrimaryEmail

                           // don't include anyone already attached to the current assessment
                           && !attachedEmails.Contains(ac.PrimaryEmail)

                        select new { ac.UserId, ac.FirstName, ac.LastName, ac.PrimaryEmail };

            // Generate a distinct, case-insensitive result list
            var candidates = query.ToList();
            var filteredCandidates = query.ToList();
            filteredCandidates.Clear();
            foreach (var candidate in candidates)
            {
                if (!filteredCandidates.Exists(x => String.Equals(x.FirstName, candidate.FirstName, StringComparison.InvariantCultureIgnoreCase)
                    && String.Equals(x.LastName, candidate.LastName, StringComparison.InvariantCultureIgnoreCase)
                    && String.Equals(x.PrimaryEmail, candidate.PrimaryEmail, StringComparison.InvariantCultureIgnoreCase)))
                {
                    filteredCandidates.Add(candidate);

                    ContactSearchResult r = new ContactSearchResult
                    {
                        UserId = (int)candidate.UserId,
                        FirstName = candidate.FirstName,
                        LastName = candidate.LastName,
                        PrimaryEmail = candidate.PrimaryEmail
                    };

                    results.Add(r);
                }
            }

            return results;

        }


        /// <summary>
        /// Connects an existing USER to an existing ASSESSMENT for the specified role.
        /// </summary>
        public ContactDetail AddContactToAssessment(int assessmentId, int userId, int roleid, bool invited)
        {
            USERS user = _context.USERS.Where(x => x.UserId == userId).First();

            var dbAC = _context.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId && ac.UserId == user.UserId).FirstOrDefault();

            if (dbAC == null)
            {
                dbAC = new ASSESSMENT_CONTACTS
                {
                    Assessment_Id = assessmentId,
                    UserId = user.UserId,
                    FirstName = user.FirstName,
                    LastName = user.LastName,
                    PrimaryEmail = user.PrimaryEmail,

                };
            }

            dbAC.AssessmentRoleId = roleid;
            dbAC.Invited = invited;

            _context.ASSESSMENT_CONTACTS.Update(dbAC);
            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);

            // Return the full list of Contacts for the Assessment
            return new ContactDetail
            {
                FirstName = dbAC.FirstName,
                LastName = dbAC.LastName,
                PrimaryEmail = dbAC.PrimaryEmail,
                AssessmentId = dbAC.Assessment_Id,
                AssessmentRoleId = dbAC.AssessmentRoleId,
                Invited = dbAC.Invited,
                UserId = dbAC.UserId ?? null
            };
        }


        /// <summary>
        /// Creates or updates the rows necessary to attach a Contact to an Assessment.  
        /// Creates a new User based on email.
        /// Creates or overwrites the ASSESSMENT_CONTACTS connection.
        /// Creates a new Contact if needed.  If a Contact already exists for the email, no 
        /// changes are made to the Contact row.
        /// </summary>
        public ContactDetail CreateAndAddContactToAssessment(ContactCreateParameters newContact, bool isMerge)
        {
            int assessmentId = _tokenManager.AssessmentForUser();
            string appName = _tokenManager.Payload(Constants.Constants.Token_Scope);

            ASSESSMENT_CONTACTS existingContact = null;

            if (!isMerge)
            {
                // See if the Contact already exists
                existingContact = _context.ASSESSMENT_CONTACTS.FirstOrDefault(x => x.UserId == newContact.UserId && x.Assessment_Id == assessmentId);
            } else
            {
                // If this is a merge, we need to check for existing contacts via different values
                existingContact = _context.ASSESSMENT_CONTACTS.FirstOrDefault(x => x.Assessment_Id == newContact.AssessmentId && x.PrimaryEmail == newContact.PrimaryEmail && x.FirstName == newContact.FirstName);
            }

            if (existingContact == null)
            {
                // Create Contact
                var c = new ASSESSMENT_CONTACTS()
                {
                    FirstName = newContact.FirstName,
                    LastName = newContact.LastName,
                    PrimaryEmail = newContact.PrimaryEmail,
                    Assessment_Id = assessmentId,
                    AssessmentRoleId = newContact.AssessmentRoleId,
                    Title = newContact.Title,
                    Phone = newContact.Phone,
                    Cell_Phone = newContact.CellPhone,
                    Reports_To = newContact.ReportsTo,
                    Organization_Name = newContact.OrganizationName,
                    Site_Name = newContact.SiteName,
                    Emergency_Communications_Protocol = newContact.EmergencyCommunicationsProtocol,
                    Is_Site_Participant = newContact.IsSiteParticipant,
                    Is_Primary_POC = newContact.IsPrimaryPoc,
                };

                // Include the userid if such a user exists
                USERS user = _context.USERS.Where(u => !string.IsNullOrEmpty(u.PrimaryEmail)
                    && u.PrimaryEmail == newContact.PrimaryEmail)
                    .FirstOrDefault();
                if (user != null)
                {
                    c.UserId = user.UserId;
                }

                _context.ASSESSMENT_CONTACTS.Update(c);


                // If there was no USER record for this new Contact, create one
                if (user == null)
                {
                    UserDetail userDetail = new UserDetail
                    {
                        Email = newContact.PrimaryEmail,
                        FirstName = newContact.FirstName,
                        LastName = newContact.LastName,
                        IsSuperUser = false,
                        PasswordResetRequired = true
                    };

                    UserCreateResponse resp = _userBusiness.CheckUserExists(userDetail);
                    if (!resp.IsExisting)
                    {
                        resp = _userBusiness.CreateUser(userDetail, _context);

                        // Send this brand-new user an email with their temporary password (if they have an email)
                        if (!string.IsNullOrEmpty(userDetail.Email))
                        {
                            if (!_localInstallationHelper.IsLocalInstallation())
                            {
                                _notificationBusiness.SendInviteePassword(userDetail.Email, userDetail.FirstName, userDetail.LastName, resp.TemporaryPassword, appName);
                            }
                        }
                    }
                    c.UserId = resp.UserId;
                }

                _context.SaveChanges();

                _assessmentUtil.TouchAssessment(assessmentId);

                existingContact = c;
            }

            // Flip the 'invite' flag to true, if they are a contact on the current Assessment
            MarkContactInvited(newContact.UserId, assessmentId);

            // Tell the user that they have been invited to participate in an Assessment (if they have an email) 
            if (!string.IsNullOrEmpty(newContact.PrimaryEmail))
            {
                if (!_localInstallationHelper.IsLocalInstallation())
                {
                    _notificationBusiness.InviteToAssessment(newContact);
                }
            }

            // Return the full list of Contacts for the Assessment
            return new ContactDetail
            {
                FirstName = existingContact.FirstName,
                LastName = existingContact.LastName,
                PrimaryEmail = existingContact.PrimaryEmail,
                AssessmentId = existingContact.Assessment_Id,
                AssessmentRoleId = existingContact.AssessmentRoleId,
                AssessmentContactId = existingContact.Assessment_Contact_Id,
                Invited = existingContact.Invited,
                UserId = existingContact.UserId ?? null,
                Title = existingContact.Title,
                Phone = existingContact.Phone,
                CellPhone = newContact.CellPhone,
                ReportsTo = newContact.ReportsTo,
                OrganizationName = newContact.OrganizationName,
                SiteName = newContact.SiteName,
                EmergencyCommunicationsProtocol = newContact.EmergencyCommunicationsProtocol,
                IsSiteParticipant = newContact.IsSiteParticipant,
                IsPrimaryPoc = newContact.IsPrimaryPoc
            };
        }


        /// <summary>
        /// Updates ASSESSMENT_CONTACT record with given userId using provided ContactDetail object
        /// </summary>
        /// <returns></returns>
        public void UpdateContact(ContactDetail contact, int userId)
        {
            var ac = _context.ASSESSMENT_CONTACTS.Where(x => x.UserId == userId
                && x.Assessment_Id == contact.AssessmentId).FirstOrDefault();

            ac.UserId = contact.UserId;
            ac.FirstName = contact.FirstName;
            ac.LastName = contact.LastName;
            ac.PrimaryEmail = contact.PrimaryEmail;
            ac.AssessmentRoleId = contact.AssessmentRoleId;
            ac.Title = contact.Title;
            ac.Phone = contact.Phone;
            ac.Title = contact.Title;
            ac.Phone = contact.Phone;
            ac.Cell_Phone = contact.CellPhone;
            ac.Reports_To = contact.ReportsTo;
            ac.Organization_Name = contact.OrganizationName;
            ac.Site_Name = contact.SiteName;
            ac.Emergency_Communications_Protocol = contact.EmergencyCommunicationsProtocol;
            ac.Is_Site_Participant = contact.IsSiteParticipant;
            ac.Is_Primary_POC = contact.IsPrimaryPoc;

            _context.SaveChanges();
        }


        /// <summary>
        /// Returns the Assessment Role ID for the user and assessment specified.  
        /// 1 = USER, 2 = ADMINISTRATOR.
        /// If the user does not have a role on the assessment, a null value is returned.
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int? GetUserRoleOnAssessment(int? userId, int assessmentId)
        {
            var contact = _context.ASSESSMENT_CONTACTS.Where(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId).FirstOrDefault();
            if (contact != null)
            {
                return contact.AssessmentRoleId;
            }
            return null;
        }


        /// <summary>
        /// Removes a Contact/User from an Assessment.
        /// Currently we actually delete the ASSESSMENT_CONTACTS record.  
        /// </summary>
        public List<ContactDetail> RemoveContact(int assessmentContactId)
        {
            var ac = (from cc in _context.ASSESSMENT_CONTACTS
                      where cc.Assessment_Contact_Id == assessmentContactId
                      select cc).FirstOrDefault();
            if (ac == null)
                throw new Exception("User does not exist");
            _context.ASSESSMENT_CONTACTS.Remove(ac);


            // Remove any related FINDING_CONTACT records
            var fcList = (from fcc in _context.FINDING_CONTACT
                          where fcc.Assessment_Contact_Id == ac.Assessment_Contact_Id
                          select fcc).ToList();
            if (fcList.Count > 0)
            {
                _context.FINDING_CONTACT.RemoveRange(fcList);
            }


            // Null out any related Facilitator or Point of Contact references
            var demoList1 = (from x in _context.DEMOGRAPHICS
                             where x.Facilitator == ac.Assessment_Contact_Id
                             select x).ToList();

            foreach (var dd in demoList1)
            {
                dd.Facilitator = null;
            }


            var demoList2 = (from x in _context.DEMOGRAPHICS
                             where x.PointOfContact == ac.Assessment_Contact_Id
                             select x).ToList();

            foreach (var dd in demoList2)
            {
                dd.PointOfContact = null;
            }



            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(ac.Assessment_Id);

            return GetContacts(ac.Assessment_Id);

        }


        /// <summary>
        /// Sets the contact's 'invited' flag to 'true', if the contact exists on the Assessment.
        /// </summary>
        /// <param name="email"></param>
        /// <param name="assessmentId"></param>
        public void MarkContactInvited(int userId, int assessmentId)
        {
            var assessmentContact = _context.ASSESSMENT_CONTACTS.Where(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId)
                .FirstOrDefault();
            if (assessmentContact != null)
            {
                assessmentContact.Invited = true;
                _context.ASSESSMENT_CONTACTS.Update(assessmentContact);
                _context.SaveChangesAsync();
            }
        }


        /// <summary>
        /// Updates the contact's first and last name from their user record.
        /// The purpose of this is to make sure that a user sees their preferred name
        /// on any assessments that they are working with, and not what somebody typed
        /// when they were added to an assessment.
        /// </summary>
        public void RefreshContactNameFromUserDetails()
        {
            int? userId = _tokenManager.PayloadInt(Constants.Constants.Token_UserId);
            int? assessmentId = _tokenManager.PayloadInt(Constants.Constants.Token_AssessmentId);
            if (assessmentId == null || userId == null)
            {
                // There's no assessment or userid on the token.  Nothing to do.
                return;
            }

            // we can expect to find this record for the current user and assessment.
            var ac = _context.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == (int)assessmentId && x.UserId == userId).FirstOrDefault();

            // The ASSESSMENT_CONTACT we want to work with is not there for some reason -- nothing to do
            if (ac == null)
            {
                return;
            }

            // get the user record for the definitive name
            var u = _context.USERS.Where(x => x.UserId == ac.UserId).FirstOrDefault();

            ac.FirstName = u.FirstName;
            ac.LastName = u.LastName;

            _context.ASSESSMENT_CONTACTS.Update(ac);
            _context.SaveChanges();
        }


        /// <summary>
        /// Returns a collection of all contact roles.
        /// </summary>
        public object GetAllRoles()
        {
            var roles = from ar in _context.ASSESSMENT_ROLES
                        select new { ar.AssessmentRoleId, ar.AssessmentRole };
            return roles.ToList();
        }
    }
}
