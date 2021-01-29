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
import { Injectable } from '@angular/core';
import { HttpHeaders, HttpParams, HttpClient } from '@angular/common/http';
import { ConfigService } from '../config.service';
import { ACETDomain, Domain, QuestionGrouping } from '../../models/questions.model';
import { QuestionFilterService } from '../question-filter.service';
import { AcetFilteringSpecifics } from './acet-filtering-specifics';
import { CmmcFilteringSpecifics } from './cmmc-filtering-specifics';
import { EdmFilteringSpecifics } from './edm-filtering-specifics';
import { AssessmentService } from '../assessment.service';


const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};


export class ACETFilter {
  DomainName: string;
  DomainId: number;
  Settings: ACETFilterSetting[];
}

export class ACETFilterSetting {
  Level: number;
  Value: boolean;
}

@Injectable({
  providedIn: 'root'
})
export class MaturityFiltersService {




  /**
   * Trying a new way to manage these things.  This is now the master filter object.
   * These are currently used exclusively for ACET.
   */
  public domainFilters: ACETFilter[];

  public overallIRP: number;

  /**
 * The page can store its model here for accessibility by question-extras
 */
  domains = null;


  /**
   * The allowable filter values.  Used for "select all"
   */
  readonly allowableFilters = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'D', 'FB', 'MT', 'MT+'];

  /**
   * The allowable maturity filter values.  Only applicable on maturity questions page.
   * On a non-maturity page, they are always assumed to be ON.
   */
  readonly maturityFilters = ['MT', 'MT+'];

  /**
   * Filter settings
   *   Comments - C
   *   Marked For Review - M
   *   Discoveries (Observations) - D
   */
  public showFilters: string[] = [];

  /**
   * Filters that are turned on at the start.
   */
  public defaultFilterSettings = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'D', 'FB', 'MT'];

  /**
   * If the user enters characters into the box, only questions containing that string
   * are visible.
   */
  public filterString = '';

  /**
   * Valid 'answer'-type filter values
   */
  public answerValues: string[] = ['Y', 'N', 'NA', 'A', 'U'];



  acetFS = new AcetFilteringSpecifics();
  cmmcFS = new CmmcFilteringSpecifics();
  edmFS = new EdmFilteringSpecifics();

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private questionFilterSvc: QuestionFilterService,
    private assesmentSvc: AssessmentService
  ) {



    this.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;

    });

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
    if (this.filterString.length > 0) {
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



  /**
  * Sets the starting value of the maturity filters, based on the 'stairstep.'
  * Any 'empty' values below the bottom of the band are set as well.
  */
  initializeMatFilters(targetLevel: number): Promise<any> {
    return new Promise((resolve) => {
      this.overallIRP = targetLevel;

      // if we have an IRP, default the maturity filters based on the stairstep.
      this.domainFilters = [];

      this.getFilters().subscribe((x: ACETFilter[]) => {
        if (!x || x.length === 0) {
          // the server has not filter pref set -- set default filters based on the bands
          this.setDmfFromDefaultBand(targetLevel);
          this.saveFilters(this.domainFilters).subscribe();
        } else {
          // rebuild domainFilters from what the API gave us
          this.domainFilters = [];
          for (const entry of x) {
            this.domainFilters.push({
              DomainName: entry.DomainName,
              DomainId: entry.DomainId,
              Settings: entry.Settings
            });
          }
        }

        // resolve this promise
        resolve(this.domainFilters);
      });
    });
  }

  /**
   * Gets the default stairstep and creates a filter profile
   * for all Domains from that stairstep.
   */
  setDmfFromDefaultBand(irp: number) {
    if (!this.domains) {
      return;
    }
    const bands = this.getStairstepOrig(irp);
    const dmf = this.domainFilters;

    this.domains.forEach((d: Domain) => {
      const settings: ACETFilterSetting[] = [];
      for (let i = 1; i <= 5; i++) {
        settings.push({
          Level: i,
          Value: bands.includes(i)
        });
      }
      dmf.push(
        {
          DomainName: d.DomainName,
          DomainId: 0,
          Settings: settings
        });

      const dFilter = this.domainFilters.find(f => f.DomainName == d.DomainName);
      let ix = 0;
      let belowBand = true;
      while (belowBand) {
        if (dFilter.Settings[ix].Value == false) {
          dFilter.Settings[ix].Value == true;
        } else {
          belowBand = false;
        }
      }
    });
  }

  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the stairstep graph in the NCUA Guide.
   */
  getStairstepOrig(irp: number): number[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return [1, 2]; // ['B', 'E'];
      case 2:
        return [1, 2, 3]; // ['B', 'E', 'Int'];
      case 3:
        return [2, 3, 4]; // ['E', 'Int', 'A'];
      case 4:
        return [3, 4, 5]; // ['Int', 'A', 'Inn'];
      case 5:
        return [4, 5]; // ['A', 'Inn'];
    }
  }



  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the proposed 'grounded' stairstep graph.
   */
  getStairstepNew(irp: number): number[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return [1]; // ['B'];
      case 2:
        return [1, 2]; // ['B', 'E'];
      case 3:
        return [1, 2, 3]; // ['B', 'E', 'Int'];
      case 4:
        return [1, 2, 3, 4]; // ['B', 'E', 'Int', 'A'];
      case 5:
        return [1, 2, 3, 4, 5]; // ['B', 'E', 'Int', 'A', 'Inn'];
    }
  }

  /**
   * Returns true if no maturity filters are enabled.
   * This is used primarily to ngif the 'all filters are off' message.
   */
  maturityFiltersAllOff(domainName: string) {
    const targetFilter = this.domainFilters?.find(f => f.DomainName == domainName);

    // If not ACET (no domain name), return false
    if (!domainName
      || domainName.length === 0
      || !this.domainFilters
      || !targetFilter) {
      return false;
    }

    return targetFilter.Settings.every(s => s.Value == false);
  }

  /**
   *
   */
  isDefaultMatLevel(mat: number) {
    const stairstepOrig = this.getStairstepOrig(this.overallIRP);
    if (!!stairstepOrig) {
      return stairstepOrig.includes(mat);
    }
    return false;
  }

  /**
   * 
   */
  resetDomainFilters(irp: number) {
    this.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;
      this.domainFilters = [];
      this.setDmfFromDefaultBand(irp);
      this.saveFilters(this.domainFilters).subscribe();
    });
  }

  currentDomainName = '';

  /**
   * Sets the Visible property on all Questions
   * based on the current filter settings.
   * @param cats
   */
  public evaluateFilters(groupings: QuestionGrouping[]) {
    if (!groupings) {
      return;
    }

    debugger;


    groupings.forEach(g => {
      this.recurseQuestions(g);
    });
  }


  /**
   * Recurses any number of grouping levels and returns any Questions found.
   */
  recurseQuestions(g: QuestionGrouping) {
    const filterSvc = this.questionFilterSvc;
    const filterStringLowerCase = filterSvc.filterString.toLowerCase();

    if (g.GroupingType == 'Domain') {
      this.currentDomainName = g.Title;
    }

    g.Questions.forEach(q => {
      // start with false, then set true if possible
      q.Visible = false;


      // Check maturity level filtering first.  If the question is not visible the rest of the 
      // conditions can be avoided.
      switch (this.assesmentSvc.assessment.MaturityModel.ModelName) {
        case 'ACET':
          this.acetFS.setQuestionVisibility(q, this.currentDomainName, this.domainFilters);
          break;

        case 'CMMC':
          this.cmmcFS.setQuestionVisibility(q);
          break;

        case 'EDM':
          this.edmFS.setQuestionVisibility(q);
          break;
      }

      if (!q.Visible) {
        return;
      }



      // If search string is specified, any questions that don't contain the string
      // are not shown.  No need to check anything else.
      if (filterSvc.filterString.length > 0
        && q.QuestionText.toLowerCase().indexOf(filterStringLowerCase) < 0) {
        return;
      }

      // evaluate answers
      if (filterSvc.answerValues.includes(q.Answer) && filterSvc.showFilters.includes(q.Answer)) {
        q.Visible = true;
      }

      // consider null answers as 'U'
      if (q.Answer == null && filterSvc.showFilters.includes('U')) {
        q.Visible = true;
      }

      // evaluate other features
      if (filterSvc.showFilters.includes('C') && q.Comment && q.Comment.length > 0) {
        q.Visible = true;
      }

      if (filterSvc.showFilters.includes('FB') && q.Feedback && q.Feedback.length > 0) {
        q.Visible = true;
      }

      if (filterSvc.showFilters.includes('M') && q.MarkForReview) {
        q.Visible = true;
      }

      if (filterSvc.showFilters.includes('D') && q.HasDiscovery) {
        q.Visible = true;
      }

      // non-ACET maturity level filtering

      // const targetLevel = this.assessmentSvc.assessment ?
      //   this.assessmentSvc.assessment.MaturityModel?.MaturityTargetLevel :
      //   10;

      // if (filterSvc.showFilters.includes('MT') && q.MaturityLevel <= targetLevel) {
      //   q.Visible = true;
      // }

      // // if the 'show above target' filter is turned off, hide the question
      // // if it is above the target level
      // if (!filterSvc.showFilters.includes('MT+') && q.MaturityLevel > targetLevel) {
      //   q.Visible = false;
      // }

      // If maturity filters are engaged (ACET standard) then they can override what would otherwise be visible
      // if (g.GroupingType == "Domain") {
      //   const filter = this.domainFilters.find(f => f.DomainName == c.DomainName);
      //   if (!!filter && filter.Settings.find(s => s.Level == q.MaturityLevel && s.Value == false)) {
      //     q.Visible = false;
      //   }
      // }

      // evaluate subcat visiblity
      g.Visible = (!!g.Questions.find(q => q.Visible));
    });


    // now dig down another level to see if there are questions
    g.SubGroupings.forEach((sg: QuestionGrouping) => {
      this.recurseQuestions(sg);
    });
  }


  //------------------ API requests ------------------

  /**
   * 
   */
  getACETDomains() {
    return this.http.get(this.configSvc.apiUrl + 'ACETDomains');
  }

  /**
   * 
   */
  getFilters() {
    return this.http.get(this.configSvc.apiUrl + 'GetAcetFilters');
  }

  /**
   * Sets a bit ('val') for the domain and level.  The bit indicates if the fiter is
   * on or of.
   */
  saveFilter(domainName: string, level: number, val: any) {
    const setting = { DomainName: domainName, Level: level, Value: val };
    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilter', setting, headers);
  }

  /**
   * Sets the state of a group of filters.  
   */
  saveFilters(filters: ACETFilter[]) {
    return this.http.post(this.configSvc.apiUrl + 'SaveAcetFilters', filters, headers);
  }
}
