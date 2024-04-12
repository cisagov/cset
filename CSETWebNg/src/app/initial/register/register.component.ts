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
import { Component, OnInit } from '@angular/core';
import { CreateUser, PotentialQuestions } from '../../models/user.model';
import { AuthenticationService } from '../../services/authentication.service';
import { EmailService } from '../../services/email.service';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { MatDialog } from '@angular/material/dialog';
import { TranslocoService } from '@ngneat/transloco';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-register',
  templateUrl: './register.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})

export class RegisterComponent implements OnInit {
  model: CreateUser = {};
  SecurityQuestions: PotentialQuestions[];
  loading = false;
  validationError = false;
  emailSent = false;
  waitingForApproval = false;
  errorMessage: any;

  constructor(
    private configSvc: ConfigService,
    private auth: AuthenticationService,
    private emailSvc: EmailService,
    private dialog: MatDialog,
    public tSvc: TranslocoService
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.getSecurityList();
  }

  /**
   * Compiles the user details and posts them to the create endpoint.
   */
  signup() {
    this.validationError = false;

    // don't send email if they have not provided everything
    if ((!this.model.firstName || this.model.firstName.length === 0)
      || (!this.model.lastName || this.model.lastName.length === 0)
      || (!this.model.primaryEmail || this.model.primaryEmail.length === 0)) {
      this.errorMessage = "* " + this.tSvc.translate('user profile.fields required');
      this.validationError = true;
      return;
    }

    // save a reference to the dialog - it disappears on error
    const dialogRef = this.dialog;

    // tell the API which app we are, for emailing purposes.
    this.model.appName = this.configSvc.installationMode;

    this.emailSvc.sendCreateUserEmail(this.model).subscribe(
      data => {
        this.loading = false;
        this.validationError = false;

        if (data == 'created-and-email-sent') {
          this.emailSent = true;
        }
        if (data == 'waiting-for-approval') {
          this.waitingForApproval = true;
        }
      },
      error => {
        this.emailSent = false;
        this.waitingForApproval = false;
        this.validationError = true;
        this.loading = false;

        // translate the error message key
        this.errorMessage = this.tSvc.translate(error.error);

        // display the error
        this.dialog = dialogRef;
        this.dialog.open(AlertComponent, {
          data: { messageText: this.errorMessage }
        })
          .afterClosed().subscribe();
        console.log('Error Creating User Account: ' + error.message);
      });
  }

  /**
   * Gets potential security questions.
   */
  getSecurityList() {
    this.auth
      .getSecurityQuestionsPotentialList()
      .subscribe(
        (data: PotentialQuestions[]) => {
          this.SecurityQuestions = data;
          this.model.securityQuestion1 = data[0].securityQuestion;
        },
        error => console.log('Error retrieving security questions: ' + error.message)
      );
  }
}
