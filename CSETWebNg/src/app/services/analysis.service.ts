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
import { Injectable } from '@angular/core';
import { HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import Chart from 'chart.js/auto';
import { ChartService } from './chart.service';
import { TranslocoService } from '@ngneat/transloco';

@Injectable({
  providedIn: 'root'
})
export class AnalysisService {
  private apiUrl: string;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private chartSvc: ChartService,
    private tSvc: TranslocoService
  ) {
    this.apiUrl = this.configSvc.apiUrl + "analysis/";
  }

  getAnswerColors() {
    return this.http.get(this.apiUrl + 'analysis/answercolors');
  }

  getDashboard() {
    return this.http.get(this.apiUrl + 'Dashboard');
  }

  getRankedQuestions() {
    return this.http.get(this.apiUrl + 'RankedQuestions');
  }

  getFeedback(): any {
    return this.http.get(this.apiUrl + 'Feedback');
  }

  getTopCategories(num: number) {
    return this.http.get(this.apiUrl + 'TopCategories?total=' + num);
  }

  getOverallRankedCategories(): any {
    return this.http.get(this.apiUrl + 'OverallRankedCategories');
  }

  getStandardsSummary(): any {
    return this.http.get(this.apiUrl + 'StandardsSummary');
  }

  getStandardsSummaryOverall(): any {
    return this.http.get(this.apiUrl + 'StandardsSummaryOverall');
  }


  getComponentsSummary(): any {
    return this.http.get(this.apiUrl + 'ComponentsSummary');
  }

  getStandardsResultsByCategory(): any {
    return this.http.get(this.apiUrl + 'StandardsResultsByCategory');
  }

  getStandardsRankedCategories(): any {
    return this.http.get(this.apiUrl + 'StandardsRankedCategories');
  }

  getComponentsResultsByCategory(): any {
    return this.http.get(this.apiUrl + 'ComponentsResultsByCategory');
  }

  getComponentsRankedCategories(): any {
    return this.http.get(this.apiUrl + 'ComponentsRankedCategories');
  }

  getComponentTypes(): any {
    return this.http.get(this.apiUrl + 'ComponentTypes');
  }

  getNetworkWarnings(): any {
    return this.http.get(this.apiUrl + 'NetworkWarnings');
  }


  // ---------------------------------------------------------
  // let's migrate the chart building to this service
  // ---------------------------------------------------------

  /**
  * Builds a horizontal bar chart from the Dashboard API response.
  * @param canvasId
  * @param x
  */
  buildPercentComplianceChart(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.overallBars.labels,
        datasets: [
          {
            label: '',
            data: x.overallBars.data.map((n: number) => parseFloat(n.toFixed(0))),
            backgroundColor: '#007BFF',
            borderColor: [],
            borderWidth: 0
          }
        ],
      },
      options: {
        indexAxis: 'y',
        plugins: {
          title: {
            display: false,
            font: { size: 20 },
            text: this.tSvc.translate('titles.assessment compliance')
          },
          tooltip: {
            callbacks: {
              label: function (context) {
                const label = context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
                return label;
              }
            }
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            beginAtZero: true,
            max: 100
          }
        }
      }
    });
  }

  /**
   *
   */
  buildTopCategories(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: [
          {
            label: '',
            data: (x.data as Array<number>).map((e: number) => parseFloat(e.toFixed(2))),
            backgroundColor: '#DC3545',
            borderColor: [],
            borderWidth: 0
          }
        ],
      },
      options: {
        indexAxis: 'y',
        plugins: {
          title: {
            display: false,
            font: { size: 20 },
            text: 'Ranked Categories'
          },
          tooltip: {
            callbacks: {
              label: ((context) =>
                context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
            }
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            beginAtZero: true
          }
        }
      }
    });
  }

  /**
   * Builds a doughnut distribution for a single standard.
   * Builds a stacked bar chart for multi-standard questions.
   */
  buildStandardsSummary(canvasId: string, x: any) {
    if (x.data.length === 5) {
      return this.chartSvc.buildDoughnutChart(canvasId, x);
    } else {
      return this.buildStandardsSummaryStackedBar(canvasId, x);
    }
  }

  /**
   *
   */
  buildStandardsSummaryStackedBar(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId,
      {
        type: 'bar',
        data: {
          labels: x.labels,
          datasets: x.dataSets
        },
        options: {
          indexAxis: 'y',
          plugins: {
            legend: { display: true },
            tooltip: {
              callbacks: {
                label: ((context) =>
                  context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
              }
            }
          },
          scales: {
            y: {
              stacked: true
            },
            x: {
              stacked: true
            }
          },
        }
      });
  }

  /**
   *
   */
  buildComponentsSummary(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }

    return this.chartSvc.buildDoughnutChart(canvasId, x);
  }

  /**
* Renders a horizontal stacked bar chart showing the answer distribution
* for each component type.
* @param canvasId
*/
  buildComponentTypes(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId,
      {
        type: 'bar',
        data: {
          labels: x.labels,
          datasets: x.dataSets
        },
        options: {
          indexAxis: 'y',
          plugins: {
            legend: { display: true },
            tooltip: {
              callbacks: {
                label: ((context) =>
                  context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%')
              }
            }
          },
          scales: {
            y: {
              stacked: true
            },
            x: {
              stacked: true
            }
          },
        }
      });
  }

  /**
   *
   */
  buildComponentsRankedCategories(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: [
          {
            label: '',
            data: x.data.map((n: number) => parseFloat(n.toFixed(2))),
            backgroundColor: '#DC3545',
            borderColor: [],
            borderWidth: 0
          }
        ],
      },
      options: {
        indexAxis: 'y',
        plugins: {
          tooltip: {
            callbacks: {
              label: ((context) => {
                return context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              })
            }
          },
          title: {
            display: false,
            font: { size: 20 },
            text: 'Ranked Categories'
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            beginAtZero: true
          }
        }
      }
    });
  }

  /**
   *
   */
  buildComponentsResultsByCategory(canvasId: string, x: any) {
    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: [
          {
            label: '',
            data: x.data.map((n: number) => parseFloat(n.toFixed())),
            backgroundColor: '#0a0',
            borderColor: [],
            borderWidth: 0
          }
        ],
      },
      options: {
        indexAxis: 'y',
        plugins: {
          tooltip: {
            callbacks: {
              label: ((context) => {
                return context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              })
            }
          },
          title: {
            display: false,
            font: { size: 20 },
            text: 'Results By Category'
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            beginAtZero: true
          }
        }
      }
    });
  }
}
