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
import { Component, Input, OnChanges } from '@angular/core';
import { CmuReportModel } from '../../../../models/reports.model';
import { ChartService } from './../../../../services/chart.service';
import { Chart } from 'chart.js';

@Component({
  selector: 'app-crr-percentage-of-practices',
  templateUrl: './crr-percentage-of-practices.component.html',
  styleUrls: ['./../crr-report.component.scss']
})
export class CrrPercentageOfPracticesComponent implements OnChanges {
  @Input() model: CmuReportModel;

  chart: Chart;

  constructor(private chartSvc: ChartService) {}

  ngOnChanges(): void {
    if (this.model) {
      this.chart = this.chartSvc.buildCrrPercentagesOfPracticesBarChart('barChart', this.model.reportChart);
    }
  }
}
