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
import { Component, OnInit, ViewChild } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AlertComponent } from "../../dialogs/alert/alert.component";
import { MatDialog } from '@angular/material/dialog';
import { Question, BasicResponse } from '../../models/set-builder.model';

@Component({
  selector: 'app-question-list',
  templateUrl: './question-list.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class QuestionListComponent implements OnInit {

  questionResponse: any;
  initialized = false;

  questionBeingEdited: Question = null;
  originalQuestionText: string = null;
  editedQuestionInUse = false;
  duplicateTextQuestion: Question = null;

  headingBeingEdited: any = null;
  originalHeading: string = null;

  @ViewChild('editQ') editQControl;
  @ViewChild('editH') editHControl;

  constructor(
    public setBuilderSvc: SetBuilderService,
    private dialog: MatDialog
  ) { }

  ngOnInit() {
    this.populatePage();
  }

  populatePage() {
    this.setBuilderSvc.getQuestionList().subscribe(data => {
      this.questionResponse = data;
      this.initialized = true;
    });
  }

  /**
   *
   */
  startQuestionEdit(q: Question) {
    this.questionBeingEdited = q;
    this.duplicateTextQuestion = null;
    this.originalQuestionText = q.questionText;

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
  endQuestionEdit(q: Question) {
    this.editedQuestionInUse = false;
    this.questionBeingEdited = null;
    this.setBuilderSvc.updateQuestionText(q).subscribe((resp: BasicResponse) => {
      if (resp.errorMessages.indexOf('DUPLICATE QUESTION TEXT') >= 0) {
        this.duplicateTextQuestion = q;
        this.abandonQuestionEdit(q);
      }
    });
  }

  abandonQuestionEdit(q: Question) {
    q.questionText = this.originalQuestionText;
    this.editedQuestionInUse = false;
    this.questionBeingEdited = null;
  }

  /**
   *
   */
  removeQuestion(q: Question) {
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
   * Removes the question.
   */
  dropQuestion(q: Question) {
    this.setBuilderSvc.removeQuestion(q.questionID).subscribe(
      (response: {}) => {
        // refresh page
        this.populatePage();
      },
      error => {
        this.dialog
          .open(AlertComponent, { data: { title: "Error removing question from set" } })
          .afterClosed()
          .subscribe();
        console.log(
          "Error removing question: " + JSON.stringify(q)
        );
      }
    );
  }

  /**
   *
   */
  hasSAL(q: Question, level: string): boolean {
    return (q.salLevels.indexOf(level) >= 0);
  }

  /**
   * Indicates if no SAL levels are currently selected for the question.
   */
  missingSAL(q: Question) {
    if (q.salLevels.length === 0) {
      return true;
    }
    return false;
  }

  /**
   * Includes/removes the level from the list of applicable SAL levels for the question.
   */
  toggleSAL(q: Question, level: string, e) {
    let state = false;
    const checked = e.target.checked;
    const a = q.salLevels.indexOf(level);

    if (checked) {
      if (a <= 0) {
        q.salLevels.push(level);
        state = true;
      }
    } else if (a >= 0) {
      q.salLevels = q.salLevels.filter(x => x !== level);
      state = false;
    }

    this.setBuilderSvc.setSalLevel(0, q.questionID, level, state).subscribe();
  }

  /**
   *
   */
  startHeadingEdit(subcat) {
    this.originalHeading = subcat.subHeading;
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
    subcat.subHeading = this.originalHeading;
    this.originalHeading = null;
    this.headingBeingEdited = null;
  }
}
