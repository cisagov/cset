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
import { ConfigService } from './config.service';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { AssessmentService } from './assessment.service';
import {
  AssessmentDetail
} from '../models/assessment-info.model';
import { Observable } from 'rxjs';
import { Router } from '@angular/router';
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class AssessCompareAnalyticsService {
  public assessment: AssessmentDetail;
  public selectedStandards: string[] = [];
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService,
    private router: Router
  ) { }

  analyticsAssessment(assessId: number) {
    this.http.get(
      this.configSvc.apiUrl + "tsa/getAssessmentById",
      headers,
    )
    this.router.navigate(["/assessment-comparison-analytics"], { queryParamsHandling: 'preserve' });
  }

  loadAssessment(id: number) {
    this.getAssessmentToken(id).then(() => {

      this.getAssessmentDetail().subscribe(data => {
        this.assessment = data;
        // const rpath = localStorage.getItem('returnPath');
        this.router.navigate(['/assessment-comparison-analytics']);
      });
    });
  }

  getAssessmentToken(assessId: number) {
    return this.http
      .get(this.configSvc.apiUrl + 'auth/token?assessmentId=' + assessId)
      .toPromise()
      .then((response: { token: string }) => {
        localStorage.removeItem('userToken');
        localStorage.setItem('userToken', response.token);
        if (assessId) {
          localStorage.removeItem('assessmentId');
          localStorage.setItem(
            'assessmentId',
            assessId ? assessId.toString() : ''
          );
        }
      });
  }

  getAssessmentDetail() {
    return this.http.get(this.configSvc.apiUrl + 'assessmentdetail', headers);
  }

  getDashboard(industry: string) {
    return this.http.get(
      this.configSvc.apiUrl +
      "TSA/Dashboard?industry=" +
      industry
      , headers);
  }

  getAssessmentsForUser(arg0: string): Observable<AssessmentsApi> {
    return this.http.get<AssessmentsApi>(
      this.configSvc.apiUrl + "Dashboard/GetAssessmentList?id=" + arg0
      , headers);
  }

  getSectors() {
    return this.http.get(this.configSvc.apiUrl + "TSA/getSectors");
  }

  getStandardList() {
    return this.http.get<any[]>(this.configSvc.apiUrl + 'TSA/getStandardList');
  }

  getSectorIndustryStandardsTSA(sectorId?: number, industryId?: number): any {
    var url = this.http.get(this.configSvc.apiUrl + 'TSA/getSectorIndustryStandardsTSA');
    if (sectorId && industryId) {
      url = this.http.get(this.configSvc.apiUrl + 'TSA/getSectorIndustryStandardsTSA?sectorId=' + sectorId + '&industryId=' + industryId);
    } else if (!sectorId) {
      url = this.http.get(this.configSvc.apiUrl + 'TSA/getSectorIndustryStandardsTSA');
    }
    else if (!industryId && sectorId || sectorId && industryId.toString() == "0: null") {
      url = this.http.get(this.configSvc.apiUrl + 'TSA/getSectorIndustryStandardsTSA?sectorId=' + sectorId);
    }

    return url;
  }

  maturityDashboardByCategory(selectedMaturityModelId: number, sectorId?: number, industryId?: number): any {
    var url
    if (!sectorId) {
      url = this.http.get(this.configSvc.apiUrl + 'TSA/analyticsMaturityDashboard?maturity_model_id=' + selectedMaturityModelId);
    }
    else if (sectorId && !industryId) {
      url = url = this.http.get(this.configSvc.apiUrl + 'TSA/analyticsMaturityDashboard?maturity_model_id=' + selectedMaturityModelId + '&sectorId=' + sectorId);
    } else if (sectorId && industryId) {
      url = url = this.http.get(this.configSvc.apiUrl + 'TSA/analyticsMaturityDashboard?maturity_model_id=' + selectedMaturityModelId + '&sectorId=' + sectorId + '&industryId=' + industryId);
    }
    return url;
  }
}

export interface AssessmentsApi {
  items: any[];
  total_count: number;
}
