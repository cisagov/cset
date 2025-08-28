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
import { Injectable } from '@angular/core';
import { Category, Domain } from '../../models/questions.model';
import { AssessmentService } from '../assessment.service';

/**
 * A new generic filtering service separate from maturity level filtering that was done
 * specifically for ACET.  That logic is in AcetFilterService.
 */
@Injectable({
  providedIn: 'root'
})
export class QuestionFilterService {

  /**
   * The allowable filter values.  Used for "select all"
   */
  private readonly baseFilters = ['Y', 'N', 'NA', 'A', 'I', 'S', 'U', 'C', 'M', 'O', 'FB', 'FR', 'FI', 'LI', 'PI', 'NI'
];

  /** UI needs this to know which toggles to render (answers + maturity levels). */
  public get allowableFilters(): string[] {
    const arr = [...this.baseFilters];
    const model = this.assessSvc.assessment?.maturityModel;

    if (model?.levels) {
      // Use the service's maturityTargetLevel if it exists, otherwise fall back to model's
      const targetLevel = this.maturityTargetLevel || model.maturityTargetLevel;

      // Add levels <= target level, avoiding duplicates
      model.levels.forEach(li => {
        const levelStr = li.level.toString();
        if (li.level <= targetLevel && !arr.includes(levelStr)) {
          arr.push(levelStr);
        }
      });
    }
    return arr;
  }
  // ADD: Method to update target level and refresh available filters
  public updateMaturityTargetLevel(newTargetLevel: number): void {
    const oldTargetLevel = this.maturityTargetLevel;
    this.maturityTargetLevel = newTargetLevel;
    // If target level increased, add new levels to showFilters
    if (newTargetLevel > oldTargetLevel) {
      const model = this.assessSvc.assessment?.maturityModel;
      if (model?.levels) {
        model.levels.forEach(li => {
          const levelStr = li.level.toString();
          if (li.level <= newTargetLevel && li.level > oldTargetLevel && !this.showFilters.includes(levelStr)) {
            this.showFilters.push(levelStr);
          }
        });
      }
    }

    // If target level decreased, remove levels that are now above target
    if (newTargetLevel < oldTargetLevel) {
      this.showFilters = this.showFilters.filter(f => {
        if (isNaN(Number(f))) {
          return true; // Keep non-numeric filters
        }
        const keep = Number(f) <= newTargetLevel;
        if (!keep) {
          console.log(`Removing level ${f} from showFilters due to target level decrease`);
        }
        return keep;
      });
    }

  }
  /**
   * This is a list of what to SHOW.
   *
   * Filter settings
   *   Comments - C
   *   Marked For Review - M
   *   Observations - O
   */
  public showFilters: string[];

  /**
   * Filters that are turned on at the start.
   */
  public defaultFilterSettings = ['Y', 'N', 'NA', 'A', 'I', 'S', 'U', 'C', 'M', 'O', 'FB', 'FR', 'FI', 'LI', 'PI', 'NI'];

  /**
   * If the user enters characters into the box, only questions containing that string
   * are visible.
   */
  public filterSearchString = '';
  private filtersInitialized= false;
  /**
   * Valid 'answer'-type filter values.  Defaulted to these (for standards)
   * but overrideable by a maturity model.
   */
  public answerOptions: string[] = ['Y', 'N', 'NA', 'A', 'I', 'U', 'FI', 'LI', 'PI', 'NI'];

  /**
   * Consuming pages can set a model ID
   */
  public maturityModelId: number;

  /**
   * Consuming pages can set a model name
   */
  public maturityModelName: string;

 public  maturityTargetLevel: number;
  /**
   * Constructor
   * @param assessSvc
   */
  constructor(
    private assessSvc: AssessmentService
  ) {
    this.refresh();
   // this.showFilters=[...this.defaultFilterSettings]
  }


  /**
   * Reset the filters back to default settings.
   */
  public refresh(): void {
    // Only do full initialization if never initialized before
    if (!this.filtersInitialized) {
      this.initializeFilters();
      this.filtersInitialized = true;
    } else {
      // On subsequent calls, only update dynamic levels without touching user selections
      this.updateDynamicLevels();
    }
  }

