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
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { QuestionsNestedService } from '../../../services/questions-nested.service';

@Component({
  selector: 'app-sd-answer-summary-report',
  templateUrl: './sd-answer-summary-report.component.html',
  styleUrls: ['../../reports.scss']
})
export class SdAnswerSummaryReportComponent implements OnInit {
  domains: any[] = [];

  loading = false;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;


  constructor(
    public questionsNestedSvc: QuestionsNestedService,
    public assessSvc: AssessmentService,
    public titleService: Title
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.titleService.setTitle("Answer Summary - Pipeline SD02 Series");
    this.loading = true;

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.creatorName;
      this.facilityName = assessmentDetail.facilityName;
    });

    this.questionsNestedSvc.getSection(0).subscribe((resp: any) => {
      this.domains.push(resp);
      this.loading = false;
    });
  }
}
