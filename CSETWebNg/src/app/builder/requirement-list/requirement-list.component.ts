import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog } from '@angular/material';
import { SetBuilderService } from '../../services/set-builder.service';
import { Category } from '../../models/set-builder.model';
import { RequirementResult, CategoryEntry } from '../../models/set-builder.model';

@Component({
  selector: 'app-requirement-list',
  templateUrl: './requirement-list.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class RequirementListComponent implements OnInit {

  initialized = false;
  requirementResponse: any;


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
  constructor(private setBuilderSvc: SetBuilderService,
    private dialog: MatDialog) { }

  ngOnInit() {
    this.setBuilderSvc.getStandard().subscribe(data => {
      this.requirementResponse = data;
      this.initialized = true;
    });

    this.setBuilderSvc.getCategoriesAndSubcategories().subscribe(
      (data: any) => {
        this.categories = data.Categories;
        this.subcategories = data.Subcategories;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
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
  editRequirement(r: RequirementResult) {
    this.setBuilderSvc.navRequirementDetail(r);
  }

  /**
   *
   */
  addCategory() {
    this.focusCategory = {CategoryName: ''};

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
      this.requirementResponse.Categories.push(newCat);
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
      cat.Subcategories.push(newSubcat);
    }

    this.focusCategory = null;
    this.focusSubcategory = null;
    this.newSubcategory = null;
  }
}
