using CSETWebCore.Model.Contact;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Contact
{
    public interface ICistContactBusiness
    {
        List<ContactDetail> GetContacts(int assessmentId);
        void CreateAndAddContactToAssessment(ContactDetail newContact);
        void UpdateContact(ContactDetail contact);
        List<ContactDetail> RemoveContact(int ContactId);
    }
}
