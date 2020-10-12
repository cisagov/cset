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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
// tslint:disable-next-line:max-line-length
import { Answer, DefaultParameter, ParameterForAnswer, Domain, Category, SubCategoryAnswers, ACETDomain, QuestionResponse, SubCategory, Question } from '../models/questions.model';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { AcetFiltersService, ACETFilter } from './acet-filters.service';
import { QuestionFilterService } from './question-filter.service';




const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class QuestionsService {

  public overallIRP: number;

  /**
   * Tracks the maturity filter settings across all domains
   */
  public domainMatFilters: Map<string, Map<string, boolean>>;

  /**
   * The TOC might make the API trip to get the questions.  If so,
   * it will store the response here so that the Question screen
   * doesn't have to.
   */
  public questionList: QuestionResponse;

  /**
   * If the user selects a question from the TOC, but the Questions screen
   * is not loaded, stash the desired 'scroll to' here so that the
   * Questions screen will know where to scroll once it loads.
   */
  public scrollToTarget: any;

  /**
   * Persists the current selection of the 'auto load supplemental' preference.
   */
  autoLoadSupplementalSetting: boolean;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessmentSvc: AssessmentService,
    private acetFilterSvc: AcetFiltersService,
    private questionFilterSvc: QuestionFilterService

  ) {
    this.autoLoadSupplementalSetting = (this.configSvc.config.supplementalAutoloadInitialValue || false);
  }

  /**
   * The page can store its model here for accessibility by question-extras
   */
  domains = null;

  /**
   * A reference to the current maturity question list.
   */
  maturityQuestions: QuestionResponse = null;

  /**
   * A reference to the current standards question list.
   */
  questions: QuestionResponse = null;

  /**
   * A reference to the current component/diagram question list.
   */
  componentQuestions: QuestionResponse = null;

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
    if (!this.domains) {
      return;
    }
    else if (!this.domains[0] || !this.domains[0].DomainName) {
      return;
    }

    this.acetFilterSvc.getFilters().subscribe((x: ACETFilter[]) => {
      // set the filters based on the bands
      if ((x === undefined) || (x.length === 0)) {
        this.getDefaultBand(irp);
        if ((x === undefined) || (x.length === 0)) {
          this.acetFilterSvc.saveFilters(this.domainMatFilters).subscribe();
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
    this.acetFilterSvc.getACETDomains().subscribe((domains: ACETDomain) => {
      this.domains = domains;
      this.domainMatFilters = new Map();
      this.getDefaultBand(irp);
      this.acetFilterSvc.saveFilters(this.domainMatFilters).subscribe();
    });
  }

  getDefaultBand(irp: number) {
    const bands = this.getStairstepOrig(irp);
    const dmf = this.domainMatFilters;

    this.domains.forEach((d: Domain) => {
      dmf.set(d.DisplayText, new Map());
      dmf.get(d.DisplayText).set('B', bands.includes('B'));
      dmf.get(d.DisplayText).set('E', bands.includes('E'));
      dmf.get(d.DisplayText).set('Int', bands.includes('Int'));
      dmf.get(d.DisplayText).set('A', bands.includes('A'));
      dmf.get(d.DisplayText).set('Inn', bands.includes('Inn'));

      // bottom fill
      let belowBand = true;
      const i = this.domainMatFilters.get(d.DisplayText).entries();
      let e = i.next();
      while (!e.done && belowBand) {
        if (e.value[1]) {
          belowBand = false;
        } else {
          dmf.get(d.DisplayText).set(e.value[0], true);
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

  /**
   * 
   */
  getComponentQuestionsList() {
    return this.http.post(this.configSvc.apiUrl + 'componentquestionlist', '*', headers);
  }

  /**
   * 
   */
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
  getDetails(questionId: number, IsComponent: boolean, IsMaturity: boolean): any {
    return this.http.post(this.configSvc.apiUrl
      + 'details?questionid=' + questionId
      + '&&IsComponent=' + IsComponent
      + '&&IsMaturity=' + IsMaturity
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
   * Sets the Visible property on all Questions, Subcategories and Categories
   * based on the current filter settings.
   * @param cats
   */
  public evaluateFilters(domains: Domain[]) {
    if (!domains) {
      return;
    }

    const filter = this.questionFilterSvc;

    const filterStringLowerCase = filter.filterString.toLowerCase();

    domains.forEach(d => {
      d.Categories.forEach(c => {
        c.SubCategories.forEach(s => {
          s.Questions.forEach(q => {
            // start with false, then set true if possible
            q.Visible = false;

            // If search string is specified, any questions that don't contain the string
            // are not shown.  No need to check anything else.
            if (filter.filterString.length > 0
              && q.QuestionText.toLowerCase().indexOf(filterStringLowerCase) < 0) {
              return;
            }

            // evaluate answers
            if (filter.answerValues.includes(q.Answer) && filter.showFilters.includes(q.Answer)) {
              q.Visible = true;
            }

            // consider null answers as 'U'
            if (q.Answer == null && filter.showFilters.includes('U')) {
              q.Visible = true;
            }

            // evaluate other features
            if (filter.showFilters.includes('C') && q.Comment && q.Comment.length > 0) {
              q.Visible = true;
            }

            if (filter.showFilters.includes('FB') && q.Feedback && q.Feedback.length > 0) {
              q.Visible = true;
            }

            if (filter.showFilters.includes('M') && q.MarkForReview) {
              q.Visible = true;
            }

            if (filter.showFilters.includes('D') && q.HasDiscovery) {
              q.Visible = true;
            }

            // maturity level filtering
            const targetLevel = this.assessmentSvc.assessment ?
              this.assessmentSvc.assessment.MaturityTargetLevel :
              10;

            if (filter.showFilters.includes('MT') && q.MaturityLevel <= targetLevel) {
              q.Visible = true;
            }

            if (filter.showFilters.includes('MT+') && q.MaturityLevel > targetLevel) {
              q.Visible = true;
            }

            // If maturity filters are engaged (ACET standard) then they can override what would otherwise be visible
            if (!!c.DomainName && !!this.domainMatFilters.get(c.DomainName)) {
              if (this.domainMatFilters.get(c.DomainName).get(q.MaturityLevel.toString()) === false) {
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

      // evaluate domain heading visibility
      d.Visible = (!!d.Categories.find(c => c.Visible));
    });

  }

  /**
   * 
   */
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
    const stairstepOrig = this.getStairstepOrig(this.overallIRP);
    if (!!stairstepOrig) {
      return stairstepOrig.includes(mat);
    }
    return false;
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
   * Returns true if no maturity filters are enabled.
   * This is used primarily to ngif the 'all filters are off' message.
   */
  maturityFiltersAllOff(domainName: string) {
    // If not ACET (no domain name), return false
    if (!domainName || domainName.length === 0
      || !this.domainMatFilters || !this.domainMatFilters.get(domainName)) {
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
    this.questions.Domains.forEach((container: Domain) => {
      container.Categories.forEach((group: Category) => {
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
    });
  }


  /**
   * 
   */
  buildNavTargetID(target: any): string {
    if (!target) {
      return '';
    }
    if (target.hasOwnProperty('parent')) {
      return target.parent.toLowerCase().replace(/ /g, '-') + '-' + target.categoryID;
    }
    return '';
  }
}
