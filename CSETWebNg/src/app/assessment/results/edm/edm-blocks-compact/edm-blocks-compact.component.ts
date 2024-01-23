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
import { Component, Input, OnChanges, OnInit } from '@angular/core';
import { MaturityService } from '../../../../services/maturity.service';

@Component({
  selector: 'app-edm-blocks-compact',
  templateUrl: './edm-blocks-compact.component.html',
  styleUrls: ['./edm-blocks-compact.component.scss', '../../../../reports/reports.scss']
})
export class EdmBlocksCompactComponent implements OnInit, OnChanges {

  @Input() section: string;

  scores: any[];

  /**
   * Constructor
   */
  constructor(public maturitySvc: MaturityService) { }

  /**
   * 
   */
  ngOnInit(): void {
  }

  /**
   * 
   */
  ngOnChanges(): void {
    this.getEdmScores();
  }

  /**
   * 
   */
  getEdmScores() {
    if (!!this.section) {
      this.maturitySvc.getEdmScores(this.section).subscribe(
        (r: any) => {
          this.scores = r;

          // now we have to manipulate the result.  
          // Remove 'parent' questions and rename their children with the parent's number
          this.scores.forEach(goal => {
            for (let i = 0; i < goal.children.length; i++) {
              const question = goal.children[i];
              if (question.children?.length > 0) {
                // clone the parent question and delete it from the goal
                const parentQuestion = Object.assign({}, question);
                goal.children.splice(i, 1);

                let insertIdx = i;

                const questionNumber = parentQuestion.title_Id.replace('Q', '');

                // promote the subquestions to the goal's question list
                for (let j = 0; j < parentQuestion.children.length; j++) {
                  const subQuestion = parentQuestion.children[j];
                  subQuestion.title_Id = questionNumber + subQuestion.title_Id;

                  const subQuestionClone = Object.assign({}, subQuestion);

                  goal.children.splice(insertIdx, 0, subQuestionClone);
                  insertIdx++;
                }
              }
            }
          });
        },
        error => console.log('RF Error: ' + (<Error>error).message)
      );
    }
  }

  /**
   * 
   * @param score 
   */
  getEdmScoreStyle(score) {
    switch (score.toLowerCase()) {
      case 'red': return 'red-score';
      case 'yellow': return 'yellow-score';
      case 'green': return 'green-score';
      default: return 'default-score';
    }
  }

  /**
   * Tries to replace "Goal" with "G" for brevity
   * @param title 
   */
  shorten(title: string): string {
    if (title.startsWith('Goal ')) {
      const s = title.split(' ');
      return 'G' + s[1];
    }
    return title;
  }

}
