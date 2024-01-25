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
  AssessmentDetail,
  MaturityModel
} from '../models/assessment-info.model';
import { map } from 'rxjs/operators';
const headers = {
  headers: new HttpHeaders().set("Content-Type", "application/json"),
  params: new HttpParams()
};


@Injectable({
  providedIn: 'root'
})

export class TsaService {
  public assessment: AssessmentDetail;
  public selectedStandards: string[] = [];
  // static currentMaturityModelName: string;
  static currentTSAModelName: string;
  // assessmentDetail is what i need
  domains: any[];

  // Array of Options for Consideration
  ofc: any[];


  cmmcData = null;

  /**
   *
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) { }
  /**
   * Posts the current selections to the server.
   */
  TSAtogglecrr(assessment: AssessmentDetail) {
    this.assessment = assessment;
    return this.http
      .post<MaturityModel>(
        this.configSvc.apiUrl + "tsa/togglecrr",
        JSON.stringify(assessment),
        headers
      );
  }

  TSAtogglerra(assessment: AssessmentDetail) {
    this.assessment = assessment;
    return this.http.post<MaturityModel>(
      this.configSvc.apiUrl + "tsa/togglerra",
      JSON.stringify(assessment),
      headers
    )
  }
  TSAtogglevadr(assessment: AssessmentDetail) {
    this.assessment = assessment;
    return this.http.post<MaturityModel>(
      this.configSvc.apiUrl + "tsa/togglevadr",
      JSON.stringify(assessment),
      headers
    )
  }

  TSAtogglestandard(assessment: AssessmentDetail) {
    this.assessment = assessment;
    this.selectedStandards = assessment.standards;
    return this.http.post(
      this.configSvc.apiUrl + "tsa/togglestandard",
      JSON.stringify(assessment),
      headers

    ).pipe(map(resp => {

      for (const key in resp) {
        this.selectedStandards.push(key);
      }
      return this.selectedStandards;
    }))
  }
  /**
 * Posts the current selections to the server.
 */
  postSelections(selections: string[]) {
    return this.http.post(
      this.configSvc.apiUrl + "tsa/standard",
      selections,
      headers

    )
  }
  TSAGetModelsName() {
    return this.http.get(this.configSvc.apiUrl + 'tsa/getModelsName');

  }
}
