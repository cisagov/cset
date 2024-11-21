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
import { Component, ElementRef, HostListener, Input, OnChanges, OnInit, SimpleChanges, ViewChild } from '@angular/core';

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

  // categories: any[] = [
  //   { label: 'Invent', min: 10, max: 77, median: 42, myScore: 33},
  //   { label: 'Prevent', min: 40, max: 95, median: 61, myScore: 83},
  //   { label: 'Circumvent', min: 25, max: 54, median: 33, myScore: 50},
  //   { label: 'Dryer Vent', min: 0, max: 94, median: 67, myScore: 23},
  //   { label: 'Lament', min: 47, max: 62, median: 52, myScore: 47},
  //   { label: 'Intent', min: 8, max: 80, median: 63, myScore: 33},
  //   { label: 'Get Bent', min: 14, max: 58, median: 36, myScore: 29}
  // ];

  @Input()
  chartWidth: number;

  containerWidth: number;


  @Input()
  myColor: string;

  ticks: any;

  @ViewChild('myDiv') myDiv!: ElementRef;
  divWidth: number | null = null;


  /**
   * 
   */
  ngOnInit(): void {
    this.containerWidth = this.chartWidth * 1.05;

    // build scale
    this.ticks = Array.from({ length: 11 }, (_, i) => ({
      value: i * 10,
      x: (i * this.chartWidth * .1)
    }));
  }

  /**
   * 
   */
  ngOnChanges(changes: SimpleChanges): void {
    this.categories = this.data?.categories;
  }
}
