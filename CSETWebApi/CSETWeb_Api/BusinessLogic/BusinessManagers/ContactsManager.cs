//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Configuration;

using System.Linq;
using System.Web;
using BusinessLogic.Helpers;
using CSETWeb_Api.BusinessLogic;
using CSETWeb_Api.BusinessLogic.Helpers;
using CSETWeb_Api.Helpers;
using CSETWeb_Api.Models;
using DataLayerCore.Model;
using Microsoft.EntityFrameworkCore;

namespace CSETWeb_Api.BusinessManagers
{
    /// <summary>
    /// Encapsulates various "Contact" functionality
    /// </summary>
    public class ContactsManager
    {
        /// <summary>
        /// Enumerates valid contact roles on an assessment.  
        /// </summary>
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

            using (var db = new CSET_Context())
            {
                var query = (from cc in db.ASSESSMENT_CONTACTS
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
                        UserId = q.cc.UserId ?? null
                    };

                    list.Add(c);
                }

                return list;
            }
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


            using (var db = new CSET_Context())
            {
                var email = db.USERS.Where(x => x.UserId == userId).FirstOrDefault();
                if (email == null)
                    return results;

                // create a list of user emails already attached to the assessment
                var attachedEmails = db.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == searchParms.AssessmentId).ToList().Select(x => x.PrimaryEmail);

