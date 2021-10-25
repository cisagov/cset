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
import { LabelType } from '@angular-slider/ngx-slider';
import { Component, OnInit, AfterViewInit } from '@angular/core';
import  Chart  from 'chart.js/auto';
import { Router } from '../../../../../../node_modules/@angular/router';
import { AnalysisService } from '../../../../services/analysis.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { NavigationService } from '../../../../services/navigation.service';
import { Utilities } from '../../../../services/utilities.service';

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
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    ) { }

  ngOnInit() {
  }

  ngAfterViewInit() {
    this.analysisSvc.getStandardsSummary().subscribe(x => this.setupChart(x));
  }

  setupChart(x: any) {
    this.initialized = false;
    this.dataRows = x.dataRowsPie;
    this.dataSets = x.dataSets;
    let tempChart = Chart.getChart('canvasStandardSummary');
    if(tempChart){
      tempChart.destroy();
    }
    if (this.dataSets.length > 1) {
      this.chart = new Chart('canvasStandardSummary', {
        type: 'bar',
        data: {
          labels: x.labels,
          datasets: x.dataSets
        },
        options: {
          indexAxis:'y',
          plugins:{
            title: {
              display: false,
              font: {size: 20},
              text: 'Standards Summary'
            },
            legend: {
              display: true
            },
            tooltip: {
              callbacks: {
                label: function(context){
                  const label = context.label + ': '
                  + context.dataset.data[context.dataIndex] + '%'; 
                  return label;
                }
              }
            }
          },
          scales: {
            x: {
              stacked: true,
            },
            y: {
              stacked: true
            }
          }
        }
      });
     } else {
      let tempChart = Chart.getChart('canvasStandardSummary');
      if(tempChart){
        tempChart.destroy();
      }
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
              backgroundColor: x.colors,
            }
          ],
        },
        options: {
          plugins: {
            tooltip: {
              callbacks: {
                label: function(context){
                  const label = context.label + ': ' + 
                    context.dataset.data[context.dataIndex] + '%';
                  return label;
                }
              }
            },
            title: {
              display: false,
              font: {size: 20},
              text: 'Standards Summary'
            },
            legend: {
              display: true,
              position: 'bottom',
              labels: {
                //@ts-ignore
                generateLabels: function(chart) { // Add values to legend labels
                    const data = chart.data;
                    if (data.labels.length && data.datasets.length) {
                        return data.labels.map(function(label, i) {
                            const meta = chart.getDatasetMeta(0);
                            const ds = data.datasets[0];
                            const arc = meta.data[i];
                            //@ts-ignore
                            const arcOpts = chart.options.elements.arc;
                            const fill = Utilities.getValueAtIndexOrDefault(ds.backgroundColor, i, arcOpts.backgroundColor);
                            const stroke = Utilities.getValueAtIndexOrDefault(ds.borderColor, i, arcOpts.borderColor);
                            const bw = Utilities.getValueAtIndexOrDefault(ds.borderWidth, i, arcOpts.borderWidth);
                            //@ts-ignore
                            const value = chart.data.datasets[0].data[i];
                            return {
                                text: label + ' : ' + value + '%',
                                fillStyle: fill,
                                strokeStyle: stroke,
                                lineWidth: bw,
                                //@ts-ignore
                                hidden: isNaN(<number>ds.data[i]) || meta.hidden,
                                index: i
                            };
                        });
                    } else {
                        return [];
                    }
                  }
                }
            }
          }
        }
      });

    }

    this.initialized = true;
  }
}
