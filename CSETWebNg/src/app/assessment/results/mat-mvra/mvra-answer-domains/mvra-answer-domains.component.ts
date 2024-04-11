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
import { Component, Input, OnChanges, SimpleChanges } from '@angular/core';

@Component({
  selector: 'app-mvra-answer-domains',
  templateUrl: './mvra-answer-domains.component.html',
  styleUrls: ['./mvra-answer-domains.component.scss', '../../../../reports/reports.scss']
})
export class MvraAnswerDomainsComponent implements OnChanges {

  @Input() model: any[];
  flattenedModel: any = [];

  constructor() { }

  ngOnChanges(changes: SimpleChanges): void {
    this.model = changes.model.currentValue;
    this.flattenData();
  }

  flattenData() {
    let m = [];
    this.model.forEach(element => {
      var goal = { title: element.title, credit: element.credit + '%', rating: '', function: true };
      this.flattenedModel.push(goal);
      m.push(goal);
      element.domainScores.forEach(domain => {
        var dGoal = { title: domain.title, credit: domain.credit, rating: domain.rating, function: false }
        m.push(dGoal)
      })
    });
    this.flattenedModel = Object.assign([], m)
  }

}
