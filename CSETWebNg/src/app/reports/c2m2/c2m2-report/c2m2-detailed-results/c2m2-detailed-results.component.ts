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

@Component({
  selector: 'app-c2m2-detailed-results',
  templateUrl: './c2m2-detailed-results.component.html',
  styleUrls: ['../c2m2-report.component.scss', '../../../reports.scss']
})
export class C2m2DetailedResultsComponent implements OnInit {

  constructor() { }

  @Input() donutData: any[] = [];
  @Input() tableData: any[] = [];

  questionDistribution: any[] = [];
  tableIndex: number = 1;
  loading: boolean = true;

  ngOnInit(): void {
    for (let i = 0; i < this.donutData.length; i++) {
      let objectives = this.donutData[i].objectives;
      for (let j = 0; j < objectives.length; j++) {
        this.questionDistribution.push(objectives[j]);
      }
    }

    this.loading = false;
  }

  removeHyphen(title: string) {
    let fixedString = '';
    fixedString = title.replace('-', ' ');
    return fixedString;
  }

  getHeatMapColor(answer: string) {
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

  getHeapMapTextColor(answer: string) {
    if (answer == 'FI') {
      return 'white';
    } else {
      return 'black';
    }
  }
}
