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
import { AssessmentService } from './../../services/assessment.service';
import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { User } from '../../models/user.model';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { EmailService } from '../../services/email.service';

@Component({
  selector: 'app-email',
  templateUrl: './email.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class EmailComponent implements OnInit {
  showContacts = true;
  contacts: User[];
  subject: string;
  body: string;
  from: User;
  textList = '';
  recipientList = '';

  constructor(
    private assessSvc: AssessmentService,
    private configSvc: ConfigService,
    private auth: AuthenticationService,
    private emailSvc: EmailService,
    private dialog: MatDialogRef<EmailComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.showContacts = this.data.showContacts;
    this.contacts = this.data.contacts;
    this.subject = this.data.subject;
    this.body = this.data.body;
    this.from = { firstName: this.auth.firstName(), lastName: this.auth.lastName(), primaryEmail: this.auth.email(), isPrimaryPoc: false, isSiteParticipant: false };

    for (const c of this.contacts) {
      this.textList += c.primaryEmail;
    }

    // recipientList is used exclusively for the read-only displayed list
    this.recipientList = this.textList;
  }

  send() {
    const sendList = this.emailSvc.getCleanEmailList(this.textList);
    this.emailSvc.sendInvites(this.subject, this.body, sendList).subscribe(
      x => {
        this.dialog.close(x);
      }
    );
  }

  testEmails(evt) {
    switch (evt.keyCode) {
      case 32:
      case 186:
      case 13:
        this.textList = this.emailSvc.makeEmailList(this.textList) + ' ';
        break;
    }
  }

  close() {
    const rval = {};

    for (const c of this.contacts) {
      rval[c.primaryEmail] = false;
    }
    this.dialog.close(rval);
  }

  newAddress() {
    for (const c of this.data.potentialContacts) {
      this.textList += c.primaryEmail + ';';
    }
    this.textList = this.emailSvc.makeEmailList(this.textList);
  }

  addAddress(idx: number) {
    this.contacts[idx].assessmentRoleId = 1;
  }

  removeAddress(idx: number) {
    this.contacts.splice(idx, 1);
  }

}
