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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import { ReportService } from '../../services/report.service';
import { Title } from '@angular/platform-browser';
import { MaturityService } from '../../services/maturity.service';
import { QuestionsService } from '../../services/questions.service';
import { ActivatedRoute } from '@angular/router';
import { AssessmentService } from '../../services/assessment.service';
import { AssessmentDetail } from '../../models/assessment-info.model';

@Component({
  selector: 'app-general-deficiency',
  templateUrl: './general-deficiency.component.html',
  styleUrls: ['../reports.scss'],
  standalone: false,
    // eslint-disable-next-line
    host: {
      'class': 'force-light-mode',
      '[attr.data-theme]': '"light"',
      '[attr.data-bs-theme]': '"light"'
    }
})
export class GeneralDeficiencyComponent implements OnInit {

  response: any;
  info: AssessmentDetail;

  moduleName: string;

  loading: boolean = false;

  constructor(
    public analysisSvc: ReportAnalysisService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    private titleService: Title,
    public maturitySvc: MaturityService,
    private route: ActivatedRoute,
    public assessSvc: AssessmentService
  ) { }

  /**
   * 
   */
  ngOnInit() {
    this.loading = true;

    this.route.queryParams.subscribe(params => {
      this.moduleName = params.m;

      this.assessSvc.getAssessmentDetail().subscribe(
        (r: AssessmentDetail) => {
          this.info = r;
          const assessmentTitle = r.assessmentName || `assessment-${r.id}`;
          this.titleService.setTitle(`Deficiency Report - ${this.moduleName} - ${assessmentTitle}`);
        }
      );
      this.maturitySvc.getMaturityDeficiency(this.moduleName).subscribe(
        (r: any) => {
          this.response = r;
          this.loading = false;
        },
        error => console.error('Deficiency Report Error: ' + (<Error>error).message)
      );
    });
  }

  /**
   * 
   */
  getQuestion(q) {
    return q.split(/(?<=^\S+)\s/)[1];
  }
}
