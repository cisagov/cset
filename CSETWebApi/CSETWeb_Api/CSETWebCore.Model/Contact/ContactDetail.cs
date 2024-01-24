//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Contact
{
    public class ContactDetail
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public int? UserId { get; set; }
        public string Title { get; set; }
        public string Phone { get; set; }
        public string CellPhone { get; set; }
        public string ReportsTo { get; set; }
        public string EmergencyCommunicationsProtocol { get; set; }
        public bool IsSiteParticipant { get; set; }
        public bool IsPrimaryPoc { get; set; }
        public string OrganizationName { get; set; }
        public string SiteName { get; set; }
        public int AssessmentId { get; set; }
        public int AssessmentRoleId { get; set; }
        public bool Invited { get; set; }
        public int AssessmentContactId { get; set; }
    }
}
