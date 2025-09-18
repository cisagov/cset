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

import {
  Component,
  EventEmitter,
  OnInit,
  Output, HostListener,
  ApplicationRef
} from '@angular/core';
import { ActivatedRoute, NavigationCancel, NavigationEnd, NavigationError, NavigationStart, Router } from '@angular/router';
import { AssessmentService } from '../services/assessment.service';
import { LayoutService } from '../services/layout.service';
import { NavTreeService } from '../services/navigation/nav-tree.service';
import { NavigationService } from '../services/navigation/navigation.service';
import { TranslocoService } from '@jsverse/transloco';
import { ConfigService } from '../services/config.service';
import { AssessmentDetail } from '../models/assessment-info.model';
import { Subscription } from 'rxjs'
import { CompletionService } from '../services/completion.service';
import { DemographicService } from '../services/demographic.service';

interface UserAssessment {
  isEntry: boolean;
  isEntryString: string;
  assessmentId: number;
  assessmentName: string;
  useDiagram: boolean;
  useStandard: boolean;
  useMaturity: boolean;
  type: string;
  assessmentCreatedDate: string;
  creatorName: string;
  markedForReview: boolean;
  altTextMissing: boolean;
  selectedMaturityModel?: string;
  selectedStandards?: string;
  completedQuestionsCount: number;
  totalAvailableQuestionsCount: number;
  questionAlias: string;
  iseSubmission: boolean;
  submittedDate?: Date;
  done?:boolean;
  favorite?:boolean;
  firstName?:string;
  lastName?:string;
}

@Component({
    selector: 'app-assessment',
    styleUrls: ['./assessment.component.scss'],
    templateUrl: './assessment.component.html',
    // eslint-disable-next-line
    host: { class: 'd-flex flex-column flex-11a w-100' },
    standalone: false
})
export class AssessmentComponent implements OnInit {
  innerWidth: number;
  innerHeight: number;
  completionPercentage:number=0;
  completedQuestions = 0;
  totalQuestions = 0;
  private completionSubscription: Subscription;
  /**
   * Indicates whether the nav panel is visible (true)
   * or hidden (false).
   */
  expandNav = false;

  /**
   * Indicates whether the nav stays visible (true)
   * or auto-hides when the screen is narrow (false).
   */
  lockNav = true;

  widthBreakpoint = 960;
  scrollTop = 0;

  assessmentAlias = this.tSvc.translate('titles.assessment');
  assessment: AssessmentDetail = {


  };

  @Output() navSelected = new EventEmitter<string>();
  isSet: boolean;

  @HostListener('window:resize', ['$event'])
  onResize(event) {
    this.evaluateWindowSize();
  }

  constructor(
    private router: Router,
    private route: ActivatedRoute,
    public assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public navTreeSvc: NavTreeService,
    public layoutSvc: LayoutService,
    public tSvc: TranslocoService,
    private configSvc: ConfigService,
    private appRef: ApplicationRef,
    private completionSvc: CompletionService,
    private demoSvc: DemographicService
  ) {
    this.assessSvc.getAssessmentToken(+this.route.snapshot.params['id']);
    this.assessSvc.getMode();
    this.setTab('prepare');
    this.navSvc.activeResultsView = null;
    this.isSet = false;
  }

  ngOnInit(): void {
    if (this.isSet) {
      this.isSet = true;
      this.appRef.tick();
    }
    this.evaluateWindowSize();

    if (this.configSvc.behaviors.replaceAssessmentWithAnalysis) {
      this.assessmentAlias = this.tSvc.translate('titles.analysis');
    }

    this.tSvc.langChanges$.subscribe((event) => {
      this.navSvc.buildTree();
    });
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
      this.loadCompletionData();
      this.assessSvc.completionRefreshRequested$.subscribe((stats) => {
        if (stats) {
          this.completedQuestions = stats.completedCount;
          this.totalQuestions = stats.totalCount;
          this.completionPercentage = this.totalQuestions > 0 ?
            Math.round((this.completedQuestions / this.totalQuestions) * 100) : 0;
        }
      });
      this.demoSvc.demographicUpdateCompleted$.subscribe(() => {
        this.loadCompletionData();
        console.log('Progress refreshed due to demographic update');
      });
    }

  }
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
  }
  setAssessmentDone(){
    this.assessment.done =!this.assessment.done;
    this.assessSvc.setAssesmentDone(this.assessment.done).subscribe();
  }
  setTab(tab) {
    this.assessSvc.currentTab = tab;
  }

  checkActive(tab) {
    return this.assessSvc.currentTab === tab;
  }

  /**
   * Determines how to display the sidenav.
   */
  sidenavMode() {
    if (this.layoutSvc.hp) {
      this.lockNav = false;
      return 'over';
    }

    return this.innerWidth < this.widthBreakpoint ? 'over' : 'side';
  }

  /**
   * Evaluates sidenav drawer behavior based on window size
   */
  evaluateWindowSize() {
    this.innerWidth = window.innerWidth;
    this.innerHeight = window.innerHeight;

    // show/hide lock/unlock the nav drawer based on available width
    if (this.innerWidth < this.widthBreakpoint) {
      this.expandNav = false;
      this.lockNav = false;
    } else {
      this.expandNav = true;
      this.lockNav = true;
    }
  }

  /**
   * Called when the user clicks an item
   * in the nav.
   */
  selectNavItem(target: string) {
    if (!this.lockNav) {
      this.expandNav = false;
    } else {
      this.expandNav = true;
    }

    this.navSvc.navDirect(target);
    setTimeout(() => {
      this.navTreeSvc.setSideNavScrollLocation(target)
    }, 300);
  }

  toggleNav() {
    this.expandNav = !this.expandNav;
  }

  /**
   * Returns the text for the Requirements label.
   */
  requirementsLabel() {
    return 'Requirements';
  }

  /**
   * Fired when the sidenav's opened state changes.
   * @param e
   */
  openStateChange(e) {
    this.expandNav = e;
  }

  goHome() {
    this.assessSvc.dropAssessment();
    this.router.navigate(['/home']);
  }

  loadCompletionData() {
    this.assessSvc.getAssessmentsCompletion().subscribe((data: any[]) => {
      const currentAssessment = data.find(x => x.assessmentId === this.assessSvc.id());

      if (currentAssessment) {
        this.completedQuestions = currentAssessment.completedCount || 0;
        this.totalQuestions = (currentAssessment.totalMaturityQuestionsCount ?? 0) +
          (currentAssessment.totalDiagramQuestionsCount ?? 0) +
          (currentAssessment.totalStandardQuestionsCount ?? 0);

        if (this.totalQuestions > 0) {
          this.completionPercentage = Math.round((this.completedQuestions / this.totalQuestions) * 100);
        } else {
          this.completionPercentage = 0;
        }

      } else {
        this.completionPercentage = 0;
        this.completedQuestions = 0;
        this.totalQuestions = 0;
      }
    });
  }

  getCompletionPercentage(): number {
    return this.completionPercentage;
  }

  getProgressTooltip(): string {
    if (this.totalQuestions === 0) return 'No questions available';
    return `${this.completedQuestions}/${this.totalQuestions} questions answered`;
  }

    ngOnDestroy() {
    this.completionSubscription?.unsubscribe();
  }
}
