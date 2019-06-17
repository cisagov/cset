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
import { AnalysisService } from '../../../../services/analysis.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { Navigation2Service } from '../../../../services/navigation2.service';

@Component({
  selector: 'app-components-types',
  templateUrl: './components-types.component.html'
})
export class ComponentsTypesComponent implements OnInit {
  chart: Chart;
  dataRows: { title: string; yes: number; no: number; na: number; alt: number; unanswered: number; total: number; }[];
  initialized = false;

  constructor(
    private analysisSvc: AnalysisService,
    private assessSvc: AssessmentService,
    public navSvc2: Navigation2Service,
    public configSvc: ConfigService,
    private router: Router) { }

  ngOnInit() {
    this.analysisSvc.getComponentTypes().subscribe(x => this.setupChart(x));

    this.dataRows = [ // TODO: Pull data from API
      {
        title: 'test',
        yes: 20,
        no: 20,
        na: 20,
        alt: 20,
        unanswered: 20,
        total: 100
      }
    ];

  }


  setupChart(x: any) {
    this.initialized = false;
    this.chart = new Chart('compTypeCanvas', {
      type: 'pie',
      data: {
        labels: x.Labels,
        datasets: [
          {
            label: '',
            data: x.data,
            backgroundColor: 'red',
            borderColor: [],
            borderWidth: 1
          }
        ],
      },
      options: {
        title: {
          display: false,
          fontSize: 20,
          text: 'Component Types'
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
    this.initialized = true;
  }
}
