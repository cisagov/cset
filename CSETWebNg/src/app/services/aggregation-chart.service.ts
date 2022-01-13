////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import  Chart  from 'chart.js/auto';
import { Utilities } from './utilities.service';


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
    let tempChart = Chart.getChart(canvasId);
    if(tempChart){
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'line',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },
      options: {
        maintainAspectRatio: true,
        plugins:{
          legend: { position: 'left' },
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
                + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
            }
          }
        }
      }
    });
  }

  /**
   *
   * @param canvasId
   * @param x
   * @param showLegend
   */
  buildBarChart(canvasId: string, x: any, showLegend: boolean) {
    if (!x.labels) {
      x.labels = [];
    }
    x.datasets.forEach(ds => {
      if (!ds.label) {
        ds.label = '';
      }
    });
    let tempChart = Chart.getChart(canvasId);
    if(tempChart){
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },
      options: {
        maintainAspectRatio: true,
        responsive: false,
        plugins:{
          legend: { display: showLegend, position: 'top' }
        }
      }
    });
  }

  /**
   * Builds a horizontal bar chart.  The x-axis and tooltips are always formatted as %
   * @param canvasId
   * @param x
   */
  buildHorizBarChart(canvasId: string, x: any, showLegend: boolean) {
    if (!x.labels) {
      x.labels = [];
    }
    x.datasets.forEach(ds => {
      if (!ds.label) {
        ds.label = '';
      }
    });

    let maintainAspectRatio = true;
    if (x.hasOwnProperty('options') && x.options.hasOwnProperty('maintainAspectRatio')) {
      maintainAspectRatio = x.options.maintainAspectRatio;
    }
    let tempChart = Chart.getChart(canvasId);
    if(tempChart){
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },
      options: {
        indexAxis: 'y',
        maintainAspectRatio: maintainAspectRatio,
        responsive: true,
        plugins: {
          legend: { display: showLegend, position: 'top' },
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
                + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
            }
          }
        }
      }
    });
  }

  /**
   * Calculates a good height for a horizontal bar chart
   * based on the number of datasets and data items,
   * i.e., the number of horizontal bars to accommodate.
   * @param x
   */
  calcHbcHeightPixels(x): string {
    // calculate the number of bars in the graph
    let maxDatasetLength = x.datasets[0].data.length;
    // calculate a good height for the chart's container
    let h = maxDatasetLength * x.datasets.length * 20;
    return (h + 50) + "px";
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

    let tempChart = Chart.getChart(canvasId);
    if(tempChart){
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },

      options: {
        indexAxis: 'y',
        maintainAspectRatio: false,
        plugins: {
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
                + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
            }
          }
        }

      }
    });
  }

  /**
   *
   */
  buildStackedHorizBarChart(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if(tempChart){
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },
      options: {
        indexAxis:'y',
        animation: { duration: 100 }, // general animation time
        scales: {
          x: {
            stacked: true
          },
          y: {
            stacked: true
          }
        },
        maintainAspectRatio: false,
        plugins:{
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': '  : ' ')
                + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
            }
          }
       }
      }
    });
  }
}




/**
 * A service that supplies colors for charts.
 */
@Injectable()
export class ChartColors {
  /**
   * These colors are used for bar charts with multiple assessments.
   */
  barColorSequence = [
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
  nextBarSequence: number = -1;

  /**
   * These colors are used for the Overall Comparison chart
   */
  bluesColorSequence = [
    '#B0BFDB',
    '#7E97C2',
    '#4180CB',
    '#386FB3',
    '#295588'
  ];
  nextBluesSequence: number = -1;

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
    if (this.nextBarSequence > this.barColorSequence.length - 1) {
      this.nextBarSequence = -1;
    }

    return this.barColorSequence[++this.nextBarSequence];
  }


  /**
   * Returns the next color in the sequence.
   * Wraps around when exhausted.
   */
  getNextBluesBarColor() {
    if (this.nextBluesSequence > this.bluesColorSequence.length - 1) {
      this.nextBluesSequence = -1;
    }

    return this.bluesColorSequence[++this.nextBluesSequence];
  }


  /**
   * Returns the specified line color based on position.
   * @param idx
   */
  getLineColor(i: number): string {
    return this.lineColors[i];
  }
}
