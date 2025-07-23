////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { ConfigService } from '../../../services/config.service';
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { ActivatedRoute, Router } from '@angular/router';
import { TranslocoService } from '@jsverse/transloco';

@Component({
  selector: 'app-cre-final-report',
  templateUrl: './cre-final-report.component.html',
  styleUrls: ['../../reports.scss'],
  standalone: false
})
export class CreFinalReportComponent implements OnInit {

  title = 'CISA Cyber Resilience Essentials (CRE+) Final Report';
  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;
  modelId: number;


  constructor(
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService,
    public titleService: Title,
    public route: ActivatedRoute
  ) {

  }

  ngOnInit(): void {
    this.modelId = +this.route.snapshot.params['m'];

    setTimeout(() => {
      this.title = this.tSvc.translate(`reports.core.cre.final reports.${this.modelId}.title`);
      this.titleService.setTitle(this.title);
    }, 500);

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });
  }

 
}
