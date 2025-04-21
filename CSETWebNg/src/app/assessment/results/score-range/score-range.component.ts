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

@Component({
  selector: 'app-score-range',
  standalone: false,
  templateUrl: './score-range.component.html',
  styleUrl: './score-range.component.scss'
})
export class ScoreRangeComponent implements OnInit {

  @Input()
  chartWidth: number;

  containerWidth: number;



  /**
   * height this svg is rendered at
   */
  h = 70;

  barH: number;

  @Input()
  label: string;

  @Input()
  min: number;

  @Input()
  max: number;

  @Input()
  median: number;

  @Input()
  average: number;

  @Input()
  myScore: number;

  @Input()
  myColor = "#0000aa";

  rangeColor = "#87909e";

  padding = 10;

  /**
   * padding value to get things away from the left and right edge
   */
  p = 25;


  ngOnInit(): void {
    this.containerWidth = this.chartWidth * 1.25;
    this.barH = this.h * .1;
  }
}
