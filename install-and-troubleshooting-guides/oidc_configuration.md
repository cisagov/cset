
[← Back to Enterprise Installation Instructions](enterprise_install.md)

# OIDC Configuration

The application supports external authentication via OpenID Connect (OIDC). This is configured through the `OIDC` block in the `Auth` section of the application's `appsettings.json` configuration file.


### Enabling OIDC
By default, the OIDC section is named `disabled_OIDC` and has no effect — CSET presents its login screen to collect credentials and authenticate the user. To activate external authentication, __rename the key__ from `disabled_OIDC` to `OIDC`:

```
"Auth": {
   "OIDC": {
     ...
   }
}
```
To disable OIDC again, rename the key back to `disabled_OIDC`.

***

### Configuration Fields
| Field | Type | Description |
|:------|:-----|:------------|
| `ClientId` | string | The client ID registered with your OIDC identity provider.
| `RedirectUri` | string | The URI the identity provider will redirect to after a successful login. Must match the redirect URI registered with the provider.
| `PostLogoutRedirectUri` | string | The URI the identity provider will redirect to after a successful logout.
| `Issuer` | string | The base URL of the OIDC identity provider, used to validate the `iss` claim in tokens. In most configurations this will be the same as `Authority`. Example: `https://{oidc-provider-host}/realms/{realm}`
| `Authority` | string | The base URL used to discover the provider's metadata (authorization, token, and userinfo endpoints). In most configurations this will be the same as `Issuer`. Example: `https://{oidc-provider-host}/realms/{realm}`
| `Audience` | string | Identifies the client ID of the application registered with the OIDC provider. This value must match the `aud` (audience) claim in the token to validate it.
| `Scope` | string | Space-separated list of OAuth 2.0 scopes to request. `openid` is required; `profile` and `email` are standard optional scopes.
| `ClaimUsernameProperty` | string | Specifies the claim name in the token that should be used to identify the username. Example: `"preferred_username"` is the default if not explicitly configured.
| `StrictDiscoveryDocumentValidation` | boolean | When `true`, enforces that all endpoint URLs in the discovery document share the same base as the `issuer`. Set to `false` if your provider returns endpoints on a different domain or subdomain (e.g., for load balancing).
| `RequireHttps` | boolean | When `true`, requires all OIDC communication to use HTTPS. Set to `false` for local development environments only. __Should always be `true` in production__.
| `ShowDebugInformation` | boolean | When `true`, logs verbose OIDC debug output to the browser console. Useful during development and troubleshooting. __Should be `false` in production__.

***

### OIDC Provider Configuration
In your OIDC provider's client or application settings, ensure the following are configured:

- **Allowed redirect URIs** – the URL the provider returns the user to after login (e.g. `https://{your-cset-ui-host}/callback`)
- **Allowed post logout redirect URIs** – the URL the provider returns the user to after logout (e.g. `https://{your-cset-ui-host}/home/login`)

The exact names of these settings vary by provider. Without a registered post logout redirect URI, most providers will reject the logout request and the user's session will not be terminated, allowing them to silently re-authenticate without seeing a login screen.

***

### Configuration Example
The default configuration targets a local OpenID Connect (OIDC) provider instance:
```
"Auth": {
   "OIDC": {
      "ClientId": "cset-local",
      "RedirectUri": "https://{your-cset-ui-host}/callback",
      "PostLogoutRedirectUri": "https://{your-cset-ui-host}/home/logout",
       
      "Issuer": "https://{oidc-provider-host}/{path-to-issuer}",
      "Authority": "https://{oidc-provider-host}/{path-to-issuer}",
      "Audience": "{your-client-id}",
      
      "Scope": "openid profile email",
      "ClaimUsernameProperty": "preferred_username",
      
      "StrictDiscoveryDocumentValidation": false,
      "RequireHttps": false,
      
      "ShowDebugInformation": true
   }
}
```

***

### Production Checklist
Before deploying to a production environment, ensure the following:
 - `RequireHttps` is set to `true`
 - `ShowDebugInformation` is set to `false`
 - `RedirectUri` and `PostLogoutRedirectUri` point to your production domain
 - `Issuer` points to your production identity provider
 - `ClientId` matches the client registered with your production identity provider
 - The redirect URIs are registered and allowed in your identity provider's client settings

***

### Notes
 - The `StrictDiscoveryDocumentValidation: false` setting is typically only needed for non-standard provider configurations or local setups where endpoint URLs don't match the issuer base URL. Enable it in production where possible.
 - The `Scope` field must always include `openid` to conform to the OIDC specification. Additional scopes such as `profile` and `email` control what claims are included in the ID token.
