////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { NavigationService } from '../../../services/navigation.service';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { QuestionGrouping, MaturityQuestionResponse, Domain } from '../../../models/questions.model';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';
import { QuestionFiltersComponent } from '../../../dialogs/question-filters/question-filters.component';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { ConfigService } from '../../../services/config.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { GlossaryService } from '../../../services/glossary.service';

@Component({
  selector: 'app-maturity-questions',
  templateUrl: './maturity-questions.component.html'
})
export class MaturityQuestionsComponent implements OnInit, AfterViewInit {

  groupings: QuestionGrouping[] = null;
  pageTitle: string = '';
  modelName: string = '';
  questionsAlias: string = '';
  showTargetLevel = false;    // TODO: set this from a new column in the DB

  loaded = false;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public maturityFilteringSvc: MaturityFilteringService,
    public filterSvc: QuestionFilterService,
    public glossarySvc: GlossaryService,
    public navSvc: NavigationService,
    private dialog: MatDialog
  ) {

    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe(
        (data: any) => {
          this.assessSvc.assessment = data;
        });
    }

    sessionStorage.setItem("questionSet", "Maturity");
  }

  ngOnInit() {
    this.loadQuestions();
    this.assessSvc.currentTab = 'questions';
  }
  
  /**
   *
   */
  ngAfterViewInit() {
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
    this.groupings = null;
    this.maturitySvc.getQuestionsList(this.configSvc.acetInstallation, false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.modelName = response.ModelName;
        this.questionsAlias = response.QuestionsAlias;
        this.groupings = response.Groupings;
        this.assessSvc.assessment.MaturityModel.MaturityTargetLevel = response.MaturityTargetLevel;

        this.assessSvc.assessment.MaturityModel.AnswerOptions = response.AnswerOptions;
        this.filterSvc.answerOptions = response.AnswerOptions;

        this.pageTitle = this.questionsAlias + ' - ' + this.modelName;
        this.glossarySvc.glossaryEntries = response.Glossary;
        this.loaded = true;

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
    this.groupings.forEach((g: QuestionGrouping) => {
      this.recurseExpansion(g, mode);
    });
  }

  /**
   * Groupings may be several levels deep so we need to recurse.
   */
  recurseExpansion(g: QuestionGrouping, mode: boolean) {
    g.Expanded = mode;
    g.SubGroupings.forEach((sg: QuestionGrouping) => {
      this.recurseExpansion(sg, mode);
    });
  }

  /**
   * 
   */
  showFilterDialog() {
    // show the 'above target level' filter option for CMMC
    let show = this.modelName === 'CMMC';
    this.filterDialogRef = this.dialog.open(QuestionFiltersComponent, {
      data: {
        showFilterAboveTargetLevel: show
      }
    });

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
 */
  refreshQuestionVisibility() {
    this.maturityFilteringSvc.evaluateFilters(this.groupings.filter(g => g.GroupingType === 'Domain'));
  }
}
