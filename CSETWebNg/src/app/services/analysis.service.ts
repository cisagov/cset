////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { HttpHeaders, HttpParams, HttpClient } from '../../../node_modules/@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class AnalysisService {
  private apiUrl: string;

  constructor(private http: HttpClient, private configSvc: ConfigService) {
      this.apiUrl = this.configSvc.apiUrl + "analysis/";
  }

  getDashboard() {
    return this.http.get(this.apiUrl + 'Dashboard');
  }

  getRankedQuestions() {
    return this.http.get(this.apiUrl + 'RankedQuestions');
  }

  getTopCategories() {
    return this.http.get(this.apiUrl + 'TopCategories');
  }

  getOverallRankedCategories(): any {
    return this.http.get(this.apiUrl + 'OverallRankedCategories');
  }

  getStandardsSummary(): any {
    return this.http.get(this.apiUrl + 'StandardsSummary');
  }

  getStandardsSummaryOverall(): any {
    return this.http.get(this.apiUrl + 'StandardsSummaryOverall');
  }


  getComponentsSummary(): any {
    return this.http.get(this.apiUrl + 'ComponentsSummary');
  }

  getStandardsResultsByCategory(): any {
    return this.http.get(this.apiUrl + 'StandardsResultsByCategory');
  }

  getStandardsRankedCategories(): any {
    return this.http.get(this.apiUrl + 'StandardsRankedCategories');
  }

  getComponentsResultsByCategory(): any {
    return this.http.get(this.apiUrl + 'ComponentsResultsByCategory');
  }

  getComponentsRankedCategories(): any {
    return this.http.get(this.apiUrl + 'ComponentsRankedCategories');
  }

  getComponentTypes(): any {
    return this.http.get(this.apiUrl + 'ComponentTypes');
  }

  getNetworkWarnings(): any {
    return this.http.get(this.apiUrl + 'NetworkWarnings');
  }
}
