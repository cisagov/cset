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
import { HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Router } from '@angular/router';
import { Aggregation } from '../models/aggregation.model';

@Injectable()
export class AggregationService {

  private apiUrl: string;

  /**
   * Contains 'TREND' or 'COMPARE'
   */
  public mode: string;

  public currentAggregation: Aggregation;

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
    this.currentAggregation = null;
  }


  id(): number {
    return +localStorage.getItem('aggregationId');
  }


  /**
   * Returns the singluar or plural name for the aggretation type.
   * @param plural
   */
  modeDisplay(plural: boolean) {
    if (!this.mode) {
      return '';
    }

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


  /**
   *
   * @param id
   */
  loadAggregation(id: number) {
    this.getAggregationToken(id).then(() => {
      this.getAggregation().subscribe((agg: any) => {
        this.currentAggregation = agg;
        this.router.navigate(['/alias-assessments', id]);
      });
    });
  }


  /**
   *
   * @param aggId
   */
  getAggregationToken(aggId: number) {
    return this.http
      .get(this.configSvc.apiUrl + 'auth/token?aggregationId=' + aggId)
      .toPromise()
      .then((response: { token: string }) => {
        localStorage.removeItem('userToken');
        localStorage.setItem('userToken', response.token);
        if (aggId) {
          localStorage.removeItem('aggregationId');
          localStorage.setItem(
            'aggregationId',
            aggId ? aggId.toString() : ''
          );
        }
      });
  }


  getAggregation() {
    return this.http.post(this.apiUrl + 'get', '');
  }


  updateAggregation() {
    const agg = this.currentAggregation;
    const aggForSubmit = {
      aggregationId: agg.aggregationId,
      aggregationName: agg.aggregationName.substring(0, 99),
      aggregationDate: agg.aggregationDate
    };
    return this.http.post(this.apiUrl + 'update', aggForSubmit);
  }


  deleteAggregation(id: any) {
    return this.http.post(this.apiUrl + 'delete?aggregationId=' + id, '');
  }


  getAssessments() {
    return this.http.post(this.apiUrl + 'getassessments', '');
  }


  saveAssessmentSelection(selected: boolean, assessment: any) {
    return this.http.post(this.apiUrl + 'saveassessmentselection',
      { selected: selected, assessmentId: assessment.assessmentId });
  }


  saveAssessmentAlias(assessment: any, aliasData: any[]) {
    return this.http.post(this.apiUrl + 'saveassessmentalias',
      { aliasAssessment: assessment, assessmentList: aliasData }, { responseType: 'text' });
  }

  getAnswerTotals(aggId) {
    return this.http.post(this.apiUrl + 'analysis/getanswertotals?aggregationID=' + aggId, '');
  }

  getMaturityAnswerTotals(aggId) {
    return this.http.post(this.apiUrl + 'analysis/getmaturityanswertotals?aggregationID=' + aggId, '');
  }



  ////////////////////////////////  Trend  //////////////////////////////////

  getOverallComplianceScores(aggId) {
    return this.http.post(this.apiUrl + 'analysis/overallcompliancescore', { aggregationID: aggId });
  }

  getTrendTop5(aggId) {
    return this.http.post(this.apiUrl + 'analysis/top5', { aggregationID: aggId });
  }

  getTrendBottom5(aggId) {
    return this.http.post(this.apiUrl + 'analysis/bottom5', { aggregationID: aggId });
  }

  getCategoryPercentageComparisons(aggId) {
    return this.http.post(this.apiUrl + 'analysis/categorypercentcompare?aggregationID=' + aggId, {});
  }



  ////////////////////////////////  Compare  //////////////////////////////////

  getOverallAverageSummary(aggId: number) {
    return this.http.post(this.apiUrl + 'analysis/overallaverages?aggregationID=' + aggId, {});
  }

  getOverallComparison() {
    return this.http.post(this.apiUrl + 'analysis/overallcomparison', {});
  }

  getStandardsAnswers() {
    return this.http.post(this.apiUrl + 'analysis/standardsanswers', {});
  }

  getComponentsAnswers() {
    return this.http.post(this.apiUrl + 'analysis/componentsanswers', {});
  }

  getCategoryAverages(aggId) {
    return this.http.post(this.apiUrl + 'analysis/categoryaverages?aggregationID=' + aggId, {});
  }

  getAggregationMaturity(aggId) {
    return this.http.get(this.apiUrl + 'analysis/maturity/compliance?aggregationId=' + aggId, {});
  }


  getMissedQuestions() {
    return this.http.post(this.apiUrl + 'getmissedquestions', {});
  }

  getSalComparison() {
    return this.http.post(this.apiUrl + 'analysis/salcomparison', {});
  }

  getBestToWorst() {
    return this.http.post(this.apiUrl + 'analysis/getbesttoworst', '');
  }

  getMaturityMissedQuestions() {
    return this.http.post(this.apiUrl + 'getmaturitymissedquestions', {});
  }

  getMaturityBestToWorst() {
    return this.http.post(this.apiUrl + 'analysis/getmaturitybesttoworst', '');
  }


  //////////////////////////////// Merge //////////////////////////////////////

  getMergeSourceAnswers() {
    return this.http.post(this.apiUrl + 'getanswers', '');
  }

  setMergeAnswer(answerId: number, answerText: string) {
    return this.http.post(this.apiUrl + 'setmergeanswer?answerId=' + answerId + '&answerText=' + answerText, null);
  }
}
