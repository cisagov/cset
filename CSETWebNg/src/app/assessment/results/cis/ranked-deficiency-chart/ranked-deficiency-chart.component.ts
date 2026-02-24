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
import { Component, AfterViewInit, OnDestroy } from '@angular/core';
import { Subscription } from 'rxjs';
import { ChartService } from '../../../../services/chart.service';
import Chart from 'chart.js/auto';
import { CisService } from '../../../../services/cis.service';
import { ThemeService } from '../../../../services/theme.service';

@Component({
    selector: 'app-ranked-deficiency-chart',
    templateUrl: './ranked-deficiency-chart.component.html',
    styleUrls: ['./ranked-deficiency-chart.component.scss', '../../../../reports/reports.scss'],
    standalone: false
})

export class RankedDeficiencyChartComponent implements AfterViewInit, OnDestroy {

  rankedChart: Chart;
  loading = true;
  hasBaseline: boolean = false;
  private chartData: any;
  private themeSubscription: Subscription;

  constructor(
    public chartSvc: ChartService,
    public cisSvc: CisService,
    private themeSvc: ThemeService
  ) { }

  ngAfterViewInit(): void {
    this.setUpChart();

    // Subscribe to theme changes to rebuild the chart
    this.themeSubscription = this.themeSvc.theme$.subscribe(() => {
      if (this.chartData) {
        this.buildChart();
      }
    });
  }

  ngOnDestroy(): void {
    if (this.themeSubscription) {
      this.themeSubscription.unsubscribe();
    }
  }

  setUpChart() {
    if (this.cisSvc.hasBaseline()) {
      this.hasBaseline = true;
      this.cisSvc.getDeficiencyData().subscribe((data: any) => {
        this.chartData = data;
        this.chartData.option = { options: false };
        setTimeout(() => {
          this.buildChart();
          this.loading = false;
        }, 1000);
      });
    } else {
      this.hasBaseline = false;
      this.loading = false;
    }
  }

  private buildChart(): void {
    const opts = {
      scales: {
        x: { position: 'top', min: -100, max: 100 },
        x1: { position: 'bottom', min: -100, max: 100 }
      }
    };
    this.rankedChart = this.chartSvc.buildHorizBarChart('canvas-ranked-deficiency', this.chartData, false, false, opts, false);
  }
}
