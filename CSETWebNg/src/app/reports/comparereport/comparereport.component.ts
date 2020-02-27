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
import { Component, OnInit, AfterViewChecked } from '@angular/core';
import { ReportService } from '../../../app/services/report.service';
import { Title } from '@angular/platform-browser';
import { AggregationService } from  '../../../app/services/aggregation.service';
import { AggregationChartService, ChartColors } from '../../../app/services/aggregation-chart.service';


@Component({
  selector: 'comparereport',
  templateUrl: './comparereport.component.html',
  styleUrls: ['../reports.scss']
})

export class CompareReportComponent implements OnInit, AfterViewChecked {
  response: any;

  chartOverallAverage: Chart;
  answerCounts: any[] = null;
  chartCategoryAverage: Chart;
  chartCategoryPercent: Chart;
  pageInitialized = false;

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }


  ngOnInit() {
    this.titleService.setTitle("Compare Report - CSET");

    this.reportSvc.getReport('comparereport').subscribe(
      (r: any) => {
        this.response = r;
    },

    error => console.log('Compare report load Error: ' + (<Error>error).message)
    );

    this.populateCharts();
  }


  populateCharts() {
    // Overall Average
    this.aggregationSvc.getOverallAverageSummary().subscribe((x: any) => {

    // Makes the Compliance Summary chart a light blue color instead of grey
    const chartColors = new ChartColors();
    x.datasets.forEach((ds: any) => {
      ds.backgroundColor = chartColors.getNextBluesBarColor();
      ds.borderColor = ds.backgroundColor;
    });
      this.chartOverallAverage = this.aggregChartSvc.buildHorizBarChart('canvasOverallAverage', x, false);
    });

    // Assessment Answer Summary - tabular data
    this.aggregationSvc.getAnswerTotals().subscribe((x: any) => {
      this.answerCounts = x;
    });

    // Category Averages
    this.aggregationSvc.getCategoryAverages().subscribe((x: any) => {
    
    // Makes the Category Average chart a nice green color instead of grey
        x.datasets.forEach(ds => {
          ds.backgroundColor = '#008a00';
          ds.borderColor = '#008a00';
        });

      if (!x.options) {
        x.options = {};
      }

      x.options.maintainAspectRatio = false;
      this.chartCategoryAverage = this.aggregChartSvc.buildHorizBarChart('canvasCategoryAverage', x, false);
    });

    // Category Percentage Comparison
    this.aggregationSvc.getCategoryPercentageComparisons().subscribe((x: any) => {
      this.chartCategoryPercent = this.aggregChartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
    });
  }
  

  ngAfterViewChecked() {
  }
  
}
