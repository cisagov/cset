////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { ActionItemText, ActionItemTextUpdate, Observation, ObservationContact } from '../assessment/questions/observations/observations.model';
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Observable } from 'rxjs';
import { AssessmentService } from './assessment.service';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class ObservationsService {
  impliedSave: boolean = false;

  constructor(
    private http: HttpClient, 
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) {}

  getSubRisks(): any {
    const qstring = this.configSvc.apiUrl + 'GetSubRisks';
    return this.http.get(qstring, headers);
  }

  getImportances(): Observable<any> {
    const qstring = this.configSvc.apiUrl + 'importancevalues';
    return this.http.get(qstring, headers);
  }

  getObservation(answerId: number, observationId: number, questionId: number, questionType: string) {
    if (answerId == null) { answerId = 0; }

    const qstring = this.configSvc.apiUrl + 'observation?answerId=' + answerId
      + '&observationId=' + observationId + '&questionId=' + questionId + '&questionType=' + questionType;
    return this.http.get<Observation>(qstring, headers);
  }

  /**
   * Retrieves all assessment-level Observations for an assessment
   */
  getAssessmentLevelObservations() {
    return this.http.get<Observation[]>(this.configSvc.apiUrl + 'observations/assessment-level');
  }

  /**
   * Retrieves all answer-level Observations for an assessment
   */
  getAnswerLevelObservations() {
    return this.http.get<Observation[]>(this.configSvc.apiUrl + 'observations/answer-level');
  }

  /**
   * retrieves all the Observations for an Answer
   */
  getObservationsForAnswer(answer_id: number) {
    const qstring = 'answer/observations?answerId=' + answer_id;
    return this.http.get<Observation[]>(this.configSvc.apiUrl + qstring, headers);
  }


  /**
   * saves the given observation
   */
  saveObservation(observation: Observation, cancel?: boolean, merge?: boolean) {
    if (cancel == null) {
      cancel = false;
    }
    if (merge == null) {
      merge = false;
    }
    return this.http.post(this.configSvc.apiUrl + 'observation/save?cancel=' + cancel + '&merge=' + merge, observation, headers);
  }

  /**
   * deletes the specified observation
   */
  deleteObservation(observationId: number): any {
    return this.http.post(this.configSvc.apiUrl + 'observation/delete', observationId, headers);
  }

  /**
   * Fills the empty observation_Contacts field with front-facing array
   * of contacts assigned to the assessment
   */
  async getContactsForEmptyObservation(): Promise<ObservationContact[]> {
    let observationContacts = [];
    let userContacts = (await this.assessSvc.getAssessmentContacts()).contactList;
    userContacts.forEach(user => {
      observationContacts.push({
        assessment_Contact_Id: user.assessmentContactId,
        name: user.primaryEmail + ' -- ' + user.firstName + ' ' + user.lastName,
        observation_Id: 0,
        selected: false
      });
    });

    return observationContacts;
  }

  /**
   * Fills the empty observation_Contacts field with front-facing array
   * of contacts assigned to the assessment
   */
  // async getContactsForObservation(): Promise<ObservationContact[]> {
  //   let observationContacts = [];
  //   let userContacts = (await this.assessSvc.getAssessmentContacts()).contactList;
  //   userContacts.forEach(user => {
  //     observationContacts.push({
  //       assessment_Contact_Id: user.assessmentContactId,
  //       name: user.primaryEmail + ' -- ' + user.firstName + ' ' + user.lastName,
  //       observation_Id: 0,
  //       selected: true
  //     });
  //   });

  //   return observationContacts;
  // }
}
