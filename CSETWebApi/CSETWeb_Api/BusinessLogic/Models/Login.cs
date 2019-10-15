//////////////////////////////// 
// 
//   Copyright 2019 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CSETWeb_Api.Models
{
    /// <summary>
    /// Encapsulates the data in a login request.
    /// </summary>
    public class Login
    {
        public string Email;
        public string Password;
        public string TzOffset;

        /// <summary>
        /// The application that is talking to the API.
        /// </summary>
        public string Scope;
    }

    /// <summary>
    /// Encapsultes the data in a login response.
    /// </summary>
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
    }
}

