//////////////////////////////// 
// 
//   Copyright 2023 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.User
{
    public class UserDetail
    {
        public int UserId { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string FullName
        {
            get
            {
                return $"{FirstName} {LastName}".Trim();
            }
        }
        public bool IsSuperUser { get; set; }
        public bool PasswordResetRequired { get; set; }
        public bool IsActive { get; set; }
        public bool PreventEncrypt { get; set; }
        public bool CisaAssessorWorkflow { get; set; }
    }
}
