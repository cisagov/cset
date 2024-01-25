//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
using System.Collections.Generic;

namespace CSETWebCore.Model.Contact
{
    public class ContactsListResponse
    {
        /// <summary>
        /// The list of candidate contacts
        /// </summary>
        public IEnumerable<ContactDetail> ContactList { get; set; }

        /// <summary>
        /// The user's role in the current assessment
        /// </summary>
        public int CurrentUserRole { get; set; }
    }
}