//////////////////////////////// 
// 
//   Copyright 2020 Battelle Energy Alliance, LLC  
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
    /// Encapsulates the response from a "create user" request.
    /// 
    /// </summary>
    public class UserCreateResponse
    {
        public int UserId { get; set; }
        public string PrimaryEmail { get; set; }
        public string TemporaryPassword { get; set; }
        public bool IsExisting { get; internal set; }
    }
}

