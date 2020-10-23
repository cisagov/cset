////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { CommonModule } from '@angular/common'; 
import { MatDialog } from '@angular/material/dialog';
import { ActivatedRoute, Router } from '@angular/router';
import { AlertComponent } from '../../dialogs/alert/alert.component';
import { EjectionComponent } from '../../dialogs/ejection/ejection.component';
import { AssessmentService } from '../../services/assessment.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import { EmailService } from '../../services/email.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class LoginComponent implements OnInit {
  /**
   * The current display mode of the page -- LOGIN or SIGNUP
   */
  mode: string;
  assessmentId: number;
  model: any = {};
  loading = false;
  incorrect = false;
  private isEjectDialogOpen = false;
  browserIsIE: boolean = false;

  constructor(
    private route: ActivatedRoute,
    private router: Router,
    private configSvc: ConfigService,
    private authenticationService: AuthenticationService,
    private emailSvc: EmailService,
    private assessSvc: AssessmentService,
    private dialog: MatDialog
  ) {}

  ngOnInit() {
    console.log("made it to the login component");
    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);

    this.authenticationService.checkLocal().then(() => {
      if (this.authenticationService.isLocal) {
        this.mode = 'LOCAL';        
        this.continueStandAlone();
      } else {
        // reset login status
        this.authenticationService.logout();

        // default the page as 'login'
        this.mode = 'LOGIN';

        if (this.route.snapshot.params['eject']) {
          sessionStorage.clear();
          if (!this.isEjectDialogOpen) {
            this.isEjectDialogOpen = true;
            this.dialog
              .open(EjectionComponent)
              .afterClosed()
              .subscribe(() => (this.isEjectDialogOpen = false));
          }
        }
      }
      if (this.route.snapshot.params['id']) {
        this.assessmentId = +this.route.snapshot.params['id'];
      }
    });
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
    this.authenticationService
      .login(this.model.email, this.model.password)
      .subscribe(
        data => {
          if (this.assessmentId) {
            this.assessSvc
              .getAssessmentToken(this.assessmentId)
              .then(() =>
                this.router.navigate(['/assessment', this.assessmentId])
              );
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
    console.log("called continue standalone");
    this.router.navigate(['/home']);
  }
}
