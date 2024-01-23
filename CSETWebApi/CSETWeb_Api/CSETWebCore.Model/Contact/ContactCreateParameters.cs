//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Contact
{
    public class ContactCreateParameters
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public int AssessmentRoleId { get; set; }
        public int AssessmentId { get; set; }
        public string Title { get; set; }
        public string Phone { get; set; }
        public string CellPhone { get; set; }
        public string ReportsTo { get; set; }
        public string OrganizationName { get; set; }
        public string SiteName { get; set; }
        public string EmergencyCommunicationsProtocol { get; set; }
        public bool IsSiteParticipant { get; set; }
        public bool IsPrimaryPoc { get; set; }

        /// <summary>
        /// The subject of the invitation email.
        /// </summary>
        public string Subject { get; set; }

        /// <summary>
        /// The message body of the invitation email.
        /// </summary>
        public string Body { get; set; }
    }
}
