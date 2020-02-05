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
    public class ContactDetail
    {
        public string FirstName;
        public string LastName;
        public string PrimaryEmail;
        public int? UserId;

        public int AssessmentId;
        public int AssessmentRoleId;
        public bool Invited;
    }


    /// <summary>
    /// The data sent when an existing contact 
    /// is added to an existing assessment.
    /// </summary>
    public class ContactAddParameters
    {
        public string PrimaryEmail;
        public int AssessmentRoleId;        
    }


    /// <summary>
    /// The raw contact and assessment data sent
    /// when creating a brand new Contact and
    /// attaching it to an Assessment
    /// </summary>
    public class ContactCreateParameters
    {
        public int UserId;
        public string FirstName;
        public string LastName;
        public string PrimaryEmail;
        public int AssessmentRoleId;
        public int AssessmentId;

        /// <summary>
        /// The subject of the invitation email.
        /// </summary>
        public string Subject;

        /// <summary>
        /// The message body of the invitation email.
        /// </summary>
        public string Body;
    }


    /// <summary>
    /// Indicate the user and assessment to disconnect.
    /// </summary>
    public class ContactRemoveParameters
    {
        /// <summary>
        /// The userId of the contact to be removed.
        /// </summary>
        public int UserId;
        /// <summary>
        /// The assesemnt id we are trying to remove the user from
        /// </summary>
        public int Assessment_ID; 
    }
}

