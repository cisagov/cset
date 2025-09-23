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
import { CreService } from '../../../../../../services/cre.service';
import { ConfigService } from '../../../../../../services/config.service';
import { AssessmentService } from '../../../../../../services/assessment.service';
import { ReportService } from '../../../../../../services/report.service';
import { QuestionsService } from '../../../../../../services/questions.service';
import { TranslocoService } from '@jsverse/transloco';
import { Title } from '@angular/platform-browser';
import { firstValueFrom } from 'rxjs';


@Component({
  selector: 'app-cre-detail-report',
  templateUrl: './cre-detail-report.component.html',
  styleUrls: ['../../reports.scss', './cre-detail-report.component.scss'],
  standalone: false,
})
export class CreDetailReportComponent implements OnInit {

  title: string;

  assessmentName: string;
  assessmentDate: string;
  assessorName: string;
  facilityName: string;
  selfAssessment: boolean;

  // chart models
  domainList22: any[];
  domainList23: any[];
  domainList24: any[];

  allResponsesDataMil: any[];

  barStackedConfig: any = {
    margin: { top: 20, right: 120, bottom: 40, left: 120 },
    width: 750,
    barHeight: 32,
    barPadding: 8,
    groupPadding: 40,
    colors: []
  };


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
    public tSvc: TranslocoService
  ) { }

  /**
   * 
   */
  async ngOnInit(): Promise<void> {
    const titleKey = 'core.cre.charts.detail.title';
    this.tSvc.selectTranslate(titleKey, {}, 'reports').subscribe(t => {
      this.title = t;
      this.titleService.setTitle(this.title);
    });

    this.assessSvc.getAssessmentDetail().subscribe((assessmentDetail: any) => {
      this.assessmentName = assessmentDetail.assessmentName;
      this.assessmentDate = assessmentDetail.assessmentDate;
      this.assessorName = assessmentDetail.facilitatorName;
      this.facilityName = assessmentDetail.facilityName;
      this.selfAssessment = assessmentDetail.selfAssessment;
    });

    this.domainList22 = await this.getFullModel(22);
    this.domainList23 = await this.getFullModel(23);
    this.domainList24 = await this.getFullModel(24);

    this.allResponsesDataMil = this.prepMilForGroupedStacked(this.domainList24);
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

  /**
   * Convert the domain/mil/series data for consumption
   * by the big grouped stacked chart
   */
  prepMilForGroupedStacked(d: any[]) {
    if (!d) return [];

    type ItemType = { group: string, bars: { name: string, series: any }[] };

    const data: { group: string; bars: any[] }[] = [];

    d.forEach(x => {
      const domain: ItemType = { group: x.name, bars: [] };
      data.push(domain);

      x.subgroups.forEach(sg => {
        const series: { [key: string]: number } = {};
        sg.series.forEach(item => {
          series[item.name] = item.value;
        });

        domain.bars.push({ name: sg.name, series: series });
      });
    });

    return data;
  }

  /**
   * Calculates a height for the chart based on how many bars are in it 
   * and how long the labels are.
   */
  calcStackedHeight(items) {
    if (items == null) {
      return 300;
    }

    let h = items.length * 40 + 15;

    return h;
  }

  /**
   * Calculates a padding value for the chart based on how many bars are in it
   */
  calcStackedPadding(items) {
    return Math.max(10, 20 - items.length);
  }
}
