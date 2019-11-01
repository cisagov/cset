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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { Chart } from 'chart.js';
import { Router } from '../../../../../../node_modules/@angular/router';
import { AnalysisService } from '../../../../services/analysis.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { Navigation2Service } from '../../../../services/navigation2.service';

@Component({
  selector: 'app-standards-summary',
  templateUrl: './standards-summary.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class StandardsSummaryComponent implements OnInit, AfterViewInit {
  chart: Chart;
  dataRows: { Answer_Full_Name: string; qc: number; Total: number; Percent: number; }[];
  // tslint:disable-next-line:max-line-length
  dataSets: { dataRows: { Answer_Full_Name: string; qc: number; Total: number; Percent: number; }[], label: string, Colors: string[], backgroundColor: string[] }[];
  initialized = false;

  constructor(
    private analysisSvc: AnalysisService,
    public navSvc2: Navigation2Service,
    public configSvc: ConfigService,
    ) { }

  ngOnInit() {
  }

  ngAfterViewInit() {
    this.analysisSvc.getStandardsSummary().subscribe(x => this.setupChart(x));
  }

  setupChart(x: any) {
    this.initialized = false;
    this.dataRows = x.DataRowsPie;
    this.dataSets = x.dataSets;

    if (this.dataSets.length > 1) {
      this.chart = new Chart('canvasStandardSummary', {
        type: 'horizontalBar',
        data: {
          labels: x.Labels,
          datasets: x.dataSets
        },
        options: {
          title: {
            display: false,
            fontSize: 20,
            text: 'Standards Summary'
          },
          legend: {
            display: true
          },
          tooltips: {
            callbacks: {
              label: ((tooltipItem, data) =>
              data.datasets[tooltipItem.datasetIndex].label + ': '
              + data.datasets[tooltipItem.datasetIndex].data[tooltipItem.index] + '%')
            }
          },
          scales: {
            xAxes: [{
              stacked: true,
            }],
            yAxes: [{
              stacked: true
            }]
          }
        }
      });
     } else {
      this.chart = new Chart('canvasStandardSummary', {
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
              label: x.label,
              data: x.data,
              backgroundColor: x.Colors,
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
              generateLabels: function(chart) { // Add values to legend labels
                  const data = chart.data;
                  if (data.labels.length && data.datasets.length) {
                      return data.labels.map(function(label, i) {
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

    this.initialized = true;
  }
}
