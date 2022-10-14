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
  textForSummary = "Results of Review (insert comments)";
  summaryCommentCopy = "";
  summaryEditedCheck = false; 

  contactInitials = "";
  altAnswerSegment = "";
  convoBuffer = '\n- - End of Comment - -\n';

  // To do: Add this to a db table and pull in dynamically.
  importantQuestions = new Set([7190, 7195, 7196, 7198, 7199, 7200, 7201, 7203, 7204, 7205,
    7206, 7208, 7209, 7210, 7211, 7212, 7213, 7214, 7216, 7217, 7219, 7220, 7222, 7223, 7224, 
    7225, 7227, 7233, 7235, 7236, 7237, 7238, 7240, 7241, 7242, 7243, 7244, 7246, 7247, 7248, 
    7249, 7251, 7252, 7253, 7256, 7258, 7259, 7263, 7264, 7267, 7268, 7269, 7270, 7271, 7272, 
    7273, 7275, 7276, 7278, 7280, 7284, 7285, 7287, 7288, 7291, 7295, 7298, 7299, 7300, 7304]
  );

  issueCheck = new Map();
  issueFindingId = new Map();
  

  // Used to place buttons/text boxes at the bottom of each subcategory
  finalScuepQuestion = new Set ([7196, 7201, 7206, 7214, 7217, 7220, 7225]);
  finalCoreQuestion = new Set ([7233, 7238, 7244, 7249, 7256, 7259, 7265, 7273, 7276, 7281, 7285, 7289, 7293, 7296, 7301, 7304]);
  finalCorePlusQuestion = new Set ([7312, 7316, 7322, 7332, 7338, 7344, 7351, 7359, 7366, 7373, 7381, 7390, 7395, 7400, 7408]);
  finalExtraQuestion = new Set ([7421, 7429, 7444, 7450, 7458, 7465]);

  showQuestionIds = false;

  iseExamLevel: string = "";
  showCorePlus: boolean = false;
  showIssues: boolean = false;
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

      this.questionsSvc.getDetails(this.myGrouping.questions[0].questionId, this.myGrouping.questions[0].questionType).subscribe(
        (details) => {
          this.extras = details;
          this.extras.questionId = this.myGrouping.questions[0].questionId;

          this.extras.findings.forEach(find => {
            if (find.auto_Generated === 1) {
              find.question_Id = this.myGrouping.questions[0].questionId;
              
              if (!this.issueFindingId.has(find.question_Id)) {
                this.issueFindingId.set(find.question_Id, find.finding_Id);
              }
            }
        });
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
  * Repopulates the map variables to correctly track/delete issues
  */
  setIssueMap() {
    let parentId = 0;
    let count = 0;

    this.myGrouping.questions.forEach(question => {
      if (question.answer === 'N') {
        if (this.importantQuestions.has(question.questionId)) {
          parentId = question.parentQuestionId;
          count++;
        }
        this.issueCheck.set(parentId, count);
      }
    });
  }

  /**
   *
   * @param ans
   */
  showThisOption(ans: string) {
    return true;
  }

  shouldIShow(q: Question) {
    if (this.iseExamLevel === 'SCUEP' && q.maturityLevel === 1) {
      return true;
    } else if (this.iseExamLevel === 'CORE') {
      if (q.maturityLevel === 2) {
        return true;
      } else if (q.maturityLevel === 3) {
        if (q.questionId < 7409 && this.showCorePlus === true) { 
          return true;
        } else if (q.questionId >= 7409 && this.ncuaSvc.showExtraQuestions === true) {
          return true;
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

    this.questionsSvc.storeAnswer(answer).subscribe
    (result => {
      this.checkForIssues(q, newAnswerValue);
    });
  }

  checkForIssues(q: Question, newAnswerValue: string) {
    if (q.answer === 'N') {
      if (this.importantQuestions.has(q.questionId)) {
        if (!this.issueCheck.has(q.parentQuestionId)) {
          this.issueCheck.set(q.parentQuestionId, 1);
        } else {
          let num = this.issueCheck.get(q.parentQuestionId);
          num += 1;
          this.issueCheck.set(q.parentQuestionId, num);
          
          if (num >= 2 && !this.issueFindingId.has(q.parentQuestionId)) {
            this.autoGenerateIssue(q.parentQuestionId, 0);
          }
        }
      }
    } else if (q.answer === 'Y' || q.answer === 'U') {
      if (this.issueCheck.has(q.parentQuestionId)) {
        if (this.importantQuestions.has(q.questionId)) {
          let num = this.issueCheck.get(q.parentQuestionId);
          num -= 1;
        
          if (num < 2) {
            if (this.issueFindingId.has(q.parentQuestionId)) {
              let findId = this.issueFindingId.get(q.parentQuestionId);
              this.deleteIssue(findId, true);
              this.issueFindingId.delete(q.parentQuestionId);
            }
          }

          if (num <= 0) {
            this.issueCheck.delete(q.parentQuestionId);
          } else {
            this.issueCheck.set(q.parentQuestionId, num);
          }
        }
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
    // q.comment = e.target.value;
    // this.summaryCommentCopy = q.comment;
    this.summaryCommentCopy = e.target.value;
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
        comment: e.target.value,
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
    if (this.iseExamLevel !== 'SCUEP') {
      // Question 6 (Maturity question id 7259) does not have any CORE+ questions and does not need this.
      if (this.isFinalQuestion(id) && id !== 7259) {
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
  addEditIssue(findid) {
    /* 
    * Per the customer's requests, an Issue's title should include the main 
    * grouping header text and the sub grouping header text.
    * this is an attempt to re-create that data which is outside of an Issue's scope.
    * SCUEP q's 1- 7 and CORE/CORE+ q's 1 - 10 use one domain, CORE/CORE+ q's 11+ have a different domain
    * this checks the q's parentQuestionId to see if it's SCUEP 1 - 7 or CORE/CORE+ 1 - 10 and sets the name accordingly
    */
    let name = "";
    if (this.myGrouping.questions[0].questionId <= 7281) {
      name = ("Information Security Program, " + this.myGrouping.title);
    } else {
      name = ("Cybersecurity Controls, " + this.myGrouping.title);
    }

    const find: Finding = {
      question_Id: this.myGrouping.questions[0].questionId,
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
      description: null,
      sub_Risk_Area_Id: null,
      subRiskArea: null,
      disposition: null,
      identified_Date: null,
      due_Date: null,
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
  // 2 or more important questions.
  autoGenerateIssue(parentId, findId) {
    let name = "";
    if (parentId <= 7281) {
      name = ("Information Security Program, " + this.myGrouping.title);
    } else {
      name = ("Cybersecurity Controls, " + this.myGrouping.title);
    }

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
      description: null,
      sub_Risk_Area_Id: null,
      subRiskArea: null,
      disposition: null,
      identified_Date: null,
      due_Date: null,
      citations: null,
      auto_Generated: 1
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
          this.issueFindingId.set(parentId, response[0].finding_Id);
          this.extras.findings = response;
          this.myGrouping.questions[0].hasDiscovery = (this.extras.findings.length > 0);
          this.myGrouping.questions[0].answer_Id = find.answer_Id;
        },
        error => console.log('Error updating findings | ' + (<Error>error).message)
      );
    });
  }
  
  /**
  * Deletes a discovery.
  * @param findingToDelete
  */
  deleteIssue(findingId, autoGenerated: boolean) {
    let msg = "";
    
    if (autoGenerated === false) {
      msg = "Are you sure you want to delete this issue?";

      const dialogRef = this.dialog.open(ConfirmComponent);
      dialogRef.componentInstance.confirmMessage = msg;
  
      dialogRef.afterClosed().subscribe(result => {
        if (result) {
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
