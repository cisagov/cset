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
import { AnalysisService } from '../services/analysis.service';
import { ReportService } from '../services/report.service';
import { Title } from '@angular/platform-browser';
import { AggregationService } from  '../../../../../src/app/services/aggregation.service';
import { AggregationChartService } from '../../../../../src/app/services/aggregation-chart.service';


@Component({
  selector: 'rapp-compare',
  templateUrl: './comparereport.component.html'
})
export class CompareReportComponent implements OnInit, AfterViewChecked {
  response: any;

  chartOverallAverage: Chart;
  chartOverallCompl: Chart;
  chartTop5: Chart;
  chartBottom5: Chart;
  chartCategoryPercent: Chart;


  // Charts for Components
  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  warningCount = 0;
  chart1: Chart;

  numberOfStandards = -1;

  pageInitialized = false;

  // FIPS SAL answers
  nistSalC = '';
  nistSalI = '';
  nistSalA = '';


  // ACET data
  DocumentationTotal: number;

  constructor(
    public reportSvc: ReportService,
    private analysisSvc: AnalysisService,
    private titleService: Title,
    public aggregationSvc: AggregationService,
    public aggregChartSvc: AggregationChartService
  ) { }

  ngOnInit() {
    this.titleService.setTitle("Compare Report - CSET");

    this.reportSvc.getReport('comparereport').subscribe(
      (r: any) => {
        this.response = r;

      // Break out any CIA special factors now - can't do a find in the template
      let v: any = this.response.nistTypes.find(x => x.CIA_Type === 'Confidentiality');
      if (!!v) {
        this.nistSalC = v.Justification;
      }
      v = this.response.nistTypes.find(x => x.CIA_Type === 'Integrity');
      if (!!v) {
        this.nistSalI = v.Justification;
      } 
      v = this.response.nistTypes.find(x => x.CIA_Type === 'Availability');
      if (!!v) {
        this.nistSalA = v.Justification;
      }  
    },
    error => console.log('Compare report load Error: ' + (<Error>error).message)
    );

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
  }
  
  ngAfterViewChecked() {

  }
}
