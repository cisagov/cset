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
  selector: 'app-question-block-ise',
  templateUrl: './question-block-ise.component.html',
  styleUrls: ['./question-block-ise.component.scss']
})
export class QuestionBlockIseComponent implements OnInit {

  @Input() myGrouping: QuestionGrouping;

  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  private _timeoutId: NodeJS.Timeout;

  percentAnswered = 0;
  answerOptions = [];

  altTextPlaceholder = "Description, explanation and/or justification for alternate answer";
  altTextPlaceholder_ACET = "Description, explanation and/or justification for compensating control";
  altTextPlaceholder_ISE = "Description, explanation and/or justification for comment";

  textForSummary = "Work Summary - insert comments";
  summaryCommentCopy = "";
  summaryEditedCheck = false;

  contactInitials = "";
  altAnswerSegment = "";
  convoBuffer = '\n- - End of Comment - -\n';
  // altAnswerConversation = [];

  showQuestionIds = false;

  showCorePlus: boolean = false;
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
    if (this.assessSvc.assessment.maturityModel.modelName != null) {
      this.answerOptions = this.assessSvc.assessment.maturityModel.answerOptions;

      if (this.assessSvc.isISE()) {
        this.configSvc.buttonLabels['A'] = "Comment";
        this.configSvc.answerLabels['A'] = "Comment";
      } else {
        this.configSvc.buttonLabels['A'] = "Yes(C)";
        this.configSvc.answerLabels['A'] = "Yes Compensating Control"
      }

      this.refreshReviewIndicator();
      this.refreshPercentAnswered();

      // set sub questions' titles so that they align with their parent when hidden
      // commented out now to maintain unique numbers for child statements
      // this.myGrouping.questions.forEach(q => {
      //   if (!!q.parentQuestionId) {
      //     q.displayNumber = this.myGrouping.questions.find(x => x.questionId == q.parentQuestionId).displayNumber;
      //   }
      // });

      if (this.configSvc.installationMode === "ACET") {
        if (this.assessSvc.isISE()) {
          this.altTextPlaceholder = this.altTextPlaceholder_ISE;
        }
        else {
          this.altTextPlaceholder = this.altTextPlaceholder_ACET;
        }
      }
    }
    this.acetFilteringSvc.filterAcet.subscribe((filter) => {
      this.refreshReviewIndicator();
      this.refreshPercentAnswered();
    });

    this.showQuestionIds = this.configSvc.showQuestionAndRequirementIDs();

    this.assessSvc.getAssessmentContacts().then((response: any) => {
      let firstInitial = response.contactList[0].firstName[0] !== undefined ? response.contactList[0].firstName[0] : "";
      let lastInitial = response.contactList[0].lastName[0] !== undefined ? response.contactList[0].lastName[0] : "";
      this.contactInitials = firstInitial + lastInitial;
    });
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
    if (this.assessSvc.isISE()) {
      let bracketContact = '[' + this.contactInitials + ']';

      if (q.altAnswerText.indexOf(bracketContact) !== 0) {
        if (!!q.altAnswerText) {
          if (q.altAnswerText.indexOf('[') !== 0) {
            this.altAnswerSegment = bracketContact + ' ' + q.altAnswerText;
            q.altAnswerText = this.altAnswerSegment + this.convoBuffer;
          }

          else {
            let previousContactInitials = q.altAnswerText.substring(q.altAnswerText.lastIndexOf('[') + 1, q.altAnswerText.lastIndexOf(']'));
            let endOfLastBuffer = q.altAnswerText.lastIndexOf(this.convoBuffer) + this.convoBuffer.length;
            if (previousContactInitials !== this.contactInitials) {
              // if ( endOfLastBuffer !== q.altAnswerText.length || endOfLastBuffer !== q.altAnswerText.length - 1) {
                let oldComments = q.altAnswerText.substring(0, endOfLastBuffer);
                let newComment = q.altAnswerText.substring(oldComments.length);

                q.altAnswerText = oldComments + bracketContact + ' ' + newComment + this.convoBuffer;
              // }
            }
          }
        }
      }
    }
    // Matt's work in progress for adding contact initials to comments
    // else{

