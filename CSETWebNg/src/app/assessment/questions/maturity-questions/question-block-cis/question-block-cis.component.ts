import { Component, Input, OnInit } from '@angular/core';
import { Answer } from '../../../../models/questions.model';
import { QuestionsService } from '../../../../services/questions.service';

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

  constructor(
    public questionsSvc: QuestionsService
  ) { }

  ngOnInit(): void {
    if (!!this.grouping) {
      this.questionList = this.grouping.questions;
    }

    if (!!this.questions) {
      this.questionList = this.questions;
    }
  }

  changeText(q, event) {
    this.storeAnswer(q, event.target.value);
  }

  changeMemo(q, event) {
    this.storeAnswer(q, event.target.value);
  }

  /**
   * 
   */
  storeAnswer(q, val) {
    const answer: Answer = {
      answerId: q.answerId,
      questionId: q.questionId,
      questionType: 'Maturity',
      is_Maturity: true,
      is_Component: false,
      is_Requirement: false,
      questionNumber: '',
      answerText: '',
      altAnswerText: '',
      freeResponseAnswer: val,
      comment: '',
      feedback: '',
      markForReview: false,
      reviewed: false,
      componentGuid: '00000000-0000-0000-0000-000000000000'
    };

    this.questionsSvc.storeAnswer(answer).subscribe();
  }
}
