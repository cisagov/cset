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
import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { Utilities } from './utilities.service';
import Chart from 'chart.js/auto';
import { QuestionsService } from './questions.service';


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
    private configSvc: ConfigService,
    private questionsSvc: QuestionsService
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
    if (tempChart) {
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
        plugins: {
          legend: { position: 'left' },
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
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
    if (tempChart) {
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
        plugins: {
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
  buildHorizBarChart(canvasId: string, x: any, showLegend: boolean, zeroHundred: boolean, opts: any = {}, isPercent: boolean = true) {
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
    let percent = isPercent ? '%' : ' ';

    var myOptions: any = {
      indexAxis: 'y',
      maintainAspectRatio: maintainAspectRatio,
      responsive: true,
      plugins: {
        legend: { display: showLegend, position: 'top' },
        tooltip: {
          callbacks: {
            label: ((context) =>
              context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
              + (<Number>context.dataset.data[context.dataIndex]).toFixed() + percent)
          }
        },

      }
    };

    // overlay the options object with any passed-in properties
    Object.assign(myOptions, opts);

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
      segmentLabels.push(this.questionsSvc.answerDisplayLabel('', element));
    });


    // if this doesn't look like an answer distribution, leave the labels and colors as specified
    if (!this.looksLikeAnswerDistribution(x.labels)) {
      segmentColors = x.colors;
      segmentLabels = x.labels;
    }


    return new Chart(canvasId, {
      type: 'doughnut',
      data: {
        labels: segmentLabels,
        datasets: [
          {
            label: x.labels,
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
                const label = context.label + (!!context.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
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
                    const getValueAtIndexOrDefault = Utilities.getValueAtIndexOrDefault;
                    const arcOpts = chart.options.elements.arc;
                    const fill = getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                    const stroke = getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                    const bw = getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
                    let value = 0.00;
                    if (!!arc) {
                      value = <number>chart.data.datasets[0].data[i];
                    }
                    return {
                      text: label + ' : ' + value.toFixed() + '%',
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
   * look at each label being supplied.  If any
   * of them are outside of our standard answer values,
   * return false, otherwise return true.
   */
  looksLikeAnswerDistribution(labels): boolean {
    var answerLabels = ['Y', 'N', 'U', 'NA', 'A', 'I'];

    for (const element of labels) {
      if (answerLabels.indexOf(element) < 0) {
        return false;
      }
    };

    return true;
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
    if (tempChart) {
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
                context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
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
  buildStackedHorizBarChart(canvasId: string, chartConfig: any) {
    const tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: chartConfig.labels,
        datasets: chartConfig.datasets
      },
      options: {
        indexAxis: 'y',
        animation: { duration: 100 }, // general animation time
        scales: {
          x: {
            stacked: true,
            beginAtZero: true,
            max: 100,
            ticks: {
              stepSize: 20
            }
          },
          y: {
            stacked: true
          }
        },
        maintainAspectRatio: false,
        plugins: {
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
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
  buildCrrPercentagesOfPracticesBarChart(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: [{
          data: x.values,
          backgroundColor: "rgb(21, 124, 142)",
          borderColor: "rgb(21,124,142)",
          borderWidth: 0
        }],
      },
      options: {
        indexAxis: 'y',
        hover: { mode: null },
        events: [],
        plugins: {
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            min: 0,
            max: 100,
            beginAtZero: true,
            ticks: {
              stepSize: 10,
              callback: function (value) {
                return value + "%";
              }
            }
          }
        }
      }
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
        return '#FFC107';
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

  /**
  * Calculates a good height for a horizontal bar chart
  * based on the number of datasets and data items,
  * i.e., the number of horizontal bars to accommodate.
  * @param x
  */
  calcHbcHeightPixels(x): string {
    // calculate the number of bars in the chart
    let maxDatasetLength = x.datasets[0].data.length;
    // calculate a good height for the chart's container
    let h = maxDatasetLength * x.datasets.length * 20;
    return (h + 50) + "px";
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
