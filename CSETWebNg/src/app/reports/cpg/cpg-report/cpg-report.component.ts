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
import { ReportService } from '../../../services/report.service';
import { firstValueFrom } from 'rxjs';
import { ScoredDomainDistrib } from '../../models/chart-results.model';
import { AnswerOptionConfig } from '../../../models/module-config.model';

@Component({
  selector: 'app-cpg-report',
  templateUrl: './cpg-report.component.html',
  styleUrls: ['./cpg-report.component.scss', '../../reports.scss'],
  standalone: false
})
export class CpgReportComponent implements OnInit {
  loading = false;

  assessmentName?: string;
  assessmentDate?: string;
  assessorName?: string;
  facilityName?: string;
  selfAssessment?: boolean;

  modelId!: number;
  techDomain: string | undefined;


  answerDistribByDomain: any;

  answerDistribByDomainOt?: any[];
  answerDistribByDomainIt?: any[];

  answerDistribsSsg: SsgDistribution[] = [];

  ssgBonusModelIds?: number[];

  heatmapModelCpg?: any[];
  ssgHeatmaps: { [id: number]: any } = {};




  /**
   * 
   */
  constructor(
    public titleSvc: Title,
    public reportSvc: ReportService,
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
      this.modelId = this.assessSvc.assessment.maturityModel?.modelId ?? 0;

      this.initialize();
    });
  }

  /**
   * 
   */
  async initialize() {
    this.tSvc.selectTranslate('core.cpg.report.cpg report', {}, { scope: 'reports' })
      .subscribe(title => {
        this.titleSvc.setTitle(title + ' - ' + this.configSvc.behaviors.defaultTitle)
      });

    var demog: Demographic = await firstValueFrom(this.demoSvc.getDemographic());
    this.techDomain = demog.techDomain;

    // CPG 1.1
    if (this.modelId == 11) {
      this.initCpg1();
    }

    // CPG 1.2
    if (this.modelId == 21) {
      this.initCpg2();

      this.heatmapModelCpg = await firstValueFrom(this.reportSvc.getHeatmap(21));
    }

    // SSG
    this.initSsg();

  }

  /**
   * 
   */
  async initCpg1(): Promise<void> {
    this.answerDistribByDomain = await this.getAnswerDistribution(this.modelId, '');
  }

  /**
   * 
   */
  async initCpg2(): Promise<void> {
    const [answerDistribByDomainOt, answerDistribByDomainIt] = await Promise.all([
      this.getAnswerDistribution(this.modelId, 'OT'),
      this.getAnswerDistribution(this.modelId, 'IT')
    ]);

    this.answerDistribByDomainOt = answerDistribByDomainOt;
    this.answerDistribByDomainIt = answerDistribByDomainIt;
  }

  /**
   * 
   */
  async initSsg(): Promise<void> {
    this.ssgBonusModelIds = this.ssgSvc.activeSsgModelIds;

    const ssgDistrib$ = this.ssgBonusModelIds.map(async id => {
      const d = await this.getAnswerDistribution(id, '');
      return {
        modelId: id,
        distribution: d
      };
    });
    this.answerDistribsSsg = await Promise.all(ssgDistrib$);


    const ssgHeatmap$ = this.ssgBonusModelIds.map(async id => {
      const scores = await firstValueFrom(this.reportSvc.getHeatmap(id));
      return {
        modelId: id,
        scores: scores
      };
    });
    const hm = await Promise.all(ssgHeatmap$);
    hm.forEach(h => {
      this.ssgHeatmaps[h.modelId] = h.scores;
    });
  }

  /**
   * 
   */
  async getAnswerDistribution(modelId: number, techDomain: string): Promise<any> {
    const resp: ScoredDomainDistrib = await firstValueFrom(this.cpgSvc.getAnswerDistrib(modelId, techDomain));
    const cpgAnswerOptions: AnswerOptionConfig[] | undefined = this.configSvc.getModuleBehavior('CPG').answerOptions;

    resp.distrib.forEach(r => {
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

interface SsgDistribution {
  modelId: number;
  distribution: any[];
}

interface SsgHeatmaps {
  modelId: number;
  scores: any[];
}