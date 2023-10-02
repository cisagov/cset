////////////////////////////////
//
//   Copyright 2023 Battelle Energy Alliance, LLC
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
// eslint-disable-next-line max-len
import { Answer, DefaultParameter, ParameterForAnswer, Domain, Category, SubCategoryAnswers, QuestionResponse, SubCategory, Question } from '../models/questions.model';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { QuestionFilterService } from './filtering/question-filter.service';
import { BehaviorSubject, Observable } from 'rxjs';
import { TranslocoService } from '@ngneat/transloco';
import { ACETService } from './acet.service';

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
   * Contains the state of the "Auto-load Supplemental" checkbox on the
   * Standard Questions screen.
   */
  public autoLoadSuppCheckboxState = false;


  /**
   *
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private tSvc: TranslocoService,
    private assessmentSvc: AssessmentService,
    private questionFilterSvc: QuestionFilterService
  ) {  }

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
    return this.http.get(this.configSvc.apiUrl + 'questionlist', headers);
  }

  /**
   *
   */
  getComponentQuestionsList() {
    return this.http.get(this.configSvc.apiUrl + 'componentquestionlist', headers);
  }

  /**
   *
   */
  getQuestionListOverridesOnly() {
    return this.http.get(this.configSvc.apiUrl + 'QuestionListComponentOverridesOnly', headers);
  }

  /**
   * Grab all the child question's answers for a specific parent question.
   * Currently set up for use in an ISE assessment.
  */
  getChildAnswers(parentId: number, assessId: number) {
    headers.params = headers.params.set('parentId', parentId).set('assessId', assessId);
    return this.http.get(this.configSvc.apiUrl + 'GetChildAnswers', headers);
  }

  /**
   * Grab all the child question's answers for a specific parent question.
   * Currently set up for use in an ISE assessment.
  */
  getActionItems(parentId: number, finding_id: number) {
    headers.params = headers.params.set('parentId', parentId);
    return this.http.get(this.configSvc.apiUrl + 'GetActionItems?finding_id=' + finding_id, headers);
  }

  /**
   * Analyzes the current 'auto load supplemental' preference and the maturity model
   */
  autoLoadSupplemental(modelId?: number) {
    // first see if it should be forced on by configuration
    if (this.configSvc.config.supplementalAutoloadInitialValue) {
      return true;
    }

    // standards (modelid is null) - check the checkbox state
    if (!modelId) {
      return this.autoLoadSuppCheckboxState;
    }

    // CPG - auto load supplemental
    if (modelId == 11) {
      return true;
    }

    return false;
  }

  /**
   * Posts an Answer to the API.
   * @param answer
   */
  storeAnswer(answer: Answer) {
    answer.questionType = localStorage.getItem('questionSet');
    return this.http.post(this.configSvc.apiUrl + 'answerquestion', answer, headers);
  }

  /**
   * Posts multiple (all) Answers to the API.
   * @param answers
   */
  storeAllAnswers(answers: Answer[]) {
    return this.http.post(this.configSvc.apiUrl + 'storeAllAnswers', answers, headers);
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
  getDetails(questionId: number, questionType: string): any {
    return this.http.post(this.configSvc.apiUrl
      + 'details?questionid=' + questionId
      + '&&questionType=' + questionType
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
  deleteDocument(id: number, questionId: number) {
    return this.http.post(this.configSvc.apiUrl + 'deletedocument?id=' + id + "&questionId=" + questionId + "&assessId=" + localStorage.getItem('assessmentId'), headers);
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
        id: p.parameterId,
        token: p.parameterName,
        substitution: p.parameterValue
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
        requirementId: answerParm.requirementId,
        id: answerParm.parameterId,
        answerId: answerParm.answerId,
        substitution: answerParm.parameterValue
      },
      headers);
  }

  /**
   *
   */
  getSubGroupingQuestionCount(subGroups: string[], modelId: number) {
    return this.http.get(this.configSvc.apiUrl + 'SubGroupingQuestionCount?subGroups=' +
      subGroups + '&modelId=' + modelId, headers);
  }

  /**
   *
   */
  getAllSubGroupingQuestionCount(modelId: number, groupLevel: number) {
    return this.http.get(this.configSvc.apiUrl + 'AllSubGroupingQuestionCount?modelId=' + modelId +
    '&groupLevel=' + groupLevel, headers);
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
    this.questions.categories.forEach((group: Category) => {
      if (group.standardShortName === 'Component Overrides') {
        group.subCategories.forEach((sc: SubCategory) => {
          sc.questions.forEach((q: Question) => {
            if (q.questionId === questionId && q.answer_Id === answerId) {
              q.answer = answerText;
            }
          });
        });
      }
    });
  }

  /**
   * Save the answer with the Marked for Review flag flipped.
   */
  saveMFR(q: Question) {
    q.markForReview = !q.markForReview;

    const newAnswer: Answer = {
      answerId: q.answer_Id,
      questionId: q.questionId,
      questionType: q.questionType,
      questionNumber: q.displayNumber,
      answerText: q.answer,
      altAnswerText: q.altAnswerText,
      comment: q.comment,
      feedback: q.feedback,
      markForReview: q.markForReview,
      freeResponseAnswer: q.freeResponseAnswer,
      reviewed: q.reviewed,
      is_Component: q.is_Component,
      is_Requirement: q.is_Requirement,
      is_Maturity: q.is_Maturity,
      componentGuid: q.componentGuid
    };

    this.storeAnswer(newAnswer).subscribe();
  }

  /**
   * The service can emit the question extras object that is given to it.
   * This was originally built to broadcast changes to documents/artifacts
   * but could be expanded for other changes as well.
   */
  extrasChanged$: BehaviorSubject<number> = new BehaviorSubject(0);
  broadcastExtras(qe: any) {
    this.extrasChanged$.next(qe);
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


  /**
   * Finds the button definition and return its CSS
   */
  answerOptionCss(modelName: string, answerCode: string) {
    return this.findAnsDefinition(modelName, answerCode).buttonCss;
  }

  /**
   * Finds the button definition and returns its label
   */
  answerButtonLabel(modelName: string, answerCode: string): string {
    return this.findAnsDefinition(modelName, answerCode).buttonLabel;
  }

  /**
   * Finds the button definition and returns its tooltip, if defined.
   * If a tooltip is not defined, the button label is returned.
   */
  answerButtonTooltip(modelName: string, answerCode: string): string {
    var t = this.findAnsDefinition(modelName, answerCode);
      if (!!t.buttonTooltip) {
        return t.buttonTooltip;
      }
      return t.buttonLabel;
  }

  /**
   * Finds the button definition and returns its full label (tooltip)
   */
  answerDisplayLabel(modelName: string, answerCode: string) {
    const def = this.findAnsDefinition(modelName, answerCode);
    if (!def) {
      console.log('cannot find definition for model: ' + modelName + ', answerCode: ' + answerCode);
      return "?";
    }
    return def.answerLabel;
  }

  /**
   * Finds the button definition and returns its code for use in transloco translating
   */
  answerButtonLabelTransloco(modelName: string, answerCode: string) {
    if (modelName == 'ACET' && answerCode == 'A') {
      return answerCode + '-ACET';
    }

    return answerCode;
  }

  /**
   * Finds the answer in the default object or the model-specific object.
   * Standards questions screen pass '0' for the modelId.
   */
  findAnsDefinition(modelName: string, answerCode: string) {

    let ans = null;

    // assume unanswered if null or undefined
    if (!answerCode) {
      answerCode = 'U';
    }

    // look for model-specific answer options
    if (!!modelName && modelName.length > 0 && modelName.trim().length > 0) {
      let model = this.configSvc.config.moduleBehaviors.find(x => x.moduleName == modelName);

      if (!!model) {
        
        // first look for a skin-specific answer option
        ans = model.answerOptions?.find(o => o.code == answerCode && o.skin == this.configSvc.installationMode);
        if (ans) {
          return ans;
        }
        
        // or the general version of the answer option for the model
        ans = model.answerOptions?.find(o => o.code == answerCode && !o.skin);
        if (ans) {
          return ans;
        }
      }
    }
    
    // fallback to default options for standard-based or model-based
    ans = this.configSvc.config.answerOptionsDefault.find(x => x.code == answerCode);    
    if (ans) {
      return ans;
    }

    return answerCode;
  }

  /**
   * Eager loading to get language loaded up front
   * @param transloco 
   * @returns 
   */
  loadLoco(lang: string): Promise<void> {
    return new Promise<void>(() => {
      console.log(`loadLoco: ${lang}`);
      this.tSvc.setActiveLang(lang);
      this.tSvc.load(lang);
    });
  }

  /**
   * Finds the answer in the default object or the model-specific object.
   * Standards questions screen pass '0' for the modelId.
   */
  findAnsDefinitionTransloco(modelName: string, answerCode: string) {
    // assume unanswered if null or undefined
    if (!answerCode) {
      answerCode = 'U';
    }
    let ans = '';
    // first look for a skin-specific label set
    // let ans = this.answerButtonDefs.find(x => x.skin == this.configSvc.installationMode
    //   && x.moduleName == modelName)?.answers.find(y => y.code == answerCode);
    // if (ans) {
    //   return ans;
    // }

    // next, look for a model-specific label set with no skin defined
    let model = this.configSvc.config.moduleBehaviors.find(x => x.moduleName == modelName);
    if (!!model) {
      ans = model.answerOptions?.find(o => o.code == answerCode);
      if (ans) {
        return answerCode + '-' + modelName;
      }
    }

    // fallback to default options
    ans = this.configSvc.config.answerOptionsDefault.find(x => x.code == answerCode);    
    if (ans) {
      return answerCode;
    }

    return answerCode;
  }

}
