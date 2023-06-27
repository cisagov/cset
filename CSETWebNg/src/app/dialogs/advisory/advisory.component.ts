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
import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ConfigService } from '../../services/config.service';


@Component({
  selector: 'app-advisory',
  templateUrl: './advisory.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AdvisoryComponent {
  appLongName: string;
  appShortName: string;
  orgLongName: string;
  orgShortName: string;
  showIntellectualPropertyRightsAssertion = false;
  intellectualPropertyRightsDistributionRequestEntity: string;


  constructor(
    public configSvc: ConfigService,
    private dialog: MatDialogRef<AdvisoryComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) {

    switch (configSvc.installationMode) {
      case '':
      case 'CSET':
        this.appLongName = 'Cyber Security Evaluation Tool';
        this.appShortName = 'CSET';
        this.orgLongName = 'Cybersecurity & Infrastructure Security Agency';
        this.orgShortName = 'CISA';
        this.showIntellectualPropertyRightsAssertion = true;
        this.intellectualPropertyRightsDistributionRequestEntity = 'the CSET Program Office';
        break; 
      case 'ACET':
        this.appLongName = 'Automated Cybersecurity Evaluation Toolbox';
        this.appShortName = 'ACET';
        this.orgLongName = '';
        this.orgShortName = 'NCUA';
        this.showIntellectualPropertyRightsAssertion = false;
        break;
      case 'TSA':
        this.appLongName = 'Cyber Security Evaluation Tool';
        this.appShortName = 'CSET';
        this.orgLongName = 'Transportation Security Administration';
        this.orgShortName = 'TSA';
        this.showIntellectualPropertyRightsAssertion = false;
        break;
      case 'CF':
        this.appLongName = 'Cyber Security Evaluation Tool';
        this.appShortName = 'CSET';
        this.orgLongName = 'Cyber Florida';
        this.orgShortName = 'CF';
        this.showIntellectualPropertyRightsAssertion = false;
        break;
      case 'RENEW':
        this.appLongName = 'Cyber Security Evaluation Tool';
        this.appShortName = 'CSET Renewables';
        this.orgLongName = 'Idaho National Laboratory';
        this.orgShortName = 'INL';
        this.showIntellectualPropertyRightsAssertion = false;
        break;
      case 'RRA':
        this.appLongName = 'Ransomware Readiness Assessment';
        this.appShortName = 'RRA';
        this.orgLongName = 'Cybersecurity & Infrastructure Security Agency';
        this.orgShortName = 'CISA';
        // this.showIntellectualPropertyRightsAssertion = true;
        // this.intellectualPropertyRightsDistributionRequestEntity = 'the CSET Program Office';
        break;
    }
  }

  close() {
    return this.dialog.close();
  }
}
