namespace CSETWebCore.Model.Contact
{
    public class ContactCreateParameters
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public int AssessmentRoleId { get; set; }
        public int AssessmentId { get; set; }
        public string Title { get; set; }
        public string Phone { get; set; }

        /// <summary>
        /// The subject of the invitation email.
        /// </summary>
        public string Subject { get; set; }

        /// <summary>
        /// The message body of the invitation email.
        /// </summary>
        public string Body { get; set; }
    }
}
