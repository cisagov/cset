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
import { Observation, Importance, ObservationContact } from './observations.model';
import { ConfigService } from '../../../services/config.service';
import { firstValueFrom } from 'rxjs';
import { ContactsService } from '../../../services/contacts.service';
import { User } from '../../../models/user.model';

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
  showContacts = true;
  answerId: number | null;
  questionId: number | null;
  impliedSave: boolean = false;

  constructor(
    private observationsSvc: ObservationsService,
    private configSvc: ConfigService,
    private dialog: MatDialogRef<ObservationDetailComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Observation,
    public assessSvc: AssessmentService,
    private contactsSvc: ContactsService
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

    if (this.configSvc.config.isRunningAnonymous) {
      this.showContacts = false;
    }

    // makes 'Individuals Responsible' show up initially
    if (this.observation.observation_Contacts.length == 0) {
      this.observation.observation_Contacts = await this.observationsSvc.getContactsForEmptyObservation();
    }

    // when the contacts list changes, re-draw the Individuals Responsible list accordingly
    this.contactsSvc.contactsUpdated$.subscribe((contacts: User[]) => {
      this.refreshIndividualsResponsible(contacts);
    });
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
    //this.refreshIndividualsResponsible();

    this.observation.answer_Id = this.answerId;
    this.observation.question_Id = this.questionId;

    const resp: any = await firstValueFrom(this.observationsSvc.saveObservation(this.observation));

    this.dialog.close(true);
  }

  /**
   * 
   */
  updateImportance(importid) {
    this.observation.importance_Id = importid;
  }

  /**
   * Build the checklist of Individuals Responsible 
   * based on the latest contact list we have been given.
   */
  refreshIndividualsResponsible(users: User[]) {
    const oldList = this.observation.observation_Contacts;

    this.observation.observation_Contacts = [];
    users.forEach(u => {
      this.observation.observation_Contacts.push({
        assessment_Contact_Id: u.assessmentContactId,
        name: `${u.primaryEmail} -- ${u.firstName} ${u.lastName}`,
        observation_Id: 0,
        selected: oldList.find(x => x.assessment_Contact_Id === u.assessmentContactId)?.selected ?? false
      } as ObservationContact);
    });
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
