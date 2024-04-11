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
import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { NgbAccordion } from '@ng-bootstrap/ng-bootstrap';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { EjectionComponent } from '../../dialogs/ejection/ejection.component';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { EmailService } from '../../services/email.service';
import { LayoutService } from '../../services/layout.service';
import { JwtParser } from '../../helpers/jwt-parser';
import { OnlineDisclaimerComponent } from '../../dialogs/online-disclaimer/online-disclaimer.component';
import { BreakpointObserver, BreakpointState } from '@angular/cdk/layout';


@Component({
  selector: 'app-login-tsa',
  templateUrl: './login-tsa.component.html',
  styleUrls: ['./login-tsa.component.scss']
})
export class LoginTsaComponent implements OnInit {

  /**
 * The current display mode of the page -- LOGIN or SIGNUP
 */
  mode: string;
  isRunningInElectron: boolean;
  assessmentId: number;
  model: any = {};
  loading = false;
  incorrect = false;
  showPassword = false;
  private isEjectDialogOpen = false;
  browserIsIE: boolean = false;
  showLoginBox: boolean = true;

  @ViewChild('acc') accordion: NgbAccordion;

  /**
   * Constructor
   */
  constructor(
    private route: ActivatedRoute,
    public router: Router,
    public configSvc: ConfigService,
    public layoutSvc: LayoutService,
    private authSvc: AuthenticationService,
    private emailSvc: EmailService,
    private assessSvc: AssessmentService,
    private dialog: MatDialog,
    private breakpointObserver: BreakpointObserver
  ) {
    this.breakpointObserver.observe([
      "(max-width: 1340px)"]).subscribe((result: BreakpointState) => {
        if (result.matches) {
          this.showLoginBox = false;
        } else {
          this.showLoginBox = true;
        }
      })
  }

  /**
   *
   */
  ngOnInit(): void {
    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.isRunningInElectron = this.configSvc.isRunningInElectron;
    if (this.authSvc.isLocal) {
      this.mode = 'LOCAL';
      this.continueStandAlone();
    } else {
      // reset login status
      // default the page as 'login'
      this.mode = 'LOGIN';
      this.checkForEjection(this.route.snapshot.queryParams['token']);
      // Clear token query param to make the url look nicer.
      if (this.route.snapshot.queryParams['token']) {
        this.router.navigate([], { queryParams: {} });
      }
    }
    if (this.route.snapshot.params['id']) {
      this.assessmentId = +this.route.snapshot.params['id'];
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

  emailValid() {
    return this.emailSvc.validAddress(this.model.email);
  }

  setMode(newMode: string) {
    this.mode = newMode;
  }

  /**
   * Logs the user into the system.
   */
  login() {
    this.loading = true;
    this.authSvc
      .login(this.model.email, this.model.password)
      .subscribe(
        data => {
          if (this.assessmentId) {
            this.assessSvc
              .getAssessmentToken(this.assessmentId)
              .then(() =>
                this.router.navigate(['/assessment', this.assessmentId, 'info-tsa'])
              );
          } else if (this.configSvc.isRunningAnonymous) {
            this.router.navigate(['/home', 'login-access'], {
              queryParamsHandling: 'preserve'
            });
          } else {
            this.router.navigate(['/home'], {
              queryParamsHandling: 'preserve'
            });
          }

          this.incorrect = false;
        },
        error => {
          if (error.status === 0) {
            console.log('SERVER UNAVAILABLE');

            this.loading = false;
            this.incorrect = false;
            this.dialog.open(AlertComponent, {
              data: { messageText: this.configSvc.config.msgServerNotAvailable }
            });

            return;
          }

          this.loading = false;
          console.log('Error logging in: ' + (<Error>error).message);
          this.incorrect = true;
        }
      );
  }

  continueStandAlone() {
    this.router.navigate(['/home']);
  }

  refreshWindow() {
    window.location.reload();
  }

  exit() {
    window.close();
  }

  isFooterOpen(): boolean {
    if (!!this.accordion) {
      return this.accordion.isExpanded('footerPanel');
    }
    return false;
  }

  togglePasswordVisibility() {
    this.showPassword = !this.showPassword;
  }

  showDisclaimer() {
    this.dialog.open(OnlineDisclaimerComponent, { data: { publicDomainName: this.configSvc.publicDomainName } });
  }
}
