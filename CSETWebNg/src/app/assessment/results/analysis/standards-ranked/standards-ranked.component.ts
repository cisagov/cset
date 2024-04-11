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
import { Component, OnInit } from '@angular/core';
import Chart from 'chart.js/auto';
import { Router } from '../../../../../../node_modules/@angular/router';
import { AnalysisService } from '../../../../services/analysis.service';
import { LayoutService } from '../../../../services/layout.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-standards-ranked',
  templateUrl: './standards-ranked.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class StandardsRankedComponent implements OnInit {
  showChart = false;
  chart: Chart;
  dataRows: { title: string; rank: string; failed: number; total: number; percent: string; }[];
  initialized = false;

  constructor(
    private analysisSvc: AnalysisService,
    private tSvc: TranslocoService,
    public navSvc: NavigationService,
    private router: Router,
    public layoutSvc: LayoutService
  ) { }

  ngOnInit() {
    this.analysisSvc.getOverallRankedCategories().subscribe(x => this.setupChart(x));
  }

  setupChart(x: any) {
    // only show the chart if there is some non-zero data to show
    this.showChart = x.data.some(x => x > 0);

    if (this.chart) {
      this.chart.destroy();
    }
    this.initialized = false;
    this.dataRows = x.dataRows;
    this.dataRows.map(r => {
      r.percent = parseFloat(r.percent).toFixed();
    });
    let tempChart = Chart.getChart('canvasStandardRank');
    if (tempChart) {
      tempChart.destroy();
    }
    this.chart = new Chart('canvasStandardRank', {
      type: 'bar',
      data: {
        labels: x.labels,
        datasets: [
          {
            label: '',
            data: x.data,
            backgroundColor: '#DC3545'
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
            text: this.tSvc.translate('titles.ranked categories')
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
    this.initialized = true;
  }
}
