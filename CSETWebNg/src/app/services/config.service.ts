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
import { HttpClient } from '@angular/common/http';
import { Injectable, APP_INITIALIZER } from '@angular/core';



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
  settingsUrl: string;
  analyticsUrl: string;
  config: any;

  isCsetOnline = false;
  behaviors: any;

  buttonClasses = {};


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


  /**
   * Constructor.
   * @param http
   */
  constructor(private http: HttpClient) {}


  processDataOverrides(source: any, data: any):any{
    //get the base object
    //get the string of overrides
    //for each over
    //get all the properties
    //for each property if the property has properites
    //then recurse
    //else set the property value on the base object from the override
    for (const property in source) {
      if(property.startsWith("answers")){
        console.log("skipping overload for "+property);
      }
      else{
        if( typeof source[property] =="object"){
          this.processDataOverrides(source[property],data[property]);
        }
        else{
          console.log(`copying source ${property} was:${data[property]} now is:${source[property]}`);
          data[property] = source[property];
        }
      }
    }

    return data;
  }

  configFiles = [];
  getConfigs(configChain:string[]){
    var configPromises = [];
      for(var config of configChain){
        var tmpURL = `./${this.settingsUrl}config.${config}.json`;
        configPromises.push( this.http.get(tmpURL)
        .toPromise()
        .then((tmpConfig: any) => {
          this.configFiles.push(tmpConfig);
        }
        ));

      }
      return Promise.all(configPromises)

  }

  getRootDataOverrides(masterConfig: any): any{
    return this.getConfigs(masterConfig.currentConfigChain).then((data)=>{
      for(var configFile of this.configFiles){
        this.config = this.processDataOverrides(configFile,masterConfig)
      }
    })
    .catch((err) => console.log(err));
  }


  /**
   *
   */
  loadConfig() {
    if (!this.initialized) {
      this.isRunningInElectron = localStorage.getItem('isRunningInElectron') == 'true';
      this.assetsUrl = 'assets/';
      this.settingsUrl = this.assetsUrl + 'settings/';
      this.configUrl = this.settingsUrl + 'config.json';

      return this.http.get(this.configUrl)
        .toPromise()
        .then((masterConfig: any) => {
          // isCsetOnline and installation mode should not change from master config file.
          return this.getRootDataOverrides(masterConfig).then(() => {

            this.isCsetOnline = this.config.isCsetOnline ?? false;
            this.installationMode = (this.config.installationMode?.toUpperCase() || 'CSET');

            let apiPort = this.config.api.port != "" ? ":" + this.config.api.port : "";
            let appPort = this.config.app.port != "" ? ":" + this.config.app.port : "";
            let apiProtocol = this.config.api.protocol + "://";
            let appProtocol = this.config.app.protocol + "://";
            if (localStorage.getItem("apiUrl") != null) {
              this.apiUrl = localStorage.getItem("apiUrl") + "/" + this.config.api.apiIdentifier + "/";
            } else {
              this.apiUrl = apiProtocol + this.config.api.url + apiPort + "/" + this.config.api.apiIdentifier + "/";
            }
            this.analyticsUrl = this.config.analyticsUrl;
            this.appUrl = appProtocol + this.config.app.appUrl + appPort;
            this.docUrl = apiProtocol + this.config.api.url + apiPort + "/" + this.config.api.documentsIdentifier + "/";
            this.helpContactEmail = this.config.helpContactEmail;
            this.helpContactPhone = this.config.helpContactPhone;

            this.galleryLayout = (this.config.galleryLayout?.toString() || 'CSET');
            this.mobileEnvironment = (this.config.mobileEnvironment);
            this.behaviors = this.config.behaviors;

            this.populateLabelValues();

            this.populateButtonClasses();

            this.initialized = true;
          });
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
   * Determines if the Import button should display or not
   */
  showImportButton() {

    // hide the import button if any Cyber Florida conditions exist
    if ((this.config.isCyberFlorida ?? false)
      || ((this.config.galleryLayout ?? '') == 'Florida')
      || ((this.config.installationMode ?? '') == 'CF')) {
      return false;
    }

    return true;
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
