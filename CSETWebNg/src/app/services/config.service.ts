////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { environment } from '../../environments/environment';



@Injectable()
export class ConfigService {

  reportsUrl: string;
  apiUrl: string;
  appUrl: string;
  docUrl: string;
  helpContactEmail: string;
  helpContactPhone: string;
  configUrl = 'assets/config.json';
  analyticsUrl: string;
  config: any;

  // button labels
  buttonLabels = {};

  buttonClasses = {};

  // labels for graph legends and report answers
  answerLabels = {};

  salLabels = {};

  private initialized = false;
  isAPI_together_With_Web = false;

  acetInstallation = false;
  

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
      
      return this.http.get(this.configUrl)
        .toPromise() 
        .then((data: any) => {
          let apiPort= data.api.port != "" ? ":" + data.api.port : "";
          let appPort= data.app.port != "" ? ":" + data.app.port : "";
          let apiProtocol = data.api.protocol +"://";
          let appProtocol = data.app.protocol +"://";
          this.apiUrl = apiProtocol + data.api.url + apiPort + "/" + data.api.apiIdentifier +"/";
          this.analyticsUrl = data.analyticsUrl;
          this.appUrl = appProtocol + data.app.appUrl + appPort;
          this.docUrl = apiProtocol + data.api.url + apiPort + "/" + data.api.documentsIdentifier+"/";
          this.reportsUrl = data.reportsApi;
          this.helpContactEmail = data.helpContactEmail;
          this.helpContactPhone = data.helpContactPhone;
          this.config = data;

          if (!!this.config.acetInstallation) {
            this.acetInstallation = this.config.acetInstallation;
          }

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
    this.buttonLabels['Y'] = this.config.buttonLabelY;
    this.buttonLabels['N'] = this.config.buttonLabelN;
    this.buttonLabels['NA'] = this.config.buttonLabelNA;
    this.buttonLabels['A'] = this.config.buttonLabelA;
    if (this.acetInstallation) {
      this.buttonLabels['A'] = this.config.buttonLabelA_ACET;
    }
    this.buttonLabels['I'] = this.config.buttonLabelI;

    this.answerLabels['Y'] = this.config.answerLabelY;
    this.answerLabels['N'] = this.config.answerLabelN;
    this.answerLabels['NA'] = this.config.answerLabelNA;
    this.answerLabels['A'] = this.config.answerLabelA;
    if (this.acetInstallation) {
      this.answerLabels['A'] = this.config.answerLabelA_ACET;
    }
    this.answerLabels['U'] = this.config.answerLabelU;
    this.answerLabels[''] = this.config.answerLabelU;
    this.answerLabels['I'] = this.config.answerLabelI;

    
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
    this.buttonClasses['I'] = 'btn-inc';
  }

  /**
   * Returns a boolean indicating if the app is configured to show
   * question and requirement IDs for debugging purposes.
   */
  showQuestionAndRequirementIDs() {
    return this.config.showQuestionAndRequirementIDs || false;
  }
}
export function ConfigFactory(config: ConfigService){
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

export{ ConfigModule }