    // }



    // if (q.altAnswerText.charAt(0) !== "[") {
    //   this.altAnswerSegment = '[' + this.contactInitials + '] ' + q.altAnswerText + this.convoBuffer;
    //   this.altAnswerConversation.push(this.altAnswerSegment);
    // }

    // else {
    //   let previousContactInitials = q.altAnswerText.substring(q.altAnswerText.lastIndexOf('[') + 1, q.altAnswerText.lastIndexOf(']'));
    //   let newTextStart = q.altAnswerText.lastIndexOf(this.convoBuffer);

    //   this.altAnswerSegment = q.altAnswerText.substring(newTextStart);

    //   if (previousContactInitials !== this.contactInitials) {
    //     this.altAnswerSegment = '[' + this.contactInitials + '] ' + this.altAnswerSegment + this.convoBuffer;
    //     this.altAnswerConversation.push(this.altAnswerSegment);
    //   }
    //   else {
    //     this.altAnswerConversation.pop();
    //     this.altAnswerConversation.push(this.altAnswerSegment);

    //   }
    // }

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

  /**
   * Very similar to 'storeAltText' above. Text box is at the end of each question set, and
   * attaches to the parent statement.
   * @param q
  */
  storeSummaryComment(q: Question, e: any) {
    q.comment = e.target.value;
    this.summaryCommentCopy = q.comment;
    this.summaryEditedCheck = true;
 
    clearTimeout(this._timeoutId);
    this._timeoutId = setTimeout(() => {
      const answer: Answer = {
        answerId: q.answer_Id,
        questionId: q.parentQuestionId,
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

  getSummaryComment(q: Question) {
    let parentId = q.parentQuestionId;
    let comment = "";

    for (const question of this.myGrouping.questions) {
      if (question.questionId === parentId) {
        // uses a local copy of the comment to avoid using API call
        if (this.summaryCommentCopy !== "") {
          comment = this.summaryCommentCopy;
          return comment;
        }
        if (this.summaryCommentCopy === "" && question.comment !== "" && this.summaryEditedCheck === true){
          comment = this.summaryCommentCopy;
          return comment;
        }
        comment = question.comment;
        break;
      }
    }

    return comment;
  }

  isFinalQuestion(id: number) {
    // If SCUEP examination
    if (this.ncuaSvc.proposedExamLevel === "SCUEP" || this.ncuaSvc.chosenOverrideLevel === "SCUEP") {
      switch (id) {
        case (7196): case(7201): case(7206): case(7214):
        case (7217): case(7220): case(7225):
          return true;
      }
      return false;
    } else { // If CORE examination
      if (!this.showCorePlus) {
        switch (id) {
          case (7233): case (7238): case (7244): case (7249): 
          case (7256): case (7265): case (7273): case (7276): 
          case (7281): case (7285): case (7289): case (7293): 
          case (7296): case (7301): case (7304):
            return true;
        }
        return false;
      } else if (this.showCorePlus) {
        switch (id) {
          // Final question under each CORE+ non-parent
          case (7312): case (7316): case (7322): case (7332): 
          case (7338): case (7344): case (7351): case (7359): 
          case (7366): case (7373): case (7381): case (7390): 
          case (7395): case (7400): case (7408): 
          
          // ID's of CORE+ only questions
          case (7421): case (7429): case (7444): case (7450): 
          case (7458): case (7465):
            return true;
        }
        return false;
      }
    }
  }

  showCorePlusButton(id: number) {
    if (this.isFinalQuestion(id)) {
      return true;
    }
  }

  showSummaryCommentBox(id: number) {
    if (this.isFinalQuestion(id)) {
      return true;
    }
  }

  showAddIssueButton(id: number) {
    if (this.isFinalQuestion(id)) {
      return true;
    }
  }

  updateCorePlusStatus(q: Question) {
    this.showCorePlus = !this.showCorePlus

    if (this.showCorePlus) {
      this.ncuaSvc.showCorePlus = true;
    } else if (!this.showCorePlus) {
      this.ncuaSvc.showCorePlus = false;
    }
  }

  
}
