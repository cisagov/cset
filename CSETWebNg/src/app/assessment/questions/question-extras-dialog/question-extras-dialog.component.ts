import { Component, Inject, Input, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
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

    this.q.is_Maturity = true;
    this.q.questionType = this.data.question.questionType;
    this.q.is_Component = false;
  }


  /**
   *
   */
  close() {
    return this.dialog.close();
  }
}
