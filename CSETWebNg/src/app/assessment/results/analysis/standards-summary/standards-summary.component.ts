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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import Chart from 'chart.js/auto';
import { AnalysisService } from '../../../../services/analysis.service';
import { ChartService } from '../../../../services/chart.service';
import { ConfigService } from '../../../../services/config.service';
import { LayoutService } from '../../../../services/layout.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-standards-summary',
  templateUrl: './standards-summary.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class StandardsSummaryComponent implements OnInit, AfterViewInit {
  chart: any;
  dataRows: { answer_Full_Name: string; answer_Text: string; qc: number; Total: number; Percent: number; }[];
  // eslint-disable-next-line max-len
  dataSets: { dataRows: { Answer_Full_Name: string; qc: number; Total: number; Percent: number; }[], label: string, Colors: string[], backgroundColor: string[] }[];
  initialized = false;


  constructor(
    private analysisSvc: AnalysisService,
    private chartSvc: ChartService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public layoutSvc: LayoutService,
    public tSvc: TranslocoService
  ) { }

  ngOnInit() {
  }

  ngAfterViewInit() {
    this.analysisSvc.getStandardsSummary().subscribe(x => this.setupChart(x));
  }

  setupChart(x: any) {
    this.initialized = false;
    this.dataRows = x.dataRowsPie;

    this.dataRows.forEach(x => {
      x.answer_Full_Name = this.tSvc.translate('answer-options.labels.' + x.answer_Text.toLowerCase());
    });

    this.dataSets = x.dataSets;
    let tempChart = Chart.getChart('canvasStandardSummary');
    if (tempChart) {
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
          indexAxis: 'y',
          plugins: {
            title: {
              display: false,
              font: { size: 20 },
              text: this.tSvc.translate('titles.standards summary')
            },
            legend: {
              display: true
            },
            tooltip: {
              callbacks: {
                label: function (context) {
                  const label = context.dataset.label + (!!context.dataset.label ? ': ' : ' ')
                    + (<Number>context.dataset.data[context.dataIndex]).toFixed() + '%';
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
      if (tempChart) {
        tempChart.destroy();
      }

      this.chart = this.chartSvc.buildDoughnutChart('canvasStandardSummary', x);
    }

    this.initialized = true;
  }
}
