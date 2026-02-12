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
import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-heatmap',
  standalone: false,
  templateUrl: './heatmap.component.html',
  styleUrls: ['../reports.scss', './heatmap.component.scss']
})
export class HeatmapComponent implements OnInit {

  /**
   * An array of groupings, typically the goals within a domain.
  */
  @Input()
  scores!: any[];

  /**
   * Optional - host page can suppress goal labels
   */
  @Input()
  showGoalLabels = true;

  /**
   * Optional - host page can suppress question labels
   */
  @Input()
  showQuestionLabels = true;


  colorToClassMap: Record<string, string> = {
    'red': 'red-score',
    'yellow': 'yellow-score',
    'gold': 'gold-score',
    'blue': 'blue-score',
    'green': 'green-score',
    'lightgray': 'light-gray-score',
    'default': 'default-score',
    'outline': 'outline-score'
  };


  constructor() { }

  /**
   * 
   */
  ngOnInit(): void {
    this.scores.forEach(element => this.applyScoreStyle(element));
  }

  /**
   * 
   * @param score 
   * @returns 
   */
  applyScoreStyle(element: any) {
    element.children?.forEach((child: any) => {
      this.applyScoreStyle(child);
    });

    const color = element.color?.toLowerCase() || 'lightgray';
    element.scoreClass = this.colorToClassMap[color];

    // suppress goal label
    if (!this.showGoalLabels && !element.questionId) {
      element.title = '';
    }
    // suppress question label
    if (!this.showQuestionLabels && element.questionId && element.questionId !== 0) {
      element.title = '';
    }
  }
}
