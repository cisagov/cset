////////////////////////////////
//
//   Copyright 2025 Battelle Energy Alliance, LLC
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
import { AfterViewInit, Component, OnDestroy, OnInit } from '@angular/core';
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
import { ActivatedRoute, NavigationEnd, Router, UrlSegment, UrlSegmentGroup, UrlTree } from '@angular/router';
import { filter, takeUntil } from 'rxjs/operators';
import { Subject, Subscription } from 'rxjs';
import { CompletionService } from '../../../services/completion.service';
import { TranslocoService } from '@jsverse/transloco';
import { DemographicService } from '../../../services/demographic.service';
import { DemographicIodService } from '../../../services/demographic-iod.service';
import { SsgService } from '../../../services/ssg.service';
import { ModuleBehavior } from '../../../models/module-config.model';
import { SelectableGroupingsService } from '../../../services/selectable-groupings.service';

@Component({
  selector: 'app-maturity-questions',
  templateUrl: './maturity-questions.component.html',
  standalone: false
})
export class MaturityQuestionsComponent implements OnInit, AfterViewInit, OnDestroy {

  private routerSubscription: Subscription;
  private destroy$ = new Subject<void>();
  navTarget: string | null; // this is a string to be able to support 'bonus' or 'm23'

  groupings: QuestionGrouping[] | null = [];
  groupingsAreMil = false;

  pageTitle: string = '';
  moduleBehavior: ModuleBehavior;
  modelId: number;
  modelName: string = '';
  groupingTitle: string = '';
  questionsAlias: string = '';
  showTargetLevel = false;    // TODO: set this from a new column in the DB
  modelSupportsTargetLevel = false;

  loaded = false;

  grouping: QuestionGrouping | null;
  showGroupingSelector = false;

  title: string;

  msgUnansweredEqualsNo = '';

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;


  /**
   * 
   */
  constructor(
    public assessSvc: AssessmentService,
    public demoSvc: DemographicService,
    public demoIodSvc: DemographicIodService,
    public configSvc: ConfigService,
    public maturitySvc: MaturityService,
    public questionsSvc: QuestionsService,
    public completionSvc: CompletionService,
    public selectableGroupingSvc: SelectableGroupingsService,
    public cisSvc: CisService,
    public ssgSvc: SsgService,
    public maturityFilteringSvc: MaturityFilteringService,
    public filterSvc: QuestionFilterService,
    public glossarySvc: GlossaryService,
    public navSvc: NavigationService,
    private dialog: MatDialog,
    private router: Router,
    private tSvc: TranslocoService
  ) {
    this.routerSubscription = this.router.events
      .pipe(filter(event => event instanceof NavigationEnd))
      .subscribe((event: NavigationEnd) => {
        this.setNavTarget(event);
        this.load();
      });
  }

  /**
   *
   */
  ngOnInit() {
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe(
        (data: any) => {
          this.assessSvc.assessment = data;
        });
    }

    // listen for grouping selector changes
    this.selectableGroupingSvc.selectionChanged$.subscribe(() => {
      this.refreshQuestionVisibility();
    });


    // Refresh the page in case of user language change.  
    // The more complex event analysis is needed because
    // the Transloco service will also emit langChanges$ when the
    // component is initialized.  We only care about a true language 
    // change to avoid calling the API multiple times.
    this.tSvc.events$
      .pipe(
        filter(event => event.type === 'langChanged'),
        takeUntil(this.destroy$)
      )
      .subscribe(() => {
        if (this.assessSvc.assessment) {
          this.load();
        }
      });


