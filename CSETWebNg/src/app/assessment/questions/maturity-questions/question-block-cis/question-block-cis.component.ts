import { Component, Input, OnInit } from '@angular/core';

@Component({
  selector: 'app-question-block-cis',
  templateUrl: './question-block-cis.component.html'
})
export class QuestionBlockCisComponent implements OnInit {

  @Input() grouping: any;
  @Input() questions: any[];

  questionList: any[];

  constructor() { }

  ngOnInit(): void {
    console.log('question-block');
    console.log(this.grouping);
    console.log(this.questions);

    if (!!this.grouping) {
      this.questionList = this.grouping.questions;
    }

    if (!!this.questions) {
      this.questionList = this.questions;
    }
  }

}
