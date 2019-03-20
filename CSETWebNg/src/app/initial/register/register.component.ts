////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { Component, EventEmitter, OnInit, Output } from '@angular/core';
import { ActivatedRoute, Router } from '@angular/router';
import { CreateUser, PotentialQuestions } from '../../models/user.model';
import { AuthenticationService } from '../../services/authentication.service';
import { EmailService } from '../../services/email.service';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { MatDialog } from '@angular/material';
import { ChangeDetectorRef } from '@angular/core';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})

export class RegisterComponent implements OnInit {
  model: CreateUser = {};
  SecurityQuestions: PotentialQuestions[];
  loading = false;
  receivedError = false;
  emailSent = false;
  errorMessage: any;

  constructor(
    private cd: ChangeDetectorRef,
    private auth: AuthenticationService,
    private configSvc: ConfigService,
    private emailSvc: EmailService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.getSecurityList();
  }

  signup() {
    this.receivedError = false;

    // don't send email if they have not provided everything
    if ((!this.model.FirstName || this.model.FirstName.length === 0)
      || (!this.model.LastName || this.model.LastName.length === 0)
      || (!this.model.PrimaryEmail || this.model.PrimaryEmail.length === 0)) {
      this.errorMessage = "* fields are required";
      this.receivedError = true;
      return;
    }
    // save a reference to the dialog - it disappears on error
    const dialogRef = this.dialog;

    // tell the API which app we are, for emailing purposes.
    this.model.AppCode = this.configSvc.config.appCode;

    this.emailSvc.sendCreateUserEmail(this.model).subscribe(
      data => {
        this.emailSent = true;
        this.loading = false;
        this.receivedError = false;
      },
      error => {
        this.emailSent = false;
        this.receivedError = true;
        this.loading = false;
        this.errorMessage = error.error;
        // display the error
        this.dialog = dialogRef;
        this.dialog.open(AlertComponent, {
          data: { messageText: this.errorMessage }
        })
          .afterClosed().subscribe();
        console.log('Error Creating User Account: ' + error.message);
      });
  }

  getSecurityList() {
    this.auth
      .getSecurityQuestionsPotentialList()
      .subscribe(
        (data: PotentialQuestions[]) => {
          this.SecurityQuestions = data;
        },
        error => console.log('Error retrieving security questions: ' + error.message)
      );
  }
}
