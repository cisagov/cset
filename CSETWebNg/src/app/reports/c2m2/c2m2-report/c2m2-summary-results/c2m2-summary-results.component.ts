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
  test: string = ' ';
  // milDataMap: Map<number, any[]> = new Map<number, any[]>(); //<domainSequence, [{mil3Data},{mil2Data},{mil1Data}]>


  constructor(
    public reportSvc: ReportService
  ) { }

  ngOnInit(): void {
    let shortTitles = [];
    let mil3 = [];
    let mil2 = [];
    let mil1 = [];

    for (let i = 0; i < this.donutData.length+1; i++) {
      if(i==0) {
        let mil3Name = this.donutData[0].domainMilRollup[2].milName.replace('-','');
        let mil2Name = this.donutData[0].domainMilRollup[1].milName.replace('-','');
        let mil1Name = this.donutData[0].domainMilRollup[0].milName.replace('-','');
        mil3.push(mil3Name);
        mil2.push(mil2Name);
        mil1.push(mil1Name);
      } else {//if(i > this.donutData.length+1){
        let milRollup = this.donutData[i-1].domainMilRollup;
        mil3.push(milRollup[2]);
        mil2.push(milRollup[1]);
        mil1.push(milRollup[0]);
      }
      // } else {
      //   // mil3.push(donutData);
      //   // mil2.push(milRollup[1]);
      //   // mil1.push(milRollup[0]);
      // }

      //shortTitles.push(shortTitle);
      
    }

    //this.milData.push(shortTitles);
    this.milData.push(mil3);
    this.milData.push(mil2);
    this.milData.push(mil1);

    console.log(this.donutData)
  }

  milNumberFlip(mil: number) {
    switch(mil){
      case 0:
        return 3;
      case 1:
        return 2;
      case 2:
        return 1;
    }
    
  }

}
