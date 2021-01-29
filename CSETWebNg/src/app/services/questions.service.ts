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
import { Answer, DefaultParameter, ParameterForAnswer, Domain, Category, SubCategoryAnswers, QuestionResponse, SubCategory, Question } from '../models/questions.model';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { QuestionFilterService } from './question-filter.service';
import { MaturityFiltersService } from './MaturityFiltering/maturity-filters.service';

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
    private questionFilterSvc: QuestionFilterService
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
