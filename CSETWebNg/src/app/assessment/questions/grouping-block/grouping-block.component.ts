////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { ModuleBehavior } from '../../../models/module-config.model';


@Component({
  selector: 'app-grouping-block',
  templateUrl: './grouping-block.component.html',
  standalone: false
})
export class GroupingBlockComponent implements OnInit {
  @Input('grouping') grouping!: QuestionGrouping;

  modelId?: number;
  moduleBehavior!: ModuleBehavior;

  HIDEABLE_LEVELS = [0, 1];

  isDomain = false;
  showDomainRemarks = false;

  /**
   *
   */
  constructor(
    public assessSvc: AssessmentService,
    public maturityFilteringService: MaturityFilteringService,
    public matSvc: MaturityService,
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.modelId = this.maturityFilteringService.assesmentSvc.assessment.maturityModel?.modelId;
    this.moduleBehavior = this.configSvc.getModuleBehavior(this.modelId);

    this.grouping.showTitleAsHeading = this.isGroupingNameVisible();

    this.isDomain = this.grouping.groupingType === 'Domain';
    this.showDomainRemarks = this.assessSvc.usesMaturityModel('EDM') || this.assessSvc.usesMaturityModel('CRR');
  }

  /**
   *
   */
  submitTextComment(grouping: QuestionGrouping) {
    const id = grouping.groupingId;
    const strRemark = grouping.domainRemark;
    const remark: MaturityDomainRemarks = {
      group_Id: id,
      domainRemark: strRemark
    };

    this.matSvc.postDomainObservation(remark).subscribe();
  }

  /**
   * Indicates if the grouping name header should be shown.
   * Invisible domains stay invisible.
   */
  isGroupingNameVisible(): boolean {
    // this prevents a group title from being displayed as a header and in the blue expandable box
    if (this.grouping.subGroupings.length == 0) {
      return false;
    }


    // look for a behavior to suppress the grouping name by its type
    if (this.moduleBehavior?.hasOwnProperty('hideTopLevelGroupingName')) {
      if ((this.moduleBehavior.hideTopLevelGroupingName ?? false)
        && this.HIDEABLE_LEVELS.includes(this.grouping.groupingLevel)) {
        return false;
      }
    }

    // the display label that uses this function is reserved for the top-level.  Hide lower levels.
    if (this.grouping.groupingLevel > 1) {
      return false;
    }

    // hide invisible groupings
    if (!this.grouping.visible) {
      return false;
    }

    return true;
  }
}
