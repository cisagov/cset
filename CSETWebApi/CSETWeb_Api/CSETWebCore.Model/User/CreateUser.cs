//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.User
{
    public class CreateUser
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public string FullName
        {
            get
            {
                return $"{FirstName} {LastName}".Trim();
            }
        }
        public string PrimaryEmail { get; set; }
        public string saveEmail { get; set; }
        public string Title { get; set; }
        public string Phone { get; set; }
        public string CellPhone { get; set; }
        public string ReportsTo { get; set; }
        public string EmergencyCommunicationsProtocol { get; set; }
        public bool IsSiteParticipant { get; set; }
        public bool IsPrimaryPoc { get; set; }
        public string OrganizationName { get; set; }
        public string SiteName { get; set; }

        public string ConfirmEmail { get; set; }
        public int AssessmentContactId { get; set; }
        public int AssessmentRoleId { get; set; }
        public string SecurityQuestion1 { get; set; }
        public string SecurityQuestion2 { get; set; }
        public string SecurityAnswer1 { get; set; }
        public string SecurityAnswer2 { get; set; }

        /// <summary>
        /// This must be explicitly sent by the front end because
        /// the user is not logged in, so there's no JWT at this point.
        /// </summary>
        public string AppName { get; set; }
    }
}