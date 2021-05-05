namespace CSETWebCore.Model.Authentication
{
    public class LoginResponse
    {
        public string Token;
        public int UserId;
        public string Email;
        public string UserFirstName;
        public string UserLastName;
        public bool ResetRequired;
        public bool IsSuperUser;
        public string ExportExtension;
        public string ImportExtensions;
    }
}