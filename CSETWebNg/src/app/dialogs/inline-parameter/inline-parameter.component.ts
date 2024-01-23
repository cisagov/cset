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
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Question, ParameterForAnswer } from '../../models/questions.model';
import { QuestionsService } from '../../services/questions.service';

@Component({
  selector: 'app-inline-parameter',
  templateUrl: './inline-parameter.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class InlineParameterComponent implements OnInit {

  question: Question;
  parameterId: number;
  parameterValue: string;
  originalValue: string;


  constructor(private questionsSvc: QuestionsService,
    public dialogRef: MatDialogRef<InlineParameterComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) { }

  ngOnInit() {
    this.question = this.data.question;
    this.parameterId = this.data.parameterId;
    this.parameterValue = this.data.clickedToken.innerText;
    this.originalValue = this.question.parmSubs.find(s => s.id === this.parameterId).token;
  }

  /**
   * Push the new value to the API and close the dialog.
   */
  save() {
    const answerParm: ParameterForAnswer = {
      requirementId: this.question.questionId,
      answerId: this.question.answer_Id,
      parameterId: this.parameterId,
      parameterValue: this.parameterValue
    };

    // Set the AnswerID to 0 so that the API will know to create a new Answer
    if (!answerParm.answerId) {
      answerParm.answerId = 0;
    }

    this.questionsSvc.storeAnswerParameter(answerParm).subscribe(result => {
      this.dialogRef.close(result);
    });
  }

  cancel() {
    this.dialogRef.close();
  }
}
