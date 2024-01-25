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
import { ActivatedRoute, Router } from '@angular/router';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { LayoutService } from '../../services/layout.service';
import { Utilities } from '../../services/utilities.service';
import { JwtParser } from '../../helpers/jwt-parser';
import { MatDialog } from '@angular/material/dialog';
import { EjectionComponent } from '../../dialogs/ejection/ejection.component';
import { AssessmentService } from '../../services/assessment.service';
import { ChangePasswordComponent } from '../../dialogs/change-password/change-password.component';
import { AlertComponent } from '../../dialogs/alert/alert.component';

@Component({
  selector: 'app-login-access-key',
  templateUrl: './login-access-key.component.html',
  styleUrls: ['./login-access-key.component.scss']
})
export class LoginAccessKeyComponent implements OnInit {
  skin: string = 'CSET';

  isRunningInElectron: boolean;
  assessmentId: number;
  model: any = {};

  loading = false;
  incorrectEmailOrPassword = false;
  passwordExpired = false;

  private isEjectDialogOpen = false;
  browserIsIE: boolean = false;

  // ===========================

  loginAccessKey = '';

  isGenerating = false;
  isKeyGenerated = false;
  generatedKey = '';

  loginAccessKeyFailed = false;

  title1: object[] = [];
  title2: object[] = [];

  /**
   *
   */
  constructor(
    public layoutSvc: LayoutService,
    private utilitiesSvc: Utilities,
    private authSvc: AuthenticationService,
    private assessSvc: AssessmentService,
    public configSvc: ConfigService,
    private route: ActivatedRoute,
    private router: Router,
    private dialog: MatDialog
  ) {
    this.title1['CSET'] = 'CSET Online';
    this.title2['CSET'] = 'CSET';
    this.title1['TSA'] = 'CSET TSA Online';
    this.title2['TSA'] = 'CSET TSA';
  }

  /**
   *
   */
  ngOnInit(): void {
    this.skin = this.configSvc.installationMode;

    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.isRunningInElectron = this.configSvc.isRunningInElectron;

    // default the page as 'login'
    this.checkForEjection(this.route.snapshot.queryParams['token']);

    this.checkPasswordReset();

    // Clear token query param to make the url look nicer.
    if (this.route.snapshot.queryParams['token']) {
      this.router.navigate([], { queryParams: {} });
    }

    if (this.route.snapshot.params['id']) {
      this.assessmentId = +this.route.snapshot.params['id'];
    }

    this.loginAccessKeyFailed = false;
  }

  /**
   *
   */
  checkForEjection(token: string) {
    if (this.route.snapshot.params['eject']) {
      let minutesSinceExpiration = 0;

      if (token) {
        const jwt = new JwtParser();
        const parsedToken = jwt.decodeToken(token);
        const expTimeUnix = parsedToken.exp;
        const nowUtcUnix = Math.floor(new Date().getTime() / 1000);
        // divide by 60 to convert seconds to minutes
        minutesSinceExpiration = (nowUtcUnix - expTimeUnix) / 60;
      }

      // Only show eject dialog if token has been expired for less than an hour.
      if (!this.isEjectDialogOpen && minutesSinceExpiration < 60) {
        this.isEjectDialogOpen = true;
        this.dialog
          .open(EjectionComponent)
          .afterClosed()
          .subscribe(() => (this.isEjectDialogOpen = false));
      }
    }
  }

  /**
   *
   */
  checkPasswordReset() {
    this.authSvc
      .passwordStatus()
      .subscribe((passwordResetRequired: boolean) => {
        if (passwordResetRequired) {
          this.openPasswordDialog(true);
        }
      });
  }

  openPasswordDialog(showWarning: boolean) {
    if (localStorage.getItem('returnPath')) {
      if (!Number(localStorage.getItem('redirectid'))) {
        this.hasPath(localStorage.getItem('returnPath'));
      }
    }
    this.dialog
      .open(ChangePasswordComponent, {
        width: '300px',
        data: { primaryEmail: this.authSvc.email(), warning: showWarning }
      })
      .afterClosed()
      .subscribe((passwordChangeSuccess) => {
        if (passwordChangeSuccess) {
          this.dialog.open(AlertComponent, {
            data: {
              messageText: 'Your password has been changed successfully.',
              title: 'Password Changed',
              iconClass: 'cset-icons-check-circle'
            }
          });
        } else {
          this.checkPasswordReset();
        }
      });
  }

  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem('returnPath');
      this.router.navigate([rpath], { queryParamsHandling: 'preserve' });
    }
  }

  /**
   * Validate the Access Key to see if the user has access.
   * If valid, route them to the landing page.
   */
  login() {
    this.authSvc.loginWithAccessKey(this.loginAccessKey).subscribe(
      (resp) => {
        localStorage.setItem('accessKey', this.loginAccessKey);
        this.router.navigate(['/home', 'landing-page-tabs']);
      },
      (error) => {
        this.loginAccessKeyFailed = true;
        localStorage.removeItem('accessKey');
        console.log(error);
      }
    );
  }

  /**
   *
   */
  generateKey() {
    this.isGenerating = true;
    this.authSvc.generateAccessKey().subscribe((key: string) => {
      this.generatedKey = key;
      this.loginAccessKey = key;
      this.isGenerating = false;
      this.isKeyGenerated = true;
    });
  }
}
