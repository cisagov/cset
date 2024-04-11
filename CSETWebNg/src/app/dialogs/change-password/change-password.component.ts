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
import { ChangeDetectionStrategy, ChangeDetectorRef, Component, Inject, OnInit } from '@angular/core';
import { NgForm } from '@angular/forms';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { ChangePassword } from '../../models/reset-pass.model';
import { AuthenticationService } from '../../services/authentication.service';
import { BehaviorSubject, Observable } from 'rxjs';
import { TranslocoService } from '@ngneat/transloco';
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-change-password',
  templateUrl: './change-password.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' },
  styleUrls: ['./change-password.component.scss'],
  changeDetection: ChangeDetectionStrategy.OnPush
})
export class ChangePasswordComponent implements OnInit {
  message = '';
  warning = false;
  cpwd: ChangePassword = {};
  forceChangePassword = false;
  showPassword = false;

  private _passwordContainsNumbers: BehaviorSubject<boolean> = new BehaviorSubject<boolean>(false);
  public passwordContainsNumbers: Observable<boolean> = this._passwordContainsNumbers.asObservable();

  msgChangeTempPw = this.tSvc.translate('change password.change temp on logon');
  check = true;
  passwordResponse: any = {
    passwordLengthMin: 13,
    passwordLengthMax: 50,
    numberOfHistoricalPasswords: 24,
    passwordLengthMet: false,
    passwordContainsNumbers: false,
    passwordContainsLower: false,
    passwordContainsUpper: false,
    passwordContainsSpecial: false,
    passwordNotReused: false
  };

  constructor(private auth: AuthenticationService,
    private configSvc: ConfigService,
    public tSvc: TranslocoService,
    public dialogRef: MatDialogRef<ChangePasswordComponent>,
    private ref: ChangeDetectorRef,
    @Inject(MAT_DIALOG_DATA) public data: { primaryEmail: string; warning: boolean }) {
    this.cpwd.primaryEmail = data.primaryEmail;
    this.cpwd.appName = this.configSvc.installationMode;
    this.cpwd.currentPassword = '';
    this.cpwd.newPassword = '';

    this.warning = data.warning;
  }

  /**
   *
   */
  ngOnInit() {
    if (this.warning) {
      this.message = this.msgChangeTempPw;
    }
  }

  /**
   *
   */
  onPasswordChangeClick(fReg: NgForm): void {
    if (this.cpwd.newPassword !== this.cpwd.confirmPassword) {
      return;
    }

    this.auth.changePassword(this.cpwd).subscribe(
      (response: any) => {
        this.passwordResponse = JSON.parse(response);

        if (this.passwordResponse.isValid) {
          this.dialogRef.close(true);
        } else {
          this.warning = true;
          this.message = this.tSvc.translate('change password.' + this.passwordResponse.message);
          this.ref.detectChanges();
        }
      },
      error => {
        this.warning = true;
        this.message = error.error;
        this.ref.detectChanges();
      });
  }

  /**
   *
   */
  checkPassword(event) {
    const temp: ChangePassword = {
      newPassword: event ?? '',
      currentPassword: this.cpwd.currentPassword,
      primaryEmail: this.cpwd.primaryEmail,
      appName: this.cpwd.appName
    };

    this.auth.checkPassword(temp).subscribe(
      (response: any) => {
        this.passwordResponse = JSON.parse(response);
        this.warning = !this.passwordResponse.isValid;
        this.ref.detectChanges();
      },
      error => {
        this.warning = true;
        this.message = error.error;
        this.ref.detectChanges();
      }
    );
  }

  /**
   *
   */
  cancel() {
    this.dialogRef.close();

    // if canceling out of a change TEMP password, navigate back to the login
    // but if cancelling out of a NON-TEMP password change, don't do anything.
    if (this.warning && this.message === this.msgChangeTempPw) {
      this.auth.logout();
    }
  }

  /**
   *
   */
  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }
}
