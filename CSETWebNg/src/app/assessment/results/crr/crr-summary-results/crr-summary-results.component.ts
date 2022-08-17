import { ChartService } from './../../../../services/chart.service';
import { Component, OnInit } from '@angular/core';
import { CrrService } from '../../../../services/crr.service';
import { CrrReportModel } from './../../../../models/report.model';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../../../services/config.service';
import { DomSanitizer, SafeUrl } from '@angular/platform-browser';

@Component({
  selector: 'app-crr-summary-results',
  templateUrl: './crr-summary-results.component.html'
})
export class CrrSummaryResultsComponent implements OnInit {

  chart: Chart;
  summaryResult: any = '';
  stylesheetUrl: SafeUrl;

  chartLoaded: boolean = false;
  summaryResultLoaded: boolean = false;

  constructor(
    private crrSvc: CrrService,
    private chartSvc: ChartService,
    private configSvc: ConfigService,
    private domSanitizer: DomSanitizer
    ) {
  }

  ngOnInit(): void {
    this.stylesheetUrl = this.domSanitizer.bypassSecurityTrustResourceUrl(this.configSvc.reportsUrl + 'css/CRRResults.css');

    this.crrSvc.getCrrModel().subscribe((data: CrrReportModel) => {
      this.chart = this.chartSvc.buildCrrPercentagesOfPracticesBarChart('percentagePractices', data.reportChart)
      this.chartLoaded = true;
    });

    this.crrSvc.getCrrHtml("_CrrResultsSummary").subscribe((data: any) => {
      this.summaryResult = data.html;
      this.summaryResultLoaded = true;
    })
  }
}
