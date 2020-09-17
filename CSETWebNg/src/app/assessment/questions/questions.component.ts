////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { Component, ViewChild, AfterViewInit, AfterViewChecked } from '@angular/core';
import { MatDialog, MatDialogRef } from "@angular/material";
import { Router } from '@angular/router';
import { QuestionFiltersComponent } from "../../dialogs/question-filters/question-filters.component";
import { QuestionResponse, Domain, Category } from '../../models/questions.model';
import { AssessmentService } from '../../services/assessment.service';
import { NavTreeNode } from '../../services/navigation.service';
import { QuestionsService } from '../../services/questions.service';
import { StandardService } from '../../services/standard.service';
import { NavigationService } from '../../services/navigation.service';


@Component({
  selector: 'app-questions',
  templateUrl: './questions.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class QuestionsComponent implements AfterViewInit, AfterViewChecked {
  @ViewChild('questionBlock') questionBlock;

  domains: Domain[] = null;

  setHasRequirements = false;

  setHasQuestions = false;

  autoLoadSupplementalInfo: boolean;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  currentDomain: string;

  PreviousComponentGroup = null;

  loaded = false;

  scrollComplete = false;


  /**
   * 
   */
  constructor(
    public questionsSvc: QuestionsService,
    public assessSvc: AssessmentService,
    private stdSvc: StandardService,
    public navSvc: NavigationService,
    private router: Router,
    private dialog: MatDialog
  ) {
    const magic = this.navSvc.getMagic();

    this.autoLoadSupplementalInfo = this.questionsSvc.autoLoadSupplementalSetting;

    // if running in IE, turn off the auto load feature
    if (this.browserIsIE()) {
      this.autoLoadSupplementalInfo = false;
    }

    this.getQuestionCounts();

    // handle any scroll events originating from the nav servicd
    this.navSvc.scrollToQuestion
      .asObservable()
      .subscribe(
        (tgt: string) => {
          const t = document.getElementById(tgt);
          if (!!t) {
            t.scrollIntoView();
          }
        }
      );
  }

  updateComponentsOverride() {
    //divide the component override processing 
    //and component questions into two portions
    //and call and update from here.    

    //clear out the navigation overrides
    //then call the get overrides questions api
    //and refressh overrides navigation
    const magic = this.navSvc.getMagic();
    this.questionsSvc.getQuestionListOverridesOnly().subscribe((data: QuestionResponse) => {
      this.refreshQuestionVisibility(magic);
    });
  }
  
  /**
   *
   */
  ngAfterViewInit() {
    if (this.domains != null && this.domains.length <= 0) {
      this.loadQuestions();
    }

    this.assessSvc.currentTab = 'questions';
    this.loaded = true;
  }

  /**
   * Wait until the DOM is loaded so that we can scroll, if needed.
   */
  ngAfterViewChecked() {
    if (this.loaded && !this.scrollComplete) {
      if (!!this.questionsSvc.scrollToTarget) {
        setTimeout(() => {
          this.scroll(this.questionsSvc.scrollToTarget);
          this.questionsSvc.scrollToTarget = null;
          this.scrollComplete = true;
        }, 1000);
      }
    }
  }

  /**
   * 
   * @param targetID 
   */
  scroll(targetID: string) {
    const t = document.getElementById(targetID);
    if (!!t) {
      t.scrollIntoView();
    }
  }

  /**
   * Re-evaluates the visibility of all questions/subcategories/categories
   * based on the current filter settings.
   * Also re-draws the sidenav category tree, skipping categories
   * that are not currently visible.
   */
  refreshQuestionVisibility(magic?: string) {
    if (!magic) {
      magic = this.navSvc.getMagic();
    }

    this.questionsSvc.evaluateFilters(this.domains);
    if (!!this.domains) {
      // this.populateTree(magic);
    }
  }

  /**
   * Changes the application mode of the assessment
   */
  setMode(mode: string) {
    this.questionsSvc.setMode(mode).subscribe(() => this.loadQuestions());
  }

  getQuestionCounts() {
    this.questionsSvc.getQuestionsList().subscribe(
      (data: QuestionResponse) => {
        this.assessSvc.applicationMode = data.ApplicationMode;
        this.setHasRequirements = (data.RequirementCount > 0);
        this.setHasRequirements = true; // RKW TEMP
        this.setHasQuestions = (data.QuestionCount > 0);
        // this.setHasQuestions = true; // RKW TEMP

        if (!this.setHasQuestions && !this.setHasRequirements) {
          this.assessSvc.applicationMode = 'Q';
          this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
        }
        else if (!this.setHasRequirements && this.assessSvc.applicationMode == "R") {
          this.assessSvc.applicationMode = 'Q';
          this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
        }
        else if (this.setHasRequirements && this.assessSvc.applicationMode == 'R') {
          this.assessSvc.applicationMode = 'R';
          this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
        }
        else if (!this.setHasQuestions && this.assessSvc.applicationMode == 'Q') {
          this.assessSvc.applicationMode = 'R';
          this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
        }
        else {
          this.assessSvc.applicationMode = 'Q';
          this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
        }
      });
  }


  /**
   * Retrieves the complete list of questions
   */
  loadQuestions() {
    const magic = this.navSvc.getMagic();
    this.domains = null;
    this.questionsSvc.getQuestionsList().subscribe(
      (response: QuestionResponse) => {
        this.assessSvc.applicationMode = response.ApplicationMode;
        this.setHasRequirements = (response.RequirementCount > 0);
        this.setHasQuestions = (response.QuestionCount > 0);
        this.questionsSvc.questions = response;

        this.domains = response.Domains;

        // default the selected maturity filters
        this.questionsSvc.initializeMatFilters(response.OverallIRP);

        this.refreshQuestionVisibility(magic);
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
   * 
   */
  processComponentOverrides(Categories: Category[]) {
    Categories.forEach(g => {
      let rval = true;
      if (g.Symbol_Name) {
        if (this.PreviousComponentGroup) {
          rval = !((g.Symbol_Name === this.PreviousComponentGroup.ComponentType)
            && (g.ComponentName === this.PreviousComponentGroup.ComponentName));
        }
        this.PreviousComponentGroup = g;
      } else {
        rval = false;
      }
      g.ShowOverrideHeader = rval;
    });
  }


  /**
   * 
   */
  insertComponentSpecificOverride(tree: NavTreeNode[], q: Category) {
    // build the question group heading element
    q.SubCategories.forEach(sub => {
      const heading = {
        label: sub.SubCategoryHeadingText,
        value: {
          target: sub.NavigationGUID,
          question: q.GroupHeadingId
        },
        elementType: 'QUESTION-HEADING',
        children: []
      };
      // componentname.children.push(heading);
    });
  }

  /**
   * 
   */
  visibleGroupCount() {
    if (!this.domains) {
      return 1;
    }
    let count = 0;
    this.domains.forEach(d => {
      console.log('visibleGroupCount');
      console.log(d.Categories);
      count = count + d.Categories.filter(g => g.Visible).length;
    });
    return count;
  }

  /**
   * Returns a boolean indicating if the browser is IE or Edge.
   * The 'auto-load supplemental' logic is not performant in IE, so we won't offer it.
   */
  browserIsIE() {
    const isIEOrEdge = /msie\s|trident\/|edge\//i.test(window.navigator.userAgent);
    return isIEOrEdge;
  }

  /**
   * Stores the Supplemental auto-load setting in the service
   * for access by the child components.
   */
  persistAutoLoadSetting() {
    this.questionsSvc.autoLoadSupplementalSetting = this.autoLoadSupplementalInfo;
  }

  /**
   * Controls the mass expansion/collapse of all subcategories on the screen.
   * @param mode
   */
  expandAll(mode: boolean) {
    this.domains.forEach((d: Domain) => {
      d.Categories.forEach(group => {
        group.SubCategories.forEach(subcategory => {
          subcategory.Expanded = mode;
        });
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
}
