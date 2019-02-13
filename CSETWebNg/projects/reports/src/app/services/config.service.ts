////////////////////////////////
//
//  Copyright 2018 Battelle Energy Alliance, LLC
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
import { Injectable } from '@angular/core';
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

  config: any;

  private initialized = false;
  isAPI_together_With_Web = false;

  constructor(private http: HttpClient) {
      this.configUrl = "assets/config.json";
        if (/reports/i.test(window.location.href)) {
          this.configUrl = "../" + this.configUrl;
        }
      this.isAPI_together_With_Web = (sessionStorage.getItem("isAPI_together_With_Web") === "true") ? true : false;
      if (this.isAPI_together_With_Web) {
        this.apiUrl = sessionStorage.getItem("appAPIURL");
      }
  }

  loadConfig() {

    if (!this.initialized) {
      // NOTE that if the api is local (not on a seperate port)
      // then it is safe to assume that everything api, main app, and reports
      // are all together.   Consequently I don't need other environments etc
      // and I can assume production

      let tmpConfigURL = 'assets/config.json';
      if (!this.isAPI_together_With_Web) { tmpConfigURL = this.configUrl; }

      // it is very important that this be a single promise
      // I'm not sure the config call is actually behaving.
      // multiple chained promises definitely does not work
      return this.http.get(tmpConfigURL)
        .toPromise()
        .then((data: any) => {
                if (this.isAPI_together_With_Web) {
                  this.apiUrl = data.apiUrl;
                  this.appUrl = data.appUrl;
                  this.docUrl = data.docUrl;
                  this.reportsUrl = data.reportsUrl;
                  this.helpContactEmail = data.helpContactEmail;
                  this.helpContactPhone = data.helpContactPhone;
                } else {
                  this.apiUrl = environment.apiUrl;
                  this.appUrl = environment.appUrl;
                  this.docUrl = environment.docUrl;
                }
                this.config = data;
                this.initialized = true;
              }).catch(error => console.log('Failed to load config file: ' + (<Error>error).message));
    }
  }
}
