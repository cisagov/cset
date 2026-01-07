//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.Model.Contact;
using CSETWebCore.Model.User;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Contact
{
    public interface IContactBusiness
    {
        List<ContactDetail> GetContacts(int assessmentId);
        List<ContactDetail> GetContactsByAssessmentId(int id1, int id2, int id3, int id4, int id5, int id6, int id7, int id8, int id9, int id10);
        IEnumerable<ContactSearchResult> SearchContacts(int userId, ContactSearchParameters searchParms);
        ContactDetail AddContactToAssessment(int assessmentId, int userId, int roleid, bool invited);
        ContactDetail CreateAndAddContactToAssessment(ContactCreateParameters newContact, bool isMerge);
        public void UpdateUserContact(int assessmentId, int currentUserId, CreateUser userBeingUpdated);
        void UpdateAssessmentContact(ContactDetail contact, int userId);
        int? GetUserRoleOnAssessment(int? userId, int assessmentId);
        List<ContactDetail> RemoveContact(int assessmentContactId);
        void MarkContactInvited(int userId, int assessmentId);
        void RefreshContactNameFromUserDetails();
        object GetAllRoles();
    }
}