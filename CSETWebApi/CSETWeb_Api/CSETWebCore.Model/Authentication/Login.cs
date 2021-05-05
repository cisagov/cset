namespace CSETWebCore.Model.Authentication
{
    public class Login
    {
        public string Email;
        public string Password;
        public string TzOffset;

        /// <summary>
        /// The application that is talking to the API.
        /// </summary>
        public string Scope;
    }
}