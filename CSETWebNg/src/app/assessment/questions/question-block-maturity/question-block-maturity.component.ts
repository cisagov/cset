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

  iseIRP: string = '';
  showCorePlus: boolean = false;

  iseParentStatements = [];


  showSubOne: boolean; showSubTwo: boolean; showSubThree: boolean;
  showSubFour: boolean; showSubFive: boolean; showSubSix: boolean;
  showSubSeven: boolean;

  statementOne = []; statementTwo= []; statementThree = []; statementFour = [];
  statementFive = []; statementSix = []; statementSeven = [];

  /**
   * Constructor.
   * @param configSvc 
   */
  constructor(
    public configSvc: ConfigService,
    public questionsSvc: QuestionsService,
    public assessSvc: AssessmentService, 
    public acetFilteringSvc: AcetFilteringService,
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

    this.iseIRP = this.ncuaSvc.iseIRP

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    // set sub questions' titles so that they align with their parent when hidden
    console.log("my grouping.questions: " + JSON.stringify(this.myGrouping.questions, null, 4));
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

    if (this.assessSvc.assessment.maturityModel.modelName === 'ISE') {
      this.setParentQuestions();
      this.setSubQuestions();
    }

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

    // Update ISE child/parent drop down statements
    if (this.assessSvc.assessment.maturityModel.modelName === 'ISE') {
      if (q.questionId == 7189 || q.questionId == 7197 || q.questionId == 7203 ||
          q.questionId == 7211 || q.questionId == 7216 || q.questionId == 7221 ||
          q.questionId == 7224) {
            this.shouldIShow(q);
      }
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

  setParentQuestions() {
    if (this.iseParentStatements.length === 0) {
      for (let i = 0; i < this.myGrouping.questions.length; i++) {
        if (this.myGrouping.questions[i].isParentQuestion) {
          this.iseParentStatements.push(this.myGrouping.questions[i].questionId);
        }
      }
    }
  }

  setSubQuestions() {
    for (let i = 0; i < this.myGrouping.questions.length; i++) {
      if (this.myGrouping.questions[i].isParentQuestion) {
        this.iseParentStatements.push(this.myGrouping.questions[i].questionId);
      }
    }
  }

  shouldIShow(q: Question) {
    if (this.iseParentStatements.includes(q.questionId) && q.answer === 'Y') {
      this.showSubQuestions(q.questionId);
    } else if (this.iseParentStatements.includes(q.questionId) && q.answer !== 'Y') {
      this.hideSubQuestions(q.questionId);
    }

    if (this.iseParentStatements.includes(q.questionId) ||
      this.showSubOne && this.statementOne.includes(q.questionId) ||
      this.showSubTwo && this.statementTwo.includes(q.questionId) ||
      this.showSubThree && this.statementThree.includes(q.questionId) ||
      this.showSubFour && this.statementFour.includes(q.questionId) ||
      this.showSubFive && this.statementFive.includes(q.questionId) ||
      this.showSubSix && this.statementSix.includes(q.questionId) ||
      this.showSubSeven && this.statementSeven.includes(q.questionId)) 
      {
        return true;
    }
  }

  showSubQuestions(id: number) {
    
    switch (id) {
      case 7189:
        this.showSubOne = true;
        break;
      case 7197:
        this.showSubTwo = true;
        break;
      case 7203:
        this.showSubThree = true;
        break;
      case 7211:
        this.showSubFour = true;
        break;
      case 7216:
        this.showSubFive = true;
        break;
      case 7221:
        this.showSubSix = true;
        break;
      case 7224:
        this.showSubSeven = true;
        break;
    }
  }

  hideSubQuestions(id: number) {
    switch (id) {
      case 7189:
        this.showSubOne = false;
        break;
      case 7197:
        this.showSubTwo = false;
        break;
      case 7203:
        this.showSubThree = false;
        break;
      case 7211:
        this.showSubFour = false;
        break;
      case 7216:
        this.showSubFive = false;
        break;
      case 7221:
        this.showSubSix = false;
        break;
      case 7224:
        this.showSubSeven = false;
        break;
    }
  }
  

  isLastCoreQuestion(id: number) {
    switch (id) {
      case 7427:
      case 7290:
      case 7439:
      case 7443:
      case 7302:
      case 7311:
      case 7226:
      case 7231:
      case 7237:
      case 7243:
      case 7247:
      case 7251:
      case 7254:
      case 7257:
      case 7262:
      case 7269:
        return true;
    }
  }

  updateCorePlusStatus() {
    this.showCorePlus = !this.showCorePlus
  }

  
}
