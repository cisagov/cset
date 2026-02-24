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
import { Component, OnInit, Inject } from '@angular/core';
import { ObservationsService } from '../../../services/observations.service';
import { AssessmentService } from '../../../services/assessment.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Observation, Importance } from './observations.model';
import { map as lodash_map, filter as lodash_filter } from 'lodash';
import { ConfigService } from '../../../services/config.service';
import { firstValueFrom, Observable } from 'rxjs';

@Component({
  selector: 'app-observations',
  templateUrl: './observation-detail.component.html',
  host: {
    'style': 'max-width: 100%'
  },
  standalone: false
})
export class ObservationDetailComponent implements OnInit {
  observation: Observation;
  importances: Importance[];
  contactsModel: any[];
  answerId: number | null;
  questionId: number | null;
  impliedSave: boolean = false;

  constructor(
    private observationsSvc: ObservationsService,
    private configSvc: ConfigService,
    private dialog: MatDialogRef<ObservationDetailComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Observation,
    public assessSvc: AssessmentService
  ) {
    this.observation = data;
    this.answerId = data.answer_Id;
    this.questionId = data.question_Id;
  }

  /**
   * 
   */
  async ngOnInit() {
    this.observationsSvc.getImportances().subscribe((result: Importance[]) => {
      this.importances = result;
    });

    this.dialog.backdropClick().subscribe(async () => {
      await this.save();
    });

    // makes 'Individuals Responsible' show up initially
    if (this.observation.observation_Contacts.length == 0)
      this.observation.observation_Contacts = await this.observationsSvc.getContactsForEmptyObservation();
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
   */
  cancel() {
    this.dialog.close(false);
  }

  /**
   * 
   */
  async save() {
    this.impliedSave = true;
    this.observation.answer_Id = this.answerId;
    this.observation.question_Id = this.questionId;
    await this.refreshContacts();

    this.observation.answer_Id = this.answerId;
    this.observation.question_Id = this.questionId;

    this.dialog.close(true);
  }

  /**
   * 
   */
  updateImportance(importid) {
    this.observation.importance_Id = importid;
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
  async refreshContacts(): Promise<void> {
    this.observation.answer_Id = this.answerId;
    this.observation.question_Id = this.questionId;

    const resp: any = await firstValueFrom(this.observationsSvc.saveObservation(this.observation));
    if ((this.observation.observation_Id == null || this.observation.observation_Id == 0) && resp.observationId) {
      this.observation.observation_Id = resp.observationId;
    }
    if ((this.observation.answer_Id == null ||this.observation.answer_Id == 0) && resp.answerId) {
      this.observation.answer_Id = resp.answerId;
    }
    if ((this.observation.question_Id == null || this.observation.question_Id == 0) && resp.questionId) {
      this.observation.question_Id = resp.questionId;
    }

    // the question type 
    let tempQType = this.observation.question_Type;
    
    const response: Observation = await firstValueFrom(
      this.observationsSvc.getObservation(
        this.observation.answer_Id,
        this.observation.observation_Id,
        this.observation.question_Id,
        this.observation.question_Type
      )
    );

    this.observation = response;
    this.contactsModel = lodash_map(lodash_filter(this.observation.observation_Contacts,
      { 'selected': true }),
      'Assessment_Contact_Id');

    if (this.observation.question_Type == null) {
      this.observation.question_Type = tempQType;
    }
  }

  /**
   * Using 'sequence' instead of 'contactId' because if the user selects a 
   * previously unselected option, the ID is 0. 
   * If there were multiple unselected options, the first unselected option 
   * was defaulted to because every unselected option had 0 as the ID
   */
  updateContact(contact, sequence) {
    const c = this.observation.observation_Contacts[sequence];
    if (!!c) {
      c.selected = contact.selected;
    }
  }
}
