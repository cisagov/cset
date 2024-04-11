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
import { Component, Input, OnInit } from '@angular/core';
import { MaturityDomainRemarks, QuestionGrouping } from '../../../models/questions.model';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { MaturityService } from '../../../services/maturity.service';
import { NCUAService } from '../../../services/ncua.service';
import { QuestionsService } from '../../../services/questions.service';


@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html'
})
export class GroupingBlockComponent implements OnInit {
  @Input('grouping') grouping: QuestionGrouping;

  modelId: number;

  /**
   *
   */
  constructor(
    public assessSvc: AssessmentService,
    public acetFilteringSvc: AcetFilteringService,
    public maturityFilteringService: MaturityFilteringService,
    public matSvc: MaturityService,
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public ncuaSvc: NCUAService
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.modelId = this.maturityFilteringService.assesmentSvc.assessment.maturityModel.modelId;
  }

  /**
   *
   */
  submitTextComment(grouping: QuestionGrouping) {
    const id = grouping.groupingID;
    const strRemark = grouping.domainRemark;
    const remark: MaturityDomainRemarks = {
      group_Id: id,
      domainRemark: strRemark
    };

    this.matSvc.postDomainObservation(remark).subscribe();
  }

  /**
   * Indicates if the grouping is a domain
   */
  isDomain(): boolean {
    return this.grouping.groupingType === 'Domain';
  }

  /**
   * Indicates if the domain label should be shown
   */
  isDomainVisible(): boolean {
    if (!this.isDomain()) {
      return false;
    }

    // ACET domains are always visible
    if (this.maturityFilteringService.assesmentSvc.assessment.maturityModel.modelName == 'ACET') {
      return true;
    }

    if (this.maturityFilteringService.assesmentSvc.assessment.maturityModel.modelName == 'ISE') {
      return false;
    }

    // hide invisible domains
    if (!this.grouping.visible) {
      return false;
    }

    return true;
  }

  /**
   * Indicates if all domain maturity filters have been turned off for the domain
   */
  allDomainMaturityLevelsHidden(): boolean {
    if (this.isDomain() && (!this.assessSvc.isISE())) {
      if (this.acetFilteringSvc.allDomainMaturityLevelsHidden(this.grouping.title)) {
        return true;
      }
    }
    return false;
  }
}