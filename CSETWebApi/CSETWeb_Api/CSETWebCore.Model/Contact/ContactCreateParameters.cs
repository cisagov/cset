namespace CSETWebCore.Model.Contact
{
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
}
