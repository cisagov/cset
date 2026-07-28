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
import { Component, OnInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { QuestionsService } from '../../services/questions.service';
import { Title } from '@angular/platform-browser';
import { TranslocoService } from '@jsverse/transloco';
import { MaturityService } from '../../services/maturity.service';
import { AssessmentService } from '../../services/assessment.service';
import { AssessmentDetail } from '../../models/assessment-info.model';

@Component({
  selector: 'app-edm-commentsmarked',
  templateUrl: './edm-commentsmarked.component.html',
  styleUrls: ['../reports.scss'],
  standalone: false
})
export class EdmCommentsmarkedComponent implements OnInit {
  response: any;
  info: AssessmentDetail;

  loading: boolean = false;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    private titleService: Title,
    public tSvc: TranslocoService,
    public maturitySvc: MaturityService,
    public assessSvc: AssessmentService
  ) { }

  ngOnInit(): void {
    this.loading = true;

    this.assessSvc.getAssessmentDetail().subscribe(
      (r: AssessmentDetail) => {
        this.info = r;
        const assessmentTitle = r.assessmentName || `assessment-${r.id}`;
        this.tSvc.selectTranslate('launch.edm.4.title', {}, { scope: 'reports' })
          .subscribe(reportTitle =>
            this.titleService.setTitle(`${reportTitle} - ${assessmentTitle}`));
      }
    );
    this.maturitySvc.getReportComments().subscribe(
      (r: any) => {
        this.response = r;
        this.loading = false;
      },
      error => console.error('Comments Marked Report Error: ' + (<Error>error).message)
    );
  }
  getQuestion(q) {
    return q.split(/(?<=^\S+)\s/)[1];
  }
}
