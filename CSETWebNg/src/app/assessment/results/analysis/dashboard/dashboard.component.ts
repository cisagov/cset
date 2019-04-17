////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import { Chart } from 'chart.js';
import { Router } from '../../../../../../node_modules/@angular/router';
import { AssessmentService } from '../../../../services/assessment.service';
import { AnalysisService } from './../../../../services/analysis.service';
declare var $: any;

@Component({
  selector: 'app-dashboard',
  templateUrl: './dashboard.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class DashboardComponent implements OnInit {

  overallScore: string;
  standardBasedScore: string;
  componentBasedScore: string;

  assessComplChart: Chart;
  topCategChart: Chart;
  stdsSummChart: Chart;
  compSummChart: Chart;
  hasComponents = false;
  initialized = false;

  constructor(private analysisSvc: AnalysisService, private assessSvc: AssessmentService, private router: Router) { }

  ngOnInit() {
    this.analysisSvc.getDashboard().subscribe(x => this.setupChart(x));

    // even up the score container widths
    $("#overall-score").css("width", $("#component-score").width() + "px");
  }

  navNext() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'results', 'ranked-questions']);
  }

  navBack() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'questions']);
  }

  setupChart(x: any) {
    this.initialized = false;
    const stds = this.getScore(x.OverallBars, 'Questions')
               + this.getScore(x.OverallBars, 'Requirement');
    const comp = x.OverallBars.data[0];
    this.overallScore = this.getScore(x.OverallBars, 'Overall').toFixed(0) + '%';
    this.standardBasedScore = stds > 0 ? stds.toFixed(0) + '%' : 'No Standards Answers';
    this.componentBasedScore = comp > 0 ? comp.toFixed(0) + '%' : 'No components answers';

    this.hasComponents = (x.ComponentSummaryPie.data as number[]).reduce((a, b) => a + b) > 0;

    this.assessComplChart = new Chart('assessComplCanvas', {
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

    this.topCategChart = new Chart('topCategCanvas', {
      type: 'horizontalBar',
      data: {
        labels: x.RedBars.Labels,
        datasets: [
          {
            label: '',
            data: (x.RedBars.data as Array<number>).map((e: number) => parseFloat(e.toFixed(2))),
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
          text: 'Top Ranked Categories'
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

    this.stdsSummChart = new Chart('stdsSummCanvas', {
      type: 'doughnut',
      data: {
        labels: [
          'Yes',
          'No',
          'N/A',
          'Alternate',
          'Unanswered'
        ],
        datasets: [
          {
            label: '',
            data: x.StandardsSummaryPie.data,
            backgroundColor: x.StandardsSummaryPie.Labels,
            borderColor: [],
            borderWidth: 1
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
    if (x.ComponentSummaryPie != null) {
      this.compSummChart = new Chart('compSummCanvas', {
        type: 'pie',
        data: {
          labels: x.ComponentSummaryPie.Labels,
          datasets: [
            {
              label: '',
              data: x.ComponentSummaryPie.data,
              backgroundColor: x.ComponentSummaryPie.backgroundColor,
              borderColor: x.ComponentSummaryPie.borderColor,
              borderWidth: 1
            }
          ],
        },
        options: {
          title: {
            display: false,
            fontSize: 20,
            text: 'Components Summary'
          },
          legend: {
            display: true,
            position: 'bottom'
          }
        }
      });
    }
    this.initialized = true;
  }


  /**
   * Returns the 'data' element that corresponds to the position of the 'Label.'
   * @param overallBars
   */
  getScore(overallBars, label) {
    for (let i = 0; i < overallBars.Labels.length; i++) {
      if (overallBars.Labels[i].toLowerCase() === label.toLowerCase()) {
        return overallBars.data[i];
      }
    }

    return 0;
  }
}
