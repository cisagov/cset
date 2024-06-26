////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { HttpClient } from '@angular/common/http';
import { Injectable, Inject } from '@angular/core';
import { DOCUMENT } from '@angular/common';
import { concat } from 'rxjs';
import { tap } from 'rxjs/operators';
import { merge } from 'lodash';

@Injectable()
export class ConfigService {
  /**
   * The full URL of the API
   */
  apiUrl: string;

  /**
   * The full URL of the UI
   */
  appUrl: string;

  /**
   * This is the host + "Documents".  Used for accessibility statement, etc.
   */
  docUrl: string;

  /**
   * This is host/api/library/doc. Used for reference document retrieval.
   */
  refDocUrl: string;

  /**
   * host/api/library
   */
  libraryUrl: string;


  onlineUrl: string;
  analyticsUrl: string = "http://localhost:5278/";

  csetGithubApiUrl: string;
  helpContactEmail: string;
  helpContactPhone: string;

  isDocUrl = false;
  isOnlineUrlLive = false;
  isRunningInElectron: boolean;
  isRunningAnonymous = false;

  configUrl: string;
  assetsUrl: string;
  settingsUrl: string;
  publicDomainName: string;
  config: any;

  behaviors: any;

  salLabels = {};

  private initialized = false;
  isAPI_together_With_Web = false;

  installationMode = '';

  galleryLayout = 'CSET';

  /**
   * Specifies the mobile ecosystem that the app is running on.
   * This is set by the build process when building CSET as
   * a mobile app.  If not being built for mobile, this property
   * will contain an empty string or "none".
   */
  mobileEnvironment = '';
  cisaAssessorWorkflow: boolean = false;

  /**
   * Constructor.
   * @param http
   */
  constructor(private http: HttpClient, @Inject(DOCUMENT) private document: Document) { }

  /**
   *
   */
  async loadConfig() {
    if (!this.initialized) {
      this.isRunningInElectron = localStorage.getItem('isRunningInElectron') == 'true';

      return this.http
        .get('assets/settings/config.json')
        .toPromise()
        .then((config) => {
          this.config = config;
        })
        .then(() => {
          const configPaths = [];
          this.config.currentConfigChain.forEach((configProfile) => {
            configPaths.push(`assets/settings/config.${configProfile}.json`);
          });

          return concat(...configPaths.map((path) => this.http.get(path)))
            .pipe(
              tap((subConfig) => {
                merge(this.config, subConfig);
              })
            )
            .toPromise()
            .then(() => {
              this.setConfigPropertiesForLocalService();
              this.switchConfigsForMode(this.config.installationMode || 'CSET');
            });
        })
        .catch(() => {
          console.error('FAILED TO LOAD APPLICATION CONFIGURATION');
        });
    }
  }

  enableCisaAssessorWorkflow() {
    return this.http
      .get('assets/settings/config.IOD.json')
      .toPromise()
      .then((iodConfig) => {
        merge(this.config, iodConfig);
        this.setConfigPropertiesForLocalService();
      });
  }

  checkLocalDocStatus() {
    return this.http.get(this.apiUrl + 'HasLocalDocuments');
  }

  checkOnlineDocStatus() {
    // TODO: temporary return until we get this working in production
    return this.http.get(this.apiUrl + 'HasLocalDocuments');
  }

  /**
   *
   */
  setConfigPropertiesForLocalService() {
    this.isRunningAnonymous = this.config.isRunningAnonymous;
    this.publicDomainName = this.config.publicDomainName;
    this.assetsUrl = 'assets/';
    this.installationMode = this.config.installationMode;

    const apiPort = this.config.api.port != '' ? ':' + this.config.api.port : '';
    const appPort = this.config.app.port != '' ? ':' + this.config.app.port : '';
    const apiProtocol = this.config.api.protocol + '://';
    const appProtocol = this.config.app.protocol + '://';


    const localStorageApiUrl = localStorage.getItem('apiUrl');
    const localStorageLibraryUrl = localStorage.getItem('libraryUrl');
    if (!!localStorageApiUrl) {
      this.apiUrl = localStorageApiUrl + '/' + this.config.api.apiIdentifier + '/';
      this.docUrl = localStorageApiUrl + '/' + this.config.api.documentsIdentifier + '/';
    } else {
      this.apiUrl = apiProtocol + this.config.api.host + apiPort + '/' + this.config.api.apiIdentifier + '/';
      this.docUrl = apiProtocol + this.config.api.host + apiPort + '/' + this.config.api.documentsIdentifier + '/';
    }

    this.appUrl = appProtocol + this.config.app.host + appPort;
    this.analyticsUrl = "http://localhost:5278/";
    this.helpContactEmail = this.config.helpContactEmail;
    this.helpContactPhone = this.config.helpContactPhone;
    this.csetGithubApiUrl = this.config.csetGithubApiUrl;

    // configure the reference document URL if the "library" property is defined
    // or if passed in as query param and stored as local storage variable. Local storage should
    // take precedence over the config file, since Electron uses it to dynamically set the port.
    const rl = this.config.library;
    if (!!localStorageLibraryUrl) {
      this.libraryUrl = localStorageLibraryUrl + '/' + this.config.api.apiIdentifier + '/library/';
    } else if (!!rl) {
      const rlProtocol = rl.protocol + '://';
      const rlPort = !!rl.port ? ':' + rl.port : '';
      this.libraryUrl = rlProtocol + rl.host + rlPort + '/' + (rl.apiIdentifier ?? 'api') + '/library/'
    } else {
      this.libraryUrl = apiProtocol + this.config.api.host + apiPort + '/' + this.config.api.apiIdentifier + '/library/';
    }

    this.refDocUrl = this.libraryUrl + 'doc/';

    this.galleryLayout = this.config.galleryLayout?.toString() || 'CSET';
    this.mobileEnvironment = this.config.mobileEnvironment;
    this.behaviors = this.config.behaviors;
    this.checkOnlineStatusFromConfig();
    this.populateLabelValues();
    this.initialized = true;
  }

