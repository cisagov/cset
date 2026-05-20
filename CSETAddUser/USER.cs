using System;

namespace CSETAddUser
{
    public class USER
    {
        public string PrimaryEmail { get; set; }

        public int UserId { get; set; }

        public string Password { get; set; }

        public string Salt { get; set; }

        public string FirstName { get; set; }

        public string LastName { get; set; }

        public Guid? Id { get; set; }
    }
}
