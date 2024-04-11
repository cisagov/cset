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
import { Component, Inject, OnInit } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { CreateUser } from '../../models/user.model';
import { AuthenticationService } from '../../services/authentication.service';
import { SecurityQuestion } from '../../models/reset-pass.model';
import { NgForm } from '@angular/forms';

@Component({
  selector: 'app-edit-user',
  templateUrl: './edit-user.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class EditUserComponent implements OnInit {
  model: CreateUser = {};
  securityQuestions: SecurityQuestion[];

  /**
   * Constructor.
   */
  constructor(
    private dialog: MatDialogRef<EditUserComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any,
    private auth: AuthenticationService
  ) { }

  /**
   * Init.
   */
  ngOnInit() {
    this.getSecurityList();
    this.getUserInformation();
  }

  /**
   *
   */
  getSecurityList() {
    this.auth
      .getSecurityQuestionsPotentialList()
      .subscribe(
        (data: SecurityQuestion[]) => {
          this.securityQuestions = data;
        },
        error => console.log('Error retrieving security questions: ' + error.message)
      );
  }

  /**
   *
   */
  getUserInformation() {
    this.auth.getUserInfo()
      .subscribe(
        (data: CreateUser) => {
          this.model = data;
        },
        error => console.log('Error retrieving security questions: ' + error.message)
      );
  }

  /**
   *
   */
  save(form: NgForm) {
    if (this.model && form.valid) {
      this.auth.updateUser(this.model).subscribe(
        () => {
          this.auth.setUserInfo(this.model)
        },
        error => console.log('Error updating the user information' + error.message)
      );
      this.dialog.close(this.model);
    }
  }

  /**
   *
   */
  cancel() {
    this.dialog.close();
  }
}
