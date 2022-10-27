////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { Component, ViewChild, AfterViewChecked } from '@angular/core';
import { MatDialog, MatDialogRef } from "@angular/material/dialog";
import { QuestionFiltersComponent } from "../../dialogs/question-filters/question-filters.component";
import { QuestionResponse, Category } from '../../models/questions.model';
import { AssessmentService } from '../../services/assessment.service';
import { QuestionsService } from '../../services/questions.service';
import { NavigationService } from '../../services/navigation/navigation.service';
import { QuestionFilterService } from '../../services/filtering/question-filter.service';
import { ConfigService } from '../../services/config.service';
import { CompletionService } from '../../services/completion.service';

@Component({
  selector: 'app-questions',
  templateUrl: './questions.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class QuestionsComponent implements AfterViewChecked {
  @ViewChild('questionBlock') questionBlock;

  categories: Category[] = null;

  setHasRequirements = false;
  showRequirementsToggle = false;

  setHasQuestions = false;
  showQuestionsToggle = false;

  autoLoadSupplementalInfo: boolean;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  PreviousComponentGroup = null;

  loaded = false;

  scrollComplete = false;


  /**
   * 
   */
  constructor(
    public questionsSvc: QuestionsService,
    public completionSvc: CompletionService,
    public assessSvc: AssessmentService,
    private configSvc: ConfigService,
    public filterSvc: QuestionFilterService,
    public navSvc: NavigationService,
    private dialog: MatDialog
  ) {
    const magic = this.navSvc.getMagic();

    this.autoLoadSupplementalInfo = this.questionsSvc.autoLoadSupplementalSetting;

    // if running in IE, turn off the auto load feature
    if (this.browserIsIE()) {
      this.autoLoadSupplementalInfo = false;
    }
    if (this.assessSvc.assessment == null) {
      this.assessSvc.getAssessmentDetail().subscribe(
        (data: any) => {
          this.assessSvc.assessment = data;
        });
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
    localStorage.setItem("questionSet", this.assessSvc.applicationMode == 'R' ? "Requirement" : "Question");
  }

  updateComponentsOverride() {
    //divide the component override processing 
    //and component questions into two portions
    //and call and update from here.    

    //clear out the navigation overrides
    //then call the get overrides questions api
    //and refressh overrides navigation
    this.questionsSvc.getQuestionListOverridesOnly().subscribe((data: QuestionResponse) => {
      this.refreshQuestionVisibility();
    });
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
  refreshQuestionVisibility() {
    this.filterSvc.evaluateFiltersForCategories(this.categories);
  }

  /**
   * Changes the application mode of the assessment
   */
  setMode(mode: string) {
    this.questionsSvc.setMode(mode).subscribe(() => {
      this.loadQuestions();
      this.navSvc.setQuestionsTree();
    });
    localStorage.setItem("questionSet", mode == 'R' ? "Requirement" : "Question");
  }

  /**
   * 
   */
  getQuestionCounts() {
    this.questionsSvc.getQuestionsList().subscribe(
      (data: QuestionResponse) => {
        this.assessSvc.applicationMode = data.applicationMode;
        this.setHasRequirements = (data.requirementCount > 0);
        this.setHasQuestions = (data.questionCount > 0);

        let modified = false;
        // Using nested ifs because '&&' statements would allow the next else if to run
        if (this.assessSvc.applicationMode == 'Q') {
          if (!this.setHasQuestions) {
            this.assessSvc.applicationMode = 'R';
            modified = true;
          }
        }
        else if (this.assessSvc.applicationMode == 'R') {
          // Accounts for !this.setHasQuestions && !this.setHasRequirements as well.
          if (!this.setHasRequirements) {
            this.assessSvc.applicationMode = 'Q';
            modified = true;
          }
        }
        else {
          this.assessSvc.applicationMode = 'Q';
          modified = true;
        }        

        // set toggle visibility
        this.showQuestionsToggle = this.setHasQuestions;
        this.showRequirementsToggle = this.setHasRequirements;
        if (data.onlyMode) {
          this.showQuestionsToggle = (this.assessSvc.applicationMode == 'Q');
          this.showRequirementsToggle = (this.assessSvc.applicationMode == 'R');       
        }

        if (modified) {
          this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
        }
        else {
          this.loadQuestions();
        }
      });
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
    this.assessSvc.currentTab = 'questions';
    this.completionSvc.reset();

    this.questionsSvc.getQuestionsList().subscribe(
      (response: QuestionResponse) => {
        this.assessSvc.applicationMode = response.applicationMode;
        this.setHasRequirements = (response.requirementCount > 0);
        this.setHasQuestions = (response.questionCount > 0);
        this.questionsSvc.questions = response;

        this.completionSvc.setQuestionArray(response);

        this.categories = response.categories;

        this.filterSvc.answerOptions = response.answerOptions;
        this.filterSvc.maturityModelId = 0;

        this.filterSvc.evaluateFiltersForCategories(this.categories);

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
   * 
   */
  visibleGroupCount() {
    let count = 0;
    count += this.categories.filter(g => g.visible).length;
    return count;
  }

  /**
   * Returns a boolean indicating if the browser is IE or Edge.
   * The 'Auto-load Guidance' logic is not performant in IE, so we won't offer it.
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
}
