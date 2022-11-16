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
import { MatDialog, MatDialogRef, MatDialogConfig } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { QuestionsService } from '../../../services/questions.service';
import { GroupingDescriptionComponent } from '../grouping-description/grouping-description.component';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { NCUAService } from '../../../services/ncua.service';
import { LayoutService } from '../../../services/layout.service';
import { Finding } from './../findings/findings.model';
import { QuestionDetailsContentViewModel } from '../../../models/question-extras.model';
import { ConfirmComponent } from '../../../dialogs/confirm/confirm.component';
import { FindingsService } from '../../../services/findings.service';
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
  dialogRef: MatDialogRef <any>;

  percentAnswered = 0;
  answerOptions = [];

  altTextPlaceholder = "Description, explanation and/or justification for alternate answer";
  altTextPlaceholder_ACET = "Description, explanation and/or justification for compensating control";
  altTextPlaceholder_ISE = "Description, explanation and/or justification for comment";
  textForSummary = "Statement Summary (insert comments)";
  summaryCommentCopy = "";
  summaryEditedCheck = false; 

  contactInitials = "";
  altAnswerSegment = "";
  convoBuffer = '\n- - End of Comment - -\n';
  summaryConvoBuffer = '\n- - End of Summary Comment - -\n';


  // To do: eventually, these should be pulled in dynamically.
  importantQuestions = new Set([7569, 7574, 7575, 7578, 7579, 7580, 7581, 7583, 7585, 7586, 7587, 7595, 7596, 
    7597, 7598, 7599, 7600, 7601, 7605, 7606, 7608, 7610, 7613, 7614, 7615, 7616, 7620, 7625, 7629, 7630, 
    7631, 7632, 7634, 7635, 7636, 7637, 7638, 7640, 7642, 7643, 7644, 7646, 7647, 7648, 7651, 7653, 7654, 
    7658, 7659, 7662, 7663, 7664, 7665, 7666, 7667, 7668, 7672, 7673, 7675, 7677, 7681, 7682, 7684, 7685, 
    7688, 7692, 7695, 7696, 7697, 7701]);
  
  // Used to place buttons/text boxes at the bottom of each subcategory
  finalScuepQuestion = new Set ([7576, 7581, 7587, 7593, 7601, 7606, 7611, 7618]);
  finalCoreQuestion = new Set ([7627, 7632, 7638, 7644, 7651, 7654, 7660, 7668, 7673, 7678, 7682, 7686, 7690, 7693, 7698, 7701]);
  finalCorePlusQuestion = new Set ([7706, 7710, 7718, 7730, 7736, 7739, 7746, 7756, 7773, 7784, 7795, 7807, 7826, 7834, 7842, 7852]);
  finalExtraQuestion = new Set ([7868, 7874, 7890, 7901, 7911, 7918, 7946]);

  showQuestionIds = false;

  iseExamLevel: string = "";
  showCorePlus: boolean = false;
  showIssues: boolean = true;
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
    public completionSvc: CompletionService,
    public ncuaSvc: NCUAService,
    public dialog: MatDialog,
    private findSvc: FindingsService
  ) { 
    
  }

  /**
  *
  */
  ngOnInit(): void {
    this.setIssueMap();
    
    if (this.assessSvc.assessment.maturityModel.modelName != null) {
      this.iseExamLevel = this.ncuaSvc.getExamLevel();

      this.summaryCommentCopy = this.myGrouping.questions[0].comment;

      this.questionsSvc.getDetails(this.myGrouping.questions[0].questionId, this.myGrouping.questions[0].questionType).subscribe(
        (details) => {
          this.extras = details;
          this.extras.questionId = this.myGrouping.questions[0].questionId;

          this.extras.findings.forEach(find => {
            if (find.auto_Generated === 1) {
              find.question_Id = this.myGrouping.questions[0].questionId;
              
              // This is a check for post-merging ISE assessments.
              // If an issue existed, but all answers were changed to "Yes" on merge, delete the issue.
              if (this.ncuaSvc.questionCheck.get(find.question_Id) !== undefined) {
                this.ncuaSvc.issueFindingId.set(find.question_Id, find.finding_Id);
              } else {
                this.deleteIssue(find.finding_Id, true);
              }
              
            }
          });
          
          this.ncuaSvc.issuesFinishedLoading = true;
      });

      this.answerOptions = this.assessSvc.assessment.maturityModel.answerOptions;

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

  displayTooltip(maturityModelId: number, option: string) {
    let toolTip = this.questionsSvc.getAnswerDisplayLabel(maturityModelId, option);
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

  deleteIssueMaps(findingId: number) {
    const iterator = this.ncuaSvc.issueFindingId.entries();
    let parentKey = 0;

    for (let value of iterator) {
      if (value[1] === findingId) {
        parentKey = value[0];
        this.ncuaSvc.questionCheck.delete(parentKey);
        this.ncuaSvc.issueFindingId.delete(parentKey);
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

    // always show parent questions
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
        if (q.questionId < 7853 && this.showCorePlus === true) { 
          if (visible) {
            this.refreshPercentAnswered();
            return true;
          }
        } else if (q.questionId >= 7853 && this.ncuaSvc.showExtraQuestions === true) {
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

      if (value >= 1 && !this.ncuaSvc.issueFindingId.has(q.parentQuestionId)) {
        if (!this.ncuaSvc.deleteHistory.has(q.parentQuestionId)) {
          this.autoGenerateIssue(q.parentQuestionId, 0);
        }
      }
    } else if (oldAnswerValue === 'N' && (q.answer === 'Y' || q.answer === 'U')) {
      value--;
      if (value < 1) {
        this.ncuaSvc.questionCheck.delete(q.parentQuestionId);

        if (this.ncuaSvc.issueFindingId.has(q.parentQuestionId)) {
          let findId = this.ncuaSvc.issueFindingId.get(q.parentQuestionId);
          this.ncuaSvc.issueFindingId.delete(q.parentQuestionId);
          this.deleteIssue(findId, true);
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
    if(q.comment === null || q.comment === '') {
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
  storeSummaryComment(q: Question, e: any) {
    this.summaryCommentCopy = e.target.value;
    this.summaryEditedCheck = true;    

    let summarySegment = '';
    // this.summaryCommentCopy = q.comment;
    if (this.assessSvc.isISE()) {
      let bracketContact = '[' + this.contactInitials + ']';

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
          console.log('in get summary: ' + this.summaryCommentCopy)
          comment = this.summaryCommentCopy;
          console.log('comment: ' + comment)
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
      if (this.isFinalQuestion(id)) {
        return true;
      }
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

  updateCorePlusStatus(q: Question) {
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
      if (this.extras?.findings.length === 1) {
        return ('Show 1 Issue');
      } else if (this.extras?.findings.length > 1) {
        return ('Show ' + this.extras.findings.length + ' Issues');
      } else {
        return ('Show Issues');
      }
    } else if (this.showIssues === true) {
      return ('Hide Issues');
    }
  }

  /**
   *
   * @param findid
   */
  addEditIssue(parentId, findid) {
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

    const find: Finding = {
      question_Id: parentId,
      answer_Id: this.myGrouping.questions[0].answer_Id,
      finding_Id: findid,
      summary: '',
      finding_Contacts: null,
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
      auto_Generated: 0
    };

    this.dialog.open(IssuesComponent, {
      data: find,
      disableClose: true,
      width: this.layoutSvc.hp ? '90%' : '60vh',
      height: this.layoutSvc.hp ? '90%' : '85vh',
    }).afterClosed().subscribe(result => {
      const answerID = find.answer_Id;
      this.findSvc.getAllDiscoveries(answerID).subscribe(
        (response: Finding[]) => {
          this.extras.findings = response;
          this.myGrouping.questions[0].hasDiscovery = (this.extras.findings.length > 0);
          this.myGrouping.questions[0].answer_Id = find.answer_Id;
        },
        error => console.log('Error updating findings | ' + (<Error>error).message)
      );
    });
  }

  // ISE "issues" should be generated if an examiner answers 'No' to
  // 2 or more important questions with no popup.
  autoGenerateIssue(parentId, findId) {
    let name = "";
    let desc = "";

    if (parentId <= 7674) {
      name = ("Information Security Program, " + this.myGrouping.title);
    } else {
      name = ("Cybersecurity Controls, " + this.myGrouping.title);
    }

    this.questionsSvc.getActionItems(parentId,findId).subscribe(
      (data: any) => {
        // Used to generate a description for ISE reports even if a user doesn't open the issue.
        desc = data[0]?.description;

        const find: Finding = {
          question_Id: parentId,
          answer_Id: this.myGrouping.questions[0].answer_Id,
          finding_Id: findId,
          summary: '',
          finding_Contacts: null,
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
          auto_Generated: 1
        };

        this.ncuaSvc.issueFindingId.set(parentId, findId);
        this.findSvc.saveDiscovery(find).subscribe(() => {
          const answerID = find.answer_Id;
          this.findSvc.getAllDiscoveries(answerID).subscribe(
            (response: Finding[]) => {
              for (let i = 0; i < response.length; i++) {
                if (response[i].auto_Generated === 1) {
                  this.ncuaSvc.issueFindingId.set(parentId, response[i].finding_Id);
                }
              }
              this.extras.findings = response;
              this.myGrouping.questions[0].hasDiscovery = (this.extras.findings.length > 0);
              this.myGrouping.questions[0].answer_Id = find.answer_Id;
            },
            error => console.log('Error updating findings | ' + (<Error>error).message)
          );
        });
      });
  }
  
  /**
  * Deletes a discovery.
  * @param findingToDelete
  */
  deleteIssue(findingId, autoGenerated: boolean) {
    let msg = "Are you sure you want to delete this issue?";
    
    if (autoGenerated === false) {
      const dialogRef = this.dialog.open(ConfirmComponent);
      dialogRef.componentInstance.confirmMessage = msg;
  
      dialogRef.afterClosed().subscribe(result => {
        if (result) {
          this.deleteIssueMaps(findingId);
          this.findSvc.deleteFinding(findingId).subscribe();
          let deleteIndex = null;
  
          for (let i = 0; i < this.extras.findings.length; i++) {
            if (this.extras.findings[i].finding_Id === findingId) {
              deleteIndex = i;
            }
          }
          this.extras.findings.splice(deleteIndex, 1);
          this.myGrouping.questions[0].hasDiscovery = (this.extras.findings.length > 0);
        }
      });
    } else if (autoGenerated === true) {
        this.findSvc.deleteFinding(findingId).subscribe();
        let deleteIndex = null;
  
          for (let i = 0; i < this.extras.findings.length; i++) {
            if (this.extras.findings[i].finding_Id === findingId) {
              deleteIndex = i;
            }
          }
        this.extras.findings.splice(deleteIndex, 1);
        this.myGrouping.questions[0].hasDiscovery = (this.extras.findings.length > 0);
      }
  }

  
  
}
