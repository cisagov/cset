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
import { AssessmentService } from '../../../../services/assessment.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { DemographicService } from '../../../../services/demographic.service';
import { ConfigService } from '../../../../services/config.service';
import { AssessmentDemographicsComponent } from '../assessment-demographics/assessment-demographics.component';
import { NCUAService } from '../../../../services/ncua.service';

@Component({
  selector: 'app-assessment-info-cie',
  templateUrl: './assessment-info-cie.component.html'
})
export class AssessmentInfoCieComponent implements OnInit {

  constructor(
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    private demoSvc: DemographicService,
    public ncuaSvc: NCUAService,
    public configSvc: ConfigService
  ) { }

  @ViewChild('demographics') demographics: AssessmentDemographicsComponent;

  ngOnInit() {
    this.demoSvc.id = (this.assessSvc.id());
  }

  /**
   *
   * @returns
   */
  isDisplayed(): boolean {
    let isStandard = this.assessSvc.assessment?.useStandard;
    let isNotAcetModel = !(this.assessSvc.usesMaturityModel('ACET'));

    let show = (this.configSvc.installationMode !== "ACET") || isStandard;

    return ((show || isNotAcetModel) && (!this.ncuaSvc.switchStatus));
  }

  /**
   *
   */
  contactsUpdated() {
    this.demographics?.refreshContacts();
  }

  /**
   * Anonymous access mode does not show contacts.  Otherwise
   * defer to the skin's behavior.
   */
  showContacts() {
    if (this.configSvc.config.isRunningAnonymous ?? false) {
      return false;
    }

    return this.configSvc.behaviors?.showContacts ?? true;
  }
}
