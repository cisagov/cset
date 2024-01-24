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
import { Router } from '../../../../node_modules/@angular/router';
import { NavigationAggregService } from '../../services/navigationAggreg.service';
import { AggregationService } from '../../services/aggregation.service';
import { ChartService } from '../../services/chart.service';
import { AuthenticationService } from '../../services/authentication.service';
import { ConfigService } from '../../services/config.service';
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-trend-analytics',
  templateUrl: './trend-analytics.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class TrendAnalyticsComponent implements OnInit {

  chartOverallCompl: Chart;
  chartTop5: Chart;
  chartBottom5: Chart;
  chartCategoryPercent: Chart;

  constructor(
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService,
    private authSvc: AuthenticationService,
    public navAggSvc: NavigationAggregService,
    public configSvc: ConfigService,
    private router: Router,
  ) { }

  /**
   *
   */
  ngOnInit() {
    this.populateCharts();
    //const aggregationId = this.aggregationSvc.id();
  }

  /**
   * Get the data from the API and build the charts for the page.
   */
  populateCharts() {
    //const aggregationId = this.aggregationSvc.id();
    var aggId: number = +localStorage.getItem("aggregationId");
    // Overall Compliance
    this.aggregationSvc.getOverallComplianceScores(aggId).subscribe((x: any) => {
      this.chartOverallCompl = this.chartSvc.buildLineChart('canvasOverallCompliance', x);
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

  generateReport(reportType: string) {
    const url = '/index.html?returnPath=report/' + reportType;
    window.open(url, "_blank");
  };
}