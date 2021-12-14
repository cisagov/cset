namespace CSETWebCore.Model.User
{
    public class UserDetail
    {
        public int UserId { get; set; }
        public string Email { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public bool IsSuperUser { get; set; }
        public bool PasswordResetRequired { get; set; }
    }
}
