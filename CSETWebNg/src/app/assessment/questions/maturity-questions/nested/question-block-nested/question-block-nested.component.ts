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
import { MatDialog } from '@angular/material/dialog';
import { Answer } from '../../../../../models/questions.model';
import { CisService } from '../../../../../services/cis.service';
import { MaturityService } from '../../../../../services/maturity.service';
import { QuestionsService } from '../../../../../services/questions.service';
import { ConfigService } from '../../../../../services/config.service';
import { QuestionExtrasDialogComponent } from '../../../question-extras-dialog/question-extras-dialog.component';
import { QuestionExtrasComponent } from '../../../question-extras/question-extras.component';

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
    public cisSvc: CisService,
    private configSvc: ConfigService,
    public dialog: MatDialog
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

    this.showIdTag = this.configSvc.showQuestionAndRequirementIDs();
  }

  getMhdNum(val: string) {
    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 0) {
      return p[0];
    }
  }

  getMhdUnit(val: string) {
    if (!val) {
      return '';
    }
    let p = val.split('|');
    if (p.length > 1) {
      return p[1];
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
   * Builds a single answer from the number + unit fields
   */
  changeMinHrDay(num, unit, q) {
    let val = num.value + '|' + unit.value;

    q.answerMemo = val;
    this.storeAnswer(q, val);
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
    });
  }

  /**
   * 
   */
  openExtras(q) {
    this.dialog.open(QuestionExtrasDialogComponent, {
      data: {
        question: q,
        options: {
          eagerSupplemental: true,
          showMfr: true
        }
      },
      width: '50%',
      maxWidth: '50%'
    });
  }
}
