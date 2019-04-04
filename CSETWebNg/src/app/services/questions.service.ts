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
import { Answer, DefaultParameter, ParameterForAnswer, QuestionGroup, SubCategoryAnswers } from '../models/questions.model';
import { ConfigService } from './config.service';


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
  public showFilters: string[] = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'D'];

  // Valid 'answer'-type filter values
  public answerValues: string[] = ['Y', 'N', 'NA', 'A', 'U'];

  // The allowable filter values.  Used for "select all"
  readonly allowableFilters = ['Y', 'N', 'NA', 'A', 'U', 'C', 'M', 'D'];

  public searchString = '';


  /**
   * Persists the current selection of the 'auto load supplemental' preference.
   */
  autoLoadSupplementalSetting: boolean;

  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.autoLoadSupplementalSetting = (this.configSvc.config.supplementalAutoloadInitialValue || false);
  }

  /**
   * The page can store its model here for accessibility by question-extras
   */
  questionGroups = null;

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
  getDetails(questionId: number): any {
    return this.http.post(this.configSvc.apiUrl + 'details?questionid=' + questionId, headers);
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
  public evaluateFilters(cats: QuestionGroup[]) {
    if (!cats) {
      return;
    }

    cats.forEach(c => {
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

          if (this.showFilters.includes('M') && q.MarkForReview) {
            q.Visible = true;
          }

          if (this.showFilters.includes('D') && q.HasDiscovery) {
            q.Visible = true;
          }
        });

        /// now evaluate subcat visiblity
        s.Visible = (!!s.Questions.find(q => q.Visible));
      });

      // evaluate category heading visibility
      c.Visible = (!!c.SubCategories.find(s => s.Visible));
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
}
