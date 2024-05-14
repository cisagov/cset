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
import { Component, OnInit, AfterViewInit } from '@angular/core';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { QuestionGrouping, MaturityQuestionResponse } from '../../../models/questions.model';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';
import { QuestionFiltersComponent } from '../../../dialogs/question-filters/question-filters.component';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { ConfigService } from '../../../services/config.service';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { CisService } from '../../../services/cis.service';
import { NCUAService } from '../../../services/ncua.service';
import { ACETService } from '../../../services/acet.service';
import { CompletionService } from '../../../services/completion.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
  selector: 'app-maturity-questions-ise',
  templateUrl: './maturity-questions-ise.component.html'
})
export class MaturityQuestionsIseComponent implements OnInit, AfterViewInit {

  statementLevel: string = '';

  maturityLevels: any[];
  groupings: QuestionGrouping[] = null;
  modelName: string = '';
  questionsAlias: string = '';

  section: QuestionGrouping;
  sectionId: Number;

  scoreObject: any;
  sectionScore: Number;

  loaded = false;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public filterSvc: QuestionFilterService,
    public maturityFilteringSvc: MaturityFilteringService,
    private acetFilteringSvc: AcetFilteringService,
    private acetSvc: ACETService,
    public navSvc: NavigationService,
    public cisSvc: CisService,
    public ncuaSvc: NCUAService,
    public completionSvc: CompletionService,
    private dialog: MatDialog,
    public tSvc: TranslocoService
  ) {

    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe(
        (data: any) => {
          this.assessSvc.assessment = data;
        });
    }
    localStorage.setItem("questionSet", "Maturity");
    this.assessSvc.currentTab = 'questions';
  }

  ngOnInit() {
    this.loadQuestions();
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
    return this.configSvc.docUrl + 'htmlhelp_acet/statement_details__resources__and_comments.htm';
  }

  /**
   * Retrieves the complete list of questions
  */
  loadQuestions() {
    const magic = this.navSvc.getMagic();
    this.groupings = null;

    this.maturitySvc.getQuestionsList(false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.completionSvc.setQuestionArray(response);
        this.modelName = response.modelName;
        this.questionsAlias = response.questionsAlias;

        // the recommended maturity level(s) based on IRP
        this.maturityLevels = response.levels;
        this.groupings = response.groupings;

        this.assessSvc.assessment.maturityModel.maturityTargetLevel = response.maturityTargetLevel;
        this.assessSvc.assessment.maturityModel.answerOptions = response.answerOptions;
        this.filterSvc.answerOptions = response.answerOptions;
        this.filterSvc.maturityModelId = response.modelId;

        // get the selected maturity filters
        this.acetFilteringSvc.initializeMatFilters(response.maturityTargetLevel).then((x: any) => {
          this.refreshQuestionVisibility();
          this.loaded = true;
        });
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

    if (this.ncuaSvc.usingExamLevelOverride === false) {
      this.statementLevel = "Statements - " + this.ncuaSvc.proposedExamLevel;
    } else {
      this.statementLevel = "Statements - " + this.ncuaSvc.chosenOverrideLevel;
    }

    if (this.ncuaSvc.usingExamLevelOverride === false) {
      if (this.ncuaSvc.proposedExamLevel === 'SCUEP') {
        this.ncuaSvc.refreshGroupList(1);
      } else if (this.ncuaSvc.proposedExamLevel === 'CORE') {
        this.ncuaSvc.refreshGroupList(2);
      }
    } else {
      if (this.ncuaSvc.chosenOverrideLevel === 'SCUEP') {
        this.ncuaSvc.refreshGroupList(1);
      } else if (this.ncuaSvc.chosenOverrideLevel === 'CORE') {
        this.ncuaSvc.refreshGroupList(2);
      }
    }
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
    g.expanded = mode;
    g.subGroupings.forEach((sg: QuestionGrouping) => {
      this.recurseExpansion(sg, mode);
    });
  }

  /**
   *
   */
  showFilterDialog() {
    this.filterDialogRef = this.dialog.open(QuestionFiltersComponent, {
      data: {
        isMaturity: true
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
    this.maturityFilteringSvc.evaluateFilters(this.groupings.filter(g => g.groupingType === 'Domain'));
  }

}
