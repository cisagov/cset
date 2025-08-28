namespace CSETWebCore.Api.Models
{
    public class UserRole
    {
        public string FirstName { get; set; }
        public string LastName { get; set; }

        public string PrimaryEmail { get; set; }
        public string RoleName { get; set; }
        
        public int RoleId { get; set; }
        
        public int UserId { get; set; }

    }
}