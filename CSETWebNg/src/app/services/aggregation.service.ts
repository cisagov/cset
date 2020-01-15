////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Router } from '@angular/router';

@Injectable()
export class AggregationService {

  private apiUrl: string;

  public mode: string;

  /**
   * Constructor.
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private router: Router
  ) {
    this.apiUrl = this.configSvc.apiUrl + "aggregation/";
  }


  id(): number {
    return +sessionStorage.getItem('aggregationId');
  }

  /**
   * Returns the singluar or plural name for the aggretation type.
   * @param plural
   */
  modeDisplay(plural: boolean) {
    switch (this.mode.toLowerCase()) {
      case 'trend':
        return plural ? 'Trends' : 'Trend';
      case 'compare':
        return plural ? 'Comparisons' : 'Comparison';
    }
  }


  getList() {
    return this.http.post(this.apiUrl + 'getaggregations?mode=' + this.mode, '');
  }

  /**
   * Calls the API to create a new aggregation record
   */
  createAggregation() {
    return this.http.post(this.apiUrl + 'create?mode=' + this.mode, '');
  }


  newAggregation() {
    this.createAggregation()
      .toPromise()
      .then(
        (response: any) => {
          this.loadAggregation(response.Id);
        },
        error =>
          console.log(
            'Unable to create new assessment: ' + (<Error>error).message
          )
      );
  }


  loadAggregation(id: number) {
    this.getAggregationToken(id).then(() => {
      this.router.navigate(['/alias-assessments', id]);
    });
  }

  getAggregationToken(aggId: number) {
    return this.http
      .get(this.configSvc.apiUrl + 'auth/token?aggregationId=' + aggId)
      .toPromise()
      .then((response: { Token: string }) => {
        sessionStorage.removeItem('userToken');
        sessionStorage.setItem('userToken', response.Token);
        if (aggId) {
          sessionStorage.removeItem('aggregationId');
          sessionStorage.setItem(
            'aggregationId',
            aggId ? aggId.toString() : ''
          );
        }
      });
  }

  getAssessments() {
    return this.http.post(this.apiUrl + 'getassessments?aggregationId=' + this.id(), '');
  }


  saveAssessmentSelection(selected: boolean, assessment: any) {
    return this.http.post(this.apiUrl + 'saveassessmentselection',
      { Selected: selected, AssessmentId: assessment.AssessmentId });
  }





  getMergeSourceAnswers() {
    return this.http.post(this.apiUrl + 'getanswers', '');
  }

  setMergeAnswer(answerId: number, answerText: string) {
    return this.http.post(this.apiUrl + 'setmergeanswer?answerId=' + answerId + '&answerText=' + answerText, null);
  }
}
