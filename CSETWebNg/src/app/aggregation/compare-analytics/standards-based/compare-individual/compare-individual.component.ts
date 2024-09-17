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
import { AggregationService } from '../../../../services/aggregation.service';
import { ChartService } from '../../../../services/chart.service';
import { Chart } from 'chart.js';
import { ColorService } from '../../../../services/color.service';

@Component({
  selector: 'app-compare-individual',
  templateUrl: './compare-individual.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareIndividualComponent implements OnInit {

  answerCounts: any[] = null;
  chartOverallComparison: Chart;
  chartCategoryPercent: Chart;
  sals: any;

  constructor(
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService,
    public colorSvc: ColorService
  ) { }

  ngOnInit() {
    this.populateCharts();
  }

  populateCharts() {
    const aggregationId = this.aggregationSvc.id();
    var aggId: number = +localStorage.getItem("aggregationId");
    // Assessment Answer Summary - tabular data
    this.aggregationSvc.getAnswerTotals(aggId).subscribe((x: any) => {
      // 
      this.answerCounts = x;
    });


    // Overall Comparison
    this.aggregationSvc.getOverallComparison().subscribe((x: any) => {

      // apply visual attributes
      x.datasets.forEach((ds: any) => {
        ds.backgroundColor = this.colorSvc.getColorForAssessment(ds.label);
        ds.borderColor = ds.backgroundColor;
      });

      this.chartOverallComparison = this.chartSvc.buildHorizBarChart('canvasOverallComparison', x, true, true);
    });


    // Comparison of Security Assurance Levels (SAL)
    this.aggregationSvc.getSalComparison().subscribe((x: any) => {
      this.sals = x;
    });


    // Category Percentage Comparison
    this.aggregationSvc.getCategoryPercentageComparisons(aggId).subscribe((x: any) => {
      this.chartCategoryPercent = this.chartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
      (<HTMLElement>this.chartCategoryPercent.canvas.parentNode).style.height = this.chartSvc.calcHbcHeightPixels(x);
    });
  }
}
