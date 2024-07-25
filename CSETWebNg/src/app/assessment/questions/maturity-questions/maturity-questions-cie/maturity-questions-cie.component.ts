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
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { MaturityService } from '../../../../services/maturity.service';
import { QuestionsService } from '../../../../services/questions.service';
import { QuestionGrouping, MaturityQuestionResponse } from '../../../../models/questions.model';
import { MatDialogRef, MatDialog } from '@angular/material/dialog';
import { QuestionFiltersComponent } from '../../../../dialogs/question-filters/question-filters.component';
import { QuestionFilterService } from '../../../../services/filtering/question-filter.service';
import { ConfigService } from '../../../../services/config.service';
import { AcetFilteringService } from '../../../../services/filtering/maturity-filtering/acet-filtering.service';
import { MaturityFilteringService } from '../../../../services/filtering/maturity-filtering/maturity-filtering.service';
import { CisService } from '../../../../services/cis.service';
import { NCUAService } from '../../../../services/ncua.service';
import { ACETService } from '../../../../services/acet.service';
import { CompletionService } from '../../../../services/completion.service';
import { ActivatedRoute, NavigationEnd, Router } from '@angular/router';
import { Subscription } from 'rxjs';
import { filter } from 'rxjs/operators';
import { CieService } from '../../../../services/cie.service';


@Component({
  selector: 'app-maturity-questions-cie',
  templateUrl: './maturity-questions-cie.component.html',
  styleUrls: ['./maturity-questions-cie.component.scss']
})
export class MaturityQuestionsCieComponent implements OnInit, AfterViewInit {

  statementLevel: string = '';

  maturityLevels: any[];
  phases: QuestionGrouping[] = null;
  principle: QuestionGrouping = null;
  modelName: string = '';
  questionsAlias: string = '';

  pageTitle: string = '';

  section: QuestionGrouping;
  sectionId: Number;
  sectionIndex: number = 0;

  scoreObject: any;
  sectionScore: Number;

  loaded = false;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  private _routerSub = Subscription.EMPTY;

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
    private route: ActivatedRoute,
    private router: Router,
    private cieSvc: CieService
  ) {
    // listen for NavigationEnd to know when the page changed
    this._routerSub = this.router.events.pipe(
      filter(event => event instanceof NavigationEnd)
    ).subscribe((e: any) => {
      if (e.urlAfterRedirects.includes('/maturity-questions-cie/')) {
        this.loadQuestions();
      }
    });
    this.assessSvc.currentTab = 'questions';
  }

  ngOnInit() {
    if (this.assessSvc.applicationMode != 'F' && this.assessSvc.applicationMode != 'P') {
      this.setMode('F');
    }
    this.assessSvc.getAssessmentContacts().then((response: any) => {
      this.cieSvc.contactInitials = response.contactList[0].firstName;
    });
    // this.loadQuestions();
  }

  /**
   *
   */
  ngAfterViewInit() {
    const scrollTarget = this.navSvc.resumeQuestionsTarget;
    this.navSvc.resumeQuestionsTarget = null;
    if (!scrollTarget) {
      return;
    }

    var mg = scrollTarget.split(',').find(x => x.startsWith('MG:'))?.replace('MG:', '');
    var mq = scrollTarget.split(',').find(x => x.startsWith('MQ:'))?.replace('MQ:', '');
    // set to Principle scope
    if (+mg <= 2632) {
      this.setMode('P');
    }
    //set to Principle-Phase scope
    else {
      this.setMode('F');
    }

    // probes to see when question element is visible and able to be scrolled to
    const intervalId = setInterval(() => {
      let mqElement = document.getElementById('question-'+mq);
      if (mqElement != null) {
        this.scrollToResumeQuestionsTarget(mg, mqElement);
        clearInterval(intervalId);
        return;
      }
    }, 1000);
  }

  
  ngOnDestroy(): void {
    this._routerSub.unsubscribe();
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
    this.sectionId = +this.route.snapshot.params['sec'];
    const magic = this.navSvc.getMagic();
    this.phases = null;
    this.maturitySvc.getQuestionsList(false, this.sectionId.valueOf()).subscribe(
      (response: MaturityQuestionResponse) => {
        this.completionSvc.setQuestionArray(response);
        this.modelName = response.modelName;
        this.questionsAlias = response.questionsAlias;
        this.sectionIndex = this.sectionId.valueOf() - response.groupings[0].groupingID -1;

        // the recommended maturity level(s) based on IRP
        this.maturityLevels = response.levels;
        this.pageTitle = response.groupings[0].subGroupings[this.sectionIndex].title;
        this.principle = response.groupings[0].subGroupings[this.sectionIndex];
        this.phases = response.groupings[0].subGroupings[this.sectionIndex].subGroupings;

        if (this.assessSvc.applicationMode) {
          this.section = response.groupings[0].subGroupings[this.sectionIndex];
        }
        this.assessSvc.assessment.maturityModel.maturityTargetLevel = response.maturityTargetLevel;
        this.assessSvc.assessment.maturityModel.answerOptions = response.answerOptions;
        this.filterSvc.answerOptions = response.answerOptions;
        this.filterSvc.maturityModelId = response.modelId;

       
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
    this.phases.forEach((g: QuestionGrouping) => {
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
    //this.maturityFilteringSvc.evaluateFilters(this.groupings.filter(g => g.groupingType === 'Domain'));
  }

  /**
   * Changes the application mode of the assessment
   */
  setMode(mode: string) {
    this.assessSvc.applicationMode = mode;
    this.questionsSvc.setMode(mode).subscribe(() => {});
    localStorage.setItem("questionSet", mode == 'P' ? "Principle" : "Principle-Phase");
  }

  
  
  /**
   * If a "resume questions" target is defined, attempt to scroll to it
   */
  scrollToResumeQuestionsTarget(mg: string, scrollTarget: HTMLElement) {
    var groupToExpand = this.findGroupingById(+mg, [this.principle]);
    if (!!groupToExpand) {
      groupToExpand.expanded = true;
    }

    setTimeout(() => {
      scrollTarget.scrollIntoView({ behavior: 'smooth' });
      return;
    }, 500);
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



}

