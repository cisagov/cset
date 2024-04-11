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
import { ChartService, ChartColors } from '../../../app/services/chart.service';
import { MaturityService } from '../../services/maturity.service';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../services/config.service';
import { ColorService } from '../../services/color.service';


@Component({
  selector: 'comparereport',
  templateUrl: './comparereport.component.html',
  styleUrls: ['../reports.scss']
})

export class CompareReportComponent implements OnInit, AfterViewChecked {
  response: any;

  chartOverallAverage: Chart;
  aggSvc: AggregationService;
  answerCounts: any[] = null;
  chartCategoryAverage: Chart;
  chartCategoryPercent: Chart;
  pageInitialized = false;
  isCmmc: boolean = false;

  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public aggregationSvc: AggregationService,
    public chartSvc: ChartService,
    public colorSvc: ColorService,
    public maturitySvc: MaturityService,
    public configSvc: ConfigService
  ) { }


  ngOnInit() {
    this.titleService.setTitle("Compare Report - " + this.configSvc.behaviors.defaultTitle);
    var aggId: number = +localStorage.getItem("aggregationId");
    this.isCmmc = this.maturitySvc.maturityModelIsCMMC();
    this.reportSvc.getAggReport('comparereport', aggId).subscribe(
      (r: any) => {
        this.response = r;
      },

      error => console.log('Compare report load Error: ' + (<Error>error).message)
    );

    this.populateCharts(aggId);
  }


  populateCharts(aggId: number) {

    // Overall Average
    this.aggregationSvc.getOverallAverageSummary(aggId).subscribe((x: any) => {

      // Makes the Compliance Summary chart a light blue color instead of grey
      const chartColors = new ChartColors();
      x.datasets.forEach((ds: any) => {
        ds.backgroundColor = chartColors.getNextBluesBarColor();
        ds.borderColor = ds.backgroundColor;
      });
      this.chartOverallAverage = this.chartSvc.buildHorizBarChart('canvasOverallAverage', x, false, true);
    });

    // Assessment Answer Summary - tabular data
    this.aggregationSvc.getAnswerTotals(aggId).subscribe((x: any) => {
      this.answerCounts = x;
    });

    // Category Averages
    this.aggregationSvc.getCategoryAverages(aggId).subscribe((x: any) => {

      // Makes the Category Average chart a nice green color instead of grey
      x.datasets.forEach(ds => {
        ds.backgroundColor = '#008a00';
        ds.borderColor = '#008a00';
      });

      if (!x.options) {
        x.options = {};
      }

      x.options.maintainAspectRatio = false;
      this.chartCategoryAverage = this.chartSvc.buildHorizBarChart('canvasCategoryAverage', x, false, true);
      (<HTMLElement>this.chartCategoryAverage.canvas.parentNode).style.height = this.chartSvc.calcHbcHeightPixels(x);
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
