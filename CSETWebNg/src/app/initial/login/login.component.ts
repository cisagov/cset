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
import { NavigationEnd, Router } from '@angular/router';
import { ConfigService } from '../../services/config.service';
import { Title } from '@angular/platform-browser';
import { Subscription } from 'rxjs';
import { filter } from 'rxjs/operators';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class LoginComponent implements OnInit {

  constructor(
    public configSvc: ConfigService,
    private titleSvc: Title
  ) { 
  }

  ngOnInit() {
    this.titleSvc.setTitle(this.configSvc.config.behaviors.defaultTitle);    
  }

  /**
   * Returns a boolean indicating if the specified skin/installationMode
   * is active.  The case of "ACCESS-KEY" is special; it is based
   * on whether CSET is currently configured to run anonymously.
   */
  show(skin: string) {
    if (skin === 'ACCESS-KEY') {
      return this.configSvc.config.isRunningAnonymous;
    }

    return !this.configSvc.config.isRunningAnonymous 
      && (this.configSvc.installationMode ?? 'CSET') === skin;
  }

  continueStandAlone() {
    // this.router.navigate(['/home']);
  }
}
