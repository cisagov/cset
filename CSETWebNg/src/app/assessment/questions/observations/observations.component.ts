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
import { Component, OnInit, Inject } from '@angular/core';
import { ObservationsService } from '../../../services/observations.service';
import { AssessmentService } from '../../../services/assessment.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Observation, Importance } from './observations.model';
import * as _ from 'lodash';
import { ConfigService } from '../../../services/config.service';

@Component({
  selector: 'app-observations',
  templateUrl: './observations.component.html',
  host: {
    'style': 'max-width: 100%'
  }
})
export class ObservationsComponent implements OnInit {

  observation: Observation;
  importances: Importance[];
  contactsModel: any[];
  answerId: number;
  questionId: number;

  constructor(
    private observationsSvc: ObservationsService,
    private configSvc: ConfigService,
    private dialog: MatDialogRef<ObservationsComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Observation,
    public assessSvc: AssessmentService
  ) {
    this.observation = data;
    this.answerId = data.answer_Id;
    this.questionId = data.question_Id;
  }

  ngOnInit() {
    this.dialog.backdropClick()
      .subscribe(() => {
        this.update();
      });

    // send the observation to the server
    // if it is empty or new let the server
    // worry about it
    this.observationsSvc.getImportance().subscribe((result: Importance[]) => {
      this.importances = result;
      this.observationsSvc.getObservation(this.observation.answer_Id, this.observation.observation_Id, this.observation.question_Id, this.observation.questionType)
        .subscribe((response: Observation) => {
          this.observation = response;
          this.answerId = this.observation.answer_Id;
          this.questionId = this.observation.question_Id;
          this.contactsModel = _.map(_.filter(this.observation.observation_Contacts,
            { 'selected': true }),
            'Assessment_Contact_Id');
          this.data.answer_Id = this.answerId;
        });
    });
  }

  /**
   * 
   */
  showContacts(): boolean {
    if (this.configSvc.config.isRunningAnonymous) {
      return false;
    }

    return true;
  }

  /**
   * 
   */
  refreshContacts(): void {
    this.observation.answer_Id = this.answerId;
    this.observation.question_Id = this.questionId;
    this.observationsSvc.saveObservation(this.observation).subscribe(() => {
      this.observationsSvc.getObservation(this.observation.answer_Id, this.observation.observation_Id, this.observation.question_Id, this.observation.questionType)
      .subscribe((response: Observation) => {
        this.observation = response;
        this.contactsModel = _.map(_.filter(this.observation.observation_Contacts,
          { 'selected': true }),
          'Assessment_Contact_Id');
      });    });
    
  }

  /**
   * 
   */
  clearMulti() {
    this.observation.observation_Contacts.forEach(c => {
      c.selected = false;
    });
  }

  /**
   * 
   * @param obs 
   * @returns 
   */
  checkObservation(obs: Observation) {
    // and a bunch of fields together
    // if they are all null then false
    // else true;
    let observationCompleted = true;

    observationCompleted = (obs.impact == null);
    observationCompleted = (obs.importance == null) && (observationCompleted);
    observationCompleted = (obs.issue == null) && (observationCompleted);
    observationCompleted = (obs.recommendations == null) && (observationCompleted);
    observationCompleted = (obs.resolution_Date == null) && (observationCompleted);
    observationCompleted = (obs.summary == null) && (observationCompleted);
    observationCompleted = (obs.vulnerabilities == null) && (observationCompleted);

    return !obs;
  }

  /**
   * 
   */
  update() {
    this.observation.answer_Id = this.answerId;
    this.observation.question_Id = this.questionId;
    this.observationsSvc.saveObservation(this.observation).subscribe(() => {
      this.dialog.close(true);
    });
  }

  updateImportance(importid) {
    this.observation.importance_Id = importid;
  }

  updateContact(contactid) {
    const c = this.observation.observation_Contacts.find(x => x.assessment_Contact_Id == contactid.assessment_Contact_Id);
    if (!!c) {
      c.selected = contactid.selected;
    }
  }

}
