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
import { AfterViewInit, Component, OnInit } from '@angular/core';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { AssessmentService } from '../../../services/assessment.service';
import { MaturityService } from '../../../services/maturity.service';
import { QuestionsService } from '../../../services/questions.service';
import { QuestionGrouping, MaturityQuestionResponse } from '../../../models/questions.model';
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
import { CompletionService } from '../../../services/completion.service';
import { TranslocoService } from '@ngneat/transloco';
import { DemographicService } from '../../../services/demographic.service';
import { DemographicIodService } from '../../../services/demographic-iod.service';
import { SsgService } from '../../../services/ssg.service';

@Component({
  selector: 'app-maturity-questions',
  templateUrl: './maturity-questions.component.html'
})
export class MaturityQuestionsComponent implements OnInit, AfterViewInit {

  groupings: QuestionGrouping[] = [];
  pageTitle: string = '';
  modelId: number;
  modelName: string = '';
  groupingTitle: string = '';
  questionsAlias: string = '';
  showTargetLevel = false;    // TODO: set this from a new column in the DB

  loaded = false;

  grouping: QuestionGrouping | null;
  groupingId: string; // this is a string to be able to support 'bonus'
  title: string;

  msgUnansweredEqualsNo = '';

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  private _routerSub = Subscription.EMPTY;

  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicService,
    public demoIodSvc: DemographicIodService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public completionSvc: CompletionService,
    public cisSvc: CisService,
    public ssgSvc: SsgService,
    public maturityFilteringSvc: MaturityFilteringService,
    public filterSvc: QuestionFilterService,
    public glossarySvc: GlossaryService,
    public navSvc: NavigationService,
    private dialog: MatDialog,
    private route: ActivatedRoute,
    private router: Router,
    private tSvc: TranslocoService
  ) {

    // listen for NavigationEnd to know when the page changed
    this._routerSub = this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((e: any) => {
      if (e.urlAfterRedirects.includes('/maturity-questions/')) {
        this.groupingId = this.route.snapshot.params['grp'];
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

  /**
   *
   */
  ngOnInit() {
    // refresh the page in case of language change
    // NOTE: langChanges$ will emit the active language on subscription,
    // so load() will always fire on initial page load
    this.tSvc.langChanges$.subscribe(() => {

      // check for assessment existence so that this isn't triggered when logging
      // in after a timeout.  In that scenario there is no assessment ID in the JWT
      // and the call to load questions or groupings will crash.
      if (!!this.assessSvc.assessment) {
        this.load();
      }
    });
  }

  ngAfterViewInit() {
    setTimeout(() => {
      this.scrollToResumeQuestionsTarget();
    }, 500);
  }

  /**
   *
   */
  load() {
    // determine whether displaying a grouping or all questions for the model
    this.grouping = null;
    this.groupingId = this.route.snapshot.params['grp'];

    if (!this.groupingId || this.groupingId.toLowerCase() == 'bonus') {
      this.loadQuestions();
    } else {
      this.loadGrouping(+this.groupingId);
    }
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


    // determine which endpoint to call to get the question list
    var obsGetQ = this.maturitySvc.getQuestionsList(false);


    if (this.groupingId?.toLowerCase() == 'bonus') {
      const bonusModelId = this.ssgSvc.ssgBonusModel()
      obsGetQ = this.maturitySvc.getBonusQuestionList(bonusModelId);
    }

    obsGetQ.subscribe(
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

        if (this.groupingId?.toLowerCase() == 'bonus') {
          this.pageTitle = this.tSvc.translate(`titles.ssg.${this.ssgSvc.ssgSimpleSectorLabel()}`);
        } else {
          this.pageTitle = this.tSvc.translate('titles.' + this.questionsAlias.toLowerCase().trim()) + ' - ' + this.modelName;
        }


        this.glossarySvc.glossaryEntries = response.glossary;

        // set the message with the current "no" answer value
        const codeForNo = this.assessSvc.assessment?.maturityModel?.modelId == 12 ? 'NI' : 'N';
        const noValue = this.questionsSvc.answerButtonLabel(this.modelName, codeForNo);
        this.msgUnansweredEqualsNo = this.tSvc.translate('questions.unanswered equals no', { 'no-ans': noValue });

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
   * If a "resume questions" target is defined, attempt to scroll to it.
   */
  scrollToResumeQuestionsTarget() {
    // scroll to the target question if we have one
    const scrollTarget = this.navSvc.resumeQuestionsTarget;
    this.navSvc.resumeQuestionsTarget = null;
    if (!scrollTarget) {
      return;
    }

    var mg = scrollTarget.split(',').find(x => x.startsWith('MG:'))?.replace('MG:', '');
    let mq = scrollTarget.split(',').find(x => x.startsWith('MQ:'))?.replace('MQ:', '');

    // expand the question's group
    var groupToExpand = this.findGroupingById(Number(mg), this.groupings);
    if (!!groupToExpand) {
      groupToExpand.expanded = true;
    }

    // scroll to the question
    let qqElement = document.getElementById(`mq${mq}`);
    setTimeout(() => {
      qqElement.scrollIntoView({ behavior: 'smooth' });
      return;
    }, 1000);
  }

  /**
   * Recurse grouping tree, looking for the ID
   */
  findGroupingById(id: number, groupings: any[]) {
    var grp = groupings.find(x => x.groupingID == id);
    if (!!grp) {
      return grp;
    }
    for (var i = 0; i < groupings.length; i++) {
      return this.findGroupingById(id, groupings[i].subGroupings);
    }
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
