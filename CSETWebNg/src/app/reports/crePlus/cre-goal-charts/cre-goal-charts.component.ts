////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { CreService } from '../../../services/cre.service';

@Component({
  selector: 'app-cre-goal-charts',
  templateUrl: './cre-goal-charts.component.html',
  styleUrls: ['../../reports.scss'],
  standalone: false,
})
export class creGoalChartsComponent implements OnChanges {

  @Input() domainDistrib: any;

  stackedModel: any[];

  stackedHeight: number;
  stackedPadding: number;

  constructor(
    public creSvc: CreService
  ) {  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    if (!!this.domainDistrib) { 
      this.stackedModel = this.domainDistrib.subgroups;
      this.calcStackedHeight();
    }
  }

  /**
   * 
   */
  calcStackedHeight() {
    this.stackedHeight = Math.max(200, this.domainDistrib.subgroups.length * 50 + 100);
    this.stackedPadding = Math.max(10, 30 - this.domainDistrib.subgroups.length);
  }
}
