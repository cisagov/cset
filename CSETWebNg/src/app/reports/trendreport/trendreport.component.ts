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
import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { ReportService } from '../../../app/services/report.service';
import { Title } from '@angular/platform-browser';
import { AggregationService } from '../../../app/services/aggregation.service';
import { ChartService } from '../../../app/services/chart.service';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../services/config.service';


@Component({
  selector: 'trendreport',
  templateUrl: './trendreport.component.html',
  styleUrls: ['../reports.scss']
})

export class TrendReportComponent implements OnInit, AfterViewChecked {
  response: any;

  // Charts for Components
  chartOverallCompl: Chart;
  chartTop5: Chart;
  chartBottom5: Chart;
  chartCategoryPercent: Chart;

  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  warningCount = 0;

  answerCounts: any[] = null;

  numberOfStandards = -1;

  pageInitialized = false;

  // FIPS SAL answers
  nistSalC = '';
  nistSalI = '';
  nistSalA = '';

  // ACET data
  DocumentationTotal: number;

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService,
    public configSvc: ConfigService
  ) { }


  ngOnInit() {
    this.titleService.setTitle("Trend Report - " + this.configSvc.behaviors.defaultTitle);
    var aggId: number = +localStorage.getItem("aggregationId");
    this.reportSvc.getAggReport('trendreport', aggId).subscribe(
      (r: any) => {
        this.response = r;

        // Break out any CIA special factors now - can't do a find in the template
        let v: any = this.response.nistTypes.find(x => x.cia_Type === 'Confidentiality');
        if (!!v) {
          this.nistSalC = v.justification;
        }
        v = this.response.nistTypes.find(x => x.cia_Type === 'Integrity');
        if (!!v) {
          this.nistSalI = v.justification;
        }
        v = this.response.nistTypes.find(x => x.cia_Type === 'Availability');
        if (!!v) {
          this.nistSalA = v.justification;
        }
      },
      error => console.log('Trend report load Error: ' + (<Error>error).message)
    );

    // Populate charts
    // Overall Compliance
    this.aggregationSvc.getOverallComplianceScores(aggId).subscribe((x: any) => {
      this.chartOverallCompl = this.chartSvc.buildLineChart('canvasOverallCompliance', x);
    });

    // Assessment Answer Summary - tabular data
    this.aggregationSvc.getAnswerTotals(aggId).subscribe((x: any) => {
      this.answerCounts = x;
    });

    // Top 5
    this.aggregationSvc.getTrendTop5(aggId).subscribe((x: any) => {
      this.chartTop5 = this.chartSvc.buildLineChart('canvasTop5', x);
    });

    // Bottom 5
    this.aggregationSvc.getTrendBottom5(aggId).subscribe((x: any) => {
      this.chartBottom5 = this.chartSvc.buildLineChart('canvasBottom5', x);
    });

    // Category Percentage Comparison
    this.aggregationSvc.getCategoryPercentageComparisons(aggId).subscribe((x: any) => {
      this.chartCategoryPercent = this.chartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
      (<HTMLElement>this.chartCategoryPercent.canvas.parentNode).style.height = this.chartSvc.calcHbcHeightPixels(x);
    });
  }

  ngAfterViewChecked() {

  }
}
