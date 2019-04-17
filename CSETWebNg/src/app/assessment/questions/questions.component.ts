////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { Component, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef } from "@angular/material";
import { Router } from '@angular/router';
import { QuestionFiltersComponent } from "../../dialogs/question-filters/question-filters.component";
import { QuestionGroup, QuestionResponse } from '../../models/questions.model';
import { AssessmentService } from '../../services/assessment.service';
import { NavigationService, NavTree } from '../../services/navigation.service';
import { QuestionsService } from '../../services/questions.service';
import { StandardService } from '../../services/standard.service';

@Component({
  selector: 'app-questions',
  templateUrl: './questions.component.html',
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class QuestionsComponent implements OnInit {
  @ViewChild('questionBlock') questionBlock;
  // applicationMode: string;
  questionGroups: QuestionGroup[] = null;

  setHasRequirements = false;

  autoLoadSupplementalInfo: boolean;

  filterDialogRef: MatDialogRef<QuestionFiltersComponent>;

  /**
   * Constructor
   * @param questionsSvc
   * @param navSvc
   * @param assessSvc
   */
  constructor(
    public questionsSvc: QuestionsService,
    private navSvc: NavigationService,
    public assessSvc: AssessmentService,
    private stdSvc: StandardService,
    private router: Router,
    private dialog: MatDialog
  ) {
    const magic = this.navSvc.getMagic();
    this.navSvc.setTree([
      { label: 'Please wait', value: '', children: [] },
      { label: 'Loading questions', value: '', children: [] }
    ], magic);

    this.autoLoadSupplementalInfo = this.questionsSvc.autoLoadSupplementalSetting;

    // if running in IE, turn off the auto load feature
    if (this.browserIsIE()) {
      this.autoLoadSupplementalInfo = false;
    }

    if (!this.assessSvc.applicationMode) {
      this.assessSvc.applicationMode = 'Q';
      this.questionsSvc.setMode(this.assessSvc.applicationMode).subscribe(() => this.loadQuestions());
    } else {
      this.loadQuestions();
    }
  }

  ngOnInit() {
    if (this.questionGroups != null && this.questionGroups.length <= 0) {
      this.loadQuestions();
    }
    this.assessSvc.currentTab = 'questions';
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
    this.questionsSvc.evaluateFilters(this.questionGroups);
    if (!!this.questionGroups) {
      this.populateTree(magic);
    }
  }

  /**
   * Changes the application mode of the assessment
   */
  setMode(mode: string) {
    this.navSvc.setTree([
      { label: 'Please wait', value: '', children: [] },
      { label: 'Loading questions', value: '', children: [] }
    ], this.navSvc.getMagic());
    this.questionGroups = null;
    this.questionsSvc.setMode(mode).subscribe(() => this.loadQuestions());
  }

  /**
   * Retrieves the complete list of questions
   */
  loadQuestions() {
    const magic = this.navSvc.getMagic();
    this.questionsSvc.getQuestionsList().subscribe(
      (data: QuestionResponse) => {
        this.questionGroups = data.QuestionGroups;
        this.questionsSvc.questionGroups = this.questionGroups;
        this.assessSvc.applicationMode = data.ApplicationMode;
        this.setHasRequirements = (data.RequirementCount > 0);

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

  populateTree(magic?: string) {
    if (!magic) {
      magic = this.navSvc.getMagic();
    }
    const tree: NavTree[] = [];
    this.questionGroups
      .filter(g => g.Visible)
      .map(q => {

        if (!!q.StandardShortName) {
          let standard = tree.find(elem => elem.label === q.StandardShortName);
          if (standard === undefined || standard === null) {
            tree.push({
              label: q.StandardShortName,
              value: '',
              children: []
            });
            standard = tree[tree.length - 1];
          }
          standard.children.push({
            label: q.GroupHeadingText,
            value: {
              target: 'Q' + q.GroupHeadingId + '.' + q.StandardShortName,
              question: q.GroupHeadingId
            },
            children: []
          });
        } else {
          tree.push({
            label: q.GroupHeadingText,
            value: {
              target: 'Q' + q.GroupHeadingId + '.' + q.StandardShortName,
              question: q.GroupHeadingId
            },
            children: []
          });
        }
      });
    this.navSvc.setTree(tree, magic, true);
    this.navSvc.itemSelected
      .asObservable()
      .subscribe(
        (tgt: { target: string; parent?: string, question: number; subcategory?: number }) => {
          if (!!tgt.subcategory) {
            this.questionGroups
              .find(val => val.GroupHeadingId === tgt.question)
              .SubCategories.find(
                val => val.SubCategoryId === tgt.subcategory
              ).Expanded = true;
            document.getElementById(tgt.parent).scrollIntoView();
          }
          if (!!tgt.target) {
            document.getElementById(tgt.target).scrollIntoView();
          }
        }
      );
  }

  visibleGroupCount() {
    if (!this.questionGroups) {
      return 1;
    }
    return this.questionGroups.filter(g => g.Visible).length;
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
    this.questionGroups.forEach(group => {
      group.SubCategories.forEach(subcategory => {
        subcategory.Expanded = mode;
      });
    });
  }

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

  navBack() {
    if (this.stdSvc.frameworkSelected) {
      this.router.navigate(['/assessment', this.assessSvc.id(), 'prepare', 'framework']);
    } else {
      this.router.navigate(['/assessment', this.assessSvc.id(), 'prepare', 'standards']);
    }
  }

  navNext() {
    this.router.navigate(['/assessment', this.assessSvc.id(), 'results']);
  }
}
