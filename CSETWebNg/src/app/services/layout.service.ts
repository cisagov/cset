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
import { BreakpointObserver, Breakpoints } from '@angular/cdk/layout';
import { AuthenticationService } from './authentication.service';


@Injectable({
  providedIn: 'root'
})
export class LayoutService {

  /**
   * handsetPortrait
   */
  hp = false;


  routesWithHiddenHeader = [
    '/home/login',
    '/home/login-access',
    '/home/reset-pass',
    '/home/login/eject',
    '/home/privacy-warning',
    '/home/privacy-warning-reject'
  ];

  routesWithHiddenFooter = [
    '/home/login',
    '/home/login-access',
    '/home/reset-pass',
    '/home/login/eject',
    '/home/privacy-warning',
    '/home/privacy-warning-reject'
  ];

  /**
   *
   */
  constructor(
    public boSvc: BreakpointObserver,
    private authSvc: AuthenticationService
  ) {
    this.boSvc.observe(Breakpoints.HandsetPortrait).subscribe(hp => {
      this.hp = hp.matches;
    });
  }

  /**
   * Certain routes should not show the header
   */
  isNavHeaderShown(url: string) {
    if (!this.authSvc.userToken() || this.authSvc.userToken() == 'null') {
      return false;
    }

    return this.routesWithHiddenHeader.indexOf(url) < 0;
  }

  /**
   * Certain routes should not show the footer
   */
  isFooterShown(url: string) {
    return this.routesWithHiddenFooter.indexOf(url) < 0;
  }
}
