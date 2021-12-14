namespace CSETWebCore.Model.Authentication
{
    public class Login
    {
        public string Email { get; set; }
        public string Password { get; set; }
        public string TzOffset { get; set; }

        /// <summary>
        /// The application that is talking to the API.
        /// </summary>
        public string Scope { get; set; }
    }
}