//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;
using CSETWebCore.Model.Contact;

namespace CSETWebCore.Interfaces.Contact
{
    public interface IContactBusiness
    {
        List<ContactDetail> GetContacts(int assessmentId);
        IEnumerable<ContactSearchResult> SearchContacts(int userId, ContactSearchParameters searchParms);
        ContactDetail AddContactToAssessment(int assessmentId, int userId, int roleid, bool invited);
        ContactDetail CreateAndAddContactToAssessment(ContactCreateParameters newContact);
        void UpdateContact(ContactDetail contact, int userId);
        int? GetUserRoleOnAssessment(int? userId, int assessmentId);
        List<ContactDetail> RemoveContact(int assessmentContactId);
        void MarkContactInvited(int userId, int assessmentId);
        void RefreshContactNameFromUserDetails();
        object GetAllRoles();
    }
}