////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import { Component, ElementRef, Input, OnChanges, OnInit, SimpleChanges, ViewChild } from '@angular/core';

@Component({
  selector: 'app-score-ranges',
  standalone: false,
  templateUrl: './score-ranges.component.html',
  styleUrl: './score-ranges.component.scss'
})
export class ScoreRangesComponent implements OnInit, OnChanges {

  @Input()
  data: any;

  categories: any[];

  @Input()
  chartWidth: number;

  labelWidth: number;

  containerWidth: number;


  @Input()
  dotFill: string;

  @Input()
  dotStroke: string;

  @Input()
  rangeBarFill: string;

  ticks: any;

  leftMargin: number = 25;

  @ViewChild('myDiv') myDiv!: ElementRef;
  divWidth: number | null = null;


  /**
   * 
   */
  ngOnInit(): void {
    this.containerWidth = this.chartWidth;
    this.labelWidth = this.chartWidth * .3;

    // build scale
    this.ticks = Array.from({ length: 11 }, (_, i) => ({
      value: i * 10,
      x: this.leftMargin + (i * this.chartWidth * .1)
    }));
  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    this.categories = this.data?.categories;
  }
}
