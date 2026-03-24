
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
        public OidcSettings OIDC { get; set; }
    }

    public class OidcSettings
    {
        /// <summary>
        /// The client ID registered with your OIDC identity provider.
        /// </summary>
        public string ClientId { get; set; } = string.Empty;

        /// <summary>
        /// The URI the identity provider will redirect to after a successful 
        /// login. Must match the redirect URI registered with the provider.
        /// </summary>
        public string RedirectUri { get; set; } = string.Empty;

        /// <summary>
        /// The URI the identity provider will redirect to after a successful logout.
        /// </summary>
        public string PostLogoutRedirectUri { get; set; } = string.Empty;

        /// <summary>
        /// Space-separated list of OAuth 2.0 scopes to request. 
        /// openid is required; profile and email are standard optional scopes.
        /// </summary>
        public string Scope { get; set; } = string.Empty;

        /// <summary>
        ///The base URL of the OIDC identity provider (the realm/tenant issuer URL). 
        ///The app will use this to discover provider endpoints via 
        ///{issuer}/.well-known/openid-configuration.
        /// </summary>
        public string Issuer { get; set; } = string.Empty;

        /// <summary>
        /// When true, enforces that all endpoint URLs in the discovery document 
        /// share the same base as the issuer. Set to false if your provider 
        /// returns endpoints on a different domain or subdomain.
        /// </summary>
        public bool StrictDiscoveryDocumentValidation { get; set; } = false;

        /// <summary>
        /// When true, requires all OIDC communication to use HTTPS. 
        /// Set to false for local development environments only. Should 
        /// always be true in production.
        /// </summary>
        public bool RequireHttps { get; set; } = true;

        /// <summary>
        /// When true, logs verbose OIDC debug output to the browser console. 
        /// Useful during development and troubleshooting. Should be false in production.
        /// </summary>
        public bool ShowDebugInformation { get; set; } = false;

        /// <summary>
        /// Identifies the client ID of the application registered with the OIDC provider. 
        /// This value must match the "aud" (audience) claim in the token to validate it.
        /// </summary>
        public string Audience { get; set; } = string.Empty;

        /// <summary>
        /// Specifies the claim name in the token that should be used to 
        /// identify the username.  Defaults to "preferred_username" if not specified.
        /// </summary>
        public string ClaimUsernameProperty { get; set; } = string.Empty;
    }
}