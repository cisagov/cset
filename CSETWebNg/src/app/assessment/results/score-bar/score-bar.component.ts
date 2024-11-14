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
  selector: 'app-score-bar',
  standalone: false,
  templateUrl: './score-bar.component.html',
  styleUrl: './score-bar.component.scss'
})
export class ScoreBarComponent implements OnInit {

  @Input()
  chartWidth: number;

  rangeStart = 10;
  rangeWidth: number;

  /**
   * height this svg is rendered at
   */
  h = 40;

  @Input()
  label: string;

  @Input()
  min: number;

  @Input()
  max: number;

  @Input()
  median: number;

  @Input()
  myScore: number;

  /**
   * padding value to get things away from the left and right edge
   */
  p = 10;


  ngOnInit(): void {
    this.rangeWidth = this.chartWidth - 10;
  }
}
