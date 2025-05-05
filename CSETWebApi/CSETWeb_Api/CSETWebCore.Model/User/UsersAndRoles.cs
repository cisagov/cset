//////////////////////////////// 
// 
//   Copyright 2025 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using CSETWebCore.DataLayer.Model;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations.Schema;

namespace CSETWebCore.Model.User
{
    public class UsersAndRoles
    {
        public UsersAndRoles()
        {
            Roles = new List<ROLES>();
            UserRoles = new List<UserRole>();
        }

       public List<ROLES> Roles { get; set; }
       public List<UserRole> UserRoles { get; set; }
    }

    public class UserRole
    {
        public UserRole()
        {
            UserId = 0;
            FirstName = "";
            LastName = "";
            PrimaryEmail = "";
            UserRoles = new USER_ROLES();
            //Roles = new List<ROLES>();
        }

        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public USER_ROLES UserRoles { get; set; }


    }
}
