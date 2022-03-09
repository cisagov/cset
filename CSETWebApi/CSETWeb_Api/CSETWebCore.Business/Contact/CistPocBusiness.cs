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
    public class CistPocBusiness : ICistPocBusiness
    {
        private readonly IAssessmentUtil _assessmentUtil;
        private readonly ITokenManager _tokenManager;
        private readonly INotificationBusiness _notificationBusiness;
        private readonly IUserBusiness _userBusiness;
        private readonly IUserAuthentication _userAuthentication;
        private CSETContext _context;

        public CistPocBusiness(CSETContext context, IAssessmentUtil assessmentUtil,
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
        public void CreateAndAddContactToAssessment(CistPocDetail newPoc)
        {
            int assessmentId = _tokenManager.AssessmentForUser();

            CIST_POC existingPoc = null;

            existingPoc = _context.CIST_POS.FirstOrDefault(
                poc => poc.Assessment_Id == newPoc.AssessmentId && 
                poc.First_Name.ToLower() == newPoc.FirstName.ToLower() &&
                poc.Last_Name.ToLower() == newPoc.LastName.ToLower() &&
                poc.Email.ToLower() == newPoc.Email.ToLower());

            if (existingPoc == null) 
            {
                var poc = new CIST_POC()
                {
                    Assessment_Id = assessmentId,
                    Is_Primary_POC = newPoc.IsPrimaryPoc,
                    First_Name = newPoc.FirstName,
                    Last_Name = newPoc.LastName,
                    Title = newPoc.Title,
                    Site_Name = newPoc.SiteName,
                    Organization_Name = newPoc.OrganizationName,
                    Email = newPoc.Email,
                    Office_Phone = newPoc.OfficePhone,
                    Cell_Phone = newPoc.CellPhone,
                    Reports_To = newPoc.ReportsTo,
                    Emergency_Communications_Protocol = newPoc.EmergencyCommunicationsProtocol,
                    Is_Site_Participant = newPoc.IsSiteParticicpant
                };

                _context.CIST_POS.Add(poc);
                _context.SaveChanges();
                _assessmentUtil.TouchAssessment(assessmentId);
            }
        }

        public List<CistPocDetail> GetContacts(int assessmentId)
        {
            throw new NotImplementedException();
        }

        public void RefreshContactNameFromUserDetails()
        {
            throw new NotImplementedException();
        }

        public List<CistPocDetail> RemoveContact(int ContactId)
        {
            throw new NotImplementedException();
        }

        public void UpdateContact(CistPocDetail contact)
        {
            throw new NotImplementedException();
        }
    }
}
