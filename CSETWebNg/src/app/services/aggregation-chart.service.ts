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
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Chart } from 'chart.js';


@Injectable()
export class AggregationChartService {

  /**
   * Constructor.
   * @param http
   * @param configSvc
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) { }



  /**
  * Builds a line chart from the aggregation API response.
  * @param canvasId
  * @param x
  */
  buildLineChart(canvasId: string, x: any) {
    const chartColors = new ChartColors();

    // add display characteristics
    for (let i = 0; i < x.datasets.length; i++) {
      const ds = x.datasets[i];
      ds.borderColor = chartColors.getLineColor(i);
      ds.backgroundColor = ds.borderColor;
      ds.pointRadius = 8;
      ds.lineTension = 0;
      ds.fill = false;
    }

    return new Chart(canvasId, {
      type: 'line',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },
      options: {
        maintainAspectRatio: true,
        legend: { position: 'left' },
        tooltips: {
          callbacks: {
            label: ((tooltipItem, data) =>
              data.datasets[tooltipItem.datasetIndex].label + ': '
              + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
          }
        }
      }
    });
  }


  /**
  * Builds a horizontal bar chart from the Dashboard API response.
  * @param canvasId
  * @param x
  */
  buildCategoryPercentChart(canvasId: string, x: any) {
    const chartColors = new ChartColors();

    for (let i = 0; i < x.datasets.length; i++) {
      const ds = x.datasets[i];
      if (ds.label === '') {
        ds.label = 'A';
      }
      ds.borderColor = chartColors.getNextBarColor();
      ds.backgroundColor = ds.borderColor;
    }


    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.categories,
        datasets: x.datasets
      },
      options: {
        maintainAspectRatio: false,
        tooltips: {
          callbacks: {
            label: ((tooltipItem, data) =>
              data.datasets[tooltipItem.datasetIndex].label + ': '
              + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
          }
        }
      }
    });
  }
}

/**
 * A service that supplies colors for charts.
 */
export class ChartColors {
  /**
   * These colors are used for bar charts with multiple assessments.
   */
  colorSequence = [
    '#0000FF',
    '#FFD700',
    '#008000',
    '#6495ED',
    '#006400',
    '#F0E68C',
    '#00008B',
    '#008B8B',
    '#FFFACD',
    '#483D8B',
    '#2F4F4F',
    '#9400D3',
    '#1E90FF',
    '#B22222',
    '#FFFAF0',
    '#228B22',
    '#DAA520',
    '#ADFF2F',
    '#4B0082',
    '#000080'
  ];
  nextSequence: number = -1;

  /**
   * These colors are used for line charts.
   */
  lineColors = [
    '#3e7bc4',
    '#81633f',
    '#9ac04a',
    '#7c5aa6',
    '#38adcc'
  ];

  /**
   * Returns the next color in the sequence.
   * Wraps around when exhausted.
   */
  getNextBarColor() {
    if (this.nextSequence > this.colorSequence.length - 1) {
      this.nextSequence = -1;
    }

    return this.colorSequence[++this.nextSequence];
  }

  /**
   * Returns the specified line color based on position.
   * @param idx
   */
  getLineColor(i: number): string {
    return this.lineColors[i];
  }
}
