import { Component, Input, OnInit, ViewChild } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';
import { CompletionService } from '../../../services/completion.service';
import { ConfigService } from '../../../services/config.service';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { LayoutService } from '../../../services/layout.service';
import { NCUAService } from '../../../services/ncua.service';
import { ObservationsService } from '../../../services/observations.service';
import { QuestionsService } from '../../../services/questions.service';
import { Answer, Question, QuestionGrouping } from '../../../models/questions.model';
import { QuestionFilterService } from '../../../services/filtering/question-filter.service';
import { ConfirmComponent } from '../../../dialogs/confirm/confirm.component';
import { QuestionDetailsContentViewModel } from '../../../models/question-extras.model';
import { GroupingDescriptionComponent } from '../grouping-description/grouping-description.component';
import { IssuesComponent } from '../issues/issues.component';
import { Observation } from '../observations/observations.model';
import { QuestionExtrasDialogComponent } from '../question-extras-dialog/question-extras-dialog.component';
import { CieService } from '../../../services/cie.service';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
  selector: 'app-question-block-cie',
  templateUrl: './question-block-cie.component.html',
  styleUrls: ['./question-block-cie.component.scss']
})
export class QuestionBlockCieComponent implements OnInit {
  @Input() myGrouping: QuestionGrouping;
  @ViewChild('groupingDescription') groupingDescription: GroupingDescriptionComponent;

  private _timeoutId: NodeJS.Timeout;
  extras: QuestionDetailsContentViewModel;
  dialogRef: MatDialogRef<any>;

  answerOptions = [];
  percentAnswered = 0;

  summaryBoxMax = 275;

  textPlaceholderEmpty = "Type answer here...";
  textPlaceholderNA = "Explain why this question is Not Applicable here (Optional)";
  freeResponseAnswers: Map<number, string> = new Map<number, string>();

  freeResponseSegment = "";
  //convoBuffer = '\n- - End of Response - -\n';

  showQuestionIds = false;

  maturityModelId: number;
  maturityModelName: string;

