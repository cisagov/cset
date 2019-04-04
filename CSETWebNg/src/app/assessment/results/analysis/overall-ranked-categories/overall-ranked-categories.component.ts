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

@Component({
  selector: 'app-overall-ranked-categories',
  templateUrl: './overall-ranked-categories.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})

export class OverallRankedCategoriesComponent implements OnInit {
  chart: Chart;
  dataRows: {title: string, rank: number, failed: number, total: number, percent: string}[];
  initialized = false;

  constructor(private analysisSvc: AnalysisService, private assessSvc: AssessmentService, private router: Router) { }

  ngOnInit() {
    this.analysisSvc.getOverallRankedCategories().subscribe(x => this.setupChart(x));
  }

  navNext() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'results', 'standards-summary']);
  }

  navBack() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'results', 'ranked-questions']);
  }

  setupChart(x: any) {
    this.initialized = false;
    this.dataRows = x.DataRows;
    this.dataRows.map(r => r.percent = parseFloat(r.percent).toFixed(2));
    this.chart = new Chart('overallRankCanvas', {
      type: 'horizontalBar',
      data: {
        labels: x.Labels,
        datasets: [
          {
            label: '',
            data: (x.data as Array<number>).map(n => parseFloat(n.toFixed(2))),
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
          text: 'Overall Ranked Categories'
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
