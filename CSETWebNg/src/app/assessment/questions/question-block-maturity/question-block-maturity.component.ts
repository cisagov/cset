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

  showQuestionIds = false;


  /* Used for ISE adding/removing questions functionality.
  *  This feels clunky, but it allows individual sub questions
  *  to be added and removed from each parent statement.
  *  There is probably a better way of going about this.
  */

  iseParentStatement = [];
  isShowing: boolean = false;

  showSubOne: boolean; showSubTwo: boolean; showSubThree: boolean;
  showSubFour: boolean; showSubFive: boolean; showSubSix: boolean;
  showSubSeven: boolean; showSubEight: boolean; showSubNine: boolean;
  showSubTen: boolean; showSubEleven: boolean; showSubTwelve: boolean;
  showSubThirteen: boolean;

  statementOne = []; statementTwo= []; statementThree = []; statementFour = [];
  statementFive = []; statementSix = []; statementSeven = []; statementEight = [];
  statementNine = []; statementTen = []; statementEleven = []; statementTwelve = [];
  statementThirteen = [];


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

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    // set sub questions' titles so that they align with their parent when hidden
    this.myGrouping.questions.forEach(q => {
      if (!!q.parentQuestionId) {
        q.displayNumber = this.myGrouping.questions.find(x => x.questionId == q.parentQuestionId).displayNumber;
      }
    });

    if (this.configSvc.installationMode === "ACET") {
      this.altTextPlaceholder = this.altTextPlaceholder_ACET;
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
      if (q.questionId == 7189 || q.questionId == 7204 || q.questionId == 7214 ||
          q.questionId == 7222 || q.questionId == 7230 || q.questionId == 7238 ||
          q.questionId == 7247 || q.questionId == 7254 || q.questionId == 7261 ||
          q.questionId == 7268 || q.questionId == 7276 || q.questionId == 7284 ||
          q.questionId == 7288) {
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
    if (this.iseParentStatement.length === 0) {
      this.iseParentStatement.push(7189, 7204, 7214, 7222,
                                   7230, 7238, 7247, 7254,
                                   7261, 7268, 7276, 7284,
                                   7288);
      }
  }

  setSubQuestions() {
    for(let i = 7190; i < 7293; i++) {
      if (i >= 7190 && i < 7204) {
        this.statementOne.push(i);
      } else if (i > 7204 && i < 7214) {
        this.statementTwo.push(i);
      } else if (i > 7214 && i < 7222) {
        this.statementThree.push(i);
      } else if (i > 7222 && i < 7230) {
        this.statementFour.push(i);
      } else if (i > 7230 && i < 7238) {
        this.statementFive.push(i);
      } else if (i > 7238 && i < 7247) {
        this.statementSix.push(i);
      } else if (i > 7247 && i < 7254) {
        this.statementSeven.push(i);
      } else if (i > 7254 && i < 7261) {
        this.statementEight.push(i);
      } else if (i > 7261 && i < 7268) {
        this.statementNine.push(i);
      } else if (i > 7268 && i < 7276) {
        this.statementTen.push(i);
      } else if (i > 7276 && i < 7284) {
        this.statementEleven.push(i);
      } else if (i > 7284 && i < 7288) {
        this.statementTwelve.push(i);
      } else if (i > 7288 && i < 7293) {
        this.statementThirteen.push(i);
      }
    }
  }

  shouldIShow(q: Question) {
    if (this.iseParentStatement.includes(q.questionId) && q.answer === 'Y') {
      this.showSubQuestions(q.questionId);
    } else if (this.iseParentStatement.includes(q.questionId) && q.answer !== 'Y') {
      this.hideSubQuestions(q.questionId);
    }

    if (this.iseParentStatement.includes(q.questionId) ||
      this.showSubOne && this.statementOne.includes(q.questionId) ||
      this.showSubTwo && this.statementTwo.includes(q.questionId) ||
      this.showSubThree && this.statementThree.includes(q.questionId) ||
      this.showSubFour && this.statementFour.includes(q.questionId) ||
      this.showSubFive && this.statementFive.includes(q.questionId) ||
      this.showSubSix && this.statementSix.includes(q.questionId) ||
      this.showSubSeven && this.statementSeven.includes(q.questionId) ||
      this.showSubEight && this.statementEight.includes (q.questionId) ||
      this.showSubNine && this.statementNine.includes(q.questionId) ||
      this.showSubTen && this.statementTen.includes(q.questionId) ||
      this.showSubEleven && this.statementEleven.includes(q.questionId) ||
      this.showSubTwelve && this.statementTwelve.includes(q.questionId) ||
      this.showSubThirteen && this.statementThirteen.includes (q.questionId)) 
      {
        return true;
    }
  }

  showSubQuestions(id: number) {
    switch (id) {
      case 7189:
        this.showSubOne = true;
        break;
      case 7204:
        this.showSubTwo = true;
        break;
      case 7214:
        this.showSubThree = true;
        break;
      case 7222:
        this.showSubFour = true;
        break;
      case 7230:
        this.showSubFive = true;
        break;
      case 7238:
        this.showSubSix = true;
        break;
      case 7247:
        this.showSubSeven = true;
        break;
      case 7254:
        this.showSubEight = true;
        break;
      case 7261:
        this.showSubNine = true;
        break;
      case 7268:
        this.showSubTen = true;
        break;
      case 7276:
        this.showSubEleven = true;
        break;
      case 7284:
        this.showSubTwelve = true;
        break;
      case 7288:
        this.showSubThirteen = true;
        break;
    }
  }

  hideSubQuestions(id: number) {
    switch (id) {
      case 7189:
        this.showSubOne = false;
        break;
      case 7204:
        this.showSubTwo = false;
        break;
      case 7214:
        this.showSubThree = false;
        break;
      case 7222:
        this.showSubFour = false;
        break;
      case 7230:
        this.showSubFive = false;
        break;
      case 7238:
        this.showSubSix = false;
        break;
      case 7247:
        this.showSubSeven = false;
        break;
      case 7254:
        this.showSubEight = false;
        break;
      case 7261:
        this.showSubNine = false;
        break;
      case 7268:
        this.showSubTen = false;
        break;
      case 7276:
        this.showSubEleven = false;
        break;
      case 7284:
        this.showSubTwelve = false;
        break;
      case 7288:
        this.showSubThirteen = false;
        break;
    }
  }

  
}
