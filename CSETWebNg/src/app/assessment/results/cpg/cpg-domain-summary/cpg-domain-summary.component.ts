////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { Component, Input, OnChanges, OnInit, SimpleChanges, ViewEncapsulation } from '@angular/core';

@Component({
    selector: 'app-cpg-domain-summary',
    templateUrl: './cpg-domain-summary.component.html',
    styleUrls: ['./cpg-domain-summary.component.scss'],
    standalone: false,
    encapsulation: ViewEncapsulation.None
})
export class CpgDomainSummaryComponent implements OnInit, OnChanges {

  @Input()
  answerDistribByDomain = [];

  chartWidth = 700;
  view = [this.chartWidth, 300];

  xAxisTicks = [0, 25, 50, 75, 100];
  answerDistribColorScheme = { domain: ['#28A745', '#007bff', '#FFC107', '#DC3545', '#c8c8c8'] };


  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes['answerDistribByDomain']) {
      this.resizeChart();
    }
  }

  /**
   * Tries to calculate a reasonable consistent height for the chart 
   * based on the number of bars displayed. 
   */
  resizeChart(): void {
    const barHeight = 32; // appropriate for short non-wrapping domain names like CPG has
    const barGap = 10;
    const ticksHeight = 35;

    let chartHeight = this.answerDistribByDomain.length * barHeight + 
      (this.answerDistribByDomain.length - 1) * barGap +
      ticksHeight;

    this.view = [this.chartWidth, chartHeight];
  }

  /**
   * 
   */
  formatPercent(x: any) {
    return x + '%';
  }
}
