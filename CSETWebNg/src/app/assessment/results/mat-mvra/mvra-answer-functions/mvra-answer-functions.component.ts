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
  selector: 'app-mvra-answer-functions',
  templateUrl: './mvra-answer-functions.component.html'
})
export class MvraAnswerFunctionsComponent implements OnChanges {

  @Input() model: any;

  colorScheme1 = { domain: ['#007BFF'] };
  xAxisTicks = [0, 25, 50, 75, 100];
  graphModel: any = [];

  constructor() { }


  ngOnChanges(changes: SimpleChanges): void {
    this.model = changes.model.currentValue;
    this.createGraphByFunction();
  }

  createGraphByFunction() {
    let m = [];
    if (this.model) {
      this.model.forEach(element => {
        var goal = { name: element.title, value: element.credit };
        m.push(goal);
      });
    }
    this.graphModel = Object.assign([], m)
  }


  formatPercent(x: any) {
    return x + '%';
  }
}
