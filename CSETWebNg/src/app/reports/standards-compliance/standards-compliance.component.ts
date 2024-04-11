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
import { AfterViewChecked, Component, OnInit } from '@angular/core';
import { ReportAnalysisService } from '../../services/report-analysis.service';
import Chart from 'chart.js/auto';

@Component({
  selector: 'app-standards-compliance',
  templateUrl: './standards-compliance.component.html',
  styleUrls: ['../reports.scss']
})
export class StandardsComplianceComponent implements OnInit, AfterViewChecked {

  loading = true;

  pageInitialized = false;
  chart1: Chart;
  complianceGraphs: any[] = [];
  numberOfStandards = -1;

  /**
   * 
   */
  constructor(
    public analysisSvc: ReportAnalysisService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.analysisSvc.getStandardsResultsByCategory().subscribe(x => {
      this.loading = false;

      // Set up arrays for green bar graphs
      this.numberOfStandards = !!x.dataSets ? x.dataSets.length : 0;
      if (!!x.dataSets) {
        x.dataSets.forEach(element => {
          this.complianceGraphs.push(element);
        });
      }
    });
  }

  /**
   * 
   */
  ngAfterViewChecked() {
    if (this.pageInitialized) {
      return;
    }

    // There's probably a better way to do this ... we have to wait until the
    // complianceGraphs array has been built so that the template can bind to it.
    if (this.complianceGraphs.length === this.numberOfStandards && this.numberOfStandards >= 0) {
      this.pageInitialized = true;
    }

    // at this point the template should know how big the complianceGraphs array is
    let cg = 0;
    this.complianceGraphs.forEach(x => {
      this.chart1 = <Chart>this.analysisSvc.buildRankedCategoriesChart("complianceGraph" + cg++, x);
    });
  }
}
