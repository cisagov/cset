//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Contact
{
    public class ContactInviteParameters
    {
        /// <summary>
        /// The subject of the invitation email.
        /// </summary>
        public string Subject { get; set; }

        /// <summary>
        /// The message body of the invitation email.
        /// </summary>
        public string Body { get; set; }

        /// <summary>
        /// A list of the invitees' email addresses.
        /// </summary>
        public List<string> InviteeList { get; set; }
    }
}