import { CompletionService } from './../../../services/completion.service';
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
import { Category } from '../../../models/questions.model';
import { QuestionResponse } from '../../../models/questions.model';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { QuestionsService } from '../../../services/questions.service';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';
import { QuestionFiltersComponent } from '../../../dialogs/question-filters/question-filters.component';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { ConfigService } from '../../../services/config.service';

@Component({
  selector: 'app-diagram-questions',
  templateUrl: './diagram-questions.component.html'
})
export class DiagramQuestionsComponent implements OnInit {

  categories: Category[] = null;

  loaded = false;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public completionSvc: CompletionService,
    public filterSvc: QuestionFilterService,
    public navSvc: NavigationService,
    private dialog: MatDialog
  ) {
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe(
        (data: any) => {
          this.assessSvc.assessment = data;
        });
    }
    localStorage.setItem("questionSet", "Component");
    this.assessSvc.currentTab = 'questions';
  }

  ngOnInit() {
    this.loadQuestions();
  }

  /**
   * Returns the URL of the Questions page in the user guide.
   */
  helpDocUrl() {
    return this.configSvc.docUrl + 'htmlhelp/question_details__resources__and_comments.htm';
  }

  /**
   * Retrieves the complete list of questions
   */
  loadQuestions() {
    const magic = this.navSvc.getMagic();
    this.questionsSvc.getComponentQuestionsList().subscribe(
      (response: QuestionResponse) => {
        this.questionsSvc.questions = response;
        this.categories = response.categories;
        this.loaded = true;

        this.completionSvc.setQuestionArray(response);

        this.refreshQuestionVisibility();
      },
      error => {
        console.log(
          'Error getting questions: ' +
          (<Error>error).name +
          (<Error>error).message
        );
        console.log('Error getting questions: ' + (<Error>error).stack);
      }
    );
  }


  /**
   * Controls the mass expansion/collapse of all subcategories on the screen.
   * @param mode
   */
  expandAll(mode: boolean) {
    this.categories.forEach(group => {
      group.subCategories.forEach(subcategory => {
        subcategory.expanded = mode;
      });
    });
  }

  /**
 *
 */
  showFilterDialog() {
    this.filterDialogRef = this.dialog.open(QuestionFiltersComponent);
    this.filterDialogRef.componentInstance.filterChanged.asObservable().subscribe(() => {
      this.refreshQuestionVisibility();
    });
    this.filterDialogRef
      .afterClosed()
      .subscribe(() => {
        this.refreshQuestionVisibility();
      });
  }

  /**
  * Re-evaluates the visibility of all questions/subcategories/categories
  * based on the current filter settings.
  * Also re-draws the sidenav category tree, skipping categories
  * that are not currently visible.
  */
  refreshQuestionVisibility() {
    this.filterSvc.evaluateFiltersForCategories(this.categories);
  }
}
