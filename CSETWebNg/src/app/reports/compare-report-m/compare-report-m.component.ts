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
import { ReportService } from '../../services/report.service';
import { Title } from '@angular/platform-browser';
import { AggregationService } from '../../services/aggregation.service';
import { ChartService, ChartColors } from '../../services/chart.service';
import { MaturityService } from '../../services/maturity.service';
import Chart from 'chart.js/auto';
import { ConfigService } from '../../services/config.service';
import { ColorService } from '../../services/color.service';
import { QuestionsService } from '../../services/questions.service';


@Component({
  selector: 'compare-report-m',
  templateUrl: './compare-report-m.component.html',
  styleUrls: ['../reports.scss']
})

export class CompareReportMComponent implements OnInit, AfterViewChecked {
  response: any;

  chartOverallAverage: Chart;
  aggSvc: AggregationService;
  chartCategoryAverage: Chart;
  chartCategoryPercent: Chart;
  pageInitialized = false;
  isCmmc: boolean = false;

  answerCounts: any[] = null;
  answerLabels: string[] = [];

  chartsMaturityCompliance: any[];


  constructor(
    public reportSvc: ReportService,
    private titleService: Title,
    public aggregationSvc: AggregationService,
    public questionSvc: QuestionsService,
    public chartSvc: ChartService,
    public colorSvc: ColorService,
    public maturitySvc: MaturityService,
    public configSvc: ConfigService
  ) { }


  ngOnInit() {
    this.titleService.setTitle("Compare Report - " + this.configSvc.behaviors.defaultTitle);
    var aggId: number = +localStorage.getItem("aggregationId");
    this.isCmmc = this.maturitySvc.maturityModelIsCMMC();
    this.reportSvc.getAggReport('compare-report', aggId).subscribe(
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
    this.aggregationSvc.getMaturityAnswerTotals(aggId).subscribe((x: any) => {
      // 
      this.answerCounts = x;

      // build a list of answer options for the table columns
      this.answerLabels = [];
      x[0].answerCounts.forEach(opt => {
        const label = this.questionSvc.answerDisplayLabel(x[0].modelId, opt.answer_Text);
        this.answerLabels.push(label);
      });
    });


    // Maturity Compliance By Model/Domain
    this.aggregationSvc.getAggregationCompliance(aggId).subscribe((resp: any) => {
      let showLegend = true;

      if (!resp.length) {
        showLegend = false;
        resp = [{
          chartName: '',
          labels: ['No Maturity Models Selected'],
          datasets: [{ data: 0 }],
          chart: null
        }];
      }

      this.chartsMaturityCompliance = resp;

      resp.forEach(x => {
        this.buildMaturityChart(x, showLegend);
      });
    });
    // Category Percentage Comparison
    this.aggregationSvc.getCategoryPercentageComparisons(aggId).subscribe((x: any) => {
      this.chartCategoryPercent = this.chartSvc.buildCategoryPercentChart('canvasCategoryPercent', x);
      (<HTMLElement>this.chartCategoryPercent.canvas.parentNode).style.height = this.chartSvc.calcHbcHeightPixels(x);
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
  ngAfterViewChecked() {
  }

}
