using CSETWebCore.Model.Contact;
using System.Collections.Generic;

namespace CSETWebCore.Interfaces.Contact
{
    public interface ICistPocBusiness
    {
        List<CistPocDetail> GetContacts(int assessmentId);
        void CreateAndAddContactToAssessment(CistPocDetail newPoc);
        void UpdateContact(CistPocDetail contact);
        List<CistPocDetail> RemoveContact(int ContactId);
        void RefreshContactNameFromUserDetails();
    }
}
