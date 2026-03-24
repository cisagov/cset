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
}
