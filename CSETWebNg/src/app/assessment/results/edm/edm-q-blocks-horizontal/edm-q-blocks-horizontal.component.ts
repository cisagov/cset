import { Component, Input, OnChanges, OnInit } from '@angular/core';
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

        const questionNumber = parentQuestion.Title_Id.replace('Q', '');

        // promote the subquestions to the goal's question list
        for (let j = 0; j < parentQuestion.children.length; j++) {
          const subQuestion = parentQuestion.children[j];
          subQuestion.Title_Id = questionNumber + subQuestion.Title_Id;

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
