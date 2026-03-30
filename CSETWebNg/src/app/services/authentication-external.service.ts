import { Injectable } from '@angular/core';
import { OAuthService } from 'angular-oauth2-oidc';
import { ConfigService } from './config.service';

@Injectable({
  providedIn: 'root',
})
export class AuthenticationExternalService {

  constructor(
    public oauthService: OAuthService,
    public configSvc: ConfigService
  ) { }

  /**
   * Set all URLs and values needed to call the
   * OIDC authentication service.
   */
  initializeOAuth() {
    const c = this.configSvc.config.oidc;
    if (!c) {
      throw new Error("OpenID Connect settings not configured");
    }

    this.oauthService.configure({
      clientId: c.clientId,
      redirectUri: c.redirectUri,
      postLogoutRedirectUri: c.postLogoutRedirectUri,
      scope: c.scope,
      issuer: c.issuer,
      strictDiscoveryDocumentValidation: c.strictDiscoveryDocumentValidation,
      requireHttps: c.requireHttps ?? true,
      showDebugInformation: c.showDebugInformation ?? false
    });

    this.oauthService.setStorage(localStorage);
  }

  /**
   * Configures the OAuth service and redirects to the IdP
   */
  async login() {
    this.initializeOAuth();
    await this.oauthService.loadDiscoveryDocument();
    this.oauthService.initLoginFlow();
  }

  /**
   * 
   */
  async logOut() {
    // if external authentication is not being used, do nothing
    if (!this.oauthService.hasValidAccessToken()) {
      return;
    }

    this.initializeOAuth();
    await this.oauthService.loadDiscoveryDocument();

    const idToken = sessionStorage.getItem('oidc-id-token');
    const logoutUrl = (this.oauthService as any).logoutUrl;
    const postLogoutUri = encodeURIComponent(this.oauthService.postLogoutRedirectUri); 

    window.location.href = `${logoutUrl}?id_token_hint=${idToken}&post_logout_redirect_uri=${postLogoutUri}`;
  }
}
