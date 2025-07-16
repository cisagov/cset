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
import { CreService } from '../../../services/cre.service';
import { ConfigService } from '../../../services/config.service';
import { TranslocoService } from '@jsverse/transloco';
import { AssessmentService } from '../../../services/assessment.service';
import { ReportService } from '../../../services/report.service';
import { QuestionsService } from '../../../services/questions.service';
import { Title } from '@angular/platform-browser';
import { ActivatedRoute } from '@angular/router';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-cre-mil-charts-2',
  templateUrl: './cre-mil-charts-2.component.html',
  styleUrls: ['../../reports.scss', './cre-mil-charts-2.component.scss'],
  standalone: false
})
export class CreMilCharts2Component {

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public reportSvc: ReportService,
    public questionsSvc: QuestionsService,
    public configSvc: ConfigService,
    public creSvc: CreService,
    public titleService: Title,
    public tSvc: TranslocoService,
    private route: ActivatedRoute
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {
    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;


      setTimeout(() => {
        const titleKey = `reports.core.cre.mil charts 2.title`;
        var title = this.tSvc.translate(titleKey, { defaultTitle: this.configSvc.behaviors.defaultTitle });
        this.titleService.setTitle(title);
      }, 500);
    });


  }

}
