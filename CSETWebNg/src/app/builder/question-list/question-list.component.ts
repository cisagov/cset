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
import { Component, OnInit, ViewChildren, ViewChild } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { MatDialog } from '@angular/material';
import { QuestionResult } from '../../models/set-builder.model';

@Component({
  selector: 'app-question-list',
  templateUrl: './question-list.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class QuestionListComponent implements OnInit {

  questionResponse: any;
  initialized = false;

  questionBeingEdited: QuestionResult = null;
  originalQuestionText: string = null;
  editedQuestionInUse = false;

  headingBeingEdited: any = null;
  originalHeading: string = null;

  @ViewChild('editQ') editQControl;
  @ViewChild('editH') editHControl;

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

  /**
   * Converts linebreak characters to HTML <br> tag.
   */
  formatLinebreaks(text: string) {
    return text.replace(/(?:\r\n|\r|\n)/g, '<br />');
  }

  /**
   *
   */
  startQuestionEdit(q: QuestionResult) {
    this.questionBeingEdited = q;
    this.originalQuestionText = q.QuestionText;

    setTimeout(() => {
      this.editQControl.nativeElement.focus();
      this.editQControl.nativeElement.setSelectionRange(0, 0);
    }, 20);

    this.setBuilderSvc.isQuestionInUse(q).subscribe((inUse: boolean) => {
      this.editedQuestionInUse = inUse;
    });
  }

  /**
   *
   */
  endQuestionEdit(q: QuestionResult) {
    this.editedQuestionInUse = false;
    this.questionBeingEdited = null;
    this.setBuilderSvc.updateQuestionText(q).subscribe();
  }

  abandonQuestionEdit(q: QuestionResult) {
    q.QuestionText = this.originalQuestionText;
    this.editedQuestionInUse = false;
    this.questionBeingEdited = null;
  }

  /**
   *
   */
  removeQuestion(q: QuestionResult) {
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
  dropQuestion(q: QuestionResult) {
    this.questionResponse.Categories.forEach((cat: any, indexCat: number) => {
      cat.Subcategories.forEach((subcat: any, indexSubcat: number) => {
        const i = subcat.Questions.findIndex((x: any) => x.QuestionID === q.QuestionID);
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

    this.setBuilderSvc.removeQuestion(q.QuestionID).subscribe(
      (response: {}) => { },
      error => {
        this.dialog
          .open(AlertComponent, { data: "Error removing question from set" })
          .afterClosed()
          .subscribe();
        console.log(
          "Error removing assessment contact: " + JSON.stringify(q)
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
   * Indicates if no SAL levels are currently selected for the question.
   */
  missingSAL(q: QuestionResult) {
    if (q.SalLevels.length === 0) {
      return true;
    }
    return false;
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
   *
   */
  startHeadingEdit(subcat) {
    this.originalHeading = subcat.SubHeading;
    this.headingBeingEdited = subcat;

    setTimeout(() => {
      this.editHControl.nativeElement.focus();
      this.editHControl.nativeElement.setSelectionRange(0, 0);
    }, 20);
  }

  /**
   *
   */
  endHeadingEdit(subcat) {
    this.headingBeingEdited = null;
    this.originalHeading = null;

    // push to API ...
    this.setBuilderSvc.updateHeadingText(subcat).subscribe();
  }

  /**
   *
   */
  abandonHeadingEdit(subcat) {
    subcat.SubHeading = this.originalHeading;
    this.originalHeading = null;
    this.headingBeingEdited = null;
  }
}
