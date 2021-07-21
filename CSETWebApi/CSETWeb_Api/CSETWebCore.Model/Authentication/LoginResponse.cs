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
        public bool IsSuperUser { get; set; }
        public string ExportExtension { get; set; }
        public string ImportExtensions { get; set; }
    }
}