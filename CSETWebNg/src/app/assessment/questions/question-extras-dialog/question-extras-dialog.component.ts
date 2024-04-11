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
import { Component, Inject, OnInit } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Question } from '../../../models/questions.model';

/**
 * This component is a wrapper so that question-extras can be
 * hosted in a dialog.
 */
@Component({
  selector: 'app-question-extras-dialog',
  templateUrl: './question-extras-dialog.component.html'
})
export class QuestionExtrasDialogComponent implements OnInit {

  q: Question;
  options: any;

  constructor(
    private dialog: MatDialogRef<QuestionExtrasDialogComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any
  ) {
  }

  /**
   *
   */
  ngOnInit(): void {
    this.q = this.data.question;
    this.options = this.data.options;

    this.q.freeResponseAnswer = this.q.answerMemo;
    this.q.is_Maturity = true;
    this.q.questionType = this.data.question.questionType ?? 'Maturity';
    this.q.is_Component = false;
  }


  /**
   *
   */
  close() {
    return this.dialog.close();
  }
}
