////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { Answer } from '../../../../../models/questions.model';
import { CisService } from '../../../../../services/cis.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { QuestionsService } from '../../../../../services/questions.service';

@Component({
  selector: 'app-question-block-cis',
  templateUrl: './question-block-nested.component.html'
})
export class QuestionBlockNestedComponent implements OnInit {

  @Input() grouping: any;
  @Input() questions: any[];

  questionList: any[];

  // temporary debug aid
  showIdTag = false;

  constructor(
    public questionsSvc: QuestionsService,
    public cisSvc: CisService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    if (!!this.grouping) {
      this.questionList = this.grouping.questions;
    }

    if (!!this.questions) {
      this.questionList = this.questions;
    }
  }

  /**
   * 
   */
  changeText(q, event) {
    this.storeAnswer(q, event.target.value);
  }

  /**
   * 
   */
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

    this.cisSvc.storeAnswer(answer).subscribe(x => {
      console.log(x);
    });
  }
}
