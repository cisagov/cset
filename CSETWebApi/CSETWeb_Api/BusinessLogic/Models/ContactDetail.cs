//////////////////////////////// 
// 
//   Copyright 2021 Battelle Energy Alliance, LLC  
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
        public string Title;
        public string Phone;

        public int AssessmentId;
        public int AssessmentRoleId;
        public bool Invited;
        public int AssessmentContactId;
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
        public string Title;
        public string Phone;

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
    /// The request should contain one or the other of the two fields.
    /// If the AssessmentId is supplied, the current user will be disconnected
    /// from the assessment.
    /// </summary>
    public class ContactRemoveParameters
    {
        /// <summary>
        /// This is a better value to send because an imported
        /// assessment's users are only given AssessmentContact records.
        /// </summary>
        public int AssessmentContactId;

        /// <summary>
        /// The assesemnt id we are trying to remove the user from
        /// </summary>
        public int AssessmentId; 
    }
}

