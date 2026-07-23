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
import { Component } from '@angular/core';
import { ICellRendererAngularComp } from 'ag-grid-angular';
import { ICellRendererParams } from 'ag-grid-community';

@Component({
  selector: 'app-my-assessments-status-renderer',
  templateUrl: './my-assessments-status-renderer.component.html',
  standalone: false
})
export class MyAssessmentsStatusRendererComponent implements ICellRendererAngularComp {
  params: ICellRendererParams;
  assessment: any;
  percentage = 0;
  reviewFlag = false;
  showProgress = false;
  progressTooltipKey = '';
  progressTooltipParams: Record<string, unknown> = {};

  agInit(params: ICellRendererParams): void {
    this.params = params;
    this.assessment = params.data;
    this.percentage = this.getCompletionPercentage();
    this.reviewFlag = !!(this.assessment.markedForReview || this.assessment.altTextMissing);
    this.showProgress = this.assessment.selectedMaturityModel !== 'CIS';

    if (this.assessment.selectedMaturityModel === 'CIS'
      || this.assessment.selectedMaturityModel === 'SD02 Series'
      || !this.assessment.totalAvailableQuestionsCount) {
      this.progressTooltipKey = 'welcome page.blank assessment';
      this.progressTooltipParams = {};
      return;
    }

    this.progressTooltipKey = 'completion-questions';
    this.progressTooltipParams = {
      complete: this.assessment.completedQuestionsCount,
      total: this.assessment.totalAvailableQuestionsCount,
      qAlias: ''
    };
  }

  refresh(params: ICellRendererParams): boolean {
    this.agInit(params);
    return true;
  }

  private getCompletionPercentage(): number {
    if (!this.assessment.totalAvailableQuestionsCount) {
      return 0;
    }

    return Math.round(
      (this.assessment.completedQuestionsCount / this.assessment.totalAvailableQuestionsCount) * 100
    );
  }
}
