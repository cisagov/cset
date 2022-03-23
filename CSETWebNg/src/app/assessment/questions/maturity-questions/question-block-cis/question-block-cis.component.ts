import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-question-block-cis',
  templateUrl: './question-block-cis.component.html'
})
export class QuestionBlockCisComponent implements OnInit {

  @Input() grouping: any;
  @Input() questions: any[];

  questionList: any[];

  // temporary debug aid
  showIdTag = false;

  constructor() { }

  ngOnInit(): void {
    if (!!this.grouping) {
      this.questionList = this.grouping.questions;
    }

    if (!!this.questions) {
      this.questionList = this.questions;
    }
  }

  changeText(q, event) {

  }

  changeMemo(q, event) {

  }

}
