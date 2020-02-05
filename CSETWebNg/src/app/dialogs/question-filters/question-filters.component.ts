////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, Inject, Output, EventEmitter } from '@angular/core';
import { QuestionsService } from '../../services/questions.service';
import { MAT_DIALOG_DATA, MatDialogRef } from '@angular/material';

@Component({
  selector: 'app-question-filters',
  templateUrl: './question-filters.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: {class: 'd-flex flex-column flex-11a'}
})
export class QuestionFiltersComponent {

  @Output() filterChanged = new EventEmitter<any>();

  constructor(public questionsSvc: QuestionsService,
    private dialog: MatDialogRef<QuestionFiltersComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) {

    // close the dialog if enter is pressed when focus is on background
    dialog.keydownEvents().subscribe(e => {
      if ((<KeyboardEvent>e).keyCode === 13) {
        this.close();
      }
    });
  }

  updateSearchString(e: Event) {
    if ((<KeyboardEvent>e).keyCode === 13) {
      this.close();
    }

    const s = (<HTMLInputElement>e.srcElement).value.trim();
    this.questionsSvc.searchString = s;

    this.filterChanged.emit(true);
  }

  updateFilters(e: Event, ans: string) {
    this.questionsSvc.setFilter(ans, (<HTMLInputElement>e.srcElement).checked);

    this.filterChanged.emit(true);
  }

  close() {
    return this.dialog.close();
  }
}
