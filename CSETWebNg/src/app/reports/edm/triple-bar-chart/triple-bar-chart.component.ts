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
import { Component, OnInit, Input, OnChanges } from '@angular/core';
import { EDMBarChartModel } from '../edm-bar-chart.model';


@Component({
  selector: 'edm-triple-bar-chart',
  templateUrl: './triple-bar-chart.component.html',
  styleUrls: ['../../reports.scss', './triple-bar-chart.component.scss']
})
export class EDMTripleBarChart implements OnInit, OnChanges {

  @Input() bar_chart_data: EDMBarChartModel;

  @Input() showLegend = false;

  total_count: number;
  green_percent: number;

  constructor() {

  }

  ngOnInit(): void {
    this.configureChart()
  }
  ngOnChanges(): void {
    this.configureChart()
  }
  configureChart() {
    this.total_count =
      this.bar_chart_data.red +
      this.bar_chart_data.yellow +
      this.bar_chart_data.green
    if (this.bar_chart_data.unanswered) {
      this.total_count += this.bar_chart_data.unanswered
    }
    if (this.total_count != 0) {
      this.green_percent = Math.round(this.bar_chart_data.green / this.total_count * 100)
    } else {
      this.green_percent = 0;
    }

  }

  getBarHeight(input) {
    let height = 0;
    if (this.total_count == 0) {
      height = 0
    } else {
      height = Math.round(input / this.total_count * 100)
    }
    let val = {
      height: `${height}%`
    }
    return val

  }

  showLegendText(): boolean {
    if (this.showLegend) {
      return true;
    }
  }
}
