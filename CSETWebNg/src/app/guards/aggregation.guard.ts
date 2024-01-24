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
import { AggregationService } from '../services/aggregation.service';

@Injectable()
export class AggregationGuard {
  private parser = new JwtParser();

  constructor(
    private router: Router,
    private authSvc: AuthenticationService,
    private aggregationSvc: AggregationService
  ) { }

  canActivateChild(childRoute: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean | Observable<boolean> | Promise<boolean> {
    return this.canActivate(childRoute, state);
  }

  canActivate(route: ActivatedRouteSnapshot, state: RouterStateSnapshot): boolean | Observable<boolean> | Promise<boolean> {

    console.log('AggregationGuard canActivate');
    return true;



    // if (route.params['id'] && !this.authSvc.userToken()) {
    //   this.router.navigate(['/home/login/assessment', route.params['id']]);
    //   return false;
    // }

    // if (route.params['id'] !== this.assessSvc.id()) {
    //   this.assessSvc.getAssessmentToken(route.params['id']).then(() => {
    //     return this.checkToken();
    //   });
    // }

    // if (this.checkToken()) {
    //   return true;
    // }

    // this.router.navigate(['/home/login/assessment', route.params['id']]);
    // return false;
  }

  checkToken() {
    if (this.parser.decodeToken(this.authSvc.userToken()).aggregation
      && this.parser.decodeToken(this.authSvc.userToken()).aggregation === this.aggregationSvc.id()) {
      return true;
    }
    this.router.navigate(['home']);
    return false;
  }
}
