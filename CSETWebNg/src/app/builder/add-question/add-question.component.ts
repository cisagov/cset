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
import { CategoryEntry } from '../../models/set-builder.model';

@Component({
  selector: 'app-add-question',
  templateUrl: './add-question.component.html'
})
export class AddQuestionComponent implements OnInit {

  newQuestionText: string = '';
  isDupeQuestion = false;
  isNewQuestionEmpty = false;
  isCatOrSubcatEmpty = false;

  categories: CategoryEntry[];
  subcategories: CategoryEntry[];
  selectedCatId: number = 0;
  selectedSubcatId: number = 0;

  constructor(private setBuilderSvc: SetBuilderService) { }

  ngOnInit() {
    this.getCategories();
  }

  getCategories() {
    this.setBuilderSvc.getCategories().subscribe(
      (data: CategoryEntry[]) => {
        this.categories = data;

        // populate Subcategory dropdown based on Category
        this.changeCategory(this.selectedCatId);
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }

  /**
   * When the user changes the selected category, get the list of corresponding subcategories.
   * @param categoryId
   */
  changeCategory(categoryId: number) {
    if (!categoryId) {
      return;
    }
    if (categoryId === 0) {
      return;
    }

    this.setBuilderSvc.getSubcategories(categoryId).subscribe(
      (data: CategoryEntry[]) => {
        this.subcategories = data;
        this.selectedSubcatId = 0;
      },
      error => {
        console.log('Error Getting Subcategories: ' + (<Error>error).name + (<Error>error).message);
        console.log('Error Getting Subcategories (cont): ' + (<Error>error).stack);
      });
  }

  /**
   * Creates a new question for the set.
   */
  addCustomQuestion() {
    // validate that they typed something
    this.newQuestionText = this.newQuestionText.trim();

    this.isNewQuestionEmpty = (this.newQuestionText.length === 0);
    this.isCatOrSubcatEmpty = this.selectedCatId === 0 || this.selectedSubcatId === 0;
    this.isDupeQuestion = false;

    if (this.isNewQuestionEmpty || this.isCatOrSubcatEmpty) {
      return;
    }

    // check to see if this question text already exists in the database.
    this.setBuilderSvc.existsQuestionText(this.newQuestionText).subscribe(result => {
      this.isDupeQuestion = result as boolean;
      if (this.isDupeQuestion) {
        this.isNewQuestionEmpty = false;
        return;
      }

      // push it to the API
      this.setBuilderSvc.addQuestion(this.newQuestionText, this.selectedCatId, this.selectedSubcatId).subscribe(() => {
        // navigate back to the questions list
        this.setBuilderSvc.navQuestionList();
      });
    });
  }
}
