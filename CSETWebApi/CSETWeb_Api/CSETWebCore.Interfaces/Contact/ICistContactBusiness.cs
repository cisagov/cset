using CSETWebCore.Model.Contact;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Contact
{
    public interface ICistContactBusiness
    {
        List<ContactDetail> GetContacts(int assessmentId);
        ContactDetail CreateAndAddContactToAssessment(ContactDetail newContact);
        void UpdateContact(ContactDetail contact);
        void RemoveContact(int assessmentContactId);
    }
}
