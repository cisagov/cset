//////////////////////////////// 
// 
//   Copyright 2024 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
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


    /// <summary>
    /// Contains the credentials for an 'anonymous' login
    /// </summary>
    public class AnonymousLogin
    {
        public string AccessKey { get; set; }
        public string TzOffset { get; set; }

        /// <summary>
        /// The application that is talking to the API.
        /// </summary>
        public string Scope { get; set; }
    }
}