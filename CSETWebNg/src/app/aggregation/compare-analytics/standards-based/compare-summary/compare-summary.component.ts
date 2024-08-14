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
import { ColorService } from '../../../../services/color.service';

@Component({
  selector: 'app-compare-summary',
  templateUrl: './compare-summary.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CompareSummaryComponent implements OnInit {

  chartOverallAverage: any;
  chartStandardsPie: any;
  chartComponentsPie: any;
  chartCategoryAverage: any;
  catAvgHeight: number;

  assessmentColors: Map<string, string>;

  /**
   *
   */
  constructor(
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService,
    public colorSvc: ColorService
  ) { }

  ngOnInit() {
    this.assessmentColors = new Map<string, string>();
    this.populateCharts();
  }

  populateCharts() {
    const aggId: number = +localStorage.getItem("aggregationId");

    // Overall Average
    this.aggregationSvc.getOverallAverageSummary(aggId).subscribe((x: any) => {

      // apply visual attributes
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#007BFF';
      });

      this.chartOverallAverage = this.chartSvc.buildHorizBarChart('canvasOverallAverage', x, false, true);
    });



    // Standards Answers
    this.aggregationSvc.getStandardsAnswers().subscribe((x: any) => {
      if (x.data.every(item => item === 0)) {
        x.data = [100];
        x.labels = ['No Standards Selected'];
      }

      this.chartStandardsPie = this.chartSvc.buildDoughnutChart('canvasStandardsPie', x);
    });



    // Components Answers
    this.aggregationSvc.getComponentsAnswers().subscribe((x: any) => {
      if (x.data.every(item => item === 0)) {
        x.data = [100];
        x.labels = ['No Assessment Diagrams'];
      }

      this.chartComponentsPie = this.chartSvc.buildDoughnutChart('canvasComponentsPie', x);
    });



    // Category Averages
    this.aggregationSvc.getCategoryAverages(aggId).subscribe((x: any) => {

      // apply visual attributes
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#28A745';
      });

      if (!x.options) {
        x.options = {};
      }
      x.options.maintainAspectRatio = false;

      this.chartCategoryAverage = this.chartSvc.buildHorizBarChart('canvasCategoryAverage', x, false, true);

      if (this.chartCategoryAverage.canvas) {
        (<HTMLElement>this.chartCategoryAverage.canvas.parentNode).style.height = this.chartSvc.calcHbcHeightPixels(x);
      }
    });
  }

  /**
   *
   */
  buildMaturityChart(c, showLegend) {
    c.datasets.forEach(ds => {
      ds.backgroundColor = this.colorSvc.getColorForAssessment(ds.label);
    });


    setTimeout(() => {
      c.chart = this.chartSvc.buildHorizBarChart('canvasMaturityBars-' + c.chartName, c, showLegend, true)
    }, 1000);
  }
}