                var query = from ac in db.ASSESSMENT_CONTACTS
                            join a in db.ASSESSMENTS on ac.Assessment_Id equals a.Assessment_Id
                            join myac in db.ASSESSMENT_CONTACTS on a.Assessment_Id equals myac.Assessment_Id
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
        }


        /// <summary>
        /// Connects an existing USER to an existing ASSESSMENT for the specified role.
        /// TODO:  Enforce no duplicates - a user should only be connected once.
        ///        If a new role is supplied, update the existing ASSESSMENT_CONTACTS role.
        /// </summary>
        public ContactDetail AddContactToAssessment(int assessmentId, int userId, int roleid, bool invited)
        {
            using (var db = new CSET_Context())
            {
                USERS user = db.USERS.Where(x => x.UserId == userId).First();

                var dbAC = db.ASSESSMENT_CONTACTS.Where(ac => ac.Assessment_Id == assessmentId && ac.UserId == user.UserId).FirstOrDefault();

                if (dbAC == null)
                {
                    dbAC = new ASSESSMENT_CONTACTS
                    {
                        Assessment_Id = assessmentId,
                        UserId = user.UserId,
                        FirstName = user.FirstName,
                        LastName = user.LastName,
                        PrimaryEmail = user.PrimaryEmail
                    };
                }

                dbAC.AssessmentRoleId = roleid;
                dbAC.Invited = invited;

                db.ASSESSMENT_CONTACTS.AddOrUpdate( dbAC, x => x.Assessment_Contact_Id);
                db.SaveChanges();

                AssessmentUtil.TouchAssessment(assessmentId);

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
        }


        /// <summary>
        /// Creates or updates the rows necessary to attach a Contact to an Assessment.  
        /// Creates a new User based on email.
        /// Creates or overwrites the ASSESSMENT_CONTACTS connection.
        /// Creates a new Contact if needed.  If a Contact already exists for the email, no 
        /// changes are made to the Contact row.
        /// </summary>
        public ContactDetail CreateAndAddContactToAssessment(ContactCreateParameters newContact)
        {
            int assessmentId = Auth.AssessmentForUser();
            TokenManager tm = new TokenManager();
            string app_code = tm.Payload(Constants.Token_Scope);

            NotificationManager nm = new NotificationManager();

            ASSESSMENT_CONTACTS existingContact = null;
            using (var db = new CSET_Context())
            {
                // See if the Contact already exists
                existingContact = db.ASSESSMENT_CONTACTS.Where(x => x.UserId == newContact.UserId && x.Assessment_Id == assessmentId).FirstOrDefault();
                if (existingContact == null)
                {
                    // Create Contact
                    var c = new ASSESSMENT_CONTACTS()
                    {
                        FirstName = newContact.FirstName,
                        LastName = newContact.LastName,
                        PrimaryEmail = newContact.PrimaryEmail,
                        Assessment_Id = assessmentId,
                        AssessmentRoleId = newContact.AssessmentRoleId
                    };

                    // Include the userid if such a user exists
                    USERS user = db.USERS.Where(u => !string.IsNullOrEmpty(u.PrimaryEmail)
                        && u.PrimaryEmail == newContact.PrimaryEmail)
                        .FirstOrDefault();
                    if (user != null)
                    {
                        c.UserId = user.UserId;
                    }

                    db.ASSESSMENT_CONTACTS.AddOrUpdate( c, x=> x.Assessment_Contact_Id);


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
                        UserManager um = new UserManager();
                        UserCreateResponse resp = um.CheckUserExists(userDetail);
                        if (!resp.IsExisting)
                        {
                            resp = um.CreateUser(userDetail);

                            // Send this brand-new user an email with their temporary password (if they have an email)
                            if (!string.IsNullOrEmpty(userDetail.Email))
                            {
                                if (!UserAuthentication.IsLocalInstallation(app_code))
                                {
                                    nm.SendInviteePassword(userDetail.Email, userDetail.FirstName, userDetail.LastName, resp.TemporaryPassword);
                                }
                            }
                        }
                        c.UserId = resp.UserId;
                    }

                    db.SaveChanges();

                    AssessmentUtil.TouchAssessment(assessmentId);

                    existingContact = c;
                }
            }

            // Flip the 'invite' flag to true, if they are a contact on the current Assessment
            ContactsManager cm = new ContactsManager();
            cm.MarkContactInvited(newContact.UserId, assessmentId);

            // Tell the user that they have been invited to participate in an Assessment (if they have an email) 
            if (!string.IsNullOrEmpty(newContact.PrimaryEmail))
            {
                if (!UserAuthentication.IsLocalInstallation(app_code))
                {
                    nm.InviteToAssessment(newContact);
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
                Invited = existingContact.Invited,
                UserId = existingContact.UserId ?? null
            };
        }


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public void UpdateContact(ContactDetail contact)
        {
            using (CSET_Context context = new CSET_Context())
            {
                var ac = context.ASSESSMENT_CONTACTS.Where(x => x.UserId == contact.UserId
                    && x.Assessment_Id == contact.AssessmentId).FirstOrDefault();

                string prevEmail = ac.PrimaryEmail;

                ac.UserId = contact.UserId;
                ac.FirstName = contact.FirstName;
                ac.LastName = contact.LastName;
                ac.PrimaryEmail = contact.PrimaryEmail;
                ac.AssessmentRoleId = contact.AssessmentRoleId;

                //// If the email was changed, reflect it into the USERS record as well.
                //// Leave the name alone, as the USERS record contains the user's preferred name.
                //// ASSESSMENT_CONTACTS is allowed to have a different spelling.
                //var user = context.USERS.Where(x => x.UserId == userBeingUpdated.UserId).FirstOrDefault();
                //if (user != null)
                //{
                //    user.PrimaryEmail = ac.PrimaryEmail;
                //}

                context.SaveChanges();
                //// If the email was changed and is not empty, send an invitation
                //if (!string.IsNullOrEmpty(contact.PrimaryEmail) && contact.PrimaryEmail != prevEmail)
                //{
                //    NotificationManager nm = new NotificationManager();
                //    nm.SendInviteePassword(contact.PrimaryEmail, contact.FirstName, contact.LastName, resp.TemporaryPassword);
                //}
            }
        }


        /// <summary>
        /// Returns the Assessment Role ID for the user and assessment specified.  
        /// 1 = USER, 2 = ADMINISTRATOR.
        /// If the user does not have a role on the assessment, a null value is returned.
        /// </summary>
        /// <param name="userId"></param>
        /// <param name="assessmentId"></param>
        /// <returns></returns>
        public int? GetUserRoleOnAssessment(int userId, int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var contact = db.ASSESSMENT_CONTACTS.Where(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId).FirstOrDefault();
                if (contact != null)
                {
                    return contact.AssessmentRoleId;
                }
                return null;
            }
        }


        /// <summary>
        /// Removes a Contact/User from an Assessment.
        /// Currently we actually delete the ASSESSMENT_CONTACTS record.  
        /// </summary>
        public List<ContactDetail> RemoveContact(int userId, int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var ac = (from cc in db.ASSESSMENT_CONTACTS
                            where cc.UserId == userId && cc.Assessment_Id == assessmentId
                            select cc).FirstOrDefault();
                if (ac == null)
                    throw new NoSuchUserException();
                db.ASSESSMENT_CONTACTS.Remove(ac);


                // Remove any related FINDING_CONTACT records
                var fcList = (from fcc in db.FINDING_CONTACT
                          where fcc.Assessment_Contact_Id == ac.Assessment_Contact_Id
                          select fcc).ToList();
                if (fcList.Count > 0)
                {
                    db.FINDING_CONTACT.RemoveRange(fcList);
                }


                db.SaveChanges();

                AssessmentUtil.TouchAssessment(assessmentId);

                return GetContacts(assessmentId);
            }
        }


        /// <summary>
        /// Sets the contact's 'invited' flag to 'true', if the contact exists on the Assessment.
        /// </summary>
        /// <param name="email"></param>
        /// <param name="assessmentId"></param>
        public void MarkContactInvited(int userId, int assessmentId)
        {
            using (var db = new CSET_Context())
            {
                var assessmentContact = db.ASSESSMENT_CONTACTS.Where(ac => ac.UserId == userId && ac.Assessment_Id == assessmentId)
                    .FirstOrDefault();
                if (assessmentContact != null)
                {
                    assessmentContact.Invited = true;
                    db.ASSESSMENT_CONTACTS.AddOrUpdate( assessmentContact, x=> x.Assessment_Contact_Id);
                    db.SaveChangesAsync();
                }
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
            TokenManager tm = new TokenManager();
            int? userId = tm.PayloadInt(Constants.Token_UserId);
            int? assessmentId = tm.PayloadInt(Constants.Token_AssessmentId);
            if (assessmentId == null || userId == null)
            {
                // There's no assessment or userid on the token.  Nothing to do.
                return;
            }

            using (var db = new CSET_Context())
            {
                // we can expect to find this record for the current user and assessment.
                var ac = db.ASSESSMENT_CONTACTS.Where(x => x.Assessment_Id == (int)assessmentId && x.UserId == userId).FirstOrDefault();

                // The ASSESSMENT_CONTACT we want to work with is not there for some reason -- nothing to do
                if (ac == null)
                {
                    return;
                }

                // get the user record for the definitive name
                var u = db.USERS.Where(x => x.UserId == ac.UserId).FirstOrDefault();

                ac.FirstName = u.FirstName;
                ac.LastName = u.LastName;

                db.ASSESSMENT_CONTACTS.AddOrUpdate( ac, x=> x.Assessment_Contact_Id);
                db.SaveChanges();
            }
        }


        /// <summary>
        /// Returns a collection of all contact roles.
        /// </summary>
        public object GetAllRoles()
        {
            using (var db = new CSET_Context())
            {
                var roles = from ar in db.ASSESSMENT_ROLES
                            select new { ar.AssessmentRoleId, ar.AssessmentRole };
                return roles.ToList();
            }
        }
    }
}

