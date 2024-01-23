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
import { Component, OnInit } from '@angular/core';
import { SetBuilderService } from '../../services/set-builder.service';
import { CategoryEntry, Question } from '../../models/set-builder.model';

@Component({
  selector: 'app-add-question',
  templateUrl: './add-question.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class AddQuestionComponent implements OnInit {

  customQuestionText: string = '';
  isDupeQuestion = false;
  isCustomQuestionEmpty = false;
  isCatOrSubcatEmpty = false;
  isSalSelectionEmpty = false;

  // custom add SAL values
  customSalL = false;
  customSalM = false;
  customSalH = false;
  customSalVH = false;

  groupheadings: CategoryEntry[];
  subcategories: CategoryEntry[];
  selectedGHId: number = 0;
  subcatText: string;

  searching = false;
  searchTerms: string = '';
  searchError = false;
  searchPerformed = false;
  searchHits: Question[] = [];
  selectedQuestionId: number;
  selectedQuestionIds: number[] = [];


  constructor(public setBuilderSvc: SetBuilderService) { }

  ngOnInit() {
    this.setBuilderSvc.getCategoriesSubcategoriesGroupHeadings().subscribe(
      (data: any) => {
        this.groupheadings = data.groupHeadings;
        this.subcategories = data.subcategories;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }


  /**
   * Creates a new question for the set.
   */
  addCustomQuestion() {
    // validate that they typed something
    this.customQuestionText = this.customQuestionText && this.customQuestionText.trim();

    this.isCustomQuestionEmpty = (this.customQuestionText.length === 0);
    this.isCatOrSubcatEmpty = this.selectedGHId.toString() === "0" || (!this.subcatText || this.subcatText.trim().length === 0);
    this.isSalSelectionEmpty = !this.customSalL && !this.customSalM && !this.customSalH && !this.customSalVH;
    this.isDupeQuestion = false;

    if (this.isCustomQuestionEmpty || this.isCatOrSubcatEmpty || this.isSalSelectionEmpty) {
      return;
    }

    // check to see if this question text already exists in the database.
    this.setBuilderSvc.existsQuestionText(this.customQuestionText).subscribe(result => {
      this.isDupeQuestion = result as boolean;
      if (this.isDupeQuestion) {
        this.isCustomQuestionEmpty = false;
        return;
      }

      const salLevels: string[] = [];
      if (this.customSalL) { salLevels.push("L"); }
      if (this.customSalM) { salLevels.push("M"); }
      if (this.customSalH) { salLevels.push("H"); }
      if (this.customSalVH) { salLevels.push("VH"); }


      // push it to the API
      this.setBuilderSvc.addCustomQuestion(this.customQuestionText, this.selectedGHId, this.subcatText, salLevels).subscribe(() => {
        if (!!this.setBuilderSvc.activeRequirement) {
          this.setBuilderSvc.navRequirementDetail(this.setBuilderSvc.activeRequirement.requirementID);
        } else {
          // navigate back to the questions list
          this.setBuilderSvc.navQuestionList();
        }
      });
    });
  }

  /**
   * Search questions to find matches to the specified terms.
   */
  search() {
    this.searchError = false;
    this.searching = true;
    this.searchTerms = this.searchTerms.trim();

    if (this.searchTerms.length === 0) {
      this.searching = false;
      this.searchError = true;
      return;
    }

    this.setBuilderSvc.searchQuestions(this.searchTerms).subscribe((result: any[]) => {
      this.searchPerformed = true;
      this.searchHits = result;
      this.searching = false;
      this.searchHits.forEach(q => {
        q.sal = {};
        q.sal['L'] = false;
        q.sal['M'] = false;
        q.sal['H'] = false;
        q.sal['VH'] = false;
        q.salLevels.forEach(s => {
          q.sal[s] = true;
        });
      });
      this.selectedQuestionId = 0;
    });
  }

  /**
   * Mark the existing question for selection.
   */
  markSelected(q: Question, e: any) {
    if (e.target.checked) {
      this.selectedQuestionIds.push(q.questionID);
    } else {
      this.selectedQuestionIds.splice(this.selectedQuestionIds.findIndex(function (x) {
        return x === q.questionID;
      }), 1);
    }
  }

  /**
   * xxx
   */
  isQuestionSelected(q) {
    return this.selectedQuestionIds.findIndex(function (x) {
      return x === q.questionID;
    }) >= 0;
  }

  /**
   * Add the question to the set.
   */
  addSelectedQuestions() {
    // make sure they selected a SAL
    const selectedQs = [];

    this.selectedQuestionIds.forEach(qid => {
      const qqq = this.searchHits.find(qq => qq.questionID === qid);
      if (this.missingSAL(qqq)) {
        return;
      }
      selectedQs.push(qqq);
    });

    this.setBuilderSvc.addExistingQuestions(selectedQs)
      .subscribe(() => {
        if (!!this.setBuilderSvc.activeRequirement) {
          this.setBuilderSvc.navRequirementDetail(this.setBuilderSvc.activeRequirement.requirementID);
        } else {
          // navigate back to the questions list
          this.setBuilderSvc.navQuestionList();
        }
      });
  }

  /**
   *
   */
  hasSAL(q: Question, level: string): boolean {
    return (q.salLevels.indexOf(level) >= 0);
  }

  /**
   * Includes/removes the level from the list of applicable SAL levels for the question.
   */
  toggleSAL(q: Question, level: string, e) {
    const checked = e.target.checked;
    const a = q.salLevels.indexOf(level);

    if (checked) {
      if (a <= 0) {
        q.salLevels.push(level);
      }
    } else if (a >= 0) {
      q.salLevels = q.salLevels.filter(x => x !== level);
    }
  }

  /**
   * Indicates if no SAL levels are currently selected for the question.
   */
  missingSAL(q: Question) {
    if (!q) {
      return false;
    }
    if ((!!this.selectedQuestionIds.find(qid => qid === q.questionID)) && q.salLevels.length === 0) {
      return true;
    }
    return false;
  }
}
