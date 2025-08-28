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
import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { Question, QuestionGrouping, Answer, AnswerQuestionResponse } from '../../../models/questions.model';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';
import { GroupingDescriptionComponent } from '../grouping-description/grouping-description.component';
import { LayoutService } from '../../../services/layout.service';
import { CompletionService } from '../../../services/completion.service';
import { TranslocoService } from '@jsverse/transloco';


/**
 * This was cloned from question-block to start a new version that is
 * not so "subcategory-centric", mainly for the new simplified
 * maturity question display.  Hopefully this more generic version
 * of the question block can eventually replace the original.
 */
@Component({
  selector: 'app-question-block-maturity',
  templateUrl: './question-block-maturity.component.html',
  styleUrls: ['./question-block-maturity.component.scss'],
  standalone: false
})
export class QuestionBlockMaturityComponent implements OnInit {

  @Input() myGrouping: QuestionGrouping;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  private _timeoutId: NodeJS.Timeout;

  percentAnswered = 0;
  modelAnswerOptions: string[] = [];

  // tokenized placeholder for transloco, made this variable a switch between the different placeholders
  altTextPlaceholder = 'alt cset';
  showQuestionIds = false;

  maturityModelId: number;
  maturityModelName: string;


  /**
   * Constructor.
   * @param configSvc
   */
  constructor(
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public completionSvc: CompletionService,
    public assessSvc: AssessmentService,
    public layoutSvc: LayoutService,
    public tSvc: TranslocoService
  ) {

  }

  /**
   *
   */
  ngOnInit(): void {
    const maturityModel = this.assessSvc.assessment?.maturityModel;

    if (maturityModel?.modelName != null) {
      this.modelAnswerOptions = maturityModel.answerOptions;
      this.maturityModelId = maturityModel.modelId;
      this.maturityModelName = maturityModel.modelName;
    }

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    this.myGrouping.questions.map((item: Question) => {
      this.setJustificationVisibility(item);
    });

    this.showQuestionIds = this.configSvc.showQuestionAndRequirementIDs();
  }

  /**
   * Toggles the Expanded property of the question block.
   */
  toggleExpansion() {
    // dispatch a 'mouseleave' event to all child elements to clear
    // any displayed glossary definitions so that they don't get orphaned
    const evt = new MouseEvent('mouseleave');
    this.groupingDescription?.para.nativeElement.childNodes.forEach(n => {
      n.childNodes.forEach(n => n.dispatchEvent(evt));
    });

    this.myGrouping.expanded = !this.myGrouping.expanded;
  }

  /**
   * If there are no spaces in the question text assume it's a hex string
   * @param q
   */
  applyWordBreak(q: Question) {
    if (q.questionText.indexOf(' ') >= 0) {
      return 'normal';
    }
    return 'break-all';
  }

  /**
   * Determines if the level indicator should show or be
   * hidden.  Use config moduleBehavior to define this.
   */
  showLevelIndicator(q): boolean {
    const behavior = this.configSvc.getModuleBehavior(this.assessSvc.assessment?.maturityModel?.modelName);
    if (!!behavior) {
      return behavior.showMaturityLevelBadge ?? true;
    }

    return true;
  }

  /**
   *
   * @param ans
   */
  showThisOption(ans: string) {
    return true;
  }

  /**
   * Sets a flag on the question indicating whether the
   * "Justification" field (or 'alt text') should display
   */
  setJustificationVisibility(q: Question) {
    q.showJustificationField = false;

    if (this.maturityModelId == 25 && q.answer === 'NA') {
      // VADR (model 25) shows it when N/A is selected
      q.showJustificationField = true;
    } else if (q.answer === 'A') {
      // Other models show it when Alt is selected (if they support that option)
      q.showJustificationField = true;
    }
  }

  /**
   * Pushes an answer asynchronously to the API.
   * @param q
   * @param ans
   */
  storeAnswer(q: Question, newAnswerValue: string) {
    // if they clicked on the same answer that was previously set, "un-set" it
    if (q.answer === newAnswerValue) {
      newAnswerValue = 'U';
    }

    if (!!newAnswerValue) {
      q.answer = newAnswerValue;
    }

    const answer: Answer = {
      answerId: q.answer_Id,
      questionId: q.questionId,
      questionType: q.questionType,
      questionNumber: '0',
      answerText: q.answer,
      altAnswerText: q.altAnswerText,
      comment: q.comment,
      feedback: q.feedback,
      markForReview: q.markForReview,
      reviewed: q.reviewed,
      is_Component: q.is_Component,
      is_Requirement: q.is_Requirement,
      is_Maturity: q.is_Maturity,
      componentGuid: q.componentGuid
    };

    this.completionSvc.setAnswer(q.questionId, q.answer);

    this.setJustificationVisibility(q);

    this.refreshReviewIndicator();

    this.refreshPercentAnswered();

    this.questionsSvc.storeAnswer(answer).subscribe((response: AnswerQuestionResponse) => {
      q.answer_Id = response.answerId;
      if (response.detailsChanged) {
        this.questionsSvc.emitRefreshQuestionDetails(answer.questionId);
      }
    });
  }

  /**
   *
   */
  saveMFR(q) {
    this.questionsSvc.saveMFR(q);
    this.refreshReviewIndicator();
  }

  /**
   * Looks at all questions in the subcategory to see if any
   * are marked for review.
   * Also returns true if alt text is required but not supplied.
   */
  refreshReviewIndicator() {
    this.myGrouping.hasReviewItems = false;
    this.myGrouping.questions.forEach(q => {
      if (q.markForReview) {
        this.myGrouping.hasReviewItems = true;
        return;
      }
    });
  }

  /**
   * Calculates the percentage of answered questions for this subcategory.
   * The percentage for maturity questions is calculated using questions
   * that are within the assessment's target level.
   * If a maturity model doesn't support target levels, we use a dummy
   * target level of 100 to make the math work.
   */
  refreshPercentAnswered() {
    let answeredCount = 0;
    let totalCount = 0;

    this.myGrouping.questions.forEach(q => {
      if (!q.isAnswerable) {
        return;
      }
      if (q.visible) {
        totalCount++;
        if (q.answer && q.answer !== 'U') {
          answeredCount++;
        }
      }
    });
    this.percentAnswered = (answeredCount / totalCount) * 100;
  }

  checkAnswerKeyPress(event: any, q: Question, newAnswerValue: string) {
    if (event) {
      if (event.key === 'Enter') {
        this.storeAnswer(q, newAnswerValue);
      }
    }
  }

  checkReviewKeyPress(event: any, q: Question) {
    if (event) {
      if (event.key === 'Enter') {
        this.saveMFR(q);
      }
    }
  }
}
