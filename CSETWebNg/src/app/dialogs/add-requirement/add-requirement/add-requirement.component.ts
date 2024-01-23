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
import { Requirement, CategoryEntry } from '../../../models/set-builder.model';
import { SetBuilderService } from '../../../services/set-builder.service';

@Component({
  selector: 'app-add-requirement',
  templateUrl: './add-requirement.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AddRequirementComponent implements OnInit {

  model: Requirement = {};

  categories: CategoryEntry[];
  subcategories: CategoryEntry[];
  groupHeadings: CategoryEntry[];

  submitted = false;

  constructor(private setBuilderSvc: SetBuilderService,
    private dialog: MatDialogRef<AddRequirementComponent>,
    @Inject(MAT_DIALOG_DATA) public data: any) {

  }

  ngOnInit() {
    this.setBuilderSvc.getCategoriesSubcategoriesGroupHeadings().subscribe(
      (data: any) => {
        this.categories = data.categories;
        this.subcategories = data.subcategories;
        this.groupHeadings = data.groupHeadings;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }

  create() {
    if (this.model) {
      // validate the entry
      this.submitted = true;

      if (!this.model.category || this.model.category.trim().length === 0
        || !this.model.subcategory || this.model.subcategory.trim().length === 0
        || !this.model.questionGroupHeadingID
        || !this.model.title || this.model.title.trim().length === 0
        || !this.model.requirementText || this.model.requirementText.trim().length === 0) {
        return;
      }

      this.setBuilderSvc.activeRequirement = this.model;

      this.dialog.close(this.model);
    }
  }

  cancel() {
    this.dialog.close();
  }
}
