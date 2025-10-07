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
import { Title } from '@angular/platform-browser';
import { AssessmentService } from '../../../services/assessment.service';
import { CisService } from '../../../services/cis.service';
import { MaturityService } from '../../../services/maturity.service';
import { ReportService } from '../../../services/report.service';
import { TranslocoService } from '@jsverse/transloco';
import { AssessmentDetail } from '../../../models/assessment-info.model';

@Component({
  selector: 'app-cis-section-scoring',
  templateUrl: './cis-section-scoring.component.html',
  styleUrls: ['../../../reports/reports.scss'],
  standalone: false
})
export class CisSectionScoringComponent implements OnInit {

  loading = true;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;


  baselineAssessmentName: string;

  myModel: any;
  response: AssessmentDetail;

  /**
   * 
   */
  constructor(
    public maturitySvc: MaturityService,
    public cisSvc: CisService,
    public assessSvc: AssessmentService,
    public titleService: Title,
    public reportSvc: ReportService,
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.loading = true;

    this.assessSvc.getAssessmentDetail().subscribe(
      (r: AssessmentDetail) => {
        this.response = r;
      }
    );

    this.cisSvc.getCisSectionScoring().subscribe((resp: any) => {
      this.myModel = resp.myModel;
      this.loading = false;
    });
  }

}
