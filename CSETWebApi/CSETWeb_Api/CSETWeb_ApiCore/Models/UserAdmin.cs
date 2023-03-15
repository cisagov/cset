namespace CSETWebCore.Api.Models
{
    public class UserAdmin
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public string PrimaryEmail { get; set; }
        public bool IsActive { get; set; }

    }
}
