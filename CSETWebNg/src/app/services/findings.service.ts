////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { ActionItemText, ActionItemTextUpdate, Observation } from '../assessment/questions/observations/observations.model';
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class ObservationsService {

  constructor(private http: HttpClient, private configSvc: ConfigService) {
  }

  getSubRisks(): any {
    const qstring = this.configSvc.apiUrl + 'GetSubRisks';
    return this.http.get(qstring, headers);
  }

  getImportance(): any {
    const qstring = this.configSvc.apiUrl + 'GetImportance';
    return this.http.get(qstring, headers);
  }

  getObservation(answerId: number, observationId: number, questionId: number, questionType: string) {
    if (answerId == null) { answerId = 0; }
    const qstring = this.configSvc.apiUrl + 'GetObservation?answerId=' + answerId
      + '&observationId=' + observationId + '&questionId=' + questionId + '&questionType=' + questionType;
    return this.http.post(qstring, headers);
  }
  /**
   * retrieves all the discoveries
   */
  getAllDiscoveries(answer_id: number) {
    const qstring = 'AnswerAllDiscoveries?Answer_Id=' + answer_id;
    return this.http.post(this.configSvc.apiUrl + qstring, headers);
  }

  /**
   * retrieves all the discoveries for an assessment
   */
  GetAssessmentObservations() {
    const qstring = 'GetAssessmentObservations';
    return this.http.post(this.configSvc.apiUrl + qstring, headers);
  }

  saveIssueText(actionItem: ActionItemText[], observation_Id: number) {
    const tmp: ActionItemTextUpdate = { actionTextItems: actionItem, observation_Id: observation_Id };
    return this.http.post(this.configSvc.apiUrl + 'SaveIssueOverrideText', tmp, headers);
  }

  /**
   * saves the given discovery
   */
  saveObservation(observation: Observation, cancel?: boolean) {
    if (cancel == null) {
      cancel = false;
    }
    return this.http.post(this.configSvc.apiUrl + 'AnswerSaveObservation?cancel=' + cancel, observation, headers);
  }

  deleteObservation(observationId: number): any {
    return this.http.post(this.configSvc.apiUrl + 'DeleteObservation', observationId, headers);
  }
}
