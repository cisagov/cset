////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-analysis-network-components',
  templateUrl: './analysis-network-components.component.html',
  styleUrls: ['../reports.scss']
})
export class AnalysisNetworkComponentsComponent implements OnInit {

  // Charts for Components
  componentCount = 0;
  chartComponentSummary: Chart;
  chartComponentsTypes: Chart;
  warningCount = 0;
  chart1: Chart;
  tempChart: Chart;

  numberOfStandards = -1;

  constructor(
    private analysisSvc: ReportAnalysisService
  ) { }

  ngOnInit(): void {
    // Component Summary
    this.analysisSvc.getComponentSummary().subscribe(x => {
      setTimeout(() => {
        this.chartComponentSummary = <Chart>this.analysisSvc.buildComponentSummary('canvasComponentSummary', x);
      }, 0);
    });


    this.tempChart = Chart.getChart('canvasComponentTypes');
    if(this.tempChart){
      this.tempChart.destroy();
    }
    // Component Types (stacked bar chart)
    this.analysisSvc.getComponentTypes().subscribe(x => {
      this.componentCount = x.labels.length;
      setTimeout(() => {
        this.chartComponentsTypes = this.analysisSvc.buildComponentTypes('canvasComponentTypes', x);
      }, 0);
    });
  }
}