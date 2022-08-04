using System.Collections.Generic;
using System.Threading.Tasks;
using CSETWebCore.Model.Contact;

namespace CSETWebCore.Interfaces.Contact
{
    public interface IContactBusiness
    {
        List<ContactDetail> GetContacts(int assessmentId);
        IEnumerable<ContactSearchResult> SearchContacts(int userId, ContactSearchParameters searchParms);
        ContactDetail AddContactToAssessment(int assessmentId, int userId, int roleid, bool invited);
        Task<ContactDetail> CreateAndAddContactToAssessment(ContactCreateParameters newContact);
        Task UpdateContact(ContactDetail contact, int userId);
        int? GetUserRoleOnAssessment(int userId, int assessmentId);
        List<ContactDetail> RemoveContact(int assessmentContactId);
        void MarkContactInvited(int userId, int assessmentId);
        void RefreshContactNameFromUserDetails();
        object GetAllRoles();
    }
}