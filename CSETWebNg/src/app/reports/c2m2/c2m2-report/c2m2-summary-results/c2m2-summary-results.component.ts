////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-c2m2-summary-results',
  templateUrl: './c2m2-summary-results.component.html',
  styleUrls: ['../c2m2-report.component.scss', '../../../reports.scss']
})
export class C2m2SummaryResultsComponent implements OnInit {

  @Input()
  donutData: any;

  milData: any[] = [];
  // milDataMap: Map<number, any[]> = new Map<number, any[]>(); //<domainSequence, [{mil3Data},{mil2Data},{mil1Data}]>


  constructor(
    public reportSvc: ReportService
  ) { }

  ngOnInit(): void {
    let shortTitles = [];
    let mil3 = [];
    let mil2 = [];
    let mil1 = [];

    for (let i = 0; i < this.donutData.length; i++) {
      //let shortTitle = this.donutData[i].shortTitle;
      let milRollup = this.donutData[i].domainMilRollup;

      //shortTitles.push(shortTitle);
      mil3.push(milRollup[2]);
      mil2.push(milRollup[1]);
      mil1.push(milRollup[0]);
    }

    //this.milData.push(shortTitles);
    this.milData.push(mil3);
    this.milData.push(mil2);
    this.milData.push(mil1);
  }

  

}
