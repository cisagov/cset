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
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { Subscription } from 'rxjs';
import { filter } from 'rxjs/operators';
import { AuthenticationService } from '../../services/authentication.service';
import { JwtParser } from '../../helpers/jwt-parser';
import { MatDialog } from '@angular/material/dialog';
import { EjectionComponent } from '../../dialogs/ejection/ejection.component';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class LoginComponent implements OnInit {

  skin: string;

  private isEjectDialogOpen = false;
  browserIsIE: boolean = false;
  isRunningInElectron: boolean;
  assessmentId: number;


  constructor(
    public configSvc: ConfigService,
    private titleSvc: Title,
    public authSvc: AuthenticationService,
    private route: ActivatedRoute,
    private router: Router,
    private dialog: MatDialog
  ) {
  }


  ngOnInit(): void {
    this.skin = this.configSvc.installationMode;
    this.titleSvc.setTitle(this.configSvc.config.behaviors.defaultTitle);

    this.browserIsIE = /msie\s|trident\//i.test(window.navigator.userAgent);
    this.isRunningInElectron = this.configSvc.isRunningInElectron;

    this.checkForEjection(this.route.snapshot.queryParams['token']);

    // Clear token query param to make the url look nicer.
    if (this.route.snapshot.queryParams['token']) {
      this.router.navigate([], { queryParams: {} });
    }

    if (this.route.snapshot.params['id']) {
      this.assessmentId = +this.route.snapshot.params['id'];
    }
  }


  /**
   * Returns a boolean indicating if the specified skin/installationMode
   * is active. 
   */
  show(skin: string) {
    return (this.configSvc.installationMode ?? 'CSET') === skin;
  }

  continueStandAlone() {
    // this.router.navigate(['/home']);
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
}
