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
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ConfigService } from './config.service';
import { Chart } from 'chart.js';



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
  constructor(private http: HttpClient, private configSvc: ConfigService) {
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
      return this.buildStandardsSummaryDoughnut(canvasId, x);
    } else {
      return this.buildStandardsSummaryStackedBar(canvasId, x);
    }
  }

  /**
   *
   */
  buildStandardsSummaryStackedBar(canvasId: string, x: any) {
    return new Chart(canvasId,
      {
        type: 'horizontalBar',
        data: {
          labels: x.Labels,
          datasets: x.dataSets
        },
        options: {
          legend: { display: true },
          tooltips: {
            callbacks: {
              label: ((tooltipItem, data) =>
                data.datasets[tooltipItem.datasetIndex].label + ': '
                + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
            }
          },
          scales: {
            yAxes: [{
              stacked: true
            }],
            xAxes: [{
              stacked: true
            }]
          },
        }
      });
  }

  /**
   *
   */
  buildStandardsSummaryDoughnut(canvasId: string, x: any) {
    return new Chart(canvasId, {
      type: 'doughnut',
      data: {
        labels: [
          this.configSvc.answerLabels['Y'],
          this.configSvc.answerLabels['N'],
          this.configSvc.answerLabels['NA'],
          this.configSvc.answerLabels['A'],
          this.configSvc.answerLabels['U']
        ],
        datasets: [
          {
            label: x.label,
            data: x.data,
            backgroundColor: x.Colors
          }
        ],
      },
      options: {
        tooltips: {
          callbacks: {
            label: ((tooltipItem, data) =>
              data.labels[tooltipItem.index] + ': ' + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
          }
        },
        title: {
          display: false,
          fontSize: 20,
          text: 'Standards Summary'
        },
        legend: {
          display: true,
          position: 'bottom',
          labels: {
            generateLabels: function (chart) { // Add values to legend labels
              const data = chart.data;
              if (data.labels.length && data.datasets.length) {
                return data.labels.map(function (label, i) {
                  const meta = chart.getDatasetMeta(0);
                  const ds = data.datasets[0];
                  const arc = meta.data[i];
                  const custom = arc && arc.custom || {};
                  const getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
                  const arcOpts = chart.options.elements.arc;
                  const fill = custom.backgroundColor ? custom.backgroundColor :
                    getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                  const stroke = custom.borderColor ? custom.borderColor :
                    getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                  const bw = custom.borderWidth ? custom.borderWidth :
                    getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
                  const value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];
                  return {
                    text: label + ' : ' + value + '%',
                    fillStyle: fill,
                    strokeStyle: stroke,
                    lineWidth: bw,
                    hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
                    index: i
                  };
                });
              } else {
                return [];
              }
            }
          }
        },
        circumference: Math.PI,
        rotation: -Math.PI
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
    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.Labels,
        datasets: x.dataSets,
      },
      options: {
        maintainAspectRatio: true,
        aspectRatio: 0,
        title: {
          display: false,
          fontSize: 20,
          text: 'Results by Category'
        },
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              beginAtZero: true,
              max: 100
            }
          }]
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
    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.Labels,
        datasets: [
          {
            label: '',
            data: x.data,
            backgroundColor: '#090',
            borderColor: [],
            borderWidth: 1
          }
        ]
      },

      options: {
        responsive: true,
        maintainAspectRatio: true,
        aspectRatio: 0,

        title: {
          display: false,
          fontSize: 20,
          text: 'Ranked Categories'
        },

        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              beginAtZero: true,
              max: 100
            }
          }]
        }
      }
    });
  }


  getStandardsRankedCategories(): any {
    return this.http.get(this.apiUrl + 'StandardsRankedCategories');
  }

  buildRankedSubjectAreasChart(canvasId: string, x: any): Chart {
    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.Labels,
        datasets: [
          {
            label: '',
            data: x.data,
            backgroundColor: '#a00',
            borderColor: [],
            borderWidth: 1
          }
        ],
      },
      options: {
        title: {
          display: false,
          fontSize: 20,
          text: 'Ranked Categories'
        },
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
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
    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.OverallBars.Labels,
        datasets: [
          {
            label: '',
            data: x.OverallBars.data.map(n => parseFloat(n.toFixed(2))),
            backgroundColor: '#0A5278',
            borderColor: [],
            borderWidth: 1
          }
        ],
      },
      options: {
        title: {
          display: false,
          fontSize: 20,
          text: 'Assessment Compliance'
        },
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              beginAtZero: true,
              max: 100
            }
          }]
        }
      }
    });
  }

  /**
   * Returns the level word styled to match the corresponding CSS class.
   * @param level
   */
  public salColor(level: string) {
    if (level === null) {
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

  public answerWord(answer: string) {
    switch (answer) {
      case "Y":
        return "Yes";
      case "N":
        return "No";
      case "NA":
        return "Not Applicable";
      case "A":
        return "Alternate";
      case "U":
        return "Unanswered";
      default:
        return "";
    }
  }

  buildComponentSummary(canvasId: string, x: any) {
    return new Chart(canvasId, {
      type: 'doughnut',
      data: {
        labels: [
          this.configSvc.answerLabels['Y'],
          this.configSvc.answerLabels['N'],
          this.configSvc.answerLabels['NA'],
          this.configSvc.answerLabels['A'],
          this.configSvc.answerLabels['U']
        ],
        datasets: [
          {
            label: x.label,
            data: x.data,
            backgroundColor: x.Colors
          }
        ],
      },
      options: {
        tooltips: {
          callbacks: {
            label: ((tooltipItem, data) =>
              data.labels[tooltipItem.index] + ': ' + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
          }
        },
        title: {
          display: false,
          fontSize: 20,
          text: 'Component Summary'
        },
        legend: {
          display: true,
          position: 'bottom',
          labels: {
            generateLabels: function (chart) { // Add values to legend labels
              const data = chart.data;
              if (data.labels.length && data.datasets.length) {
                return data.labels.map(function (label, i) {
                  const meta = chart.getDatasetMeta(0);
                  const ds = data.datasets[0];
                  const arc = meta.data[i];
                  const custom = arc && arc.custom || {};
                  const getValueAtIndexOrDefault = Chart.helpers.getValueAtIndexOrDefault;
                  const arcOpts = chart.options.elements.arc;
                  const fill = custom.backgroundColor ? custom.backgroundColor :
                    getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                  const stroke = custom.borderColor ? custom.borderColor :
                    getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                  const bw = custom.borderWidth ? custom.borderWidth :
                    getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
                  const value = chart.config.data.datasets[arc._datasetIndex].data[arc._index];
                  return {
                    text: label + ' : ' + value + '%',
                    fillStyle: fill,
                    strokeStyle: stroke,
                    lineWidth: bw,
                    hidden: isNaN(ds.data[i]) || meta.data[i].hidden,
                    index: i
                  };
                });
              } else {
                return [];
              }
            }
          }
        },
        circumference: Math.PI,
        rotation: -Math.PI
      }
    });
  }


  /**
  * Renders a horizontal stacked bar chart showing the answer distribution
  * for each component type.
  * @param canvasId
  */
  buildComponentTypes(canvasId: string, x: any) {
    return new Chart(canvasId,
      {
        type: 'horizontalBar',
        data: {
          labels: x.Labels,
          datasets: x.dataSets
        },
        options: {
          legend: { display: true },
          tooltips: {
            callbacks: {
              label: ((tooltipItem, data) =>
                data.datasets[tooltipItem.datasetIndex].label + ': '
                + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
            }
          },
          scales: {
            yAxes: [{
              stacked: true
            }],
            xAxes: [{
              stacked: true
            }]
          },
        }
      });
  }

  /**
   *
   */
  buildComponentsResultsByCategory(canvasId: string, x: any) {
    return new Chart(canvasId, {
      type: 'horizontalBar',
      data: {
        labels: x.Labels,
        datasets: [
          {
            label: '',
            data: x.data,
            backgroundColor: '#0a0',
            borderColor: [],
            borderWidth: 1
          }
        ],
      },
      options: {
        tooltips: {
          callbacks: {
            label: ((tooltipItem, data) => {
              return data.labels[tooltipItem.index] + ': '
                + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%';
            })
          }
        },
        title: {
          display: false,
          fontSize: 20,
          text: 'Results By Category'
        },
        legend: {
          display: false
        },
        scales: {
          xAxes: [{
            ticks: {
              beginAtZero: true
            }
          }]
        }
      }
    });
  }

}
