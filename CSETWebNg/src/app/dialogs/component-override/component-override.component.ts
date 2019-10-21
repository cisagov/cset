////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';
import { ConfigService } from '../../services/config.service';
import { Answer } from '../../models/questions.model';
import { QuestionsService } from '../../services/questions.service';

@Component({
  selector: 'component-override',
  templateUrl: './component-override.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' },
  styleUrls: ['./component-override.component.scss']
})
export class ComponentOverrideComponent {

  questions:any[]=[];
  loading:boolean=true;
  constructor(private dialog: MatDialogRef<ComponentOverrideComponent>,
  public configSvc: ConfigService, public questionsSvc: QuestionsService,
  @Inject(MAT_DIALOG_DATA) public data: any) {
    console.log(data);
    this.questionsSvc.getOverrideQuestions(data.myQuestion.QuestionId,
      data.Component_Symbol_Id).subscribe((x:any) =>{
      this.questions = x;
      this.loading = false;
    });
  }

  storeAnswer(q: any, newAnswerValue: string) {
    // if they clicked on the same answer that was previously set, "un-set" it	
    if (q.Answer === newAnswerValue) {
      newAnswerValue = "U";
    }

    q.Answer_Text = newAnswerValue;

    const answer: Answer = {
      QuestionId: q.Question_Id,
      QuestionNumber: q.Question_Number,
      AnswerText: q.Answer_Text,
      AltAnswerText: '',
      Comment: '',
      FeedBack: '',
      MarkForReview: false,
      Reviewed: false,
      Is_Component: q.Is_Component,
      ComponentGuid: q.Component_GUID
    };

    // update the master question structure
    this.questionsSvc.setAnswerInQuestionList(q.Question_Id, q.Answer_Id, q.Answer_Text);

    this.questionsSvc.storeAnswer(answer)
      .subscribe();
  }

  close() {
    return this.dialog.close();
  }

  applyHeight() {
    const styles = { 'max-height': window.screen.availHeight };
    return styles;
  }
}
