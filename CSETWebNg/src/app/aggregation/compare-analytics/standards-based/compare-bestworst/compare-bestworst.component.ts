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
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-compare-bestworst',
  templateUrl: './compare-bestworst.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareBestworstComponent implements OnInit {

  categories: any;

  currentCategory: any;
  chartAnswerBreakdown: Chart;

  constructor(
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService
  ) { }

  ngOnInit() {
    this.loadPage();
  }

  loadPage() {
    this.loadCategoryList();
  }

  loadCategoryList() {
    this.aggregationSvc.getBestToWorst().subscribe((x: any) => {
      this.categories = x;
      this.selectCategory(this.categories[0]);
    });
  }

  public selectCategory(cat: any) {
    this.currentCategory = cat;

    // create chart data skeleton
    const chartConfig = {
      labels: [],
      datasets: [
        { label: 'Yes', data: [], backgroundColor: "#28A745" },
        { label: 'No', data: [], backgroundColor: "#DC3545" },
        { label: 'Not Applicable', data: [], backgroundColor: "#007BFF" },
        { label: 'Alternate', data: [], backgroundColor: "#FFC107" },
        { label: 'Unanswered', data: [], backgroundColor: "#CCCCCC" }
      ]
    };

    // populate chart data object 
    cat.assessments.forEach(a => {
      chartConfig.labels.push(a.assessmentName);

      const ds = chartConfig.datasets;
      ds.find(x => x.label === 'Yes').data.push(a.yesValue);
      ds.find(x => x.label === 'No').data.push(a.noValue);
      ds.find(x => x.label === 'Not Applicable').data.push(a.naValue);
      ds.find(x => x.label === 'Alternate').data.push(a.alternateValue);
      ds.find(x => x.label === 'Unanswered').data.push(a.unansweredValue);
    });

    if (this.chartAnswerBreakdown) {
      this.chartAnswerBreakdown.destroy();
    }
    this.chartAnswerBreakdown = this.chartSvc.buildStackedHorizBarChart('canvasAnswerBreakdown', chartConfig);
  }
}
