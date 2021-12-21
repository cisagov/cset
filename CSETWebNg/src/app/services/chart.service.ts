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
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import Chart from 'chart.js/auto';
import { Utilities } from './utilities.service';
import { Options } from 'selenium-webdriver';

/**
 * The eventual home for one-stop shopping for the various
 * types of Chart.js charts.  
 */
@Injectable({
  providedIn: 'root'
})
export class ChartService {

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService
  ) { }

  /**
   *
   * @param canvasId
   * @param x
   */
  buildDoughnutChart(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }

    // assume that this is an answer distribution pie
    let segmentColors = [];
    let segmentLabels = [];
    x.labels.forEach(element => {
      segmentColors.push(this.segmentColor(element));
      segmentLabels.push(this.configSvc.answerLabels[element]);
    });

    
    // if this doesn't look like an answer distribution, leave the labels and colors as specified
    if (x.labels.indexOf('Y') < 0 || x.labels.indexOf('N') < 0) {
      segmentColors = x.colors;
      segmentLabels = x.labels;
    }


    return new Chart(canvasId, {
      type: 'doughnut',
      data: {
        labels: segmentLabels,
        datasets: [
          {
            label: x.label,
            data: x.data,
            backgroundColor: segmentColors
          }
        ],
      },
      options: {
        plugins: {
          tooltip: {
            callbacks: {
              label: function (context) {
                const label = context.label + ': '
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed(2) + '%';
                return label;
              }
            }
          },
          title: {
            display: false,
            font: { size: 20 },
            text: x.title
          },
          legend: {
            display: true,
            position: 'bottom',
            labels: {
              //@ts-ignore
              generateLabels: function (chart) { // Add values to legend labels
                var data = chart.data;
                if (data.labels.length && data.datasets.length) {
                  return data.labels.map(function (label, i) {
                    var meta = chart.getDatasetMeta(0);
                    var ds = data.datasets[0];
                    var arc = meta.data[i];
                    //@ts-ignore
                    const getValueAtIndexOrDefault = Utilities.getValueAtIndexOrDefault;
                    const arcOpts = chart.options.elements.arc;
                    const fill = getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                    const stroke = getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                    const bw = getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
                    let value = 0.00;
                    if (!!arc) {

                      //@ts-ignore
                      value = <number>chart.data.datasets[0].data[i];
                    }
                    return {
                      text: label + ' : ' + value.toFixed(2) + '%',
                      fillStyle: fill,
                      strokeStyle: stroke,
                      lineWidth: bw,
                      hidden: isNaN(<number>ds.data[i]) || meta.hidden,
                      index: i
                    };
                  });
                } else {
                  return [];
                }
              }
            }
          },
        },
      }
    });
  }


  /**
   * Builds a horizontal bar chart.  The x-axis and tooltips are always formatted as %
   * @param canvasId
   * @param x
   */
  buildHorizBarChart(canvasId: string, x: any, showLegend: boolean, zeroHundred: boolean) {
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
    if (tempChart) {
      tempChart.destroy();
    }

    var myOptions: any = {
      indexAxis: 'y',
      maintainAspectRatio: maintainAspectRatio,
      responsive: true,
      plugins: {
        legend: { display: showLegend, position: 'top' },
        tooltip: {
          callbacks: {
            label: ((context) =>
              context.label + ': '
              + (<Number>context.dataset.data[context.dataIndex]).toFixed(2) + '%')
          }
        }
      }
    };

    // set the scale if desired
    if (zeroHundred) {
      myOptions.scale = { min: 0, max: 100 };
    }


    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: x.datasets
      },
      options: myOptions
    });
  }

  /**
   * 
   * @param ans 
   * @returns 
   */
  segmentColor(ans: string) {
    switch (ans) {
      case 'U':
      case 'Unanswered':
        return '#CCCCCC';
      case 'Y':
      case 'Yes':
        return '#28A745';
      case 'A':
      case 'Alternate':
        return '#B17300';
      case 'NA':
      case 'Not Applicable':
        return '#007BFF';
      case 'N':
      case 'No':
        return '#DC3545';
      default:
        return '#000000';
    }
  }
}
