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
import { Injectable } from '@angular/core';
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ConfigService } from '../../config.service';
import { QuestionGrouping } from '../../../models/questions.model';
import { QuestionFilterService } from '../question-filter.service';
import { AssessmentService } from '../../assessment.service';
import { AcetFilteringService } from './acet-filtering.service';
import { EdmFilteringService } from './edm-filtering.service';
import { CrrFilteringService } from './crr-filtering.service';
import { CmmcFilteringService } from './cmmc-filtering.service';
import { RraFilteringService } from './rra-filtering.service';
import { BasicFilteringService } from './basic-filtering.service';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};



@Injectable({
  providedIn: 'root'
})
export class MaturityFilteringService {


  /**
 * The page can store its model here for accessibility by question-extras
 */
  domains = null;


  /**
   * The allowable filter values.  Used for "select all"
   */
  readonly allowableFilters = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'O', 'FB', 'MT', 'MT+', 'FR', 'FI', 'LI', 'PI', 'NI'];

  /**
   * The allowable maturity filter values.  Only applicable on maturity questions page.
   * On a non-maturity page, they are always assumed to be ON.
   */
  readonly maturityFilters = ['MT', 'MT+'];

  /**
   * Filter settings
   *   Comments - C
   *   Marked For Review - M
   *   Observations - O
   */
  public showFilters: string[] = [];

  /**
   * Filters that are turned on at the start.
   */
  public defaultFilterSettings = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'O', 'FB', 'MT', 'FR', 'FI', 'LI', 'PI', 'NI'];

  /**
   * If the user enters characters into the box, only questions containing that string
   * are visible.
   */
  public filterSearchString = '';

  /**
   * Valid 'answer'-type filter values
   */
  public answerOptions: string[] = ['Y', 'N', 'NA', 'A', 'U', 'FI', 'LI', 'PI', 'NI'];



  constructor(
    http: HttpClient,
    public configSvc: ConfigService,
    public questionFilterSvc: QuestionFilterService,
    public assesmentSvc: AssessmentService,
    public acetFilteringSvc: AcetFilteringService,
    public cmmcFilteringSvc: CmmcFilteringService,
    public edmFilteringSvc: EdmFilteringService,
    public crrFilteringSvc: CrrFilteringService,
    public rraFilteringSvc: RraFilteringService,
    public basicFilteringSvc: BasicFilteringService
  ) {




    this.refresh();

  }

  /**
 * Reset the filters back to default settings.
 */
  refresh() {
    this.showFilters = this.defaultFilterSettings;
  }


  /**
 * Returns true if the filter is turned on to show
 * questions above the maturity target level.
 */
  showingAboveMaturityTargetLevel() {
    return (this.showFilters.indexOf('MT+') >= 0);
  }


  /**
   * Returns true if we have any inclusion filters turned off.
   * We don't count MT+ for this, since it is normally turned off.
   */
  isFilterEngaged() {
    if (this.filterSearchString.length > 0) {
      return true;
    }

    // see if any filters (not counting MT+) are turned off
    const e = (this.remove(this.allowableFilters, 'MT+').length !== this.remove(this.showFilters, 'MT+').length);

    return e;
  }


  /**
   * Indicates if the specified answer filter is currently 'on'
   * @param ans
   */
  filterOn(ans: string) {
    if (ans === 'ALL') {
      if (this.arraysAreEqual(this.remove(this.showFilters, 'MT+'), this.remove(this.allowableFilters, 'MT+'))) {
        return true;
      } else {
        return false;
      }
    }
    return (this.showFilters.indexOf(ans) >= 0);
  }

  /**
   * Adds or removes the specified answer.
   * @param ans
   * @param show
   */
  setFilter(ans: string, show: boolean) {
    if (ans === 'ALL') {
      if (show) {
        this.showFilters = this.allowableFilters.slice();
        this.showFilters = this.remove(this.showFilters, 'MT+');
      } else {
        this.showFilters = [];
      }
      return;
    }

    if (show) {
      if (this.showFilters.indexOf(ans) < 0) {
        this.showFilters.push(ans);
      }
    } else {
      const i = this.showFilters.indexOf(ans);
      if (i >= 0) {
        this.showFilters.splice(i, 1);
      }
    }
  }

  /**
  * Utility method.  Should be moved somewhere common.
  */
  arraysAreEqual(a1: any[], a2: any[]) {
    if (a1.length !== a2.length) {
      return false;
    }

    for (let i = 0, l = a1.length; i < l; i++) {
      if (a1[i] instanceof Array && a2[i] instanceof Array) {
        if (!a1[i].equals(a2[i])) {
          return false;
        }
      } else if (a1[i] !== a2[i]) {
        return false;
      }
    }
    return true;
  }

  /**
   * Returns an array with the target removed.
   * @param a
   * @param target
   */
  remove(a: any[], target: any) {
    if (!a) {
      return a;
    }
    const a1 = a.slice();
    const idx = a1.indexOf(target);
    if (idx >= 0) {
      a1.splice(idx, 1);
    }
    return a1;
  }





  public currentDomainName = '';

  /**
   * Sets the Visible property on all Questions
   * based on the current filter settings.
   * @param cats
   */
  public evaluateFilters(groupings: QuestionGrouping[]) {
    if (!groupings) {
      return;
    }

    groupings.forEach(g => {
      this.recurseQuestions(g);
    });
  }


  /**
   * Recurses any number of grouping levels and returns any Questions found.
   */
  public recurseQuestions(g: QuestionGrouping) {
    const filterSvc = this.questionFilterSvc;
    const filterStringLowerCase = filterSvc.filterSearchString.toLowerCase();

    if (g.groupingType == 'Domain') {
      this.currentDomainName = g.title;

    }

    g.visible = true;

    g.questions.forEach(q => {
      // start with false, then set true if the question should be shown
      q.visible = false;


      // Check maturity level filtering first.  If the question is not visible the rest of the
      // conditions can be avoided.
      switch (this.assesmentSvc.assessment.maturityModel.modelName) {
        case 'ACET':
          this.acetFilteringSvc.setQuestionVisibility(q, this.currentDomainName);
          break;
        case 'ISE':
          this.acetFilteringSvc.setIseQuestionVisibility(q, this.currentDomainName);
          break;
        case 'CMMC':
        case 'CMMC2':
          this.cmmcFilteringSvc.setQuestionVisibility(q);
          break;

        case 'EDM':
          this.edmFilteringSvc.setQuestionVisibility(q);
          break;
        case 'CRR':
          this.crrFilteringSvc.setQuestionVisibility(q);
          break;
        case 'RRA':
          this.rraFilteringSvc.setQuestionVisibility(q);
          break;
        default:
          this.basicFilteringSvc.setQuestionVisibility(q);
      }

      if (!q.visible) {
        return;
      }

      // If we made it this far, start over assuming visible = false
      q.visible = false;


      // If search string is specified, any questions that don't contain the string
      // are not shown.  No need to check anything else.
      if (filterSvc.filterSearchString.length > 0
        && q.questionText.toLowerCase().indexOf(filterStringLowerCase) < 0) {
        return;
      }

      // evaluate answers
      if (filterSvc.answerOptions.includes(q.answer) && filterSvc.showFilters.includes(q.answer)) {
        q.visible = true;
      }

      // consider null answers as 'U'
      if ((q.answer == null || q.answer == 'U') && filterSvc.showFilters.includes('U')) {
        q.visible = true;

        if (this.assesmentSvc.isISE() && q.isParentQuestion) { //skips parent question when checking for visibility
          q.visible = false;
        }
        if (this.assesmentSvc.usesMaturityModel('VADR') && (q.freeResponseAnswer && q.freeResponseAnswer.length > 0)) {
          q.visible = false;
        }
      }

      // evaluate other features
      if (filterSvc.showFilters.includes('C') && q.comment && q.comment.length > 0) {
        q.visible = true;
      }

      if (filterSvc.showFilters.includes('FB') && q.feedback && q.feedback.length > 0) {
        q.visible = true;
      }

      if (filterSvc.showFilters.includes('M') && q.markForReview) {
        q.visible = true;
      }

      if (filterSvc.showFilters.includes('O') && q.hasObservation) {
        q.visible = true;
      }

      if (filterSvc.showFilters.includes('FR') && q.freeResponseAnswer && q.freeResponseAnswer.length > 0) {
        q.visible = true;
      }
    });


    // now dig down another level to see if there are questions
    g.subGroupings.forEach((sg: QuestionGrouping) => {
      this.recurseQuestions(sg);
    });

    // if I have questions and they are all invisible, then I am invisible
    if (g.questions.length > 0 && g.questions.every(q => !q.visible)) {
      g.visible = false;
    }

    // if all my subgroups are invisible, then I am invisible
    if (g.subGroupings.length > 0 && g.subGroupings.every(sg => !sg.visible)) {
      g.visible = false;
    }

    if (g.subGroupings.length == 0 && g.questions.length == 0) {
      g.visible = false;
    }
  }
}
