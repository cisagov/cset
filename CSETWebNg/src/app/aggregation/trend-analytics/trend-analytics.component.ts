////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { NavigationAggregService } from '../../services/navigationAggreg.service';
import { AggregationService } from '../../services/aggregation.service';
import { AggregationChartService } from '../../services/aggregation-chart.service';

@Component({
  selector: 'app-trend-analytics',
  templateUrl: './trend-analytics.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class TrendAnalyticsComponent implements OnInit {

  chartOverallCompl: Chart;
  chartTop5: Chart;
  chartBottom5: Chart;
  chartCategoryPercent: Chart;

  constructor(
    public navSvc: NavigationAggregService,
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {
    // call service to get the big enchilada of data. subscribe(x => { this.populateGraphs(x) });

    this.populateGraphs();
  }

  populateGraphs() {
    // Overall Compliance
    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartOverallCompl = this.aggregChartSvc.buildPercentComplianceChart('canvasOverallCompliance', x);
    });

    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartTop5 = this.aggregChartSvc.buildTop5Chart('canvasTop5', x);
    });

    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartBottom5 = this.aggregChartSvc.buildBottom5Chart('canvasBottom5', x);
    });

    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartCategoryPercent = this.aggregChartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
    });
  }
}
