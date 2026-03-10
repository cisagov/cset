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
import { Component, Input, OnChanges, OnInit, SimpleChanges } from '@angular/core';
import { AssessmentService } from '../../../../services/assessment.service';
import { ObservationsService } from '../../../../services/observations.service';
import { ReportService } from '../../../../services/report.service';
import reportListdata from './report-list.json';

@Component({
    selector: 'app-report-list-common',
    templateUrl: './report-list-common.component.html',
    standalone: false
})
export class ReportListCommonComponent implements OnChanges {
  @Input() sectionId: string;

  jsonData: any = reportListdata;;
  reportList: any[] = [];

  constructor(public assessSvc: AssessmentService,
    public observationsSvc: ObservationsService,
    public reportSvc: ReportService
  ) { }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['sectionId']) {
      this.reportList = this.getReportList(this.sectionId);
    }
  }

  getReportList(sectionId: string): any[] {
    const result = this.jsonData.find(item => item.title === sectionId);
    // Check if the result exists and return the reportList or an empty array if not found
    return result ? result.reportList : [];
  }
}
