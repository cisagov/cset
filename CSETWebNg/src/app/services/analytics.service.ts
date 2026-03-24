////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { lastValueFrom } from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class AnalyticsService {
  private apiUrl: string;
  private baseUrl: string;
  private analyticsUrl: string;
  public headers = {
    headers: new HttpHeaders().set('Content-Type', 'application/json'),
    params: new HttpParams()
  };

  /**
   *
   */
  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.baseUrl = this.configSvc.apiUrl;
    this.apiUrl = this.baseUrl + "analytics/";
    this.analyticsUrl = this.configSvc.analyticsUrl + "api/";
  }

  /**
   *
   */
  getAnalytics(): any {
    return this.http.get(this.apiUrl + 'getAggregation');
  }

  /**
   *
   */
  isCisaAssessorMode() {
    return this.configSvc.installationMode == "IOD";
  }

  /**
   * Gets a list of sectors and the sample size (number of assessments in that sector)
   */
  getSampleSizes() {
    return lastValueFrom(this.http.get(this.apiUrl + 'samplesizes'));
  }

  /**
   *
   */
  getAnalyticResults(maturityModelId: number, sectorId?: number): any {
    let url = this.apiUrl + "maturity/bars?"
    if (maturityModelId) {
      url += `&modelId=${maturityModelId}`;
    }
    if (sectorId) {
      url += `&sectorId=${sectorId}`;
    }
    return this.http.get(url);
  }

  /**
   * Use remote credentials to get the remote token
   */
  getAnalyticsToken(username, password): any {
    let obj = JSON.stringify({
      Email: username,
      Password: password,
      TzOffset: new Date().getTimezoneOffset().toString(),
      Scope: "CSET"
    });

    //Custom header to avoid interceptor from adding the authorization header + token
    let headers = {
      headers: new HttpHeaders().set('Content-Type', 'application/json').set('noauth', 'true'),
      params: new HttpParams()
    };

    return this.http.post(
      this.analyticsUrl + 'auth/login', obj, headers
    );
  }

  /**
   * Check
   */
  isRemoteTokenValid(tokenString: string | null) {
    // the TokenManager in the API will throw a 401 for an empty string
    if (!tokenString) {
      tokenString = 'abc';
    }

    //Custom header to avoid interceptor from adding the authorization header + token
    let headers = {
      headers: new HttpHeaders().set('Content-Type', 'application/json').set('noauth', 'true').set('cset-noauth', 'true'),
      params: new HttpParams()
    };

    return this.http.post(this.analyticsUrl + 'auth/istokenvalid', JSON.stringify(tokenString), headers);
  }

  /**
   *
   */
  postAnalytics(remoteToken: string): any {
    let headers = {
      headers: new HttpHeaders()
        .set('RemoteAuthorization', remoteToken)
        .set('Content-Type', 'application/json')
        .set('cset-noauth', 'true'),
      params: new HttpParams()
    };

    return this.http.get(this.baseUrl + 'assessment/exportandsend', headers);
  }
}