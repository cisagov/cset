//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Authentication
{
    public class LoginResponse
    {
        public string Token { get; set; }
        public int UserId { get; set; }
        public string Email { get; set; }
        public string UserFirstName { get; set; }
        public string UserLastName { get; set; }
        public bool ResetRequired { get; set; }
        public bool IsPasswordExpired { get; set; }
        public bool IsSuperUser { get; set; }
        public string Lang { get; set; }
        public string ExportExtension { get; set; }
        public string ImportExtensions { get; set; }
        public string LinkerTime { get; set; }
        public bool IsFirstLogin { get; set; }
    }
}