import { Component, OnInit, Inject, Output, EventEmitter } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { Requirement, CategoryEntry } from '../../../models/set-builder.model';
import { SetBuilderService } from '../../../services/set-builder.service';

@Component({
  selector: 'app-add-requirement',
  templateUrl: './add-requirement.component.html',
  // tslint:disable-next-line:use-host-property-decorator
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
        this.categories = data.Categories;
        this.subcategories = data.Subcategories;
        this.groupHeadings = data.GroupHeadings;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }

  create() {
    if (this.model) {
      // validate the entry
      this.submitted = true;

      if (!this.model.Category || this.model.Category.trim().length === 0
        || !this.model.Subcategory || this.model.Subcategory.trim().length === 0
        || !this.model.QuestionGroupHeadingID
        || !this.model.Title || this.model.Title.trim().length === 0
        || !this.model.RequirementText || this.model.RequirementText.trim().length === 0) {
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
