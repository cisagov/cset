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
import { Component, Input, OnInit } from '@angular/core';
import { ReportService } from '../../../../services/report.service';

@Component({
  selector: 'app-c2m2-summary-results',
  templateUrl: './c2m2-summary-results.component.html',
  styleUrls: ['../c2m2-report.component.scss', '../../../reports.scss']
})
export class C2m2SummaryResultsComponent implements OnInit {

  @Input() donutData: any[];
  @Input() tableData: any;

  domainCategories = [];
  milData: any[] = [];

  loading: boolean = true;

  constructor(
    public reportSvc: ReportService
  ) { }

  ngOnInit(): void {
    this.getDomainCategories();

    let mil3 = [];
    let mil2 = [];
    let mil1 = [];
    let milsAchieved = [];

    for (let i = 0; i < this.donutData.length + 1; i++) {
      if (i == 0) {
        let mil3Name = this.donutData[0].domainMilRollup[2].milName.replace('-', '');
        let mil2Name = this.donutData[0].domainMilRollup[1].milName.replace('-', '');
        let mil1Name = this.donutData[0].domainMilRollup[0].milName.replace('-', '');
        mil3.push(mil3Name);
        mil2.push(mil2Name);
        mil1.push(mil1Name);
        milsAchieved.push('MIL Achieved')
      } else {
        let milRollup = this.donutData[i - 1].domainMilRollup;
        mil3.push(milRollup[2]);
        mil2.push(milRollup[1]);
        mil1.push(milRollup[0]);
      }

      if (i < this.donutData.length) {
        milsAchieved.push(this.donutData[i].milAchieved);
      }
    }

    this.milData.push(mil3);
    this.milData.push(mil2);
    this.milData.push(mil1);
    this.milData.push(milsAchieved);

    this.loading = false;
  }

  milNumberFlip(mil: number) {
    switch (mil) {
      case 0:
        return 3;
      case 1:
        return 2;
      case 2:
        return 1;
    }
  }

  getDomainCategories() {
    for (let i = 0; i < this.tableData.domainList.length; i++) {
      let text = this.tableData.domainList[i].objectives[0].practices[0].title
      let modifiedText = text.split('-')[0];
      this.domainCategories.push(modifiedText);
    }
  }

  getBackgroundColor(answer: string) {
    switch (answer) {
      case 'FI':
        return '#265B94';
      case 'LI':
        return '#90A5C7';
      case 'PI':
        return '#F5DA8C';
      case 'NI':
        return '#DCA237';
      case 'U':
      case null:
        return '#E6E6E6';
    }
  }

  getTextColor(answer: string) {
    if (answer == 'FI') {
      return 'white';
    } else {
      return 'black';
    }
  }

}
