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
import { Injectable } from '@angular/core';
import { ActivatedRouteSnapshot, Router, RouterStateSnapshot } from '@angular/router';
import { Observable } from 'rxjs';
import { JwtParser } from '../helpers/jwt-parser';
import { AuthenticationService } from '../services/authentication.service';

@Injectable()
export class AuthGuard {
  private parser = new JwtParser();
  private holdItForAMoment = localStorage.getItem('isAPI_together_With_Web');

  /**
   * 
   */
  constructor(
    private router: Router,
    private authSvc: AuthenticationService
  ) { }

  /**
   * 
   */
  canActivateChild(childRoute: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean | Observable<boolean> | Promise<boolean> {
    return this.canActivate(childRoute, state);
  }

  /**
   * 
   */
  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot) {
    if (!this.authSvc.hasUserAgreedToPrivacyWarning()) {
      this.router.navigate(['/home/privacy-warning'], { queryParamsHandling: "preserve" });
      return false;
    }

    if (this.authSvc.userToken()
      && this.parser.decodeToken(this.authSvc.userToken()).userid) {
      return true;
    }

    // check for access key if userid not there
    if (this.authSvc.userToken()
      && this.parser.decodeToken(this.authSvc.userToken()).acckey) {
      return true;
    }

    this.router.navigate(['/home/login'], { queryParamsHandling: "preserve" });
    return false;
  }
}
