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
import { Component, Input, OnChanges } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'edm-q-blocks-horizontal',
  templateUrl: './edm-q-blocks-horizontal.component.html',
  styleUrls: ['./edm-q-blocks-horizontal.component.scss', '../../../../reports/reports.scss']
})
export class EdmQBlocksHorizontalComponent implements OnChanges {


  /**
   * hand me a list of Qx and a color
   */
  @Input()
  scoresForGoal: any;


  /**
   * 
   * @param maturitySvc 
   */
  constructor(
    public maturitySvc: MaturityService
  ) { }


  /**
   * Manipulate the question array if there are parent/sub questions present
   */
  ngOnChanges(): void {
    // Remove 'parent' questions and rename their children with the parent's number
    for (let i = 0; i < this.scoresForGoal?.children.length; i++) {
      const question = this.scoresForGoal.children[i];
      if (question.children?.length > 0) {
        // clone the parent question and delete it from the goal
        const parentQuestion = Object.assign({}, question);
        this.scoresForGoal.children.splice(i, 1);

        let insertIdx = i;

        const questionNumber = parentQuestion.title_Id.replace('Q', '');

        // promote the subquestions to the goal's question list
        for (let j = 0; j < parentQuestion.children.length; j++) {
          const subQuestion = parentQuestion.children[j];
          subQuestion.title_Id = questionNumber + subQuestion.title_Id;

          const subQuestionClone = Object.assign({}, subQuestion);

          this.scoresForGoal.children.splice(insertIdx, 0, subQuestionClone);
          insertIdx++;
        }
      }
    }
  }

  /**
   * 
   * @param q 
   */
  getEdmScoreStyle(color: string) {
    switch (color.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      default: return 'default-score';
    }
  }

}
