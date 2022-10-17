////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { CDK_CONNECTED_OVERLAY_SCROLL_STRATEGY } from '@angular/cdk/overlay/overlay-directives';
import { HttpClient } from '@angular/common/http';
import { Injectable, APP_INITIALIZER } from '@angular/core';
import { debug } from 'console';
import { environment } from '../../environments/environment';



@Injectable()
export class ConfigService {

  apiUrl: string;
  appUrl: string;
  docUrl: string;
  helpContactEmail: string;
  helpContactPhone: string;
  isRunningInElectron: boolean;
  configUrl: string;
  assetsUrl: string;
  analyticsUrl: string;
  config: any;
  
  isCsetOnline = false;

  // Contains settings from an option config.development.json that will not 
  // be deployed in any delivery or production setting.
  development: any;

  buttonClasses = {};


  salLabels = {};

  private initialized = false;
  isAPI_together_With_Web = false;

  installationMode = '';

  galleryLayout = 'CSET';
  isCyberFlorida = false;

  /**
   * Specifies the mobile ecosystem that the app is running on.
   * This is set by the build process when building CSET as
   * a mobile app.  If not being built for mobile, this property
   * will contain an empty string or "none".
   */
  mobileEnvironment = '';


  /**
   * Constructor.
   * @param http
   */
  constructor(private http: HttpClient) {

  }

  /**
   *
   */
  loadConfig() {
    if (!this.initialized) {
      this.isRunningInElectron = localStorage.getItem('isRunningInElectron') == 'true';
      this.assetsUrl = this.isRunningInElectron ? 'assets/' : '/assets/';
      this.configUrl = this.assetsUrl + 'config.json';

      this.http.get(this.assetsUrl + 'config.development.json').toPromise().then((data: any) => {
        this.development = data;
      },
      (error) => {
        this.development = {};
      });

      return this.http.get(this.configUrl)
        .toPromise()
        .then((data: any) => {
          let apiPort = data.api.port != "" ? ":" + data.api.port : "";
          let appPort = data.app.port != "" ? ":" + data.app.port : "";
          let apiProtocol = data.api.protocol + "://";
          let appProtocol = data.app.protocol + "://";
          if (localStorage.getItem("apiUrl") != null) {
            this.apiUrl = localStorage.getItem("apiUrl") + "/" + data.api.apiIdentifier + "/";
          } else {
            this.apiUrl = apiProtocol + data.api.url + apiPort + "/" + data.api.apiIdentifier + "/";
          }
          this.analyticsUrl = data.analyticsUrl;
          this.appUrl = appProtocol + data.app.appUrl + appPort;
          this.docUrl = apiProtocol + data.api.url + apiPort + "/" + data.api.documentsIdentifier + "/";
          this.helpContactEmail = data.helpContactEmail;
          this.helpContactPhone = data.helpContactPhone;
          this.config = data;

          this.isCsetOnline = this.config.isCsetOnline ?? false;

          this.installationMode = (this.config.installationMode?.toUpperCase() || '');
          this.galleryLayout = (this.config.galleryLayout?.toString() || 'CSET');

          this.isCyberFlorida = this.isCyberFloridaCheck();

          this.mobileEnvironment = (this.config.mobileEnvironment);

          this.populateLabelValues();

          this.populateButtonClasses();

          this.initialized = true;
        }).catch(error => console.log('Failed to load config file: ' + (<Error>error).message));
    }
  }

  /**
   * Populates label values.
   */
  populateLabelValues() {
    // Apply any overrides to button and graph labels
    this.salLabels['L'] = "Low";
    this.salLabels['M'] = "Moderate";
    this.salLabels['H'] = "High";
    this.salLabels['VH'] = "Very High";
  }

  /**
   * Associates a CSS class with each answer option.
   */
  populateButtonClasses() {
    this.buttonClasses['Y'] = 'btn-yes';
    this.buttonClasses['N'] = 'btn-no';
    this.buttonClasses['NA'] = 'btn-na';
    this.buttonClasses['A'] = 'btn-alt';
    this.buttonClasses['Iss'] = 'btn-iss';
    this.buttonClasses['I'] = 'btn-inc';
  }

  /**
   * A convenience method so that consumers can quickly know whether
   * CSET is currently running as a mobile app or not.
   */
  isMobile(): boolean {
    if (this.mobileEnvironment.toUpperCase() == 'NONE'
      || this.mobileEnvironment == '') {
      return false;
    }
    return true;
  }

  /**
   * Checks whether CSET is in Florida gallery mode or not
   */
  isCyberFloridaCheck() {
    if (this.galleryLayout !== null && this.galleryLayout !== undefined &&  this.galleryLayout === 'Florida') {
      this.config.isCyberFlorida = true;
      return true;
    }
    this.config.isCyberFlorida = false;
    return false;
  }

  /**
   * Returns a boolean indicating if the app is configured to show
   * question and requirement IDs for debugging purposes.
   */
  showQuestionAndRequirementIDs() {
    return this.development.showQuestionAndRequirementIDs ?? false;
  }

  /**
   * Returns a boolean indicating if the app is configured to show
   * the API build/link datetime in the CSET help about for debugging purposes.
   * @returns
   */
  showBuildTime() {
    return this.development.showBuildTime ?? false;
  }
}

export function ConfigFactory(config: ConfigService) {
  return () => config.loadConfig();
}

export function init() {
  return {
    provide: APP_INITIALIZER,
    useFactory: ConfigFactory,
    deps: [ConfigService],
    multi: true
  }
}
const ConfigModule = {
  init: init
}

export { ConfigModule }
