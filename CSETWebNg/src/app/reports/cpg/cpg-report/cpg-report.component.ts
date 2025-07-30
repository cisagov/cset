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
import { ConfigService } from '../../../services/config.service';
import { CpgService } from '../../../services/cpg.service';
import { SsgService } from '../../../services/ssg.service';
import { TranslocoService } from '@jsverse/transloco';
import { Demographic } from '../../../models/assessment-info.model';
import { DemographicService } from '../../../services/demographic.service';
import { firstValueFrom } from 'rxjs';

@Component({
  selector: 'app-cpg-report',
  templateUrl: './cpg-report.component.html',
  styleUrls: ['./cpg-report.component.scss', '../../reports.scss'],
  standalone: false
})
export class CpgReportComponent implements OnInit {
  loading = false;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  modelId: number;
  techDomain: string | undefined;


  answerDistribByDomain: any;

  answerDistribByDomainOt: any[];
  answerDistribByDomainIt: any[];

  isSsgApplicable = false;
  ssgBonusModel: number | null = null;


  /**
   * 
   */
  constructor(
    public titleSvc: Title,
    private assessSvc: AssessmentService,
    public demoSvc: DemographicService,
    public cpgSvc: CpgService,
    public ssgSvc: SsgService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService
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

      this.assessSvc.assessment = assessmentDetail;

      this.modelId = assessmentDetail.maturityModel.modelId;

      if (this.modelId == 11) {
        this.initCpg1();
      }

      if (this.modelId == 21) {
        this.initCpg2();
      }

      this.isSsgApplicable = this.ssgSvc.doesSsgApply();
      this.ssgBonusModel = this.ssgSvc.ssgBonusModel();
    });

    this.tSvc.selectTranslate('core.cpg.report.cpg report', {}, { scope: 'reports' })
      .subscribe(title =>
        this.titleSvc.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle));

    var demog: Demographic = await firstValueFrom(this.demoSvc.getDemographic());
    this.techDomain = demog.techDomain;
  }

  /**
   * 
   */
  async initCpg1() {
    this.answerDistribByDomain = await this.getDistribForTechDomain(this.modelId, '');
  }

  /**
   * 
   */
  async initCpg2() {
    this.answerDistribByDomainOt = await this.getDistribForTechDomain(this.modelId, 'OT');
    this.answerDistribByDomainIt = await this.getDistribForTechDomain(this.modelId, 'IT');
  }

  /**
   * 
   */
  async getDistribForTechDomain(modelId: number, techDomain: string): Promise<any> {
    const resp = await firstValueFrom(this.cpgSvc.getAnswerDistrib(modelId, techDomain));
    const cpgAnswerOptions = this.configSvc.getModuleBehavior('CPG').answerOptions;

    resp.forEach(r => {
      r.series.forEach(element => {
        if (element.name == 'U') {
          element.name = this.tSvc.translate('answer-options.labels.u');
        } else {
          const key = cpgAnswerOptions?.find(x => x.code == element.name)?.buttonLabelKey;
          element.name = this.tSvc.translate('answer-options.labels.' + key?.toLowerCase());
        }
      });
    });

    return resp;
  }
}
