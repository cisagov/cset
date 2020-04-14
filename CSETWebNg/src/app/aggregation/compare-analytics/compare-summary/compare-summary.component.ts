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
import { AggregationService } from '../../../services/aggregation.service';
import { AggregationChartService } from '../../../services/aggregation-chart.service';

@Component({
  selector: 'app-compare-summary',
  templateUrl: './compare-summary.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareSummaryComponent implements OnInit {

  chartOverallAverage: Chart;
  chartStandardsPie: Chart;
  chartComponentsPie: Chart;
  chartCategoryAverage: Chart;
  catAvgHeight: number;

  constructor(
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {
    this.populateCharts();
  }

  populateCharts() {
    const aggregationId = this.aggregationSvc.id();

    // Overall Average
    this.aggregationSvc.getOverallAverageSummary().subscribe((x: any) => {

      // apply visual attributes
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#004c75';
        ds.borderColor = '#004c75';
      });

      this.chartOverallAverage = this.aggregChartSvc.buildHorizBarChart('canvasOverallAverage', x, false);
    });



    // Standards Answers
    this.aggregationSvc.getStandardsAnswers().subscribe((x: any) => {
      
      // apply visual attributes
      x.colors = ["#006000", "#990000", "#0063B1", "#B17300", "#CCCCCC"];

      this.chartStandardsPie = this.aggregChartSvc.buildDoughnutChart('canvasStandardsPie', x);
    });



    // Components Answers
    this.aggregationSvc.getComponentsAnswers().subscribe((x: any) => {

      // apply visual attributes
      x.colors = ["#006000", "#990000", "#0063B1", "#B17300", "#CCCCCC"];

      this.chartComponentsPie = this.aggregChartSvc.buildDoughnutChart('canvasComponentsPie', x);
    });



    // Category Averages
    this.aggregationSvc.getCategoryAverages().subscribe((x: any) => {

      // apply visual attributes
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#008a00';
        ds.borderColor = '#008a00';
      });
      
      if (!x.options) {
        x.options = {};
      }
      x.options.maintainAspectRatio = false;   
      
      this.chartCategoryAverage = this.aggregChartSvc.buildHorizBarChart('canvasCategoryAverage', x, false);
      
      (<HTMLElement>this.chartCategoryAverage.canvas.parentNode).style.height = this.aggregChartSvc.calcHbcHeightPixels(x);
    });
  }
}
