//////////////////////////////// 
// 
//   Copyright 2018 Battelle Energy Alliance, LLC  
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
    /// Defines the role that a user can have with an assessment.
    /// One role is not related to an assessment:  Root Admin.  It is used 
    /// primarily by system administrators and developers.
    /// </summary>
    public class Role
    {
        public enum RoleType { AssessmentAdmin, AssessmentUser, DeactivatedUser }
    }
}

