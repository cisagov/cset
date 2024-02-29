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



/**
 * Provides API calls and chart-building methods.  This was cloned from
 * the AnalysisService in the main CSET app and then modified.
 */
@Injectable({
  providedIn: 'root'
})
export class ReportAnalysisService {
  private apiUrl: string;

  /**
   *
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private chartSvc: ChartService,
    private tSvc: TranslocoService
  ) {
    this.apiUrl = this.configSvc.apiUrl + "analysis/";
  }

  getDashboard() {
    return this.http.get(this.apiUrl + 'Dashboard');
  }

  getRankedQuestions() {
    return this.http.get(this.apiUrl + 'RankedQuestions');
  }

  getTopCategories() {
    return this.http.get(this.apiUrl + 'TopCategories');
  }

  getOverallRankedCategories(): any {
    return this.http.get(this.apiUrl + 'OverallRankedCategories');
  }

  getStandardsSummaryOverall(): any {
    return this.http.get(this.apiUrl + 'StandardsSummaryOverall');
  }

  getStandardsSummary(): any {
    return this.http.get(this.apiUrl + 'StandardsSummary');
  }

  getComponentSummary(): any {
    return this.http.get(this.apiUrl + 'ComponentsSummary');
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
  getStandardsResultsByCategory(): any {
    return this.http.get(this.apiUrl + 'StandardsResultsByCategory');
  }

  /**
  *
  */
  buildStandardResultsByCategoryChart(canvasId: string, x: any) {

    let tempChart = Chart.getChart(canvasId);
    if (tempChart) {
      tempChart.destroy();
    }
    return new Chart(canvasId, {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: x.dataSets,
      },
      options: {
        indexAxis: 'y',
        plugins: {
          title: {
            display: false,
            font: { size: 20 },
            text: 'Results by Category'
          },
          tooltip: {
            callbacks: {
              label: ((context) => {
                return context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              })
            }
          },
          legend: {
            display: true,
            position: 'top'
          }
        },
        scales: {
          x: {
            max: 100,
            ticks: {
              //@ts-ignore
              beginAtZero: true
            }
          },
          y: {
            ticks: {
              autoSkip: false
            }
          }
        }
      }
    });
  }

  /**
   * Just pass in one member of 'multipleDataSets'
   * @param canvasId
   * @param x
   */
  buildRankedCategoriesChart(canvasId: string, x: any) {
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
            data: x.data,
            backgroundColor: '#00aa00',
            borderColor: [],
            borderWidth: 0
          }
        ]
      },

      options: {
        indexAxis: 'y',
        responsive: true,
        plugins: {
          title: {
            display: false,
            font: { size: 20 },
            text: 'Ranked Categories'
          },
          tooltip: {
            callbacks: {
              label: ((context) => {
                return context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              })
            }
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            max: 100,
            beginAtZero: true
          },
          y: {
            ticks: {
              autoSkip: false
            }
          }
        }
      }
    });
  }


  getStandardsRankedCategories(): any {
    return this.http.get(this.apiUrl + 'StandardsRankedCategories');
  }

  buildRankedSubjectAreasChart(canvasId: string, x: any): Chart {
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
            data: x.data,
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
              label: ((context) => {
                return context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              })
            }
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            max: 100,
            beginAtZero: true
          },
          y: {
            ticks: {
              autoSkip: false
            }
          }
        }
      }
    });
  }

  getComponentsResultsByCategory(): any {
    return this.http.get(this.apiUrl + 'ComponentsResultsByCategory');
  }

  getOtherComments(): any {
    return this.http.get(this.apiUrl + 'DocumentComments');
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
            data: x.overallBars.data.map(n => parseFloat(n.toFixed())),
            backgroundColor: '#0A5278',
            borderColor: [],
            borderWidth: 0
          }
        ],
      },
      options: {
        indexAxis: 'y',
        maintainAspectRatio: false,
        plugins: {
          title: {
            display: false,
            font: { size: 20 },
            text: this.tSvc.translate('titles.assessment compliance')
          },
          tooltip: {
            callbacks: {
              label: function (context) {
                return context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                  + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
              }
            }
          },
          legend: {
            display: false
          }
        },
        scales: {
          x: {
            max: 100,
            beginAtZero: true
          }
        }
      }
    });
  }

  /**
   * Returns the level word styled to match the corresponding CSS class.
   * @param level
   */
  public salColor(level: string) {
    if (level == null) {
      return "";
    }
    return level.toLowerCase().replace(' ', '-');
  }

  /**
   *
   * @param level
   */
  public salWord(level: string) {
    switch (level) {
      case "L":
        return "Low";
      case "M":
        return "Moderate";
      case "H":
        return "High";
      case "VH":
        return "Very High";
      default:
        return "";
    }
  }


  buildComponentSummary(canvasId: string, x: any) {
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
            legend: { display: true, position: 'bottom' },
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
            data: x.data,
            backgroundColor: '#00aa00',
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
          },
          y: {
            ticks: {
              autoSkip: false
            }
          }
        }
      }
    });
  }

}