  options: any =  {
    eagerSupplemental: true,
    showMfr: true
  };

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
    public cieSvc: CieService,
    public dialog: MatDialog,
    private observationSvc: ObservationsService,
    private navSvc: NavigationService
  ) {

  }

  /**
  *
  */
  ngOnInit(): void {
    //this.setIssueMap();
    this.myGrouping.questions.sort((a, b) => a.questionId - b.questionId);
    if (this.assessSvc.assessment.maturityModel.modelName != null) {
      this.answerOptions = this.assessSvc.assessment.maturityModel.answerOptions;
      this.maturityModelId = this.assessSvc.assessment.maturityModel.modelId;
      this.maturityModelName = this.assessSvc.assessment.maturityModel.modelName;
      // this.freeResponseAnswers.clear();
      // this.cieSvc.feedbackMap.clear();
      this.myGrouping.questions.forEach(question => {
        this.freeResponseAnswers.set(question.questionId, question.freeResponseAnswer);
      });
      this.refreshReviewIndicator();
      this.refreshPercentAnswered();

    }

    this.showQuestionIds = false; //this.configSvc.showQuestionAndRequirementIDs();
  
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

  shouldIShow(question: Question) {
    let visibility = false;
    if (question.parentQuestionId == null) {
      return true;
    }
    this.myGrouping.questions.forEach(q => {
      if (q.questionId == question.parentQuestionId) {
        if (q.freeResponseAnswer != null && q.freeResponseAnswer != '') {
          visibility = true;
        }
        if (this.freeResponseAnswers.get(q.questionId) != null 
          && this.freeResponseAnswers.get(q.questionId) != '') {
          visibility = true;
        }
        if (q.answer == 'NA') {
          visibility = false;
        }
      } 
        
    });
    return visibility;
  }

  isParentNA(parentQuestionId: any) {
    if (parentQuestionId == null) {
      return false;
    }
    let isNA = false;
    this.myGrouping.questions.forEach(q => {
      if (q.questionId == parentQuestionId) {
        if (q.answer == 'NA') {
          isNA = true;
        }
      } 
    });
    return isNA;
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
      // comment: q.comment,
      // feedback: q.feedback,
      comment: q.comment,
      feedback: q.feedback,
      markForReview: q.markForReview,
      reviewed: q.reviewed,
      is_Component: q.is_Component,
      is_Requirement: q.is_Requirement,
      is_Maturity: q.is_Maturity,
      componentGuid: q.componentGuid,
      freeResponseAnswer: this.freeResponseAnswers.get(q.questionId)
    };

    // Errors out on ISE answers. Commenting out for now.
    //this.completionSvc.setAnswer(q.questionId, q.answer);

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    this.questionsSvc.storeAnswer(answer).subscribe
      (result => {
        // this.checkForIssues(q, oldAnswerValue);
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
      if (q.displayNumber != 'Question K') {
        if (q.parentQuestionId == null || (q.parentQuestionId != null && q.answer == 'NA')) {
          totalCount++;
          if ( q.freeResponseAnswer != null && q.freeResponseAnswer != '') {
            answeredCount++;
          }
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
        componentGuid: q.componentGuid,
        freeResponseAnswer: q.freeResponseAnswer
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
   * Very similar to 'storeAltText' above. Text box is at the end of each question set, and
   * attaches to the parent statement.
   * @param q
  */
  changeText(q: Question, e: any) {
    // if they clicked on the same answer that was previously set, "un-set" it

    q.freeResponseAnswer = this.cieSvc.applyContactAndEndTag(e.target.value, '\n- - End of Response - -\n');
    this.freeResponseAnswers.set(q.questionId, q.freeResponseAnswer);
    const answer: Answer = {
      answerId: q.answer_Id,
      questionId: q.questionId,
      questionType: q.questionType,
      questionNumber: "0",
      answerText: q.answer,
      altAnswerText: q.altAnswerText,
      comment: this.cieSvc.commentMap.get(q.questionId),
      feedback: this.cieSvc.feedbackMap.get(q.questionId),
      markForReview: q.markForReview,
      reviewed: q.reviewed,
      is_Component: q.is_Component,
      is_Requirement: q.is_Requirement,
      is_Maturity: q.is_Maturity,
      componentGuid: q.componentGuid,
      freeResponseAnswer: q.freeResponseAnswer
    };

    // Errors out on ISE answers. Commenting out for now.
    //this.completionSvc.setAnswer(q.questionId, q.answer);

    this.refreshReviewIndicator();
    this.refreshPercentAnswered();

    this.questionsSvc.storeAnswer(answer).subscribe
      (result => {
        //this.checkForIssues(q, oldAnswerValue);
      });
  }

  // applyContactAndEndTag(q: Question) {
  //   let bracketContact = '[' + this.assessSvc.assessment.assessmentName + ']';

  //   if (q.freeResponseAnswer.indexOf(bracketContact) !== 0) {
  //     if (!!q.freeResponseAnswer) {
  //       if (q.freeResponseAnswer.indexOf('[') !== 0) {
  //         this.freeResponseSegment = bracketContact + ' ' + q.freeResponseAnswer;
  //         q.freeResponseAnswer = this.freeResponseSegment + this.convoBuffer;
  //       }

  //       else {
  //         let previousContactInitials = q.freeResponseAnswer.substring(q.freeResponseAnswer.lastIndexOf('[') + 1, q.freeResponseAnswer.lastIndexOf(']'));
  //         let endOfLastBuffer = q.freeResponseAnswer.lastIndexOf(this.convoBuffer) + this.convoBuffer.length;
  //         if (previousContactInitials !== this.assessSvc.assessment.assessmentName) {
  //           // if ( endOfLastBuffer !== q.altAnswerText.length || endOfLastBuffer !== q.altAnswerText.length - 1) {
  //           let oldComments = q.freeResponseAnswer.substring(0, endOfLastBuffer);
  //           let newComment = q.freeResponseAnswer.substring(oldComments.length);

  //           q.freeResponseAnswer = oldComments + bracketContact + ' ' + newComment + this.convoBuffer;
  //           // }
  //         }
  //       }
  //     }
  //   }

  //   return q;
  // }

  autoResize(id: number) {
    let textArea = document.getElementById("freeResponse-q-" + id);
    textArea.style.overflow = 'hidden';
    // textArea.style.overflowY = 'hidden';
    textArea.style.height = '0px';
    textArea.style.height = textArea.scrollHeight + 'px';
    if (textArea.scrollHeight > this.summaryBoxMax) {
      textArea.style.height = this.summaryBoxMax + 'px';
      textArea.style.overflowY = 'scroll';

    }
  }

  
  /**
   *
   * @param observationid
   */
  addEditIssue(parentId, observationId) {
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
      title: this.myGrouping.title,
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
          //this.deleteIssueMaps(observationId);
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

  findChildQuestionIndention(q: any) {
    if (q.parentQuestionId != null){
      let parentBlock = document.getElementById("question-" + q.parentQuestionId);    

      if (parentBlock != null && parentBlock.style?.paddingLeft != null) {
        let paddingNumber = parseInt(parentBlock.style?.paddingLeft.substring(0, parentBlock.style?.paddingLeft.indexOf('p')));
        paddingNumber += 36;
        return paddingNumber.toString() + 'px';
      }
    }
    return '0px';
  }

  /**
   * Returns 'inline' if any details/extras exist
   */
  hasDetails(q: Question): string {
    if (q.comment !== null && q.comment.length > 0) {
      return 'inline';
    }
    // if (q.documentIds !== null && q.documentIds.length != 0) {
    //   return 'inline';
    // }
    if (q.hasObservation) {
      return 'inline';
    }
    if (q.feedback !== null && q.feedback.length > 0) {
      return 'inline';
    }
    if (q.markForReview) {
      return 'inline';
    }
    return 'none';
  }

  /**
   *
   */
  openExtras(q) {
    if (!q.questionType) {
      q.questionType = 'Maturity';
    }
    this.dialog.open(QuestionExtrasDialogComponent, {
      data: {
        question: q,
        options: {
          eagerSupplemental: true,
          showMfr: true
        }
      },
      width: this.layoutSvc.hp ? '90%' : '50%',
      maxWidth: this.layoutSvc.hp ? '90%' : '50%'
    });
  }


  // getDetails(q: Question) {
  //   this.questionsSvc.getDetails(q.questionId, q.questionType).subscribe(
  //     (details) => {
  //       this.extras = details;
  //       this.extras.questionId = q.questionId;

  //     });
  // }

}
