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
import { Answer, IntegrityCheckOption } from '../models/questions.model';
import { BehaviorSubject } from "rxjs";
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};



@Injectable({
  providedIn: 'root'
})
export class CisService {

  public baselineAssessmentId?: number;

  /**
   * This list holds the optionIds for all of the possible inconsistent CIS options.
   */
  public integrityCheckOptions: IntegrityCheckOption[] = [];

  /**
   *
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public assessSvc: AssessmentService
  ) { }

  /**
   *
   */
  getCisSection(sectionId: Number) {
    return this.http.get(this.configSvc.apiUrl + 'maturity/nested/questions?sectionId=' + sectionId);
  }

  getIntegrityCheckOptions() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cis/integritycheck');
  }

  /**
   *
   */
  getCisSectionScoring() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cis/sectionscoring');
  }

  /**
   *
   */
  getMyCisAssessments() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cis/mycisassessments');
  }

  /*
  * Get deficiency report data
  */
  getDeficiencyData() {
    return this.http.get(this.configSvc.apiUrl + 'maturity/cis/getDeficiency');
  }

  /**
   * Persists the selected baseline assessment.
   */
  saveBaseline(baselineId: any) {
    var b = +baselineId;
    this.baselineAssessmentId = b;
    var baseline = Number.isNaN(b) ? "0" : b.toString();
    localStorage.setItem("baseline", baseline);
    return this.http.post(this.configSvc.apiUrl + 'maturity/cis/baseline', b);
  }


  /**
   * Sends a single answer to the API to be persisted.
   */
  storeAnswer(answer: Answer, sectionId: number) {
    answer.questionType = localStorage.getItem('questionSet');
    const answers = [];
    answers.push(answer);
    return this.http.post(this.configSvc.apiUrl + 'answerquestions?sectionId=' + sectionId, answers, headers);
  }

  /**
   * Sends a group of answers to the API to be persisted.
   */
  storeAnswers(answers: Answer[], sectionId: number) {
    return this.http.post(this.configSvc.apiUrl + 'answerquestions?sectionId=' + sectionId, answers, headers);
  }


  /// The service can emit the score that is given to it
  cisScore$: BehaviorSubject<number> = new BehaviorSubject(0);
  changeScore(s: number) {
    this.cisScore$.next(s);
  }

  /**
   *
   */
  hasBaseline(): boolean {
    let baseline = localStorage.getItem("baseline");
    if (baseline && baseline != "0") {
      return true;
    }
    return false;
  }

  /**
   * Tells the API to replace the current assessment's
   * answers with answers from the source assessment.
   */
  importSurvey(current: number, source: number) {
    var req = {
      dest: current,
      source: source
    };
    return this.http.post(this.configSvc.apiUrl + 'maturity/cis/importsurvey', req, headers);
  }
}
