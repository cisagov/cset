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
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-mvra-summary',
  templateUrl: './mvra-summary.component.html'
})
export class MvraSummaryComponent implements OnInit {

  model: any = [];
  flattenedModel: any = [];
  initialized: boolean = false;
  errors: boolean = false;

  /**
   *
   */
  constructor(public maturitySvc: MaturityService) { }

  /**
   *
   */
  ngOnInit(): void {
    this.maturitySvc.getMvraScoring().subscribe(
      (r: any) => {
        this.model = r;
        this.flattenData();
        this.initialized = true;
      },
      error => {
        this.errors = true;
        console.log('Mvra Gaps load Error: ' + (<Error>error).message);
      }
    ),
      (finish) => {
      };
  }

  flattenData() {
    let m = [];
    this.model.forEach(element => {
      var goal = { title: element.title, credit: '', totalPassed: '', totalTiers: '', function: true };
      this.flattenedModel.push(goal);
      m.push(goal);
      element.levelScores.forEach(level => {
        let credit = level.totalTiers > 0 ? level.credit + '%' : 'N/A';
        var dGoal = { title: level.level, credit: credit, totalPassed: level.totalPassed, totalTiers: level.totalTiers, function: false }
        m.push(dGoal)
      })
    });
    this.flattenedModel = Object.assign([], m)
  }
}