  private initializeFilters(): void {
    // Start with base defaults
    this.showFilters = [...this.defaultFilterSettings];
    const model=this.assessSvc.assessment?.maturityModel;
    if(model?.levels){
      this.maturityTargetLevel=model.maturityTargetLevel
      model.levels.forEach(li=>{
        const levelStr=li.level.toString();
        if(li.level<=this.maturityTargetLevel && !this.showFilters.includes(levelStr)){
          this.showFilters.push(levelStr)
        }
      })
    }
  }

// ADD: New method to handle dynamic level updates without resetting user choices
  private updateDynamicLevels(): void {
    const model = this.assessSvc.assessment?.maturityModel;

    if (!model?.levels) {
      return;
    }

    const newTargetLevel = model.maturityTargetLevel;
    // Only update if target level actually changed
    if (this.maturityTargetLevel !== newTargetLevel) {
      this.updateMaturityTargetLevel(newTargetLevel);
    } else {
      console.log('Target level unchanged, no dynamic update needed');
    }
  }

// Force complete re-initialization (for when assessment/model changes)
  public forceRefresh(): void {
    this.filtersInitialized = false;
    this.refresh();
  }
  public refreshAllowableFilters(): void {
    const filters = this.allowableFilters; // This will trigger the getter
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
  public setFilter(ans: string, show: boolean): void {
    // “Select All” toggles every filter except the special MT+ flag
    if (ans === 'ALL') {
      if (show) {
        this.showFilters = this.allowableFilters.filter(f => f !== 'MT+');
      } else {
        this.showFilters = [];
      }
      return;
    }

    // Individual toggle
    if (show) {
      // Add it if not already present
      if (!this.showFilters.includes(ans)) {
        this.showFilters.push(ans);
      }
    } else {
      // Remove it if present
      const idx = this.showFilters.indexOf(ans);
      if (idx >= 0) {
        this.showFilters.splice(idx, 1);
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
    const a1 = a.slice();
    const idx = a1.indexOf(target);
    if (idx >= 0) {
      a1.splice(idx, 1);
    }
    return a1;
  }

  /**
   * This is an overload of evaluateFilters, which takes a list
   * of Domains.  This version wraps the category list in
   * a dummy Domain and calls evaluateFilters.
   * @param categories
   */
  public evaluateFiltersForCategories(categories: Category[]) {
    var dummyDomain: Domain = {
      categories: [],
      displayText: '',
      domainName: '',
      domainText: '',
      isDomain: true,
      setName: '',
      setShortName: '',
      visible: true
    };
    dummyDomain.categories = categories;

    var dummyDomainList = [];
    dummyDomainList.push(dummyDomain);

    return this.evaluateFilters(dummyDomainList);
  }


  /**
   * Sets the Visible property on all Questions, Subcategories and Categories
   * based on the current filter settings.
   * @param cats
   */
  public evaluateFilters(domains: Domain[]) {
    if (!domains) {
      return;
    }

    const filterStringLowerCase = this.filterSearchString.toLowerCase();

    domains.forEach(d => {
      d.categories.forEach(c => {
        c.subCategories.forEach(s => {
          s.questions.forEach(q => {
            // start with false, then set true if possible
            q.visible = false;

            // If search string is specified, any questions that don't contain the string
            // are not shown.  No need to check anything else.
            if (this.filterSearchString.length > 0
              && q.questionText.toLowerCase().indexOf(filterStringLowerCase) < 0) {
              return;
            }

            // evaluate answers
            if (this.answerOptions.includes(q.answer) && this.showFilters.includes(q.answer)) {
              q.visible = true;
            }

            // consider null answers as 'U'
            if ((q.answer == null || q.answer == 'U') && this.showFilters.includes('U')) {
              q.visible = true;
            }

            // evaluate other features
            if (this.showFilters.includes('C') && q.comment && q.comment.length > 0) {
              q.visible = true;
            }

            if (this.showFilters.includes('FB') && q.feedback && q.feedback.length > 0) {
              q.visible = true;
            }

            if (this.showFilters.includes('M') && q.markForReview) {
              q.visible = true;
            }

            if (this.showFilters.includes('O') && q.hasObservation) {
              q.visible = true;
            }

            if (this.showFilters.includes('FR') && q.freeResponseAnswer && q.freeResponseAnswer.length > 0) {
              q.visible = true;
            }
          });

          // evaluate subcat visiblity
          s.visible = (!!s.questions.find(q => q.visible));
        });

        // evaluate category heading visibility
        c.visible = (!!c.subCategories.find(s => s.visible));
      });

      // evaluate domain heading visibility
      d.visible = (!!d.categories.find(c => c.visible));
    });
  }

  // cie filter for reports
  /**
   * This is an overload of evaluateFilters, which takes a list
   * of Domains.  This version wraps the category list in
   * a dummy Domain and calls evaluateFilters.
   *
   * Made specifically for CIE, but can be modified to work with other maturities
   * @param categories
   */
  public evaluateFiltersForReportCategories(categories: any[], matLevel: number) {
    var dummyDomain: Domain = {
      categories: [],
      displayText: '',
      domainName: '',
      domainText: '',
      isDomain: true,
      setName: '',
      setShortName: '',
      visible: true
    };
    dummyDomain.categories = categories;

    var dummyDomainList = [];
    dummyDomainList.push(dummyDomain);

    return this.evaluateReportFilters(dummyDomainList, matLevel);
  }


  /**
   * Sets the Visible property on all Questions, Subcategories and Categories
   * based on the current filter settings.
   *
   * Made specifically for CIE, but can be modified to work with other maturities
   * @param cats
   */
  public evaluateReportFilters(domains: any[], matLevel: number) {
    if (!domains) {
      return;
    }

    const filterStringLowerCase = this.filterSearchString.toLowerCase();

    if (matLevel == 5) {
      domains.forEach(d => {
        d.categories.assessmentFactors.forEach(af => { // categories / principles
          af.questions.forEach(q => {
            // start with false, then set true if possible
            q.visible = false;

            // If search string is specified, any questions that don't contain the string
            // are not shown.  No need to check anything else.
            if (this.filterSearchString.length > 0
              && q.questionText.toLowerCase().indexOf(filterStringLowerCase) < 0) {
              return;
            }

            // because CIE is free-response based, 'U' just means "not NA"
            // 'U' with 'freeResponseAnswer' gives whether it's an 'N' (Unanswered) or 'Y' (Answered))
            if (q.answerText == 'U'
              && (q.freeResponseText && q.freeResponseText.length > 0)
              && this.showFilters.includes('Y')) {
              q.visible = true;
            }

            if ((q.answerText == null || q.answerText == 'U')
              && (!q.freeResponseText || q.freeResponseText.length == 0)
              && this.showFilters.includes('N')) {
              q.visible = true;
            }

            // if answer is 'NA', the free-response part is optional
            if (q.answerText == 'NA' && this.showFilters.includes(q.answerText)) {
              q.visible = true;
            }
          });
          // evaluate category heading visibility
          af.areQuestionsDeficient = (af.questions.find(q => q.visible) == null ? true : false);
        });

        /** evaluate domain heading principle question visibility.
        * Put into 'areFactorQuestionsDeficient' to allow both principle
        * and principle-phase tables to have separate filters
        */
        d.categories.areFactorQuestionsDeficient = (d.categories.assessmentFactors.find(af => !af.areQuestionsDeficient) == null ? true : false);
      });
    }

    else {
      domains.forEach(d => {
        d.categories.assessmentFactors.forEach(af => { // categories / principles
          af.components.forEach(c => { // subCategories / phases
            c.questions.forEach(q => {
              // start with false, then set true if possible
              q.visible = false;

              // If search string is specified, any questions that don't contain the string
              // are not shown.  No need to check anything else.
              if (this.filterSearchString.length > 0
                && q.questionText.toLowerCase().indexOf(filterStringLowerCase) < 0) {
                return;
              }

              // because CIE is free-response based, 'U' just means "not NA"
              // 'U' with 'freeResponseAnswer' gives whether it's an 'N' (Unanswered) or 'Y' (Answered))
              if (q.answerText == 'U' && (q.freeResponseText && q.freeResponseText.length > 0)
                && this.showFilters.includes('Y')) {
                q.visible = true;
              }

              if ((q.answerText == null || q.answerText == 'U')
                && (!q.freeResponseText || q.freeResponseText.length == 0)
                && this.showFilters.includes('N')) {
                q.visible = true;
              }

              // if answer is 'NA', the free-response part is optional
              if (q.answerText == 'NA' && this.showFilters.includes(q.answerText)) {
                q.visible = true;
              }
            });

            // evaluate subcat visiblity
            c.isDeficient = (c.questions.find(q => q.visible) == null ? true : false);
          });

          // evaluate category heading visibility
          af.isDeficient = (af.components.find(c => !c.isDeficient) == null ? true : false);
        });

        // evaluate domain heading principle-phase question visibility
        d.categories.isDeficient = (d.categories.assessmentFactors.find(c => !c.isDeficient) == null ? true : false);
      });
    }
  }
  //
}
