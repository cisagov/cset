//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Contact
{
    public class ContactRemoveParameters
    {
        /// <summary>
        /// This is a better value to send because an imported
        /// assessment's users are only given AssessmentContact records.
        /// </summary>
        public int AssessmentContactId { get; set; }

        /// <summary>
        /// The assesemnt id we are trying to remove the user from
        /// </summary>
        public int AssessmentId { get; set; }
    }
}