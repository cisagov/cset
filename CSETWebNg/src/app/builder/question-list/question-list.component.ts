////////////////////////////////
//
//   Copyright 2018 Battelle Energy Alliance, LLC
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
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { MatDialog } from '@angular/material';

@Component({
  selector: 'app-question-list',
  templateUrl: './question-list.component.html'
})
export class QuestionListComponent implements OnInit {

  questionList: any;

  constructor(
    private setBuilderSvc: SetBuilderService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.setBuilderSvc.getQuestionList().subscribe(data => {
      this.questionList = data;
    });
  }

  navAddQuestion() {
    this.setBuilderSvc.navAddQuestion();
  }

  removeQuestion(q) {
    // confirm
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      "Are you sure you want to remove the question?";

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dropQuestion(q);
      }
    });
  }


  dropQuestion(question) {
    console.log(question);

    this.questionList.splice(
      this.questionList.findIndex(x => x.QuestionID === question.QuestionID), 1);

    const setName = sessionStorage.getItem('setName');

    this.setBuilderSvc.removeQuestion(setName, question.QuestionID).subscribe(
      (response: {}) => { },
      error => {
        this.dialog
          .open(AlertComponent, { data: "Error removing question from set" })
          .afterClosed()
          .subscribe();
        console.log(
          "Error removing assessment contact: " + JSON.stringify(question)
        );
      }
    );
  }

}
