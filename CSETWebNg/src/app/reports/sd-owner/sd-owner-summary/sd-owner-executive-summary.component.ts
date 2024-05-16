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
import { ReportAnalysisService } from '../../../services/report-analysis.service';
import { ReportService } from '../../../services/report.service';
import { Title } from '@angular/platform-browser';
import { AcetDashboard } from '../../../models/acet-dashboard.model';
import { ACETService } from '../../../services/acet.service';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../../services/config.service';
import { AssessmentService } from '../../../services/assessment.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-sd-owner-executive-summary',
  templateUrl: './sd-owner-executive-summary.component.html',
  styleUrls: ['./sd-owner-executive-summary.component.scss']
})
export class SdOwnerExecutiveSummaryComponent {
  response: any;

  chartPercentCompliance: Chart;
  chartStandardsSummary: Chart;
  //canvasStandardResultsByCategory: Chart;
  responseResultsByCategory: any;
  translationSub: any; 

  // Charts for Components
  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  warningCount = 0;
  chart1: Chart;
  tempChart: Chart;

  numberOfStandards = -1;

  pageInitialized = false;

  acetDashboard: AcetDashboard;


  constructor(
    public reportSvc: ReportService,
    public analysisSvc: ReportAnalysisService,
    private titleService: Title,
    public acetSvc: ACETService,
    private assessmentSvc: AssessmentService,
    public configSvc: ConfigService,
    public tSvc: TranslocoService, 
    private translocoService: TranslocoService
  ) { }

  ngOnInit() {

    this.titleService.setTitle("Executive Summary - " + this.configSvc.behaviors.defaultTitle);

    this.translationSub = this.translocoService.selectTranslate('')
        .subscribe(value => 
        this.titleService.setTitle(this.tSvc.translate('reports.core.executive summary.report title') + ' - ' + this.configSvc.behaviors.defaultTitle));

    this.reportSvc.getReport('executive').subscribe(
      (r: any) => {
        this.response = r;
      },
      error => console.log('Executive report load Error: ' + (<Error>error).message)
    );


    this.tempChart = Chart.getChart('canvasComponentTypes');
    if (this.tempChart) {
      this.tempChart.destroy();
    }

    // Component Types (stacked bar chart)
    this.analysisSvc.getComponentTypes().subscribe(x => {
      this.componentCount = x.labels.length;
      setTimeout(() => {
        this.chartComponentsTypes = this.analysisSvc.buildComponentTypes('canvasComponentTypes', x);
      }, 0);
    });
  }

  usesRAC() {
    return !!this.responseResultsByCategory?.dataSets.find(e => e.label === 'RAC');
  }

  ngOnDestroy() {
    this.translationSub.unsubscribe()
}

}