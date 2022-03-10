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
        /// Creates a new point of contact (POC) for a CIST assessment.
        /// Uses full name, email, and assessmentId to determine if poc already exists.
        /// </summary>
        public void CreateAndAddContactToAssessment(ContactDetail newContact)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            ASSESSMENT_CONTACTS existingContact = null;

            existingContact = _context.ASSESSMENT_CONTACTS.FirstOrDefault(
                contact => contact.Assessment_Id == newContact.AssessmentId && 
                contact.FirstName.ToLower() == newContact.FirstName.ToLower() &&
                contact.LastName.ToLower() == newContact.LastName.ToLower() &&
                contact.Email.ToLower() == newContact.Email.ToLower());

            if (existingContact == null) 
            {
                var contact = new ASSESSMENT_CONTACTS()
                {
                    Assessment_Id = assessmentId,
                    Is_Primary_POC = newContact.IsPrimaryPoc,
                    FirstName = newContact.FirstName,
                    LastName = newContact.LastName,
                    Title = newContact.Title,
                    Site_Name = newContact.SiteName,
                    Organization_Name = newContact.OrganizationName,
                    PrimaryEmail = newContact.Email,
                    Office_Phone = newContact.OfficePhone,
                    Cell_Phone = newContact.CellPhone,
                    Reports_To = newContact.ReportsTo,
                    Emergency_Communications_Protocol = newContact.EmergencyCommunicationsProtocol,
                    Is_Site_Participant = newContact.IsSiteParticicpant
                };

                _context.ASSESSMENT_CONTACTS.Add(contact);
                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(assessmentId);
            }
        }

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
                    FirstName = q.cc.FirstName,
                    LastName = q.cc.LastName,
                    PrimaryEmail = q.cc.PrimaryEmail,
                    AssessmentId = q.cc.Assessment_Id,
                    AssessmentRoleId = q.cc.AssessmentRoleId,
                    Invited = q.cc.Invited,
                    UserId = q.cc.UserId ?? null,
                    AssessmentContactId = q.cc.Assessment_Contact_Id,
                    Title = q.cc.Title,
                    Phone = q.cc.Phone
                };

                list.Add(c);
            }

            return list;
        }

        public List<ContactDetail> RemoveContact(int ContactId)
        {
            throw new NotImplementedException();
        }

        public void UpdateContact(ContactDetail contact)
        {
            throw new NotImplementedException();
        }
    }
}
