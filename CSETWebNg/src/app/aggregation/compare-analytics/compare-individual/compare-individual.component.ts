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
import { NavigationAggregService } from '../../../services/navigationAggreg.service';
import { AggregationService } from '../../../services/aggregation.service';
import { AggregationChartService, ChartColors } from '../../../services/aggregation-chart.service';

@Component({
  selector: 'app-compare-individual',
  templateUrl: './compare-individual.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareIndividualComponent implements OnInit {

  answerCounts: any[] = null;
  chartOverallComparison: Chart;
  chartCategoryPercent: Chart;
  sals: any;

  constructor(
    public navSvc: NavigationAggregService,
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {
    this.populateCharts();
  }

  populateCharts() {
    const aggregationId = this.aggregationSvc.id();

    // Assessment Answer Summary - tabular data
    this.aggregationSvc.getAnswerTotals().subscribe((x: any) => {
      // 
      this.answerCounts = x;
    });


    // Overall Comparison
    this.aggregationSvc.getOverallComparison().subscribe((x: any) => {      

      // apply visual attributes
      const chartColors = new ChartColors();
      x.datasets.forEach((ds: any) => {
        ds.backgroundColor = chartColors.getNextBluesBarColor();
        ds.borderColor = ds.backgroundColor;
      });

      this.chartOverallComparison = this.aggregChartSvc.buildHorizBarChart('canvasOverallComparison', x, true);
    });


    // Comparison of Security Assurance Levels (SAL)
    this.aggregationSvc.getSalComparison().subscribe((x: any) => {
      this.sals = x;
    });


    // Category Percentage Comparison
    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartCategoryPercent = this.aggregChartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
    });
  }
}