    localStorage.setItem("questionSet", "Maturity");
    this.assessSvc.currentTab = 'questions';
  }


  /**
   * 
   */
  ngAfterViewInit() {
    setTimeout(() => {
      this.scrollToResumeQuestionsTarget();
    }, 500);
  }

  /**
   * 
   */
  ngOnDestroy(): void {
    this.destroy$.next();
    this.destroy$.complete();


    if (this.routerSubscription) {
      this.routerSubscription.unsubscribe();
    }
  }

  /**
   *
   */
  load() {
    // determine whether displaying a grouping or all questions for the model
    if (!this.navTarget || this.navTarget.toLowerCase() == 'bonus' || this.navTarget.toLowerCase().startsWith('m')) {
      this.loadQuestions();
    } else {
      this.loadGrouping(+this.navTarget);
    }

    this.refreshQuestionVisibility();
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
    var obsGetQ;

    if (this.navTarget?.toLowerCase() == 'bonus') {
      const bonusModelId = this.ssgSvc.ssgBonusModel();
      obsGetQ = this.maturitySvc.getBonusQuestionList(bonusModelId);

    } else if (this.navTarget?.toLowerCase().startsWith('m')) {
      const bonusModelId = +this.navTarget.substring(1);
      obsGetQ = this.maturitySvc.getBonusQuestionList(bonusModelId);

    } else {
      obsGetQ = this.maturitySvc.getQuestionsList(false);
    }


    obsGetQ.subscribe(
      (response: MaturityQuestionResponse) => {
        this.modelId = response.modelId;

        this.moduleBehavior = this.configSvc.getModuleBehavior(this.modelId);


        // Show the selector for CRE+ Optional Domain Questions (model 23)
        // and CRE+ Optional MIL Questions (model 24)
        this.showGroupingSelector = this.moduleBehavior.mustSelectGroupings ?? false;
        this.groupingsAreMil = this.moduleBehavior.groupingsAreMil ?? false;
        this.modelName = response.modelName;
        this.questionsAlias = response.questionsAlias;
        this.groupings = response.groupings;
        this.selectableGroupingSvc.setModelGroupings(this.modelId, response.groupings);

        if (this.assessSvc.assessment && this.assessSvc.assessment.maturityModel) {
          this.assessSvc.assessment.maturityModel.maturityTargetLevel = response.maturityTargetLevel;
          this.assessSvc.assessment.maturityModel.answerOptions = response.answerOptions;
        }

        // 100 is the default level if the model does not support a target
        this.modelSupportsTargetLevel = response.maturityTargetLevel < 100;

        this.filterSvc.answerOptions = response.answerOptions.slice();
        this.filterSvc.maturityModelId = response.modelId;
        this.filterSvc.maturityModelName = response.modelName;
        this.filterSvc.maturityTargetLevel = response.maturityTargetLevel;

        // Adding Maturity Levels to the filters
        this.filterSvc.refreshAllowableFilters();
        this.filterSvc.forceRefresh();
        this.displayTitle();


        this.glossarySvc.glossaryEntries = response.glossary;


        // set the message with the current "no" answer value
        let codeForNo = this.moduleBehavior.answerOptions?.find(o => o.unansweredEquivalent)?.code ?? 'N';
        const valueForNo = this.questionsSvc.answerButtonLabel(this.modelName, codeForNo);
        this.msgUnansweredEqualsNo = this.tSvc.translate('questions.unanswered equals no', { 'no-ans': valueForNo });

        this.loaded = true;

        this.completionSvc.setQuestionArray(response);

        this.refreshQuestionVisibility();
      },
      error => {
        console.error(
          'Error getting questions: ' +
          (<Error>error).name +
          (<Error>error).message
        );
        console.error('Error getting questions: ' + (<Error>error).stack);
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
    this.groupings = null;

    this.maturitySvc.getGroupingQuestions(groupingId).subscribe((response: MaturityQuestionResponse) => {
      this.modelId = response.modelId;
      this.modelName = response.modelName;
      this.questionsAlias = response.questionsAlias;
      this.groupings = response.groupings;
      if (this.assessSvc.assessment && this.assessSvc.assessment.maturityModel) {
        this.assessSvc.assessment.maturityModel.maturityTargetLevel = response.maturityTargetLevel;
        this.assessSvc.assessment.maturityModel.answerOptions = response.answerOptions;
      }

      this.filterSvc.answerOptions = response.answerOptions.slice();
      this.filterSvc.maturityModelId = response.modelId;

      this.pageTitle = this.questionsAlias + ' - ' + this.modelName;

      this.glossarySvc.glossaryEntries = response.glossary;

      this.loaded = true;

      this.completionSvc.setQuestionArray(response);

      this.refreshQuestionVisibility();
    },
      error => {
        console.error(
          'Error getting questions: ' +
          (<Error>error).name +
          (<Error>error).message
        );
        console.error('Error getting questions: ' + (<Error>error).stack);
      });
  }

  /**
   *
   */
  displayTitle() {
    // Bonus questions are for SSGs.
    if (this.navTarget?.toLowerCase() == 'bonus') {
      this.pageTitle = this.tSvc.translate(`titles.ssg.${this.ssgSvc.ssgSimpleSectorLabel()}`);
      return;
    }

    let displayName = this.modelName;

    if (this.moduleBehavior?.displayNameKey != null) {
      displayName = this.tSvc.translate(this.moduleBehavior.displayNameKey);
    }

    this.pageTitle = this.tSvc.translate('titles.' + this.questionsAlias.toLowerCase().trim()) + ' - ' + displayName;
  }

  /**
     * Controls the mass expansion/collapse of all subcategories on the screen.
     * @param mode
     */
  expandAll(mode: boolean) {
    this.groupings?.forEach((g: QuestionGrouping) => {
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
    var grp = groupings.find(x => x.groupingId == id);
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
    return this.groupings?.some(g => g.visible);
  }

  /**
   * Show the selector for CRE+ Optional Domain Questions (model 23)
   * and CRE+ Optional MIL Questions (model 24)
   */
  showCreSelector(modelId: number): boolean {
    return (modelId == 23 || modelId == 24);
  }


  /**
   * This component can load the entire model, a specific model
   * or a particular grouping.
   * Parses the URL to determine how to format the API call.
   * navTarget is the property that gets set.
   */
  setNavTarget(event: any) {
    const currentUrl = event.urlAfterRedirects;
    if (!currentUrl.endsWith('/maturity-questions') && !currentUrl.includes('/maturity-questions/')) {
      return;
    }

    // get the next URL segment, if there is one and set the navTarget
    const mqIndex = this.findSegmentIndex(currentUrl, 'maturity-questions');
    const t = this.getSegment(currentUrl, mqIndex + 1);
    if (!!t) {
      this.navTarget = t;
    } else {
      this.navTarget = null;
    }
  }

  /**
   * Helper method for parsing routing URLs.
   */
  findSegmentIndex(url: string, segmentToFind: string): number {
    const urlTree: UrlTree = this.router.parseUrl(url);
    const primaryGroup: UrlSegmentGroup = urlTree.root.children['primary'];

    if (primaryGroup) {
      const segments = primaryGroup.segments;
      for (let i = 0; i < segments.length; i++) {
        if (segments[i].path === segmentToFind) {
          return i;
        }
      }
    }
    return -1;
  }

  /**
   * Helper method for parsing routing URLs.
   */
  getSegment(url: string, idx: number): string | null {
    const urlTree: UrlTree = this.router.parseUrl(url);
    const primaryGroup: UrlSegmentGroup = urlTree.root.children['primary'];

    if (primaryGroup) {
      const segments = primaryGroup.segments;
      if (segments.length > idx) {
        return segments[idx].toString();
      }
    }

    return null;
  }
}
