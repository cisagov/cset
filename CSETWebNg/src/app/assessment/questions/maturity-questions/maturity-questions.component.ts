////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
import { QuestionGrouping, MaturityQuestionResponse, Domain } from '../../../models/questions.model';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';
import { QuestionFiltersComponent } from '../../../dialogs/question-filters/question-filters.component';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { ConfigService } from '../../../services/config.service';
import { MaturityFilteringService } from '../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { GlossaryService } from '../../../services/glossary.service';
import { CisService } from '../../../services/cis.service';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { filter } from 'rxjs/operators';
import { Subscription } from 'rxjs';
import { MatGridTileHeaderCssMatStyler } from '@angular/material/grid-list';
import { CompletionService } from '../../../services/completion.service';

@Component({
  selector: 'app-maturity-questions',
  templateUrl: './maturity-questions.component.html'
})
export class MaturityQuestionsComponent implements OnInit, AfterViewInit {

  groupings: QuestionGrouping[] = null;
  pageTitle: string = '';
  modelId: number;
  modelName: string = '';
  groupingTitle: string = '';
  questionsAlias: string = '';
  showTargetLevel = false;    // TODO: set this from a new column in the DB

  loaded = false;

  grouping: QuestionGrouping;
  groupingId: Number;
  title: string;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  private _routerSub = Subscription.EMPTY;

  constructor(
    public assessSvc: AssessmentService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public completionSvc: CompletionService,
    public cisSvc: CisService,
    public maturityFilteringSvc: MaturityFilteringService,
    public filterSvc: QuestionFilterService,
    public glossarySvc: GlossaryService,
    public navSvc: NavigationService,
    private dialog: MatDialog,
    private route: ActivatedRoute,
    private router: Router
  ) {

    // listen for NavigationEnd to know when the page changed
    this._routerSub = this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((e: any) => {
      if (e.urlAfterRedirects.includes('/maturity-questions/')) {
        this.groupingId = +this.route.snapshot.params['grp'];
        this.loadGrouping(+this.groupingId);
      }
    });


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
    // determine whether displaying a grouping or all questions for the model
    this.grouping = null;
    this.groupingId = +this.route.snapshot.params['grp'];

    if (!this.groupingId) {
      this.loadQuestions();
    } else {
      this.loadGrouping(+this.groupingId);
    }
  }

  /**
   *
   */
  ngAfterViewInit() {
  }

  isNcuaModel() {
    if (this.modelName == 'ACET' || this.modelName == 'ISE') {
      return true;
    }
    return false;
  }


  /**
   * Returns the URL of the Questions page in the user guide.
   */
  helpDocUrl() {
    return this.configSvc.docUrl + 'htmlhelp/question_details__resources__and_comments.htm';
  }

  /**
   * Retrieves the complete list of questions for the model.
   */
  loadQuestions() {
    this.completionSvc.reset();

    const magic = this.navSvc.getMagic();
    this.groupings = null;
    this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
      (response: MaturityQuestionResponse) => {
        this.modelId = response.modelId;
        this.modelName = response.modelName;
        this.questionsAlias = response.questionsAlias;
        this.groupings = response.groupings;
        this.assessSvc.assessment.maturityModel.maturityTargetLevel = response.maturityTargetLevel;

        this.assessSvc.assessment.maturityModel.answerOptions = response.answerOptions;
        this.filterSvc.answerOptions = response.answerOptions;
        this.filterSvc.maturityModelId = response.modelId;
        this.filterSvc.maturityModelName = response.modelName;

        this.pageTitle = this.questionsAlias + ' - ' + this.modelName;
        this.glossarySvc.glossaryEntries = response.glossary;

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
   * Retrieves questions for a single grouping.
   */
  loadGrouping(groupingId: number) {
    if (isNaN(groupingId)) {
      return;
    }

    this.completionSvc.reset();

    this.maturitySvc.getGroupingQuestions(groupingId).subscribe((response: MaturityQuestionResponse) => {

      this.modelId = response.modelId;
      this.modelName = response.modelName;
      this.questionsAlias = response.questionsAlias;
      this.groupings = response.groupings;
      this.assessSvc.assessment.maturityModel.maturityTargetLevel = response.maturityTargetLevel;

      this.assessSvc.assessment.maturityModel.answerOptions = response.answerOptions;
      this.filterSvc.answerOptions = response.answerOptions;
      this.filterSvc.maturityModelId = response.modelId;

      this.pageTitle = this.questionsAlias + ' - ' + this.modelName;
      this.groupingTitle = response.title;
      this.glossarySvc.glossaryEntries = response.glossary;

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
      });
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
    // show the 'above target level' filter option for CMMC
    let show = this.modelName === 'CMMC' || this.modelName === 'CMMC2';
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
 * The groupings array should only contain groupings who have no parent.
 */
  refreshQuestionVisibility() {
    this.maturityFilteringSvc.evaluateFilters(this.groupings);
  }

  /**
   *
   * @returns
   */
  areGroupingsVisible() {
    return this.groupings.some(g => g.visible);
  }
}
