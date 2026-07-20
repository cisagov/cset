////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
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
import {
  Answer,
  AnswerQuestionResponse,
  Category,
  DefaultParameter,
  ParameterForAnswer,
  Question,
  QuestionResponse,
  SubCategory,
  SubCategoryAnswers
} from '../models/questions.model';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import {
  BehaviorSubject,
  firstValueFrom,
  Observable,
  Subject
} from 'rxjs';
import { TranslocoService } from '@jsverse/transloco';
import { LinebreakPipe } from '../helpers/linebreak.pipe';
import { tap } from 'rxjs/operators';

const headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

interface CompletionCountResponse {
  completedCount?: number;
  totalMaturityQuestionsCount?: number;
  totalDiagramQuestionsCount?: number;
  totalStandardQuestionsCount?: number;
}

@Injectable()
export class QuestionsService {

  public questionOverrideSubject =
    new BehaviorSubject<boolean>(false);

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
   * Components override update subject
   */
  private componentOverrideEventSubject = new Subject<any>();
  componentOverrideEvent$ =
    this.componentOverrideEventSubject.asObservable();

  /**
   * The tail of each answer's save queue.
   *
   * Saves for different questions can run concurrently, while saves for the
   * same answer identity are executed in the order they were submitted.
   */
  private answerSaveQueues = new Map<string, Promise<void>>();

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private tSvc: TranslocoService,
    public linebreakPipe: LinebreakPipe,
    private assessSvc: AssessmentService
  ) { }

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
    return this.http.post(
      this.configSvc.apiUrl + 'setmode?mode=' + mode,
      headers
    ).pipe(
      tap((response: any) => {
        this.publishCompletionCounts(response);
      })
    );
  }

  /**
   * Retrieves the list of questions.
   */
  getQuestionsList() {
    return this.http.get(
      this.configSvc.apiUrl + 'questionlist',
      headers
    );
  }

  getComponentQuestionsList(): Observable<QuestionResponse> {
    return this.http.get<QuestionResponse>(
      this.configSvc.apiUrl + 'componentquestionlist',
      headers
    );
  }

  getQuestionListOverridesOnly() {
    return this.http.get(
      this.configSvc.apiUrl + 'QuestionListComponentOverridesOnly',
      headers
    );
  }

  /**
   * Gets all child-question answers for a parent question.
   */
  getChildAnswers(parentId: number) {
    const options = {
      ...headers,
      params: headers.params.set('parentId', parentId)
    };

    return this.http.get(
      this.configSvc.apiUrl + 'GetChildAnswers',
      options
    );
  }

  /**
   * Determines whether supplemental content should load automatically.
   */
  autoLoadSupplemental(modelId?: any) {
    if (this.configSvc.config.supplementalAutoloadInitialValue) {
      return true;
    }

    const moduleBehavior =
      this.configSvc.getModuleBehavior(modelId);

    if (!moduleBehavior) {
      return this.autoLoadSuppCheckboxState;
    }

    return moduleBehavior.autoLoadSupplemental ?? false;
  }

  /**
   * Queues an answer for persistence.
   *
   * Calls for the same answer identity are serialized. This prevents an older
   * extras request from completing after a newer answer-value request and
   * overwriting the newer value.
   */
  storeAnswer(
    answer: Answer
  ): Observable<AnswerQuestionResponse> {

    // All Answer properties are primitives, so a shallow copy is sufficient.
    // The snapshot prevents later UI mutations from changing a queued request.
    const snapshot: Answer = { ...answer };
    const queueKey = this.buildAnswerQueueKey(snapshot);

    return new Observable<AnswerQuestionResponse>(subscriber => {
      const previousTail =
        this.answerSaveQueues.get(queueKey) ?? Promise.resolve();

      let currentTail: Promise<void>;

      currentTail = previousTail
        // A failed save must not permanently block later saves.
        .catch(() => undefined)
        .then(async () => {
          try {
            const response = await firstValueFrom(
              this.postAnswer(snapshot)
            );

            if (!subscriber.closed) {
              subscriber.next(response);
              subscriber.complete();
            }
          } catch (error) {
            if (!subscriber.closed) {
              subscriber.error(error);
            }
          }
        })
        .finally(() => {
          // Only the current tail may remove this queue. A newer request may
          // already have replaced it.
          if (this.answerSaveQueues.get(queueKey) === currentTail) {
            this.answerSaveQueues.delete(queueKey);
          }
        });

      this.answerSaveQueues.set(queueKey, currentTail);
    });
  }

  /**
   * Performs the actual HTTP request after the queued request reaches the
   * front of its answer-specific queue.
   */
  private postAnswer(
    answer: Answer
  ): Observable<AnswerQuestionResponse> {

    return this.http.post<AnswerQuestionResponse>(
      this.configSvc.apiUrl + 'answerquestion',
      answer,
      headers
    ).pipe(
      tap((response: AnswerQuestionResponse) => {
        this.publishCompletionCounts(response);
      })
    );
  }

  /**
   * Builds the natural identity used for client-side save ordering.
   *
   * Assessment ID is included because this service can remain alive while
   * navigating between assessments.
   */
  private buildAnswerQueueKey(answer: Answer): string {
    return [
      this.assessSvc.id() ?? '',
      answer.questionType?.trim() ?? '',
      answer.questionId,
      answer.componentGuid ?? '',
      answer.optionId ?? ''
    ].join('|');
  }

  /**
   * Publishes completion-count changes returned by answer endpoints.
   */
  private publishCompletionCounts(response: CompletionCountResponse): void {
    if (response?.completedCount === undefined) {
      return;
    }

    const totalCount =
      (response.totalMaturityQuestionsCount || 0) +
      (response.totalDiagramQuestionsCount || 0) +
      (response.totalStandardQuestionsCount || 0);

    this.assessSvc.completionRefreshRequested$.next({
      completedCount: response.completedCount,
      totalCount
    });
  }

  /**
   * Posts a block of answers to the API.
   */
  storeSubCategoryAnswers(
    answers: SubCategoryAnswers
  ): Observable<CompletionCountResponse> {
    // Snapshot the request because the same answer objects may continue to be
    // edited while this save is waiting for earlier requests to finish.
    const snapshot: SubCategoryAnswers = {
      ...answers,
      answers: (answers.answers ?? []).map(answer => ({ ...answer }))
    };

    const queueKeys = Array.from(new Set(
      snapshot.answers.map(answer => this.buildAnswerQueueKey(answer))
    )).sort();

    // A subcategory with no answer rows still needs its own serialization key.
    if (queueKeys.length === 0) {
      queueKeys.push([
        'subcategory',
        this.assessSvc.id() ?? '',
        snapshot.groupHeadingId,
        snapshot.subCategoryId
      ].join('|'));
    }

    return new Observable<CompletionCountResponse>(subscriber => {
      // Capture every current tail before publishing this request as the next
      // tail for all affected answers. Later individual saves will then wait
      // until the complete subcategory save finishes.
      const previousTails = queueKeys.map(queueKey =>
        this.answerSaveQueues.get(queueKey) ?? Promise.resolve()
      );

      let currentTail: Promise<void>;

      currentTail = Promise.all(
        previousTails.map(previousTail =>
          previousTail.catch(() => undefined)
        )
      )
        .then(async () => {
          try {
            const response = await firstValueFrom(
              this.postSubCategoryAnswers(snapshot)
            );

            if (!subscriber.closed) {
              subscriber.next(response);
              subscriber.complete();
            }
          } catch (error) {
            if (!subscriber.closed) {
              subscriber.error(error);
            }
          }
        })
        .finally(() => {
          queueKeys.forEach(queueKey => {
            if (this.answerSaveQueues.get(queueKey) === currentTail) {
              this.answerSaveQueues.delete(queueKey);
            }
          });
        });

      queueKeys.forEach(queueKey => {
        this.answerSaveQueues.set(queueKey, currentTail);
      });
    });
  }

  /**
   * Performs the subcategory HTTP request after all affected answer queues
   * have reached this request.
   */
  private postSubCategoryAnswers(
    answers: SubCategoryAnswers
  ): Observable<CompletionCountResponse> {
    return this.http.post(
      this.configSvc.apiUrl + 'answersubcategory',
      answers,
      headers
    ).pipe(
      tap((response: CompletionCountResponse) => {
        this.publishCompletionCounts(response);
      })
    );
  }

  /**
   * Retrieves extra detail content for a question.
   */
  getDetails(
    questionId: number,
    questionType: string
  ): any {
    return this.http.post(
      this.configSvc.apiUrl
      + 'details?questionid=' + questionId
      + '&&questionType=' + questionType,
      headers
    );
  }

  /**
   * Renames a document.
   */
  renameDocument(id: number, title: string) {
    return this.http.post(
      this.configSvc.apiUrl
      + 'renamedocument?id=' + id
      + '&title=' + title,
      headers
    );
  }

  toggleShared(id: number, isShared: boolean) {
    return this.http.post(
      this.configSvc.apiUrl
      + 'doc/toggleshared?id=' + id
      + '&isShared=' + isShared,
      headers
    );
  }

  /**
   * Deletes a document.
   */
  deleteDocument(id: number, questionId: number) {
    return this.http.post(
      this.configSvc.apiUrl
      + 'deletedocument?id=' + id
      + '&questionId=' + questionId,
      headers
    );
  }

  getQuestionsForDocument(id: number) {
    return this.http.get(
      this.configSvc.apiUrl
      + 'questionsfordocument?id=' + id,
      headers
    );
  }

  getDefaultParametersForAssessment() {
    return this.http.get(
      this.configSvc.apiUrl + 'ParametersForAssessment',
      headers
    );
  }

  /**
   * Stores an assessment-wide parameter override.
   */
  storeAssessmentParameter(p: DefaultParameter) {
    return this.http.post(
      this.configSvc.apiUrl + 'SaveAssessmentParameter',
      {
        id: p.parameterId,
        token: p.parameterName,
        substitution: p.parameterValue
      },
      headers
    );
  }

  /**
   * Stores an answer-specific parameter override.
   */
  storeAnswerParameter(answerParm: ParameterForAnswer) {
    return this.http.post(
      this.configSvc.apiUrl + 'SaveAnswerParameter',
      {
        requirementId: answerParm.requirementId,
        id: answerParm.parameterId,
        answerId: answerParm.answerId,
        substitution: answerParm.parameterValue
      },
      headers
    );
  }

  getSubGroupingQuestionCount(
    subGroups: string[],
    modelId: number
  ) {
    return this.http.get(
      this.configSvc.apiUrl
      + 'SubGroupingQuestionCount?subGroups='
      + subGroups
      + '&modelId='
      + modelId,
      headers
    );
  }

  getOverrideQuestions(
    questionId: number,
    componentSymbolId: number
  ) {
    let params = new HttpParams();

    params = params.append(
      'question_id',
      questionId
    );

    params = params.append(
      'Component_Symbol_Id',
      componentSymbolId
    );

    return this.http.get(
      this.configSvc.apiUrl + 'GetOverrideQuestions',
      { params }
    );
  }

  /**
   * Updates an answer in the master Component Overrides structure.
   */
  setAnswerInQuestionList(
    questionId: number,
    answerId: number,
    answerText: string
  ) {
    this.questions.categories.forEach((group: Category) => {
      if (group.standardShortName !== 'Component Overrides') {
        return;
      }

      group.subCategories.forEach((sc: SubCategory) => {
        sc.questions.forEach((q: Question) => {
          if (
            q.questionId === questionId
            && q.answer_Id === answerId
          ) {
            q.answer = answerText;
          }
        });
      });
    });
  }

  /**
   * Saves an answer with its Marked for Review flag flipped.
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

    /*
     * This retains the existing fire-and-forget behavior. A stronger design
     * would return this Observable and let the component display or recover
     * from an error.
     */
    this.storeAnswer(newAnswer).subscribe({
      error: error => {
        q.markForReview = !q.markForReview;
        console.error(
          'Unable to save Marked for Review state.',
          error
        );
      }
    });
  }

  extrasChanged$: BehaviorSubject<number> =
    new BehaviorSubject(0);

  broadcastExtras(qe: any) {
    this.extrasChanged$.next(qe);
  }

  private detailsChangedSubject =
    new BehaviorSubject<number>(0);

  detailsChanged$ =
    this.detailsChangedSubject.asObservable();

  emitRefreshQuestionDetails(questionId: number) {
    this.detailsChangedSubject.next(questionId);
  }

  buildNavTargetID(target: any): string {
    if (!target) {
      return '';
    }

    if (target.hasOwnProperty('parent')) {
      return target.parent
        .toLowerCase()
        .replace(/ /g, '-')
        + '-'
        + target.categoryID;
    }

    return '';
  }

  answerOptionCss(
    modelName: string,
    answerCode: string
  ) {
    return this.findAnsDefinition(
      modelName,
      answerCode
    ).buttonCss;
  }

  answerButtonLabel(
    modelName: string,
    answerCode: string
  ): string {
    const definition = this.findAnsDefinition(
      modelName,
      answerCode
    );

    return this.tSvc.translate(
      'answer-options.button-labels.'
      + definition.buttonLabelKey.toLowerCase()
    );
  }

  answerButtonTooltip(
    modelName: string,
    answerCode: string
  ): string {
    const definition = this.findAnsDefinition(
      modelName,
      answerCode
    );

    return this.tSvc.translate(
      'answer-options.button-tooltips.'
      + definition.buttonLabelKey.toLowerCase()
    );
  }

  answerDisplayLabel(
    modelName: string,
    answerCode: string
  ) {
    const definition = this.findAnsDefinition(
      modelName,
      answerCode
    );

    return this.tSvc.translate(
      'answer-options.labels.'
      + definition.buttonLabelKey.toLowerCase()
    );
  }

  findAnsDefinition(
    model: string,
    answerCode: string
  ) {
    let answerDefinition;

    if (!answerCode) {
      answerCode = 'U';
    }

    if (model && String(model).trim().length > 0) {
      const moduleBehavior =
        this.configSvc.getModuleBehavior(model);

      if (moduleBehavior) {
        answerDefinition =
          moduleBehavior.answerOptions?.find(option =>
            option.code === answerCode
            && option.skin === this.configSvc.installationMode
          );

        if (answerDefinition) {
          return answerDefinition;
        }

        answerDefinition =
          moduleBehavior.answerOptions?.find(option =>
            option.code === answerCode
            && !option.skin
          );

        if (answerDefinition) {
          return answerDefinition;
        }
      }
    }

    answerDefinition =
      this.configSvc.config.answerOptionsDefault.find(
        option => option.code === answerCode
      );

    if (answerDefinition) {
      return answerDefinition;
    }

    return {
      buttonLabelKey: 'X',
      buttonCss: 'btn-yes'
    };
  }

  formatParameters(text: string) {
    return text
      .replace(/{{/g, '[<em>')
      .replace(/}}/g, '</em>]');
  }

  applyTokensToText(q: Question) {
    let text = q.questionText;

    if (!q.parmSubs) {
      return text;
    }

    q.parmSubs.sort((a, b) => {
      if (a.token.length > b.token.length) {
        return -1;
      }

      if (a.token.length < b.token.length) {
        return 1;
      }

      return 0;
    });

    q.parmSubs.forEach(token => {
      if (token.substitution == null) {
        text = this.replaceAll(
          text,
          `{{${token.token}}}`,
          '[<span class=\'sub-me fst-italic pid-'
          + token.id
          + '\'>'
          + token.token
          + '</span>]'
        );
      } else {
        text = this.replaceAll(
          text,
          `{{${token.token}}}`,
          '<span class=\'sub-me pid-'
          + token.id
          + '\'>'
          + token.substitution
          + '</span>'
        );
      }
    });

    return text;
  }

  replaceAll(
    original: string,
    search: string,
    replacement: string
  ) {
    search = search.replace(
      /[-\/\\^$*+?.()|[\]{}]/g,
      '\\$&'
    );

    return original.replace(
      new RegExp(search, 'gi'),
      replacement
    );
  }

  emitComponentOverrideEvent(data: any) {
    this.componentOverrideEventSubject.next(data);
  }
}
