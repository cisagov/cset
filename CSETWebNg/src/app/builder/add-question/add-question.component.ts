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
import { CategoryEntry, QuestionResult } from '../../models/set-builder.model';
import { ChartLegendLabelItem } from 'chart.js';

@Component({
  selector: 'app-add-question',
  templateUrl: './add-question.component.html'
})
export class AddQuestionComponent implements OnInit {

  newQuestionText: string = '';
  isDupeQuestion = false;
  isNewQuestionEmpty = false;
  isCatOrSubcatEmpty = false;
  isSalSelectionEmpty = false;

  // custom add SAL values
  customSalL = false;
  customSalM = false;
  customSalH = false;
  customSalVH = false;

  categories: CategoryEntry[];
  subcategories: CategoryEntry[];
  selectedCatId: number = 0;
  subcatText: string;

  searching = false;
  searchTerms: string;
  searchPerformed = false;
  searchHits: QuestionResult[] = null;
  selectedQuestionId: number;

  constructor(private setBuilderSvc: SetBuilderService) { }

  ngOnInit() {
    this.getCategoriesAndSubcategories();
  }

  getCategoriesAndSubcategories() {
    this.setBuilderSvc.getCategoriesAndSubcategories().subscribe(
      (data: any) => {
        this.categories = data.Categories;
        this.subcategories = data.Subcategories;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }

  /**
   * Creates a new question for the set.
   */
  addCustomQuestion() {
    // validate that they typed something
    this.newQuestionText = this.newQuestionText.trim();

    this.isNewQuestionEmpty = (this.newQuestionText.length === 0);
    this.isCatOrSubcatEmpty = this.selectedCatId === 0 || this.subcatText.trim().length === 0;
    this.isSalSelectionEmpty = !this.customSalL && !this.customSalM && !this.customSalH && !this.customSalVH;
    this.isDupeQuestion = false;

    if (this.isNewQuestionEmpty || this.isCatOrSubcatEmpty || this.isSalSelectionEmpty) {
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
      const salLevels: string[] = [];
      if (this.customSalL) { salLevels.push("L"); }
      if (this.customSalM) { salLevels.push("M"); }
      if (this.customSalH) { salLevels.push("H"); }
      if (this.customSalVH) { salLevels.push("VH"); }
      this.setBuilderSvc.addQuestion(this.newQuestionText, this.selectedCatId, this.subcatText, salLevels).subscribe(() => {
          // navigate back to the questions list
          this.setBuilderSvc.navQuestionList();
        });
    });
  }

  /**
   * Search questions to find matches to the specified terms.
   */
  search() {
    this.searching = true;
    this.searchTerms = this.searchTerms.trim();
    this.setBuilderSvc.searchQuestions(this.searchTerms).subscribe((result: any[]) => {
      this.searchPerformed = true;
      this.searchHits = result;
      this.searching = false;
      this.searchHits.forEach(q => {
        q.Sal = {};
        q.Sal['L'] = false;
        q.Sal['M'] = false;
        q.Sal['H'] = false;
        q.Sal['VH'] = false;
        q.SalLevels.forEach(s => {
          q.Sal[s] = true;
        });
      });
      this.selectedQuestionId = 0;
    });
  }

  /**
   * Add the question to the set.
   */
  selectExistingQuestion(q: QuestionResult) {
    // make sure they selected a SAL
    this.selectedQuestionId = q.QuestionID;
    if (this.missingSAL(q)) {
      return;
    }

    this.setBuilderSvc.addExistingQuestion(q).subscribe(() => {
      // navigate back to the questions list
      this.setBuilderSvc.navQuestionList();
    });
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
    const a = q.SalLevels.indexOf(level);
    if (a === -1) {
      q.SalLevels.push(level);
    } else {
      q.SalLevels = q.SalLevels.filter(x => x !== level);
    }
  }

  /**
   * Indicates if no SAL levels are currently selected for the question.
   */
  missingSAL(q: QuestionResult) {
    if (!q) {
      return false;
    }
    if (this.selectedQuestionId === q.QuestionID && q.SalLevels.length === 0) {
      return true;
    }
    return false;
  }
}
