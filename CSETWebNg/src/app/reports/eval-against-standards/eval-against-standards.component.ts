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
import { ReportAnalysisService } from '../../services/report-analysis.service';
import Chart from 'chart.js/auto';

/**
 * This is an attempt to consolidate the big graph display.
 * It is used on both the Executive and the Site Summary reports.
 * I haven't gotten it to work yet.  Including it in the page
 * makes Angular navigate to the root.
 *
 * So for now it is being checked in, in case it can be made
 * to work in the future.
 */
@Component({
  selector: 'app-eval-against-standards',
  templateUrl: './eval-against-standards.component.html',
  styleUrls: ['../reports.scss']
})
export class EvalAgainstStandardsComponent implements OnInit {

  chartStandardsSummary: Chart;
  canvasStandardResultsByCategory: Chart;

  loading1 = true;
  loading2 = true;


  /**
   * 
   */
  constructor(
    public analysisSvc: ReportAnalysisService
  ) {
  }

  /**
   * 
   */
  ngOnInit() {
    this.analysisSvc.getStandardsSummary().subscribe(x => {
      this.loading1 = false;

      setTimeout(() => {
        this.chartStandardsSummary = <Chart>this.analysisSvc.buildStandardsSummary('canvasStandardSummary', x);
      }, 0);
    });

    // Standards By Category
    this.analysisSvc.getStandardsResultsByCategory().subscribe(x => {
      this.loading2 = false;

      setTimeout(() => {
        this.canvasStandardResultsByCategory = <Chart>this.analysisSvc.buildStandardResultsByCategoryChart('canvasStandardResultsByCategory', x);
      }, 0);
    });
  }
}