////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, Input, OnDestroy, OnInit } from '@angular/core';
import { Subscription } from 'rxjs';
import { ChartService } from '../../../../services/chart.service';
import { ThemeService } from '../../../../services/theme.service';

@Component({
    selector: 'app-cis-scoring-chart',
    templateUrl: './cis-scoring-chart.component.html',
    styleUrls: ['../../../../reports/reports.scss'],
    standalone: false
})
export class CisScoringChartComponent implements OnInit, OnDestroy {

  @Input()
  g: any;

  title: string;

  chartScore: any;

  private themeSubscription: Subscription;

  /**
   *
   */
  constructor(
    public chartSvc: ChartService,
    private themeSvc: ThemeService
  ) { }

  /**
   *
   */
  ngOnInit(): void {
    this.title = this.g.title;
    if (!!this.g.prefix) {
      this.title = this.g.prefix + '. ' + this.g.title;
    }

    setTimeout(() => {
      this.buildChart();
    }, 800);

    // Subscribe to theme changes to rebuild the chart
    this.themeSubscription = this.themeSvc.theme$.subscribe(() => {
      this.buildChart();
    });
  }

  ngOnDestroy(): void {
    if (this.themeSubscription) {
      this.themeSubscription.unsubscribe();
    }
  }

  private buildChart(): void {
    const x = this.g.chart;

    const opts = {
      scales: { y: { display: false } },
      plugins: {
        legend: { position: 'right' }
      }
    };

    this.chartScore = this.chartSvc.buildHorizBarChart('canvasScore-' + this.g.groupingId, x, true, true, opts);
  }

}
