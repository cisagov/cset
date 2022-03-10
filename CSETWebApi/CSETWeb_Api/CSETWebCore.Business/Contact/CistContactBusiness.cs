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

namespace CSETWebCore.Business.Contact
{
    public class CistContactBusiness : ICistContactBusiness
    {
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ITokenManager _tokenManager;
        private readonly INotificationBusiness _notificationBusiness;
        private readonly IUserBusiness _userBusiness;
        private readonly IUserAuthentication _userAuthentication;
        private CSETContext _context;

        public CistContactBusiness(CSETContext context, IAssessmentUtil assessmentUtil,
            ITokenManager tokenManager, INotificationBusiness notificationBusiness, IUserBusiness userBusiness,
            IUserAuthentication userAuthentication)
        {
            _context = context;
            _assessmentUtil = assessmentUtil;
            _tokenManager = tokenManager;
            _notificationBusiness = notificationBusiness;
            _userBusiness = userBusiness;
            _userAuthentication = userAuthentication;
        }

        /// <summary>
        /// Creates a new assessment contact for a CIST assessment.
        /// Uses full name, email, and assessmentId to determine if contact already exists.
        /// </summary>
        public ContactDetail CreateAndAddContactToAssessment(ContactDetail newContact)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            ASSESSMENT_CONTACTS existingContact = null;

            existingContact = _context.ASSESSMENT_CONTACTS.FirstOrDefault(
                contact => contact.Assessment_Id == newContact.AssessmentId && 
                contact.FirstName.ToLower() == newContact.FirstName.ToLower() &&
                contact.LastName.ToLower() == newContact.LastName.ToLower() &&
                contact.PrimaryEmail.ToLower() == newContact.PrimaryEmail.ToLower());

            if (existingContact == null) 
            {
                var contact = new ASSESSMENT_CONTACTS()
                {
                    Assessment_Id = assessmentId,
                    PrimaryEmail = newContact.PrimaryEmail,
                    FirstName = newContact.FirstName,
                    LastName = newContact.LastName,
                    Invited = newContact.Invited,
                    AssessmentRoleId = newContact.AssessmentRoleId,
                    Title = newContact.Title,
                    Phone = newContact.Phone,
                    Is_Primary_POC = newContact.IsPrimaryPoc,
                    Site_Name = newContact.SiteName,
                    Organization_Name = newContact.OrganizationName,
                    Cell_Phone = newContact.CellPhone,
                    Reports_To = newContact.ReportsTo,
                    Emergency_Communications_Protocol = newContact.EmergencyCommunicationsProtocol,
                    Is_Site_Participant = newContact.IsSiteParticipant
                };

                _context.ASSESSMENT_CONTACTS.Add(contact);
                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(assessmentId);

                existingContact = contact;
            }

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
                IsPrimaryPoc = newContact.IsPrimaryPoc,
                SiteName = newContact.SiteName,
                OrganizationName = newContact.OrganizationName,
                CellPhone = newContact.CellPhone,
                ReportsTo = newContact.ReportsTo,
                EmergencyCommunicationsProtocol = newContact.EmergencyCommunicationsProtocol,
                IsSiteParticipant = newContact.IsSiteParticipant
            };
        }

        /// <summary>
        /// Gets all the contacts for a given CIST assesmentId
        /// </summary>
        public List<ContactDetail> GetContacts(int assessmentId)
        {
            List<ContactDetail> list = new List<ContactDetail>();


            var query = (from cc in _context.ASSESSMENT_CONTACTS
                         where cc.Assessment_Id == assessmentId
                         select new { cc });

            foreach (var q in query.ToList())
            {
                ContactDetail c = new ContactDetail
                {
                    AssessmentId = q.cc.Assessment_Id,
                    PrimaryEmail = q.cc.PrimaryEmail,
                    FirstName = q.cc.FirstName,
                    LastName = q.cc.LastName,
                    Invited = q.cc.Invited,
                    AssessmentRoleId = q.cc.AssessmentRoleId,
                    UserId = q.cc.UserId ?? null,
                    Title = q.cc.Title,
                    Phone = q.cc.Phone,
                    IsPrimaryPoc = q.cc.Is_Primary_POC,
                    OrganizationName = q.cc.Organization_Name,
                    CellPhone = q.cc.Cell_Phone,
                    ReportsTo = q.cc.Reports_To,
                    EmergencyCommunicationsProtocol = q.cc.Emergency_Communications_Protocol,
                    IsSiteParticipant = q.cc.Is_Site_Participant,

                };

                list.Add(c);
            }

            return list;
        }

        /// <summary>
        /// Remove a contact from a CIST assessment using the assessmentContactId
        /// </summary>
        public void RemoveContact(int assessmentContactId)
        {
            var ac = (from cc in _context.ASSESSMENT_CONTACTS
                      where cc.Assessment_Contact_Id == assessmentContactId
                      select cc).FirstOrDefault();
            if (ac == null)
                throw new Exception("Contact does not exist");
            _context.ASSESSMENT_CONTACTS.Remove(ac);

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(ac.Assessment_Id);
        }

        /// <summary>
        /// Finds a contact by assessmentContactId and assessmentId. Updates if found.
        /// </summary>
        public void UpdateContact(ContactDetail contact)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            var ac = _context.ASSESSMENT_CONTACTS.FirstOrDefault(
                x => x.Assessment_Id == assessmentId && x.Assessment_Contact_Id == contact.AssessmentContactId);

            ac.FirstName = contact.FirstName;
            ac.LastName = contact.LastName;
            ac.PrimaryEmail = contact.PrimaryEmail;
            ac.Title = contact.Title;
            ac.Phone = contact.Phone;
            ac.Is_Primary_POC = contact.IsPrimaryPoc;
            ac.Site_Name = contact.SiteName;
            ac.Organization_Name = contact.OrganizationName;
            ac.Cell_Phone = contact.CellPhone;
            ac.Reports_To = contact.ReportsTo;
            ac.Emergency_Communications_Protocol = contact.EmergencyCommunicationsProtocol;
            ac.Is_Site_Participant = contact.IsSiteParticipant;

            _context.SaveChanges();

            _assessmentUtil.TouchAssessment(assessmentId);
        }
    }
}
