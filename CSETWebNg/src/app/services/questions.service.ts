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
import { QuestionsAcetService } from './questions-acet.service';




const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable()
export class QuestionsService {



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
    private questionFilterSvc: QuestionFilterService,
    private questionsAcetSvc: QuestionsAcetService
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
   */
  deleteDocument(id: number, answerId: number) {
    return this.http.post(this.configSvc.apiUrl + 'deletedocument?id=' + id + "&answerId=" + answerId, headers);
  }

  /**
   * 
   */
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

    const filterSvc = this.questionFilterSvc;

    const filterStringLowerCase = filterSvc.filterString.toLowerCase();

    let categoryAccessControl = null;

    domains.forEach(d => {
      d.Categories.forEach(c => {
        c.SubCategories.forEach(s => {
          s.Questions.forEach(q => {
            // start with false, then set true if possible
            q.Visible = false;

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

            // maturity level filtering
            const targetLevel = this.assessmentSvc.assessment ?
              this.assessmentSvc.assessment.MaturityModel?.MaturityTargetLevel :
              10;

            if (filterSvc.showFilters.includes('MT') && q.MaturityLevel <= targetLevel) {
              q.Visible = true;
            }

            // if the 'show above target' filter is turned off, hide the question
            // if it is above the target level
            if (!filterSvc.showFilters.includes('MT+') && q.MaturityLevel > targetLevel) {
              q.Visible = false;
            }

            // If maturity filters are engaged (ACET standard) then they can override what would otherwise be visible
            if (!!c.DomainName && !!this.questionsAcetSvc.domainMatFilters.get(c.DomainName)) {
              if (this.questionsAcetSvc.domainMatFilters.get(c.DomainName).get(q.MaturityLevel.toString()) === false) {
                q.Visible = false;
              }
            }
          });

          // evaluate subcat visiblity
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
