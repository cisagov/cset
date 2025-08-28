import { Component, Input, OnInit } from '@angular/core';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-vadr-grouping-block',
  standalone: false,
  templateUrl: './vadr-grouping-block.component.html',
  styleUrls: ['../../reports.scss']
})
export class VadrGroupingBlockComponent implements OnInit {

  @Input() grouping;


  constructor(
    public questionsSvc: QuestionsService
  ) { }


  ngOnInit(): void {
    console.log(this.grouping);
  }

  /**
   * Sets the coloring of a cell based on its answer.
   * @param answer
   */
  answerCellClass(answer: string) {
    switch (answer) {
      case 'Y':
        return 'green-score';
      case 'NA':
        return 'blue-score';
      case 'N':
        return 'red-score';
      case 'U':
        return 'default-score';
    }
  }
}
