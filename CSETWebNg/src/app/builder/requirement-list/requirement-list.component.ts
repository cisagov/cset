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
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { SetBuilderService } from '../../services/set-builder.service';
import { Requirement } from '../../models/set-builder.model';
import { RequirementResult, CategoryEntry } from '../../models/set-builder.model';
import { AddRequirementComponent } from '../../dialogs/add-requirement/add-requirement/add-requirement.component';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';
import { AlertComponent } from '../../dialogs/alert/alert.component';

@Component({
  selector: 'app-requirement-list',
  templateUrl: './requirement-list.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class RequirementListComponent implements OnInit {

  initialized = false;
  requirementResponse: any;

  addReqDialogRef: MatDialogRef<AddRequirementComponent>;

  // pageMode: string = null;
  categories: CategoryEntry[];
  subcategories: CategoryEntry[];
  focusCategory: any = null;
  newCategory: string = null;
  focusSubcategory: any = null;
  newSubcategory: string = null;

  @ViewChild('editCat') editCatControl;
  @ViewChild('editSubcat') editSubcatControl;

  /**
   * Constructor
   * @param setBuilderSvc
   * @param dialog
   */
  constructor(public setBuilderSvc: SetBuilderService,
    private dialog: MatDialog) { }

  ngOnInit() {
    this.populatePage();
  }

  /**
   *
   */
  populatePage() {
    this.setBuilderSvc.getStandard().subscribe(data => {
      this.requirementResponse = data;
      this.initialized = true;
    });

    this.setBuilderSvc.getCategoriesSubcategoriesGroupHeadings().subscribe(
      (data: any) => {
        this.categories = data.categories;
        this.subcategories = data.subcategories;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }

  /**
   *
   */
  editRequirement(r: RequirementResult) {
    // navigate to the requirement detail page
    this.setBuilderSvc.getRequirement(r.requirementID).subscribe((req: Requirement) => {
      this.setBuilderSvc.navRequirementDetail(req.requirementID);
    });
  }

  /**
   *
   */
  removeRequirement(r: RequirementResult) {
    // confirm
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      "Are you sure you want to remove the requirement?";

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dropRequirement(r);
      }
    });
  }

  /**
   *
   */
  dropRequirement(r: RequirementResult) {
    // call API with delete request
    this.setBuilderSvc.removeRequirement(r).subscribe(
      (response: {}) => {
        // refresh page
        this.populatePage();
      },
      error => {
        this.dialog
          .open(AlertComponent, { data: { title: "Error removing requirement from set" } })
          .afterClosed()
          .subscribe();
        console.log(
          "Error removing requirement: " + JSON.stringify(r)
        );
      }
    );
  }

  /**
   *
   */
  addCategory() {
    this.focusCategory = { CategoryName: '' };

    setTimeout(() => {
      this.editCatControl.nativeElement.focus();
      this.editCatControl.nativeElement.setSelectionRange(0, 0);
    }, 20);
  }

  /**
   *
   */
  saveCategory() {
    if (!!this.newCategory && this.newCategory.trim().length > 0) {

      const newCat = {
        CategoryName: this.newCategory,
        Subcategories: []
      };
      this.requirementResponse.categories.push(newCat);
    }
    this.focusCategory = null;
    this.newCategory = null;
  }

  /**
   *
   * @param cat
   */
  addSubcategory(cat: any) {
    this.focusSubcategory = {};
    this.focusCategory = cat;

    setTimeout(() => {
      this.editSubcatControl.nativeElement.focus();
      this.editSubcatControl.nativeElement.setSelectionRange(0, 0);
    }, 20);
  }

  /**
   *
   * @param cat
   */
  saveSubcategory(cat: any) {
    if (!!this.newSubcategory && this.newSubcategory.trim().length > 0) {
      const newSubcat = {
        SubcategoryName: this.newSubcategory
      };
      cat.subcategories.push(newSubcat);
    }

    this.focusCategory = null;
    this.focusSubcategory = null;
    this.newSubcategory = null;
  }

  /**
  * Launches the add requirement dialog.
  */
  addRequirementDialog() {
    this.addReqDialogRef = this.dialog.open(AddRequirementComponent);
    this.addReqDialogRef
      .afterClosed()
      .subscribe((data) => {

        // if data was returned they clicked Create.  Otherwise they clicked Cancel
        if (data) {
          this.setBuilderSvc.createRequirement(data).subscribe((r: Requirement) => {
            this.addReqDialogRef = undefined;

            this.setBuilderSvc.navRequirementDetail(r.requirementID);
          },
            error => console.log(error.message)
          );

        } else {
          // canceled out of dialog
        }
      });
  }
}
