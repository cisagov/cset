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
import { QuestionResult } from '../../models/set-builder.model';

@Component({
  selector: 'app-question-list',
  templateUrl: './question-list.component.html'
})
export class QuestionListComponent implements OnInit {

  questionResponse: any;
  initialized = false;

  constructor(
    private setBuilderSvc: SetBuilderService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.setBuilderSvc.getQuestionList().subscribe(data => {
      this.questionResponse = data;
      this.initialized = true;
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

  /**
   * Finds the question in the structure and removes it.
   */
  dropQuestion(question) {
    this.questionResponse.Categories.forEach((cat: any, indexCat: number) => {
      cat.Subcategories.forEach((subcat: any, indexSubcat: number) => {
        const i = subcat.Questions.findIndex((x: any) => x.QuestionID === question.QuestionID);
        if (i >= 0) {

          // remove question
          subcat.Questions.splice(i, 1);

          // remove empty subcategory
          if (subcat.Questions.length === 0) {
            cat.Subcategories.splice(indexSubcat, 1);
          }

          // remove empty category
          if (cat.Subcategories.length === 0) {
            this.questionResponse.Categories.splice(indexCat, 1);
          }
        }
      });
    });

    this.setBuilderSvc.removeQuestion(question.QuestionID).subscribe(
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

  /**
   *
   */
  hasSAL(q: QuestionResult, level: string): boolean {
    return (q.SalLevels.indexOf(level) >= 0);
  }

  /**
   * Includes/removes the level from the list of applicable SAL levels for the question.
   */
  toggleSAL(q: QuestionResult, level: string, e: Event) {
    let state = false;

    const a = q.SalLevels.indexOf(level);
    if (a === -1) {
      q.SalLevels.push(level);
      state = true;
    } else {
      q.SalLevels = q.SalLevels.filter(x => x !== level);
      state = false;
    }

    this.setBuilderSvc.setQuestionSalLevel(q.QuestionID, level, state).subscribe();
  }

  /**
   * Indicates if no SAL levels are currently selected for the question.
   */
  missingSAL(q: QuestionResult) {
    if (q.SalLevels.length === 0) {
      return true;
    }
    return false;
  }
}
