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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { CmmcStyleService } from './cmmc-style.service';
import { ConfigService } from './config.service';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class VadrDataService {
  apiUrl: string;
  constructor(public cmmcSvc: CmmcStyleService, private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'reports';

  }

  response: any;
  pageInitialized = false;
  referenceTable: any;

  cmmcModel: any;
  statsByLevel: any;
  statsByDomain: any;
  statsByDomainAtUnderTarget: any;
  stackBarChartData: any;
  complianceLevelAcheivedData: any;
  gridColumnCount = 10
  gridColumns = new Array(this.gridColumnCount);

  public getReport(reportId: string) {
    return this.http.get(this.apiUrl + '/' + reportId);
  }

  public getVADRDetail() {
    return this.http.get(this.apiUrl + '/vadrdetail')
  }

  public getVADRQuestions() {
    return this.http.get(this.apiUrl + '/vadrquestions')
  }
}
