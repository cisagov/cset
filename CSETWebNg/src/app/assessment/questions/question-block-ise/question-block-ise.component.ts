////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { Question, QuestionGrouping, Answer } from '../../../models/questions.model';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';
import { GroupingDescriptionComponent } from '../grouping-description/grouping-description.component';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { NCUAService } from '../../../services/ncua.service';
import { LayoutService } from '../../../services/layout.service';
import { Observation } from '../observations/observations.model';
import { QuestionDetailsContentViewModel } from '../../../models/question-extras.model';
import { ConfirmComponent } from '../../../dialogs/confirm/confirm.component';
import { ObservationsService } from '../../../services/observations.service';
import { IssuesComponent } from '../issues/issues.component';
import { CompletionService } from '../../../services/completion.service';


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
  extras: QuestionDetailsContentViewModel;
  dialogRef: MatDialogRef<any>;

  percentAnswered = 0;
  answerOptions = [];

  altTextPlaceholder = "Description, explanation and/or justification for alternate answer";
  altTextPlaceholder_ACET = "Description, explanation and/or justification for compensating control";
  altTextPlaceholder_ISE = "Description, explanation and/or justification for note";
  textForSummary = "Statement Summary (insert summary)";
  summaryCommentCopy = "";
  summaryEditedCheck = false;

  contactInitials = "";
  altAnswerSegment = "";
  convoBuffer = '\n- - End of Note - -\n';
  summaryConvoBuffer = '\n\n- - End of Statement Summary - -\n';
  summaryBoxMax = 800;

  // Used to place buttons/text boxes at the bottom of each subcategory
  finalScuepQuestion = new Set([7576, 7581, 7587, 7593, 7601, 7606, 7611, 7618]);
  finalCoreQuestion = new Set([7627, 7632, 7638, 7644, 7651, 7654, 7660, 7668, 7673, 7678, 7682, 7686, 7690, 7693, 7698, 7701]);
  finalCorePlusQuestion = new Set([7706, 10926, 7718, 7730, 7736, 7739, 7746, 7755, 7771, 7779, 7790, 7802, 7821, 10929, 7838, 7851]);
  finalExtraQuestion = new Set([7867, 7873, 7889, 7900, 7910, 7917, 7946, 7965, 8001]);
  
  // Statements added late so their id's are very different from other sub statements
  addedLateQuestions = new Set([10926, 10927, 10928, 10929, 10930]);

  showQuestionIds = false;

  iseExamLevel: string = "";
  showCorePlus: boolean = false;
  showIssues: boolean = true;
  coreChecked: boolean = false;

  autoGenerateInProgress: boolean = false;
  maturityModelId: number;
  maturityModelName: string;


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
    public completionSvc: CompletionService,
    public ncuaSvc: NCUAService,
    public dialog: MatDialog,
    private observationSvc: ObservationsService
  ) {

  }

  /**
  *
  */
  ngOnInit(): void {
    this.setIssueMap();

    if (this.assessSvc.assessment.maturityModel.modelName != null) {
      this.answerOptions = this.assessSvc.assessment.maturityModel.answerOptions;
      this.maturityModelId = this.assessSvc.assessment.maturityModel.modelId;
      this.maturityModelName = this.assessSvc.assessment.maturityModel.modelName;

      this.iseExamLevel = this.ncuaSvc.getExamLevel();

      this.summaryCommentCopy = this.myGrouping.questions[0].comment;

      this.questionsSvc.getDetails(this.myGrouping.questions[0].questionId, this.myGrouping.questions[0].questionType).subscribe(
        (details) => {
          this.extras = details;
          this.extras.questionId = this.myGrouping.questions[0].questionId;

          this.extras.observations.forEach(obs => {
            if (obs.auto_Generated === 1) {
              obs.question_Id = this.myGrouping.questions[0].questionId;

              // This is a check for post-merging ISE assessments.
              // If an issue existed, but all answers were changed to "Yes" on merge, delete the issue.
              if (this.ncuaSvc.questionCheck.get(obs.question_Id) !== undefined) {
                this.ncuaSvc.issueObservationId.set(obs.question_Id, obs.observation_Id);
              } else {
                this.deleteIssue(obs.observation_Id, true);
              }

            }
          });

          this.ncuaSvc.issuesFinishedLoading = true;
        });

      this.refreshReviewIndicator();
      this.refreshPercentAnswered();

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

    this.showQuestionIds = false; //this.configSvc.showQuestionAndRequirementIDs();

    this.assessSvc.getAssessmentContacts().then((response: any) => {
      this.contactInitials = response.contactList[0].firstName;
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

  displayTooltip(maturityModelName: string, option: string) {
    let toolTip = this.questionsSvc.answerDisplayLabel(maturityModelName, option);
    if (toolTip === 'Yes' || toolTip === 'No') {
      toolTip = "";
    }
    return toolTip;
  }

  /**
  * Repopulates the map variables to correctly track/delete issues
  */
  setIssueMap() {
    let parentId = 0;
    let count = 0;

    this.myGrouping.questions.forEach(question => {
      parentId = question.parentQuestionId;

      if (question.answer === 'N') {
        count++;
        this.ncuaSvc.questionCheck.set(parentId, count);
      }
      this.ncuaSvc.deleteHistory.clear();
    });
  }

  deleteIssueMaps(observation: number) {
    const iterator = this.ncuaSvc.issueObservationId.entries();
    let parentKey = 0;

    for (let value of iterator) {
      if (value[1] === observation) {
        parentKey = value[0];
        this.ncuaSvc.questionCheck.delete(parentKey);
        this.ncuaSvc.issueObservationId.delete(parentKey);
        this.ncuaSvc.deleteHistory.add(parentKey);
      }
    }
  }

  /**
  *
  * @param ans
  */
  showThisOption(ans: string) {
    return true;
  }

  shouldIShow(q: Question) {
    let visible = false;

    if (q.visible || q.isParentQuestion) {
      visible = true;
    }

    // If running a SCUEP exam, always show level 1 (SCUEP) questions
    if (this.iseExamLevel === 'SCUEP' && q.maturityLevel === 1) {
      if (visible) {
        this.refreshPercentAnswered(); // updates filtered %completed circles, and keeps it in step when switching between filters
        return true;
      }
      //If running a CORE exam, always show level 2 (CORE) questions
    } else if (this.iseExamLevel === 'CORE') {
      if (q.maturityLevel === 2) {
        if (visible) {
          this.refreshPercentAnswered();
          return true;
        }
        // For all level 3 (CORE+) questions, check to see if we want to see them
        } else if (q.maturityLevel === 3) {
        if ((q.questionId < 7852 || q.questionId >= 10926) && this.showCorePlus === true) {
          if (visible) {
            this.refreshPercentAnswered();
            return true;
          }
        } else if ((q.questionId >= 7852 && (!this.addedLateQuestions.has(q.questionId)) 
                    && this.ncuaSvc.showExtraQuestions === true)) {
          if (visible) {
            this.refreshPercentAnswered();
            return true;
          }
        }
      }
    }

    return false;
  }


  /**
   * Pushes an answer asynchronously to the API.
   * @param q
   * @param ans
   */
  storeAnswer(q: Question, newAnswerValue: string) {
    // if they clicked on the same answer that was previously set, "un-set" it
    let oldAnswerValue = q.answer;

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

    // Errors out on ISE answers. Commenting out for now.
    //this.completionSvc.setAnswer(q.questionId, q.answer);

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    this.questionsSvc.storeAnswer(answer).subscribe
      (result => {
        this.checkForIssues(q, oldAnswerValue);
      });
  }

  checkForIssues(q: Question, oldAnswerValue: string) {
    let count = this.ncuaSvc.questionCheck.get(q.parentQuestionId);
    let value = (count != undefined) ? count : 0;

    if (q.answer === 'N') {
      value++;
      this.ncuaSvc.questionCheck.set(q.parentQuestionId, value);

      if (value >= 1 && !this.ncuaSvc.issueObservationId.has(q.parentQuestionId)) {
        if (!this.ncuaSvc.deleteHistory.has(q.parentQuestionId)) {
          this.autoGenerateIssue(q.parentQuestionId, 0);
        }
      }
    } else if (oldAnswerValue === 'N' && (q.answer === 'Y' || q.answer === 'U')) {
      value--;
      if (value < 1) {
        this.ncuaSvc.questionCheck.delete(q.parentQuestionId);

        if (this.ncuaSvc.issueObservationId.has(q.parentQuestionId)) {
          let observationId = this.ncuaSvc.issueObservationId.get(q.parentQuestionId);
          this.ncuaSvc.issueObservationId.delete(q.parentQuestionId);
          this.deleteIssue(observationId, true);
        }
      } else {
        this.ncuaSvc.questionCheck.set(q.parentQuestionId, value);
      }
    }
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
      if (q.parentQuestionId === null) {
        return;
      }
      if (q.visible && q.maturityLevel != 3) {

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
   * @param q
   */
  storeComment(q: Question) {
    if (this.assessSvc.isISE()) {
      let bracketContact = '[' + this.contactInitials + ']';

      if (q.comment.indexOf(bracketContact) !== 0) {
        if (q.comment !== '') {
          if (q.comment.indexOf('[') !== 0) {
            this.altAnswerSegment = bracketContact + ' ' + q.comment;
            q.comment = this.altAnswerSegment + this.convoBuffer;
          }

          else {
            let previousContactInitials = q.comment.substring(q.comment.lastIndexOf('[') + 1, q.comment.lastIndexOf(']'));
            let endOfLastBuffer = q.comment.lastIndexOf(this.convoBuffer) + this.convoBuffer.length;
            if (previousContactInitials !== this.contactInitials) {
              let oldComments = q.comment.substring(0, endOfLastBuffer);
              let newComment = q.comment.substring(oldComments.length);

              q.comment = oldComments + bracketContact + ' ' + newComment + this.convoBuffer;
            }
          }
        }
      }
    }

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
   * Shows/hides the "expand" section.
   * @param q
   * @param feature
   */
  toggleComment(q: Question) {
    if (q.extrasExpanded) {
      // hide if already open
      q.extrasExpanded = false;
      return;
    }
    q.extrasExpanded = true;
  }

  /**
   * @param q
   */
  hasComment(q: Question) {
    if (q.comment === null || q.comment === '') {
      return false;
    }
    return true;
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
  storeSummaryComment(q: Question, id: number, e: any) {
    this.autoResize(id);

    this.summaryCommentCopy = e.target.value;
    this.summaryEditedCheck = true;

    let summarySegment = '';
    // this.summaryCommentCopy = q.comment;
    if (this.assessSvc.isISE()) {
      let bracketContact = '[' + this.contactInitials + ']\n';

      if (this.summaryCommentCopy.indexOf(bracketContact) !== 0) {
        if (this.summaryCommentCopy !== '') {
          if (this.summaryCommentCopy.indexOf('[') !== 0) {
            summarySegment = bracketContact + ' ' + this.summaryCommentCopy;
            this.summaryCommentCopy = summarySegment + this.summaryConvoBuffer;
          }

          else {
            let previousContactInitials = this.summaryCommentCopy.substring(this.summaryCommentCopy.lastIndexOf('[') + 1, this.summaryCommentCopy.lastIndexOf(']'));
            let endOfLastBuffer = this.summaryCommentCopy.lastIndexOf(this.summaryConvoBuffer) + this.summaryConvoBuffer.length;
            if (previousContactInitials !== this.contactInitials) {
              let oldComments = this.summaryCommentCopy.substring(0, endOfLastBuffer);
              let newComment = this.summaryCommentCopy.substring(oldComments.length);

              this.summaryCommentCopy = oldComments + bracketContact + ' ' + newComment + this.summaryConvoBuffer;
            }
          }
        }
      }
    }

    clearTimeout(this._timeoutId);
    this._timeoutId = setTimeout(() => {
      const answer: Answer = {
        answerId: q.answer_Id,
        questionId: q.parentQuestionId,
        questionType: q.questionType,
        questionNumber: q.displayNumber,
        answerText: q.answer,
        altAnswerText: q.altAnswerText,
        comment: this.summaryCommentCopy,
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
        if (this.summaryCommentCopy === "" && question.comment !== "" && this.summaryEditedCheck === true) {
          comment = this.summaryCommentCopy;
          return comment;
        }
        comment = question.comment;
        break;
      }
    }

    return comment;
  }

  autoResize(id: number) {
    let textArea = document.getElementById("summaryComment" + id);
    textArea.style.overflow = 'hidden';
    // textArea.style.overflowY = 'hidden';
    textArea.style.height = '0px';
    textArea.style.height = textArea.scrollHeight + 'px';
    if (textArea.scrollHeight > this.summaryBoxMax) {
      textArea.style.height = this.summaryBoxMax + 'px';
      textArea.style.overflowY = 'scroll';

    }
  }

  isFinalQuestion(id: number) {
    if (this.iseExamLevel === 'SCUEP' && this.finalScuepQuestion.has(id)) {
      return true;
    }

    if (this.iseExamLevel === 'CORE') {
      if (!this.showCorePlus && this.finalCoreQuestion.has(id)) {
        return true;
      } else if (this.showCorePlus && this.finalCorePlusQuestion.has(id)) {
        return true;
      }

      if (this.ncuaSvc.getExtraQuestionStatus() === true && this.finalExtraQuestion.has(id)) {
        return true;
      }
    }

  }


  showCorePlusButton(id: number) {
    // SCUEP only shows SCUEP.
    if (this.iseExamLevel !== 'SCUEP') {
      // if (this.isFinalQuestion(id)) {
      return true;
      // }
    }
    return false;
  }

  showSummaryCommentBox(id: number) {
    if (this.isFinalQuestion(id)) {
      return true;
    }
    return false;
  }

  showAddIssueButton(id: number) {
    if (this.isFinalQuestion(id)) {
      return true;
    }
    return false;
  }

  updateCorePlusStatus() {
    this.showCorePlus = !this.showCorePlus;

    if (this.showCorePlus) {
      this.ncuaSvc.showCorePlus = true;
    } else if (!this.showCorePlus) {
      this.ncuaSvc.showCorePlus = false;
    }
  }

  updateShowIssues() {
    if (this.showIssues === false) {
      this.showIssues = true;
    } else if (this.showIssues === true) {
      this.showIssues = false;
    }
  }

  getIssuesButtonText() {
    if (this.showIssues === false) {
      if (this.extras?.observations.length === 1) {
        return ('Show 1 Issue');
      } else if (this.extras?.observations.length > 1) {
        return ('Show ' + this.extras.observations.length + ' Issues');
      } else {
        return ('Show Issues');
      }
    } else if (this.showIssues === true) {
      return ('Hide Issues');
    }
  }

  /**
   *
   * @param observationid
   */
  addEditIssue(parentId, observationId) {
    /* 
    * Per the customer's requests, an Issue's title should include the main 
    * grouping header text and the sub grouping header text.
    * this is an attempt to re-create that data which is outside of an Issue's scope.
    * SCUEP q's 1- 7 and CORE/CORE+ q's 1 - 10 use one domain, CORE/CORE+ q's 11+ have a different domain
    * this checks the q's parentQuestionId to see if it's SCUEP 1 - 7 or CORE/CORE+ 1 - 10 and sets the name accordingly
    */
    let name = "";
    if (this.myGrouping.questions[0].questionId <= 7674) {
      name = ("Information Security Program, " + this.myGrouping.title);
    } else {
      name = ("Cybersecurity Controls, " + this.myGrouping.title);
    }

    const observation: Observation = {
      question_Id: parentId,
      questionType: this.myGrouping.questions[0].questionType,
      answer_Id: this.myGrouping.questions[0].answer_Id,
      observation_Id: observationId,
      summary: '',
      observation_Contacts: null,
      impact: '',
      importance: null,
      importance_Id: 1,
      issue: '',
      recommendations: '',
      resolution_Date: null,
      vulnerabilities: '',
      title: name,
      type: null,
      risk_Area: 'Transaction',
      sub_Risk: 'Information Systems & Technology Controls',
      description: null,
      actionItems: null,
      citations: null,
      auto_Generated: 0,
      supp_Guidance: null
    };

    this.dialog.open(IssuesComponent, {
      data: observation,
      disableClose: true,
    }).afterClosed().subscribe(result => {
      let stringResult = result.toString();
      if (stringResult != 'true') {
        observation.observation_Id = result;

        this.observationSvc.saveObservation(observation, true).subscribe((r: any) => {
          this.myGrouping.questions[0].hasObservation = (this.extras.observations.length > 0);
          this.myGrouping.questions[0].answer_Id = observation.answer_Id;
        });

      }
      else {
        const answerID = observation.answer_Id;
        // if (result == true) {
        this.observationSvc.getAllObservations(answerID).subscribe(

          (response: Observation[]) => {
            this.extras.observations = response;
            this.myGrouping.questions[0].hasObservation = (this.extras.observations.length > 0);
            this.myGrouping.questions[0].answer_Id = observation.answer_Id;
          }
        ),


          error => console.log('Error updating observations | ' + (<Error>error).message)
      }
    });

  }

  isIssueEmpty(observation: Observation) {
    if (observation.actionItems == null
      && observation.citations == null
      && observation.description == null
      && observation.issue == null
      && observation.type == null) {
      return true;
    }
    return false;
  }

  // ISE "issues" should be generated if an examiner answers 'No' to
  autoGenerateIssue(parentId, observationId) {
    let name = "";
    let desc = "";

    if (parentId <= 7674) {
      name = ("Information Security Program, " + this.myGrouping.title);
    } else {
      name = ("Cybersecurity Controls, " + this.myGrouping.title);
    }

    this.questionsSvc.getActionItems(parentId, observationId).subscribe(
      (data: any) => {
        // Used to generate a description for ISE reports even if a user doesn't open the issue.
        desc = data[0]?.description;

        const obs: Observation = {
          question_Id: parentId,
          questionType: this.myGrouping.questions[0].questionType,
          answer_Id: this.myGrouping.questions[0].answer_Id,
          observation_Id: observationId,
          summary: '',
          observation_Contacts: null,
          impact: '',
          importance: null,
          importance_Id: 1,
          issue: '',
          recommendations: '',
          resolution_Date: null,
          vulnerabilities: '',
          title: name,
          type: null,
          risk_Area: 'Transaction',
          sub_Risk: 'Information Systems & Technology Controls',
          description: desc,
          actionItems: null,
          citations: null,
          auto_Generated: 1,
          supp_Guidance: null
        };

        this.ncuaSvc.issueObservationId.set(parentId, observationId);

        this.observationSvc.saveObservation(obs).subscribe(() => {
          const answerID = obs.answer_Id;
          this.observationSvc.getAllObservations(answerID).subscribe(
            (response: Observation[]) => {
              for (let i = 0; i < response.length; i++) {
                if (response[i].auto_Generated === 1) {
                  this.ncuaSvc.issueObservationId.set(parentId, response[i].observation_Id);
                }
              }
              this.extras.observations = response;
              this.myGrouping.questions[0].hasObservation = (this.extras.observations.length > 0);
              this.myGrouping.questions[0].answer_Id = obs.answer_Id;
            },
            error => console.log('Error updating observations | ' + (<Error>error).message)
          );
        });
      });
  }

  /**
  * Deletes an Observation.
  */
  deleteIssue(observationId, autoGenerated: boolean) {
    let msg = "Are you sure you want to delete this issue?";

    if (autoGenerated === false) {
      const dialogRef = this.dialog.open(ConfirmComponent);
      dialogRef.componentInstance.confirmMessage = msg;

      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          this.deleteIssueMaps(observationId);
          this.observationSvc.deleteObservation(observationId).subscribe();
          let deleteIndex = null;

          for (let i = 0; i < this.extras.observations.length; i++) {
            if (this.extras.observations[i].observation_Id === observationId) {
              deleteIndex = i;
            }
          }
          this.extras.observations.splice(deleteIndex, 1);
          this.myGrouping.questions[0].hasObservation = (this.extras.observations.length > 0);
        }
      });
    } else if (autoGenerated === true) {
      this.observationSvc.deleteObservation(observationId).subscribe();
      let deleteIndex = null;

      for (let i = 0; i < this.extras.observations.length; i++) {
        if (this.extras.observations[i].observation_Id === observationId) {
          deleteIndex = i;
        }
      }
      this.extras.observations.splice(deleteIndex, 1);
      this.myGrouping.questions[0].hasObservation = (this.extras.observations.length > 0);
    }
  }

  /* This function is used for 508 compliance. 
  * It allows the user to select the "Yes"/"No", "Comment" and "Mark for review" buttons
  * via the "Enter" key in case they can't use a mouse.
  */
  checkKeyPress(event: any, q: Question, buttonType: string, answer: string = "") {
    if (event) {
      if (event.key === "Enter") {

        // For "Yes"/"No" buttons
        if (buttonType == "answer" && answer != "") {
          this.storeAnswer(q, answer);
        }

        // For the "Comment" button
        if (buttonType == "comment") {
          this.toggleComment(q);
        }

        // For the "MFR" button
        if (buttonType == "mfr") {
          this.saveMFR(q);
        }
      }
    }
  }
}