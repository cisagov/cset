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
import { Component, AfterViewInit } from '@angular/core';
import { ChartService } from '../../../../services/chart.service';
import Chart from 'chart.js/auto';
import { CisService } from '../../../../services/cis.service';

@Component({
  selector: 'app-ranked-deficiencty-chart',
  templateUrl: './ranked-deficiencty-chart.component.html',
  styleUrls: ['./ranked-deficiencty-chart.component.scss', '../../../../reports/reports.scss']
})

export class RankedDeficienctyChartComponent implements AfterViewInit {

  rankedChart: Chart;
  loading = true;
  hasBaseline: boolean = false;

  constructor(public chartSvc: ChartService, public cisSvc: CisService) { }

  ngAfterViewInit(): void {
    this.setUpChart();
  }

  setUpChart() {
    if (this.cisSvc.hasBaseline()) {
      this.hasBaseline = true;
      this.cisSvc.getDeficiencyData().subscribe((data: any) => {

        data.option = { options: false };
        var opts = { scales: { x: { position: 'top', min: -100, max: 100 }, x1: { position: 'bottom', min: -100, max: 100 } } };
        this.rankedChart = this.chartSvc.buildHorizBarChart('ranked-deficiency', data, false, false, opts, false);

        this.loading = false;
      });
    } else {
      this.hasBaseline = false;
      this.loading = false;
    }
  }

}
