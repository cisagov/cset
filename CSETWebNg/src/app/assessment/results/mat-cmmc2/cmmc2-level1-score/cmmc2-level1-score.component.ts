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
import { Component, Input, OnInit } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';
import { TsaService } from '../../../../services/tsa.service';

@Component({
    selector: 'app-cmmc2-level1-score',
    templateUrl: './cmmc2-level1-score.component.html',
    styleUrl: './cmmc2-level1-score.component.scss',
    standalone: false
})
export class Cmmc2Level1ScoreComponent {

  width = 700;


  @Input()
  score: number;

  @Input()
  maxScore: number;

  @Input()
  active = true;


  /**
   * Normalizes a score to the x coordinates of the chart
   * The max width in score is 313.  (offset / 313)
   */
  n(s: number) {
    if (s == null) {
      return 0;
    }
    
    return (s / this.maxScore) * this.width;
  }
}
