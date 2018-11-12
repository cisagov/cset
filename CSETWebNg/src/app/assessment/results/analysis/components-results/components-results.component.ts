////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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

@Component({
  selector: 'app-components-results',
  templateUrl: './components-results.component.html'
})
export class ComponentsResultsComponent implements OnInit {
  chart: Chart;
  dataRows: { title: string; passed: number; total: number; percent: number; }[];
  initialized = false;
  constructor(private analysisSvc: AnalysisService, private assessSvc: AssessmentService, private router: Router) { }

  ngOnInit() {
    this.analysisSvc.getComponentsResultsByCategory().subscribe(x => this.setupChart(x));

    this.dataRows = [ // TODO: Pull data from API
      {
        title: 'test',
        passed: 30,
        total: 17,
        percent: 100
      }
    ];
  }

  navNext() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'results', 'components-types']);
  }

  navBack() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'results', 'components-ranked']);
  }

  setupChart(x: any) {
    this.initialized = false;
    this.chart = new Chart('compResCanvas', {
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
          text: 'Results by Category'
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
