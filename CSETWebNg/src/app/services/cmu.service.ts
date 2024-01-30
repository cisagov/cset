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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class CmuService {
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

  constructor(private http: HttpClient, private configSvc: ConfigService) {}

  getCmuModel() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/model');
  }

  /**
   *
   */
  getDomainCompliance() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/domaincompliance');
  }

  /**
   * Get the entire answer distribution for the whole assessment
   */
  getFullAnswerDistribWidget() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/fullanswerdistrib', { responseType: 'text' });
  }

  /**
   * Goal Performance stacked bar charts
   */
  getGoalPerformanceSummaryBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/goalperformance');
  }

  /**
   * Goal Performance individual question heat maps
   */
  getPerformance() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/performance');
  }

  getMil1PerformanceSummaryLegendWidget(configuration = '') {
    return this.http.get(
      this.configSvc.apiUrl + 'cmu/mil1PerformanceSummaryLegend?configuration=' + configuration,
      { responseType: 'text' }
    );
  }

  getPerformanceSummaryBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/getPerformanceSummaryBodyCharts');
  }

  getBlockLegendWidget(includeGoal: boolean) {
    return this.http.get(this.configSvc.apiUrl + `cmu/blocklegend?includeGoal=${includeGoal}`, {
      responseType: 'text'
    });
  }

  getMil1PerformanceLegendWidget(includeGoal: boolean) {
    return this.http.get(this.configSvc.apiUrl + `cmu/mil1performancelegend?includeGoal=${includeGoal}`, {
      responseType: 'text'
    });
  }

  getNistCsfSummaryChartWidget() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/csfsummarywidget', { responseType: 'text' });
  }

  /**
   * Returns SVG markup for the the specified domain abbreviation.
   * Scaling the SVG to 1.5 gives a nice readable chart.
   */
  getDomainHeatmapWidget(domain: string) {
    return this.http.get(this.configSvc.apiUrl + 'cmu/widget/heatmap?domain=' + domain + '&scale=1.5', {
      responseType: 'text'
    });
  }

  getCsf() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/csf');
  }

  getCsfCatSummary() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/csfcatsummary');
  }

  getMil1PerformanceBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/getMil1PerformanceBodyCharts');
  }

  getCsfCatPerf() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/csfcatperf');
  }

  getMil1FullAnswerDistribWidget() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/mil1fullanswerdistrib', { responseType: 'text' });
  }

  getMil1PerformanceSummaryBodyCharts() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/getMil1PerformanceSummaryBodyCharts');
  }

  getNistCsfCatSummaryBodyData() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/csfcatsummary');
  }

  getPerformanceAppendixABodyData() {
    return this.http.get(this.configSvc.apiUrl + 'cmu/getCrrPerformanceAppendixABodyData');
  }
}