  checkOnlineStatusFromConfig() {
    this.checkLocalDocStatus().subscribe(
      (resp: boolean) => {
        this.isDocUrl = resp;
      },
      () => {
        this.isDocUrl = false;
      }
    );

    this.checkOnlineDocStatus().subscribe(
      (resp: boolean) => {
        this.isOnlineUrlLive = resp;
      },
      () => {
        this.isOnlineUrlLive = false;
      }
    );
  }

  /**
   * Populates label values.
   */
  populateLabelValues() {
    // Apply any overrides to button and graph labels
    this.salLabels['L'] = 'Low';
    this.salLabels['M'] = 'Moderate';
    this.salLabels['H'] = 'High';
    this.salLabels['VH'] = 'Very High';
  }

  /**
   * A convenience method so that consumers can quickly know whether
   * CSET is currently running as a mobile app or not.
   */
  isMobile(): boolean {
    if (this.mobileEnvironment.toUpperCase() == 'NONE' || this.mobileEnvironment == '') {
      return false;
    }
    return true;
  }

  /**
   * Determines if the Import button should display or not
   */
  showImportButton() {
    // hide the import button if any Cyber Florida conditions exist
    if (
      (this.config.isCyberFlorida ?? false) ||
      (this.config.galleryLayout ?? '') == 'Florida' ||
      (this.config.installationMode ?? '') == 'CF'
    ) {
      return false;
    }

    return true;
  }

  /**
   * Determines if the Export All button should display or not
   */
  showExportAllButton() {
    return this.config.debug.showExportAllButton ?? false;
  }

  /**
   * Returns a boolean indicating if the app is configured to show
   * question and requirement IDs for debugging purposes.
   */
  showQuestionAndRequirementIDs() {
    return this.config.debug.showQuestionAndRequirementIDs ?? false;
  }

  /**
   * Returns a boolean indicating if the app is configured to show
   * the API build/link datetime in the CSET help about for debugging purposes.
   * @returns
   */
  showBuildTime() {
    return this.config.debug.showBuildTime ?? false;
  }

  /**
   * Gets the current CISA workflow flag from the current user/access key and sets it in the config.
   */
  getCisaAssessorWorkflow() {
    return this.http.get(this.apiUrl + 'EnableProtectedFeature/getCisaAssessorWorkflow');
  }

  setCisaAssessorWorkflow(cisaAssessorWorkflowEnabled: boolean) {
    this.cisaAssessorWorkflow = cisaAssessorWorkflowEnabled;
    return this.http.post(this.apiUrl + 'EnableProtectedFeature/setCisaAssessorWorkflow', cisaAssessorWorkflowEnabled);
  }

  switchConfigsForMode(installationMode) {
    switch (installationMode) {
      case 'ACET':
        {
          var x = this.document.getElementsByClassName('root');
          if (x.length > 0) {
            x[0].classList.add('acet-background');
          }

          var x = document.getElementsByClassName('ncua-seal');
          if (x.length > 0) {
            x[0].classList.remove('d-none');
          }

          // change favicon and title
          const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
          link.href = 'assets/icons/favicon_acet.ico?app=acet1';

          var title = this.document.querySelector('title');
          title.innerText = 'ACET';
        }
        break;
      case 'TSA':
        {
          // change favicon and title
          const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
          link.href = 'assets/icons/favicon_tsa.ico?app=tsa1';

          var title = this.document.querySelector('title');
          title.innerText = 'CSET-TSA';
        }
        break;
        case 'CIE':
          {
            // change favicon and title
            const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
            link.href = 'assets/icons/favicon_cie.ico?app=cie1';

            var title = this.document.querySelector('title');
            title.innerText = 'CIE';
          }
          break;
      case 'CF':
        {
          // change favicon and title
          const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
          link.href = 'assets/icons/favicon_cf.ico?app=cf1';

          var title = this.document.querySelector('title');
          title.innerText = 'CSET-CF';
        }
        break;
      case 'RRA':
        {
          // change favicon and title
          const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
          link.href = 'assets/icons/favicon_rra.ico?app=rra1';

          var title = this.document.querySelector('title');
          title.innerText = 'CISA - Ransomware Readiness';
        }
        break;
      case 'RENEW':
        {
          // change favicon and title
          const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
          link.href = 'assets/icons/favicon_renew.ico?app=renew1';

          var title = this.document.querySelector('title');
          title.innerText = 'CSET Renewables';
        }
        break;
      default: {
        // change favicon and title
        const link: HTMLLinkElement = this.document.querySelector("link[rel~='icon']");
        link.href = 'assets/icons/favicon_cset.ico?app=cset';

        var title = this.document.querySelector('title');
        title.innerText = 'CSET';
      }
    }
  }
}
