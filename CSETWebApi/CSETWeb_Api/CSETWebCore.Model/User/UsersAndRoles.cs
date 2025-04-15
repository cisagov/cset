//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;

namespace CSETWebCore.Model.User
{
    public class UsersAndRoles
    {
       public List<ROLES> Roles { get; set; }
       public List<UserRole> UserRoles { get; set; }
    }

    public class UserRole
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public List<ROLES> Roles { get; set; }
    }
}
