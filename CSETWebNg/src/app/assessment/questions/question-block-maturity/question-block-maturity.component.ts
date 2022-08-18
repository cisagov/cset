////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { NCUAService } from '../../../services/ncua.service';
import { LayoutService } from '../../../services/layout.service';


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
  altTextPlaceholder_ISE = "Description, explanation and/or justification for note";

  showQuestionIds = false;

  showCorePlus: boolean = false;
  endOfCore: number[] = [7235, 7240, 7248, 7253, 7260, 7267, 
                         7270, 7273, 7279, 7285, 7289, 7293, 
                         7296, 7299, 7304, 7311];
  coreChecked: boolean = false;


  /**
   * Constructor.
   * @param configSvc 
   */
  constructor(
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public assessSvc: AssessmentService, 
    public acetFilteringSvc: AcetFilteringService,
    public layoutSvc: LayoutService,
    public ncuaSvc: NCUAService
  ) { 
    
  }

  /**
   * 
   */
  ngOnInit(): void {
    this.answerOptions = this.assessSvc.assessment.maturityModel.answerOptions;

    if (this.assessSvc.assessment.maturityModel.modelName === 'ISE') {
      this.configSvc.buttonLabels['A'] = "Notes(N)";
      this.configSvc.answerLabels['A'] = "Notes or Issues";
    } else {
      this.configSvc.buttonLabels['A'] = "Yes(C)";
      this.configSvc.answerLabels['A'] = "Yes Compensating Control"
    }

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    // set sub questions' titles so that they align with their parent when hidden
    this.myGrouping.questions.forEach(q => {
      if (!!q.parentQuestionId) {
        q.displayNumber = this.myGrouping.questions.find(x => x.questionId == q.parentQuestionId).displayNumber;
      }
    });

    if (this.configSvc.installationMode === "ACET") {
      if (this.assessSvc.assessment.maturityModel.modelName === 'ISE') {
        this.altTextPlaceholder = this.altTextPlaceholder_ISE;
      }
      else {
        this.altTextPlaceholder = this.altTextPlaceholder_ACET;
      }
    }
    this.acetFilteringSvc.filterAcet.subscribe((filter) => {
      this.refreshReviewIndicator();
      this.refreshPercentAnswered();
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
    if (q.answer === newAnswerValue) {
      newAnswerValue = "U";
    }

    q.answer = newAnswerValue;

    const answer: Answer = {
      answerId: q.answer_Id,
      questionId: q.questionId,
      questionType: q.questionType,
      questionNumber: "0",
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

    this.refreshReviewIndicator();

    this.refreshPercentAnswered();

    this.questionsSvc.storeAnswer(answer)
      .subscribe();
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
      if (q.answer == 'A' && this.isAltTextRequired(q)) {
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
      if (q.isParentQuestion) {
        return;
      }
      if (q.visible) {
        
          totalCount++;
          if (q.answer && q.answer !== "U") {
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
    if ((this.configSvc.installationMode === "ACET")
      && (!q.altAnswerText || q.altAnswerText.trim().length < 3)) {
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
        answerId: q.answer_Id,
        questionId: q.questionId,
        questionType: q.questionType,
        questionNumber: q.displayNumber,
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

      this.refreshReviewIndicator();

      this.questionsSvc.storeAnswer(answer)
        .subscribe();
    }, 500);

  }

  showCorePlusButton(id: number) {
    switch(id) {
      case (7235): case (7240): case (7248):
      case (7253): case (7260): case (7267):
      case (7273): case (7279): case (7285): 
      case (7289): case (7293): case (7296): 
      case (7299): case (7304): case (7311):
        return true;
    }
  }

  updateCorePlusStatus(q: Question) {
    console.log(JSON.stringify(q, null, 4));
    this.showCorePlus = !this.showCorePlus

    if (this.showCorePlus) {
      this.ncuaSvc.showCorePlus = true;
    } else if (!this.showCorePlus) {
      this.ncuaSvc.showCorePlus = false;
    }

    console.log("this.showCorePlus: " + this.showCorePlus);
    console.log("this.ncuaSvc.showCorePlus: " + this.ncuaSvc.showCorePlus);
  }

  
}
