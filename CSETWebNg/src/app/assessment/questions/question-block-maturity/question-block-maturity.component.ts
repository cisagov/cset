////////////////////////////////
//
//   Copyright 2021 Battelle Energy Alliance, LLC
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
import { Component, ComponentFactoryResolver, ElementRef, Injector, Input, OnInit, Renderer2, ViewChild } from '@angular/core';
import { Question, QuestionGrouping, Answer } from '../../../models/questions.model';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';
import { GroupingDescriptionComponent } from '../grouping-description/grouping-description.component';


/**
 * This was cloned from question-block to start a new version that is
 * not so "subcategory-centric", mainly for the new simplified
 * maturity question display.  Hopefully this more generic version
 * of the question block can eventually replace the original.
 */
@Component({
  selector: 'app-question-block-maturity',
  templateUrl: './question-block-maturity.component.html', 
  styleUrls: ['./question-block-maturity.component.scss']
})
export class QuestionBlockMaturityComponent implements OnInit {

  @Input() myGrouping: QuestionGrouping;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  private _timeoutId: NodeJS.Timeout;

  percentAnswered = 0;
  answerOptions = [];

  altTextPlaceholder = "Description, explanation and/or justification for alternate answer";
  altTextPlaceholder_ACET = "Description, explanation and/or justification for compensating control";

  /**
   * Constructor.
   * @param configSvc 
   */
  constructor(
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public assessSvc: AssessmentService
  ) { }

  /**
   * 
   */
  ngOnInit(): void {
    this.answerOptions = this.assessSvc.assessment.MaturityModel.AnswerOptions;

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    // set sub questions' titles so that they align with their parent when hidden
    this.myGrouping.Questions.forEach(q => {
      if (!!q.ParentQuestionId) {
        q.DisplayNumber = this.myGrouping.Questions.find(x => x.QuestionId == q.ParentQuestionId).DisplayNumber;
      }
    });

    if (this.configSvc.acetInstallation) {
      this.altTextPlaceholder = this.altTextPlaceholder_ACET;
    }
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

    this.myGrouping.Expanded = !this.myGrouping.Expanded;
  }

  /**
 * If there are no spaces in the question text assume it's a hex string
 * @param q
 */
  applyWordBreak(q: Question) {
    if (q.QuestionText.indexOf(' ') >= 0) {
      return "normal";
    }
    return "break-all";
  }

  /**
   * 
   * @param ans 
   */
  showThisOption(ans: string) {
    return true;
  }

  /**
   * Pushes an answer asynchronously to the API.
   * @param q
   * @param ans
   */
  storeAnswer(q: Question, newAnswerValue: string) {
    // if they clicked on the same answer that was previously set, "un-set" it
    if (q.Answer === newAnswerValue) {
      newAnswerValue = "U";
    }

    q.Answer = newAnswerValue;

    const answer: Answer = {
      AnswerId: q.Answer_Id,
      QuestionId: q.QuestionId,
      QuestionType: q.QuestionType,
      QuestionNumber: q.DisplayNumber,
      AnswerText: q.Answer,
      AltAnswerText: q.AltAnswerText,
      Comment: q.Comment,
      Feedback: q.Feedback,
      MarkForReview: q.MarkForReview,
      Reviewed: q.Reviewed,
      Is_Component: q.Is_Component,
      Is_Requirement: q.Is_Requirement,
      Is_Maturity: q.Is_Maturity,
      ComponentGuid: q.ComponentGuid
    };

    this.refreshReviewIndicator();

    this.refreshPercentAnswered();

    this.questionsSvc.storeAnswer(answer)
      .subscribe();
  }

  /**
   *
   */
  saveMFR(q: Question) {
    q.MarkForReview = !q.MarkForReview; // Toggle Bind

    const newAnswer: Answer = {
      AnswerId: q.Answer_Id,
      QuestionId: q.QuestionId,
      QuestionType: q.QuestionType,
      QuestionNumber: q.DisplayNumber,
      AnswerText: q.Answer,
      AltAnswerText: q.AltAnswerText,
      Comment: q.Comment,
      Feedback: q.Feedback,
      MarkForReview: q.MarkForReview,
      Reviewed: q.Reviewed,
      Is_Component: q.Is_Component,
      Is_Requirement: q.Is_Requirement,
      Is_Maturity: q.Is_Maturity,
      ComponentGuid: q.ComponentGuid
    };

    this.refreshReviewIndicator();
    this.questionsSvc.storeAnswer(newAnswer).subscribe();
  }

  /**
   * Looks at all questions in the subcategory to see if any
   * are marked for review.
   * Also returns true if alt text is required but not supplied.
   */
  refreshReviewIndicator() {
    this.myGrouping.HasReviewItems = false;
    this.myGrouping.Questions.forEach(q => {
      if (q.MarkForReview) {
        this.myGrouping.HasReviewItems = true;
        return;
      }
      if (q.Answer == 'A' && this.isAltTextRequired(q)) {
        this.myGrouping.HasReviewItems = true;
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

    this.myGrouping.Questions.forEach(q => {
      // parent questions aren't answered and don't count
      if (q.IsParentQuestion) {
        return;
      }

      let targetLevel = this.assessSvc.assessment?.MaturityModel.MaturityTargetLevel;
      if (targetLevel == 0) {
        targetLevel = 100;
      }
     
      if (q.MaturityLevel <= targetLevel) {
        totalCount++;
        if (q.Answer && q.Answer !== "U") {
              answeredCount++;
            }
          }
      });

    this.percentAnswered = (answeredCount / totalCount) * 100;
  }

  /**
   * For ACET installations, alt answers require 3 or more characters of 
   * justification.
   */
  isAltTextRequired(q: Question) {
    if (this.configSvc.acetInstallation
      && (!q.AltAnswerText || q.AltAnswerText.trim().length < 3)) {
      return true;
    }
    return false;
  }

  /**
   * Pushes the answer to the API, specifically containing the alt text
   * @param q
   * @param altText
   */
  storeAltText(q: Question) {

    clearTimeout(this._timeoutId);
    this._timeoutId = setTimeout(() => {
      const answer: Answer = {
        AnswerId: q.Answer_Id,
        QuestionId: q.QuestionId,
        QuestionType: q.QuestionType,
        QuestionNumber: q.DisplayNumber,
        AnswerText: q.Answer,
        AltAnswerText: q.AltAnswerText,
        Comment: q.Comment,
        Feedback: q.Feedback,
        MarkForReview: q.MarkForReview,
        Reviewed: q.Reviewed,
        Is_Component: q.Is_Component,
        Is_Requirement: q.Is_Requirement,
        Is_Maturity: q.Is_Maturity,
        ComponentGuid: q.ComponentGuid
      };

      this.refreshReviewIndicator();

      this.questionsSvc.storeAnswer(answer)
        .subscribe();
    }, 500);

  }
}
