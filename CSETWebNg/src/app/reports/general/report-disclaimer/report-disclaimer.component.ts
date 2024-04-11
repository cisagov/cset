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
import { Component } from '@angular/core';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-report-disclaimer',
  templateUrl: './report-disclaimer.component.html',
  styleUrls: ['./report-disclaimer.component.scss', '../../reports.scss']
})
export class ReportDisclaimerComponent {

  appLongName: string;
  appShortName: string;
  orgLongName: string;
  orgShortName: string;
  showIntellectualPropertyRightsAssertion = false;
  intellectualPropertyRightsDistributionRequestEntity: string;

  /**
   * 
   */
  constructor(
    public configSvc: ConfigService,
    public tSvc: TranslocoService
  ) {
    this.appLongName = this.tSvc.translate(`publisher.${configSvc.installationMode.toLowerCase()}.app long name`);
    this.appShortName = this.tSvc.translate(`publisher.${configSvc.installationMode.toLowerCase()}.app short name`);
    this.orgLongName = this.tSvc.translate(`publisher.${configSvc.installationMode.toLowerCase()}.org long name`);
    this.orgShortName = this.tSvc.translate(`publisher.${configSvc.installationMode.toLowerCase()}.org short name`);
    this.showIntellectualPropertyRightsAssertion = this.tSvc.translate(`publisher.${configSvc.installationMode.toLowerCase()}.show ip rights assertion`);
    this.intellectualPropertyRightsDistributionRequestEntity = this.tSvc.translate(`publisher.${configSvc.installationMode.toLowerCase()}.ip dist`);
  }
}
