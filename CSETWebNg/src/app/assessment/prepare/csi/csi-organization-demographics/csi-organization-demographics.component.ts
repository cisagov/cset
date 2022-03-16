////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { AssessmentDetail } from './../../../../models/assessment-info.model';
import { Component, OnInit } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';

@Component({
  selector: 'app-csi-organization-demographics',
  templateUrl: './csi-organization-demographics.component.html',
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CsiOrganizationDemographicsComponent implements OnInit {

  assessment: AssessmentDetail = {};

  motivationCrr: boolean;
  motivationCrrDescription?: string;
  motivationRrap: boolean;
  motivationRrapDescription?: string;
  motivationOrganizationRequest: boolean;
  motivationOrganizationRequestDescription?: string;
  motivationLawEnforcementRequest: boolean;
  motivationLawEnforcementRequestDescription?: string;
  motivationDirectThreats: boolean;
  motivationDirectThreatsDescription?: string;
  motivationSpecialEvent: boolean;
  motivationSpecialEventDescription?: string
  motivationOther: boolean;
  motivationOtherDescription?: string;

  constructor(private assessSvc: AssessmentService) { }

  ngOnInit(): void {
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
    }
  }

  /**
   *
   */
   update(e) {
    this.assessSvc.updateCsiOrganizationDemographics(this.assessment);
  }

}
