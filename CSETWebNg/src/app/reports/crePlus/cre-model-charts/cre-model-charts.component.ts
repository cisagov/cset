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
  selector: 'app-cre-model-charts',
  templateUrl: './cre-model-charts.component.html',
  styleUrls: ['../../reports.scss'],
  standalone: false,
})
export class CreModelChartsComponent implements OnInit {

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  modelId: number;


  // chart models
  distribModel: any[];
  domainDistrib: any[];
  domainList: any[];



  /**
   * CTOR
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
    this.modelId = +this.route.snapshot.params['m'];


    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;


      setTimeout(() => {
        const titleKey = `reports.core.cre.chart reports.${this.modelId}.title`;
        var title = this.tSvc.translate(titleKey, { defaultTitle: this.configSvc.behaviors.defaultTitle });
        this.titleService.setTitle(title);
      }, 500);
    });

    this.distribModel = await this.buildAllDistrib([this.modelId]);
    this.domainDistrib = await this.buildDomainDistrib([this.modelId]);
    this.domainList = await this.getFullModel(this.modelId);
  }

  /**
   * 
   */
  async buildAllDistrib(modelIds: number[]): Promise<any[]> {
    const resp = await firstValueFrom(this.creSvc.getAllAnswerDistrib([...modelIds])) || [];

    // translate the answer labels
    var opts = this.configSvc.getModuleBehavior(modelIds[0]).answerOptions;

    resp.forEach(element => {
      const key = opts?.find(x => x.code === element.name)?.buttonLabelKey.toLowerCase() ?? 'u';
      element.name = this.tSvc.translate('answer-options.labels.' + key);
    });

    return resp;
  }

  /**
   * 
   */
  async buildDomainDistrib(modelIds: number[]): Promise<any[]> {
    let resp = await firstValueFrom(this.creSvc.getDomainAnswerDistrib([...modelIds])) || [];

    // translate the answer labels
    var opts = this.configSvc.getModuleBehavior(modelIds[0]).answerOptions;

    resp.forEach(element => {
      element.series.forEach(series => {
        const key = opts?.find(x => x.code === series.name)?.buttonLabelKey.toLowerCase() ?? 'u';
        series.name = this.tSvc.translate('answer-options.labels.' + key);
      });
    });

    return resp;
  }

  /**
   * Get the full answer distrib object from the API
   */
  async getFullModel(modelId: number): Promise<any[]> {
    let resp = await firstValueFrom(this.creSvc.getDistribForModel(modelId)) || [];

    // translate the answer labels
    var opts = this.configSvc.getModuleBehavior(modelId).answerOptions;
    resp.forEach(x => {
      x.subgroups.forEach(element => {
        element.series.forEach(element => {
          const key = opts?.find(x => x.code === element.name)?.buttonLabelKey.toLowerCase() ?? 'u';
          element.name = this.tSvc.translate('answer-options.labels.' + key);
        });
      });
    });

    return resp;
  }
}
