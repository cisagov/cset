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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
// tslint:disable-next-line:max-line-length
import { Answer, DefaultParameter, ParameterForAnswer, Domain, QuestionGroup, SubCategoryAnswers, ACETDomain, QuestionResponse, SubCategory, Question } from '../models/questions.model';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { AcetFiltersService, ACETFilter } from './acet-filters.service';




const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class QuestionsService {
  

  /**
   * Filter settings
   *   Comments - C
   *   Marked For Review - M
   *   Discoveries (Observations) - D
   */
  public showFilters: string[] = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'D', 'FB'];

  // Valid 'answer'-type filter values
  public answerValues: string[] = ['Y', 'N', 'NA', 'A', 'U'];

  // The allowable filter values.  Used for "select all"
  readonly allowableFilters = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'D', 'FB'];

  public searchString = '';

  public overallIRP: number;

  /**
   * Tracks the maturity filter settings across all domains
   */
  public domainMatFilters: Map<string, Map<string, boolean>>;


  /**
   * Persists the current selection of the 'auto load supplemental' preference.
   */
  autoLoadSupplementalSetting: boolean;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessmentSvc: AssessmentService,
    private filterSvc: AcetFiltersService

  ) {
    this.autoLoadSupplementalSetting = (this.configSvc.config.supplementalAutoloadInitialValue || false);
  }

  /**
   * The page can store its model here for accessibility by question-extras
   */
  domains = null;

  /**
   * A reference to the current question list.
   */
  questions: QuestionResponse = null;

  /**
   * Sets the starting value of the maturity filters, based on the 'stairstep.'
   * Any 'empty' values below the bottom of the band are set as well.
   */
  initializeMatFilters(irp: number) {
    this.overallIRP = irp;

    // if we have an IRP, default the maturity filters based on the stairstep.


    // this.domainMatFilters = new Map<string, Map<string, boolean>>();
    this.domainMatFilters = new Map();


    // if we don't have domain names in this array of questions, there's no maturity filters to worry about
    if (!this.domains){
      return;
    } 
    else if(!this.domains[0] || !this.domains[0].DomainName) {
      return;
    }

    this.filterSvc.getFilters().subscribe((x: ACETFilter[]) => {
      // set the filters based on the bands
      if ((x === undefined) || (x.length === 0)) {
        this.getDefaultBand(irp);
        if ((x === undefined) || (x.length === 0)) {
          this.filterSvc.saveFilters(this.domainMatFilters).subscribe();
        }
      } else {
        for (const entry of x) {
          const tmpMap = new Map();
          this.domainMatFilters.set(entry.DomainName, tmpMap);
          tmpMap.set('B', entry.B);
          tmpMap.set('E', entry.E);
          tmpMap.set('Int', entry.Int);
          tmpMap.set('A', entry.A);
          tmpMap.set('Inn', entry.Inn);
        }
      }
      this.evaluateFilters(this.domains);
    });
  }

  resetBandS(irp: number) {
    this.filterSvc.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;
      this.domainMatFilters = new Map();
      this.getDefaultBand(irp);
      this.filterSvc.saveFilters(this.domainMatFilters).subscribe();
    });
  }

  getDefaultBand(irp: number) {
    const bands = this.getStairstepOrig(irp);
    const dmf = this.domainMatFilters;

    this.domains.forEach((d: Domain) => {
      dmf.set(d.DomainName, new Map());
      dmf.get(d.DomainName).set('B', bands.includes('B'));
      dmf.get(d.DomainName).set('E', bands.includes('E'));
      dmf.get(d.DomainName).set('Int', bands.includes('Int'));
      dmf.get(d.DomainName).set('A', bands.includes('A'));
      dmf.get(d.DomainName).set('Inn', bands.includes('Inn'));

      // bottom fill
      let belowBand = true;
      const i = this.domainMatFilters.get(d.DomainName).entries();
      let e = i.next();
      while (!e.done && belowBand) {
        if (e.value[1]) {
          belowBand = false;
        } else {
          dmf.get(d.DomainName).set(e.value[0], true);
        }
        e = i.next();
      }
    });
  }
  /**
   * Sets the application mode of the assessment.
   */
  setMode(mode: string) {
    return this.http.post(this.configSvc.apiUrl + 'setmode?mode=' + mode, headers);
  }

  /**
   * Retrieves the list of questions.
   */
  getQuestionsList() {
    return this.http.post(this.configSvc.apiUrl + 'questionlist', '*', headers);
  }

  getQuestionListOverridesOnly() {
    return this.http.post(this.configSvc.apiUrl + 'QuestionListComponentOverridesOnly', '*', headers);
  }
  /**
   * Posts an Answer to the API.
   * @param answer
   */
  storeAnswer(answer: Answer) {
    return this.http.post(this.configSvc.apiUrl + 'answerquestion', answer, headers);
  }

  /**
   * Posts a block of answers to the API.
   */
  storeSubCategoryAnswers(answers: SubCategoryAnswers) {
    return this.http.post(this.configSvc.apiUrl + 'answersubcategory', answers, headers);
  }

  /**
   * Retrieves the extra detail content for the question.
   * @param questionId
   */
  getDetails(questionId: number, IsComponent: boolean): any {
    return this.http.post(this.configSvc.apiUrl
      + 'details?questionid=' + questionId
      + '&&IsComponent=' + IsComponent
    , headers);
  }

  /**
   * Renames a document.
   */
  renameDocument(id: number, title: string) {
    return this.http.post(this.configSvc.apiUrl + 'renamedocument?id=' + id + '&title=' + title, headers);
  }

  /**
   * Deletes a document.
   * @param id
   */
  deleteDocument(id: number, answerId: number) {
    return this.http.post(this.configSvc.apiUrl + 'deletedocument?id=' + id + "&answerId=" + answerId, headers);
  }

  getQuestionsForDocument(id: number) {
    return this.http.get(this.configSvc.apiUrl + 'questionsfordocument?id=' + id, headers);
  }


  /**
   * Returns true if we have any inclusion filters turned off.
   */
  isFilterEngaged() {
    return (this.allowableFilters.length !== this.showFilters.length)
      || this.searchString.length > 0;
  }


  /**
   * Sets the Visible property on all Questions, Subcategories and QuestionGroups
   * based on the current filter settings.
   * @param cats
   */
  public evaluateFilters(domains: Domain[]) {
    if (!domains) {
      return;
    }

    domains.forEach(d => {
      d.QuestionGroups.forEach(c => {
        c.SubCategories.forEach(s => {
          s.Questions.forEach(q => {
            // start with false, then set true if possible
            q.Visible = false;

            // If search string is specified, any questions that don't contain the string
            // are not shown.  No need to check anything else.
            if (this.searchString.length > 0
              && q.QuestionText.indexOf(this.searchString) < 0) {
              return;
            }

            // evaluate answers
            if (this.answerValues.includes(q.Answer) && this.showFilters.includes(q.Answer)) {
              q.Visible = true;
            }

            // consider null answers as 'U'
            if (q.Answer == null && this.showFilters.includes('U')) {
              q.Visible = true;
            }

            // evaluate other features
            if (this.showFilters.includes('C') && q.Comment && q.Comment.length > 0) {
              q.Visible = true;
            }

            if (this.showFilters.includes('FB') && q.Feedback && q.Feedback.length > 0) {
              q.Visible = true;
            }

            if (this.showFilters.includes('M') && q.MarkForReview) {
              q.Visible = true;
            }

            if (this.showFilters.includes('D') && q.HasDiscovery) {
              q.Visible = true;
            }

            // If maturity filters are engaged (ACET standard) then they can override what would otherwise be visible
            if (!!c.DomainName && !!this.domainMatFilters.get(c.DomainName)) {
              if (this.domainMatFilters.get(c.DomainName).get(q.MaturityLevel) === false) {
                q.Visible = false;
              }
            }
          });

          /// now evaluate subcat visiblity
          s.Visible = (!!s.Questions.find(q => q.Visible));
        });

        // evaluate category heading visibility
        c.Visible = (!!c.SubCategories.find(s => s.Visible));
      });
    });
  }


  /**
   * Indicates if the specified answer filter is currently 'on'
   * @param ans
   */
  filterOn(ans: string) {
    if (ans === 'ALL') {
      if (this.arraysAreEqual(this.showFilters, this.allowableFilters)) {
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
   * Returns true if no maturity filters are enabled.
   * This is used primarily to ngif the 'all filters are off' message.
   */
  maturityFiltersAllOff(domainName: string) {
    // If not ACET (no domain name), return false
    if (!domainName || domainName.length === 0 || !this.domainMatFilters.get(domainName)) {
      return false;
    }

    const i = this.domainMatFilters.get(domainName).entries();
    let e = i.next();
    while (!e.done) {
      if (e.value[1]) {
        return false;
      }
      e = i.next();
    }

    return true;
  }


  getDefaultParametersForAssessment() {
    return this.http.get(this.configSvc.apiUrl + 'ParametersForAssessment', headers);
  }

  /**
   * Stores an assessment-specific (global) parameter value override.
   */
  storeAssessmentParameter(p: DefaultParameter) {
    return this.http.post(this.configSvc.apiUrl + 'SaveAssessmentParameter',
      {
        Id: p.ParameterId,
        Token: p.ParameterName,
        Substitution: p.ParameterValue
      },
      headers);
  }


  /**
   *
   */
  isDefaultMatLevel(mat: string) {
    return this.getStairstepOrig(this.overallIRP).includes(mat);
  }


  /**
   * Indicates whether a certain filter is set to 'on'
   */
  isDomainMatFilterSet(domainName: string, mat: string) {
    if (!this.domainMatFilters.get(domainName)) {
      return false;
    }

    return this.domainMatFilters.get(domainName).get(mat);
  }

  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the stairstep graph in the NCUA Guide.
   */
  getStairstepOrig(irp: number): string[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return ['B', 'E'];
      case 2:
        return ['B', 'E', 'Int'];
      case 3:
        return ['E', 'Int', 'A'];
      case 4:
        return ['Int', 'A', 'Inn'];
      case 5:
        return ['A', 'Inn'];
    }
  }

  /**
   * Returns the maturity levels applicable to the overall IRP,
   * based on the proposed 'grounded' stairstep graph.
   */
  getStairstepNew(irp: number): string[] {
    switch (irp) {
      case 0:
        return [];
      case 1:
        return ['B'];
      case 2:
        return ['B', 'E'];
      case 3:
        return ['B', 'E', 'Int'];
      case 4:
        return ['B', 'E', 'Int', 'A'];
      case 5:
        return ['B', 'E', 'Int', 'A', 'Inn'];
    }
  }

  /**
   * Stores an answer-specific (in-line) parameter value override.
   * @param answerParm
   */
  storeAnswerParameter(answerParm: ParameterForAnswer) {
    return this.http.post(this.configSvc.apiUrl + 'SaveAnswerParameter',
      {
        RequirementId: answerParm.RequirementId,
        Id: answerParm.ParameterId,
        AnswerId: answerParm.AnswerId,
        Substitution: answerParm.ParameterValue
      },
      headers);
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
   *
   */
  getOverrideQuestions(questionId, Component_Symbol_Id) {
    let params = new HttpParams();
    params = params.append('question_id', questionId);
    params = params.append('Component_Symbol_Id', Component_Symbol_Id);
    return this.http.get(this.configSvc.apiUrl + 'GetOverrideQuestions', { params: params });
  }

  /**
   * Finds the question in the master collection and updates its answer.
   * This function was built specifically for Component Overrides,
   * so it's currently limited to those.  But it could be expanded if there was
   * a general need to update answers anywhre in the master structure.
   */
  setAnswerInQuestionList(questionId: number, answerId: number, answerText: string) {
    this.questions.QuestionGroups.forEach((group: QuestionGroup) => {
      if (group.StandardShortName === 'Component Overrides') {
        group.SubCategories.forEach((sc: SubCategory) => {
          sc.Questions.forEach((q: Question) => {
            if (q.QuestionId === questionId && q.Answer_Id === answerId) {
              q.Answer = answerText;
            }
          });
        });
      }
    });
  }
}
