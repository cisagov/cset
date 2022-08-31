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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { CrrPerformanceAppendixA } from '../models/crrperformanceappendixa.model';
import { result } from 'lodash';

const headers = {
  headers: new HttpHeaders()
      .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class CrrService {

  keyToCategory = {
    AM: 'Asset Management',
    CM: 'Controls Management',
    CCM: 'Configuration and Change Management',
    VM: 'Vulnerability Management',
    IM: 'Incident Management',
    SCM: 'Service Continuity Management',
    RM: 'Risk Management',
    EDM: 'External Dependencies Management',
    TA: 'Training and Awareness',
    SA: 'Situational Awareness'
  };

  constructor(private http: HttpClient, private configSvc: ConfigService) { }

  /**
   * Retrieves the list of frameworks.
   */
  getCrrHtml(view:string) {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getCrrHtml?view='+view);
  }

  getCrrModel(){
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getCrrModel');
  }

  getMil1FullAnswerDistribWidget() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/widget/mil1FullAnswerDistrib',
    { responseType: 'text' });
  }

  getMil1PerformanceSummaryLegendWidget() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/widget/mil1PerformanceSummaryLegend',
    { responseType: 'text'});
  }

  getMil1PerformanceSummaryBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getCrrMil1PerformanceSummaryBodyCharts');
  }

  getCrrPerformanceSummaryBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getCrrPerformanceSummaryBodyCharts');
  }

  getCrrPerformanceSummaryLegendWidget() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/widget/performanceLegend',
    { responseType: 'text'});
  }

  getNistCsfSummaryChartWidget() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/widget/nistCsfSummaryChart',
    { responseType: 'text'});
  }

  getNistCsfSummaryReportBodyData() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getNistCsfReportBodyData');
  }

  getMil1PerformanceLegendWidget() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/widget/mil1PerformanceLegend',
    { responseType: 'text'});
  }

  getMil1PerformanceBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getCrrMil1PerformanceBodyCharts');
  }

  /**
   * Calls the api to get CrrPerformanceAppendixA Data
   */
   getCrrPerformanceAppendixA() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/widget/GetCrrPerformanceAppendixA');
  }

  getNistCsfCatPerformanceBodyData() {
    return this.http.get(this.configSvc.apiUrl + 'reportscrr/getNistCsfCatPerformanceBodyData');
  }

}
