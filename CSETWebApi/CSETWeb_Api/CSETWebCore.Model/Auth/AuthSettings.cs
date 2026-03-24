
//////////////////////////////// 
// 
//   Copyright 2026 Battelle Energy Alliance, LLC  
// 
// 
//////////////////////////////// 
namespace CSETWebCore.Model.Auth
{
    public class AuthSettings
    {
        public JwtSettings OIDC { get; set; } = new();
    }

    public class JwtSettings
    {
        public string Authority { get; set; } = string.Empty;
        public string Audience { get; set; } = string.Empty;

        /// <summary>
        /// The username property key
        /// </summary>
        public string ClaimUsernameProperty { get; set; } = string.Empty;
    }
}