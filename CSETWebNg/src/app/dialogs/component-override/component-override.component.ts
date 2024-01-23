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
import { Component, Inject } from '@angular/core';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material/dialog';
import { ConfigService } from '../../services/config.service';
import { Answer } from '../../models/questions.model';
import { QuestionsService } from '../../services/questions.service';

@Component({
  selector: 'component-override',
  templateUrl: './component-override.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' },
  // styleUrls: ['./component-override.component.scss']
})
export class ComponentOverrideComponent {

  questions: any[] = [];
  loading: boolean = true;
  questionChanged: boolean;
  private _timeoutId: NodeJS.Timeout;

  /**
   * Constructor.
   */
  constructor(private dialog: MatDialogRef<ComponentOverrideComponent>,
    public configSvc: ConfigService, public questionsSvc: QuestionsService,
    @Inject(MAT_DIALOG_DATA) public data: any) {
    dialog.beforeClosed().subscribe(() => dialog.close(this.questionChanged));
    this.questionsSvc.getOverrideQuestions(data.myQuestion.questionId,
      data.component_Symbol_Id).subscribe((x: any) => {
        this.questions = x;
        this.loading = false;
        this.questionChanged = false;

        this.questions.forEach(q => {
          q.altAnswerText = q.alternate_Justification;
        });
      });
  }

  /**
 * 
 * @param ans 
 */
  showThisOption(ans: string) {
    if (!this.questionsSvc.questions) {
      return true;
    }
    return this.questionsSvc.questions?.answerOptions.indexOf(ans) >= 0;
  }

  storeAnswer(q: any, newAnswerValue: string) {
    // if they clicked on the same answer that was previously set, "un-set" it
    if (q.answer === newAnswerValue) {
      newAnswerValue = "U";
    }

    q.answer_Text = newAnswerValue;

    q.question_Number = this.data.myQuestion.displayNumber;

    const answer: Answer = {
      answerId: q.answer_Id,
      questionId: q.question_Id,
      questionType: q.questionType,
      questionNumber: q.question_Number,
      answerText: q.answer_Text,
      altAnswerText: q.altAnswerText,
      comment: q.comment,
      feedback: q.feedback,
      markForReview: q.markForReview,
      reviewed: q.reviewed,
      is_Component: q.is_Component,
      is_Requirement: q.is_Requirement,
      is_Maturity: q.is_Maturity,
      componentGuid: q.component_GUID
    };


    // update the master question structure
    this.questionsSvc.setAnswerInQuestionList(q.question_Id, q.answer_Id, q.answer_Text);

    this.questionsSvc.storeAnswer(answer).subscribe();
    this.questionChanged = true;
  }


  close() {
    return this.dialog.close(this.questionChanged);
  }

  applyHeight() {
    const styles = { 'max-height': window.screen.availHeight };
    return styles;
  }
}
