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
import { ConfigService } from '../../services/config.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class LoginComponent implements OnInit {

  constructor(public configSvc: ConfigService) { }

  ngOnInit(): void {

    /**
     * If we are at the login page already and the hasUserAgreedToPrivacy warning session storage flag is false or non-existent,
     * don't show the privacy warning to force a second login.
    */
    let hasUserAgreedToPrivacyWarning: string = sessionStorage.getItem('hasUserAgreedToPrivacyWarning');
    if (hasUserAgreedToPrivacyWarning === 'false' || hasUserAgreedToPrivacyWarning === null) {
      sessionStorage.setItem('hasUserAgreedToPrivacyWarning', 'true')
    }
  }

  /**
   * Returns a boolean indicating if the specified skin/installationMode
   * is active.
   */
  show(skin: string) {
    return (this.configSvc.installationMode ?? 'CSET') === skin;
  }
}
