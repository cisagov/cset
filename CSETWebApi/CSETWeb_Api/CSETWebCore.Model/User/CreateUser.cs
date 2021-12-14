namespace CSETWebCore.Model.User
{
    public class CreateUser
    {
        public int UserId { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public string PrimaryEmail { get; set; }
        public string saveEmail { get; set; }
        public string Title { get; set; }
        public string Phone { get; set; }

        public string ConfirmEmail { get; set; }
        public int AssessmentRoleId { get; set; }
        public string SecurityQuestion1 { get; set; }
        public string SecurityQuestion2 { get; set; }
        public string SecurityAnswer1 { get; set; }
        public string SecurityAnswer2 { get; set; }

        /// <summary>
        /// This must be explicitly sent by the front end because
        /// the user is not logged in, so there's no JWT at this point.
        /// </summary>
        public string AppCode { get; set; }
    }
}