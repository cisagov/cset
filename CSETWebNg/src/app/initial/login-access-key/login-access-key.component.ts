////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { LayoutService } from '../../services/layout.service';
import { Utilities } from '../../services/utilities.service';
import { JwtParser } from '../../helpers/jwt-parser';
import { MatDialog } from '@angular/material/dialog';
import { EjectionComponent } from '../../dialogs/ejection/ejection.component';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { AssessmentService } from '../../services/assessment.service';
import { EmailService } from '../../services/email.service';
import { OnlineDisclaimerComponent } from '../../dialogs/online-disclaimer/online-disclaimer.component';
import { ChangePasswordComponent } from '../../dialogs/change-password/change-password.component';
import { PasswordStatusResponse } from '../../models/reset-pass.model';

@Component({
  selector: 'app-login-access-key',
  templateUrl: './login-access-key.component.html',
  styleUrls: ['./login-access-key.component.scss']
})
export class LoginAccessKeyComponent implements OnInit {



  /**
   * The current display mode of the page -- LOGIN or SIGNUP
   */
  mode: string;
  isRunningInElectron: boolean;
  assessmentId: number;
  model: any = {};

  loading = false;
  incorrectEmailOrPassword = false;
  passwordExpired = false;

  private isEjectDialogOpen = false;
  browserIsIE: boolean = false;

  /**
   * The page is in either EMAIL-PASSWORD mode
   * or ACCESS-KEY mode.  This determines which
   * portion of the page displays.
   */
  pageMode = 'EMAIL-PASSWORD';


  // ===========================

  loginAccessKey = '';

  isGenerating = false;
  isKeyGenerated = false;
  generatedKey = '';

  loginAccessKeyFailed = false;

  /**
   *
   */
  constructor(
    public layoutSvc: LayoutService,
    private utilitiesSvc: Utilities,
    private authSvc: AuthenticationService,
    private assessSvc: AssessmentService,
    private emailSvc: EmailService,
    public configSvc: ConfigService,
    private route: ActivatedRoute,
    private router: Router,
    private dialog: MatDialog
  ) {

  }

  /**
   *
   */
  ngOnInit(): void {
    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.isRunningInElectron = this.configSvc.isRunningInElectron;

    // reset login status
    //this.authSvc.logout();
    this.pageMode = 'EMAIL-PASSWORD';

    // default the page as 'login'
    this.mode = 'LOGIN';
    this.checkForEjection(this.route.snapshot.queryParams['token']);

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
  emailValid() {
    return this.emailSvc.validAddress(this.model.email);
  }

  /**
   *
   */
  setMode(newMode: string) {
    this.mode = newMode;
  }

  /**
   * Authenticates the user's email and password.  If they supply
   * valid credentials, the Access Key controls are revealed.
   */
  loginEmailPassword() {
    this.loading = true;
    this.incorrectEmailOrPassword = false;
    this.passwordExpired = false;

    this.authSvc
      .login(this.model.email, this.model.password)
      .subscribe(
        data => {
          this.loading = false;
          this.incorrectEmailOrPassword = false;

          this.checkPasswordReset();

          // show the access key controls
          this.pageMode = 'ACCESS-KEY';

        },
        error => {
          if (error.status === 0) {
            console.log('SERVER UNAVAILABLE');

            this.loading = false;
            this.incorrectEmailOrPassword = false;
            this.dialog.open(AlertComponent, {
              data: { messageText: this.configSvc.config.msgServerNotAvailable }
            });

            return;
          }

          this.loading = false;
          console.log('Error logging in: ' + (<Error>error).message);


          // see if the password is expired
          if (error.error.isPasswordExpired) {
            this.passwordExpired = true;
            return;
          }

          this.incorrectEmailOrPassword = true;
        }
      );
  }

  /**
   *
   */
  checkPasswordReset() {
    this.authSvc.passwordStatus()
      .subscribe((result: PasswordStatusResponse) => {
        if (result) {
          if (!result.resetRequired) {
            this.openPasswordDialog(true);
          }
        }
      });
  }

  openPasswordDialog(showWarning: boolean) {
    if (localStorage.getItem("returnPath")) {
      if (!Number(localStorage.getItem("redirectid"))) {
        this.hasPath(localStorage.getItem("returnPath"));
      }
    }
    this.dialog
      .open(ChangePasswordComponent, {
        width: "300px",
        data: { primaryEmail: this.authSvc.email(), warning: showWarning }
      })
      .afterClosed()
      .subscribe(() => {
        this.checkPasswordReset();
      });
  }

  hasPath(rpath: string) {
    if (rpath != null) {
      localStorage.removeItem("returnPath");
      this.router.navigate([rpath], { queryParamsHandling: "preserve" });
    }
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
        const nowUtcUnix = Math.floor((new Date()).getTime() / 1000)
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
  loginWithAccessKey() {
    this.authSvc.loginWithAccessKey(this.loginAccessKey).subscribe((resp) => {
      localStorage.setItem('accessKey', this.loginAccessKey);
      this.router.navigate(['/home', 'landing-page-tabs']);
    },
      error => {
        this.loginAccessKeyFailed = true;
        localStorage.removeItem('accessKey');
        console.log(error);
      });
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

  showDisclaimer() {
    this.dialog.open(OnlineDisclaimerComponent);
  }

}
