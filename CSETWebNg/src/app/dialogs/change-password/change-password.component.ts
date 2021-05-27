////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { NgForm } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { ChangePassword } from '../../models/reset-pass.model';
import { AuthenticationService } from '../../services/authentication.service';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class ChangePasswordComponent implements OnInit {
  message = '';
  warning = false;
  cpwd: ChangePassword = {};
  forceChangePassword = false;
  msgChangeTempPw = 'Temporary password must be changed on first logon.';

  constructor(private auth: AuthenticationService,
    private router: Router,
    public dialogRef: MatDialogRef<ChangePasswordComponent>,
    @Inject(MAT_DIALOG_DATA) public data: { primaryEmail: string; warning: boolean }) {
    this.cpwd.primaryEmail = data.primaryEmail;
    this.warning = data.warning;
  }

  ngOnInit() {
    if (this.warning) {
      this.message = this.msgChangeTempPw;
    }
  }

  onPasswordChangeClick(fReg: NgForm): void {
    if (fReg.valid) {
      this.auth.changePassword(this.cpwd).subscribe(
        (response: any) => {
          console.log('changePassword:');
          console.log(response);
          this.dialogRef.close();
        },
        error => {
          console.log('changePassword error');
          console.log(error);
          this.warning = true;
          this.message = error.error;
        });
    }
  }

  cancel() {
    this.dialogRef.close();

    // if canceling out of a change TEMP password, navigate back to the login
    // but if cancelling out of a NON-TEMP password change, don't do anything.
    if (this.warning && this.message === this.msgChangeTempPw) {
      this.auth.logout();
    }
  }
}

