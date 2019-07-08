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
import { StandardService } from '../../../../services/standard.service';
import { Navigation2Service } from '../../../../services/navigation2.service';

@Component({
  selector: 'app-standards-results',
  templateUrl: './standards-results.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class StandardsResultsComponent implements OnInit {
  chart: Chart;
  dataRows: { title: string; failed: number; total: number; percent: number; }[];
  dataSets: { dataRows: { title: string; failed: number; total: number; percent: number; }[], label: string };
  initialized = false;
  constructor(
    private analysisSvc: AnalysisService,
    private assessSvc: AssessmentService,
    public navSvc2: Navigation2Service,
    private stdSvc: StandardService,
    private router: Router) { }

  ngOnInit() {
    this.analysisSvc.getStandardsResultsByCategory().subscribe(x => this.setupChart(x));
  }


  setupChart(x: any) {
    this.initialized = false;
    this.dataRows = x.DataRows;
    this.dataSets = x.dataSets;
    for(var i = 0; i < x.dataSets.length; i++){
      x.dataSets[i].borderColor = [];
      x.dataSets[i].borderWidth = 1;
    }
    
    this.chart = new Chart('stdResultCanvas', {
      type: 'horizontalBar',
      data: {
        labels: x.Labels,
        datasets: x.dataSets,
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
