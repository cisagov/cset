import { ResourceLibraryService } from './../../../services/resource-library.service';
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
import { Component, EventEmitter, Input, OnInit, Output, ViewEncapsulation, ViewChild, ElementRef } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { OkayComponent } from '../../../dialogs/okay/okay.component';
import { ConfirmComponent } from '../../../dialogs/confirm/confirm.component';
// eslint-disable-next-line max-len
import { ReferenceDocLink, QuestionDetailsContentViewModel, QuestionInformationTabData } from '../../../models/question-extras.model';
import { Answer, Question } from '../../../models/questions.model';
import { ConfigService } from '../../../services/config.service';
import { FileUploadClientService } from '../../../services/file-client.service';
import { ObservationsService } from '../../../services/observations.service';
import { QuestionsService } from '../../../services/questions.service';
import { AuthenticationService } from './../../../services/authentication.service';
import { ObservationsComponent } from '../observations/observations.component';
import { Observation } from '../observations/observations.model';
import { AssessmentService } from '../../../services/assessment.service';
import { ComponentOverrideComponent } from '../../../dialogs/component-override/component-override.component';
import { LayoutService } from '../../../services/layout.service';
import { TranslocoService } from '@ngneat/transloco';
import { CieService } from '../../../services/cie.service';



@Component({
  selector: 'app-question-extras',
  templateUrl: './question-extras.component.html',
  styleUrls: ['./question-extras.component.css'],
  encapsulation: ViewEncapsulation.None,
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class QuestionExtrasComponent implements OnInit {

  @Input() myQuestion: Question;
  @Output() changeExtras = new EventEmitter();
  @Output() changeComponents = new EventEmitter();
  @ViewChild('questionExtras') questionExtrasDiv: ElementRef;

  @Input() myOptions: any;

  // ISE options
  @Input() ncuaDisplay: boolean = false;
  @Input() iconsToDisplay: string[] = [];

  extras: QuestionDetailsContentViewModel;
  tab: QuestionInformationTabData;
  expanded = false;
  mode: string;  // selector for which data is being displayed, 'DETAIL', 'SUPP', 'CMNT', 'DOCS', 'OBSV', 'FDBK'.
  answer: Answer;
  dialogRef: MatDialogRef<OkayComponent>;

  msgNoSupplemental: string = `(${this.tSvc.translate('extras.no supplemental available')})`;

  showMfr = false;

  showQuestionIds = false;

  toggleComponent = false;

  /**
   * Stores the original document title, in case the user escapes out of an unwanted change
   */
  origTitle: string;

  constructor(
    public questionsSvc: QuestionsService,
    private observationSvc: ObservationsService,
    public fileSvc: FileUploadClientService,
    public dialog: MatDialog,
    public configSvc: ConfigService,
    public authSvc: AuthenticationService,
    public assessSvc: AssessmentService,
    public layoutSvc: LayoutService,
    private tSvc: TranslocoService,
    private cieSvc: CieService,
    private resourceLibSvc: ResourceLibraryService
  ) {
  }


  ngOnInit() {
    this.showQuestionIds = this.configSvc.showQuestionAndRequirementIDs();

    if (this.assessSvc.usesMaturityModel('CIE')) {
      this.cieSvc.feedbackMap.set(this.myQuestion.questionId, this.myQuestion.feedback);
      this.cieSvc.commentMap.set(this.myQuestion.questionId, this.myQuestion.comment);
    }

    if (!!this.myOptions) {
      if (this.myOptions.eagerSupplemental) {
        this.toggleExtras('SUPP');
      }

      this.showMfr = this.myOptions.showMfr;
    }
  }

  /**
   *
   */
  showOverrideDialog(componentType: any): void {
    const dialogRef = this.dialog.open(ComponentOverrideComponent, {
      data: { componentType: componentType, component_Symbol_Id: componentType.component_Symbol_Id, myQuestion: this.myQuestion },
    });
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.changeComponents.emit(result);
      }
    });
  }

  /**
   * Shows/hides the "expand" section.
   * @param q
   * @param feature
   */
  toggleExtras(clickedMode: string) {
    if (this.expanded && clickedMode === this.mode) {

      // hide
      this.expanded = false;
      this.mode = '';
      return;
    }

    this.expanded = true;
    this.mode = clickedMode;

    this.show();
  }

  scrollToExtras() {
    setTimeout(() => {
      if (this.questionExtrasDiv.nativeElement.getBoundingClientRect().bottom > window.innerHeight) {
        this.questionExtrasDiv.nativeElement.scrollIntoView({ block: 'end', behavior: 'smooth' });
      }
    })
  }

  /**
   *
   */
  show() {
    // we already have content - don't make another server call
    if (this.tab != null) {
      //this.scrollToExtras();
      return;
    }


    // Call the API for content
    this.questionsSvc.getDetails(this.myQuestion.questionId, this.myQuestion.questionType).subscribe(
      (details) => {
        this.extras = details;
        if (details.is_Component === true) {
          this.myQuestion.is_Component = true;
          this.toggleComponent = true;
        }

        this.extras.questionId = this.myQuestion.questionId;

        // populate my details with the first "non-null" tab
        this.tab = this.extras.listTabs?.find(t => t.requirementFrameworkTitle != null) ?? this.extras.listTabs[0];


        // Component detail toggle
        if (this.toggleComponent == true) {
          this.toggleExtras('COMPONENT')
          this.toggleComponent = false;
        }

        // add questionIDs to related questions for debug if configured to do so
        if (this.showQuestionIds) {
          if (this.tab) {
            if (this.tab.isComponent) {
            } else {
              if (!!this.tab.questionsList) {
                this.tab.questionsList.forEach((q: any) => {
                  q.questionText += '<span class="debug-highlight">' + q.questionID + '</span>';
                });
              }
            }
          }
        }
      });
  }

  /**
   * Translates the level to the user's language.
   * Returns empty string if no level is present.
   */
  salLevel(level: string) {
    if (!level) {
      return '';
    }
    return this.tSvc.translate('titles.sal.level.' + level.toLowerCase());
  }

  /**
   *
   * @param e
   */
  saveComment(e) {
    this.defaultEmptyAnswer();
    if (this.assessSvc.usesMaturityModel('CIE')) {
      this.myQuestion.comment = this.cieSvc.applyContactAndEndTag(e.target.value, '\n- - End of Comment - -\n');
      this.cieSvc.commentMap.set(this.myQuestion.questionId, this.myQuestion.comment);
    }
    else {
      this.answer.comment = e.target.value;
    }
    this.saveAnswer();
  }

  /**
   *
   * @returns
   */
  showDocumentsIcon(): boolean {
    return true;
  }

  /**
  *
  * @param e
  */
  saveFeedback(e) {
    this.defaultEmptyAnswer();
    if (this.assessSvc.usesMaturityModel('CIE')) {
      this.myQuestion.feedback = this.cieSvc.applyContactAndEndTag(e.target.value, '\n- - End of Feedback - -\n');
      this.cieSvc.feedbackMap.set(this.myQuestion.questionId, this.myQuestion.feedback);
    }
    else {
      this.myQuestion.feedback = e.target.value;
    }

    this.saveAnswer();
  }

  /**
   *
   * @param q
   */
  storeReviewed(e: any) {
    this.defaultEmptyAnswer();
    this.myQuestion.reviewed = e.target.checked;
    this.answer.reviewed = this.myQuestion.reviewed;
    this.saveAnswer();
  }

  /**
   * Creates an Answer if one does not already exist.
   */
  defaultEmptyAnswer() {
    if (this.answer == null) {
      const newAnswer: Answer = {
        answerId: this.myQuestion.answer_Id,
        questionId: this.myQuestion.questionId,
        questionType: this.myQuestion.questionType,
        questionNumber: this.myQuestion.displayNumber,
        answerText: this.myQuestion.answer,
        altAnswerText: this.myQuestion.altAnswerText,
        freeResponseAnswer: this.myQuestion.freeResponseAnswer,
        comment: '',
        feedback: '',
        markForReview: false,
        reviewed: false,
        is_Component: this.myQuestion.is_Component,
        is_Requirement: this.myQuestion.is_Requirement,
        is_Maturity: this.myQuestion.is_Maturity,
        componentGuid: ''
      };

      this.answer = newAnswer;
    }
  }

  /**
   *
   */
  saveAnswer() {
    this.defaultEmptyAnswer();

    this.answer.questionId = this.myQuestion.questionId;
    this.answer.answerText = this.myQuestion.answer;
    this.answer.altAnswerText = this.myQuestion.altAnswerText;
    this.answer.markForReview = this.myQuestion.markForReview;
    this.answer.reviewed = this.myQuestion.reviewed;
    this.answer.comment = this.myQuestion.comment;
    this.answer.feedback = this.myQuestion.feedback;
    this.answer.componentGuid = this.myQuestion.componentGuid;
    this.answer.freeResponseAnswer = this.myQuestion.freeResponseAnswer;

    // Tell the parent (subcategory) component that something changed
    this.changeExtras.emit(null);

    // Tell any observers the new extras
    this.questionsSvc.broadcastExtras(this.extras);

    this.questionsSvc.storeAnswer(this.answer).subscribe(
      (response: number) => {
        this.myQuestion.answer_Id = response;
      },
      error => console.log('Error saving response: ' + (<Error>error).message)
    );
  }


  /**
   * Returns a boolean indicating if there are comments, documents or observations present
   * on the answer.
   * @param mode
   */
  has(mode) {
    switch (mode) {
      case 'CMNT':
        return (this.myQuestion.comment && this.myQuestion.comment.length > 0) ? 'inline' : 'none';

      case 'FDBK':
        return (this.myQuestion.feedback && this.myQuestion.feedback.length > 0) ? 'inline' : 'none';

      case 'DOCS':
        // if the extras have not been pulled, get the indicator from the question list JSON
        if (this.extras == null || this.extras.documents == null) {
          return this.myQuestion.hasDocument ? 'inline' : 'none';
        }
        return (this.extras && this.extras.documents && this.extras.documents.length > 0) ? 'inline' : 'none';

      case 'OBSV':
        // if the extras have not been pulled, get the indicator from the question list JSON
        if (this.extras == null || this.extras.observations == null) {
          return (this.myQuestion.hasObservation) ? 'inline' : 'none';
        }
        return (this.extras && this.extras.observations && this.extras.observations.length > 0) ? 'inline' : 'none';
    }
    return false;
  }

  /**
   *
   * @param observationId
   */
  addEditObservation(observationId) {

    // TODO Always send an empty one for now.
    // At some juncture we need to change this to
    // either send the observation to be edited or
    // send an empty one.
    const obs: Observation = {
      question_Id: this.myQuestion.questionId,
      questionType: this.myQuestion.questionType,
      answer_Id: this.myQuestion.answer_Id,
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
      title: null,
      type: null,
      risk_Area: null,
      sub_Risk: null,
      description: null,
      actionItems: null,
      citations: null,
      auto_Generated: null,
      supp_Guidance: null
    };

    this.dialog.open(ObservationsComponent, {
      data: obs,
      disableClose: true,
      width: this.layoutSvc.hp ? '90%' : '750px',
      maxWidth: this.layoutSvc.hp ? '90%' : '750px',
    }

    )
      .afterClosed().subscribe(result => {
        const answerID = obs.answer_Id;
        this.observationSvc.getAllObservations(answerID).subscribe(
          (response: Observation[]) => {
            this.extras.observations = response;
            for (let i of response) {
              if ((!i.summary) && (!i.resolution_Date) && (!i.issue) && (!i.impact) && (!i.recommendations) && (!i.vulnerabilities)) {
                this.deleteEmptyObservation(i)
              }
            }
            this.myQuestion.hasObservation = (this.extras.observations.length > 0);
            this.myQuestion.answer_Id = obs.answer_Id;
          },
          error => console.log('Error updating observations | ' + (<Error>error).message)
        );

      });

  }

  /**
   * Deletes an empty observation.
   * @param observationToDelete
   */
  deleteEmptyObservation(observationToDelete) {
    this.observationSvc.deleteObservation(observationToDelete.observation_Id).subscribe();
    let deleteIndex = null;

    for (let i = 0; i < this.extras.observations.length; i++) {
      if (this.extras.observations[i].observation_Id === observationToDelete.observation_Id) {
        deleteIndex = i;
      }
    }
    this.extras.observations.splice(deleteIndex, 1);
    this.myQuestion.hasObservation = (this.extras.observations.length > 0);
  };


  /**
   * Deletes an Observation.
   * @param obsToDelete
   */
  deleteObservation(obsToDelete) {
    // Build a message whether the observation has a title or not
    let msg = this.tSvc.translate('observation.delete ' + this.observationOrIssue().toLowerCase() + ' confirm');
    msg = msg.replace('{title}', obsToDelete.summary);

    if (obsToDelete.summary === null) {
      msg = this.tSvc.translate('observation.delete this ' + this.observationOrIssue().toLowerCase() + ' confirm');
    }


    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = msg;

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.observationSvc.deleteObservation(obsToDelete.observation_Id).subscribe();
        let deleteIndex = null;

        for (let i = 0; i < this.extras.observations.length; i++) {
          if (this.extras.observations[i].observation_Id === obsToDelete.observation_Id) {
            deleteIndex = i;
          }
        }
        this.extras.observations.splice(deleteIndex, 1);
        this.myQuestion.hasObservation = (this.extras.observations.length > 0);
      }
    });
  }

  /**
   * Programatically clicks the corresponding file upload element.
   * @param event
   */
  openFileBrowser(event: any) {
    event.preventDefault();
    const element: HTMLElement = document.getElementById('docUpload_q' + this.myQuestion.questionId) as HTMLElement;
    element.click();
  }

  /**
   * Uploads the selected file to the API.
   * @param e The 'file' event
   */
  fileSelect(e) {
    const options = {};
    options['questionId'] = this.myQuestion.questionId;
    options['answerId'] = this.myQuestion.answer_Id;
    options['questionType'] = this.myQuestion.questionType;

    this.fileSvc.fileUpload(e.target.files[0], options)
      .subscribe(resp => {
        // refresh the document list
        if (resp.status === 200 && resp.body) {
          this.extras.documents = resp.body;
          this.questionsSvc.broadcastExtras(this.extras);
        }
        e.target.value = "";
      }
      );
  }

  /**
   * Caches the original title of the document (in case the user cancels out)
   * and flips into edit mode.
   * @param document
   */
  startEdit(document) {
    document.isEdit = true;
    this.origTitle = document.title;
  }

  /**
   * Changes the title of a stored document.
   */
  renameDocument(document) {
    document.isEdit = false;
    if (this.isNullOrWhiteSpace(document.title)) {
      document.title = "click to edit";
    }
    this.questionsSvc.renameDocument(document.document_Id, document.title)
      .subscribe();
  }

  isNullOrWhiteSpace(str) {
    return str === null || str.match(/^[\t ]*$/) !== null;
  }

  /**
   * Reverts any changes to the title and gets out of edit mode.
   * @param document
   */
  abandonEdit(document) {
    document.title = this.origTitle;
    document.isEdit = false;
  }

  /**
   * Deletes a document.
   * @param document
   */
  deleteDocument(document) {
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      "Are you sure you want to delete file '"
      + document.title
      + "?'";
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        // remove from the local model
        this.extras.documents = this.extras.documents.filter(d => d.document_Id !== document.document_Id);
        this.extras.documents.forEach((item, index) => {
          if (item.document_Id == document.document_Id) this.extras.documents.splice(index, 1);
        })
        // push the change to the API
        this.questionsSvc.deleteDocument(document.document_Id, this.myQuestion.questionId)
          .subscribe();

        this.questionsSvc.broadcastExtras(this.extras);
      }
    });
  }

  /**
   * Displays a dialog with questions that have this document attached.
   * @param document
   */
  showRelatedQuestions(document) {
    // call the API to get the list of questions
    this.questionsSvc.getQuestionsForDocument(document.document_Id)
      .subscribe((qlist: number[]) => {
        const array = [];

        // Traverse the local model to get the "display" question numbers
        if (this.questionsSvc.questions) {
          this.questionsSvc.questions.categories.forEach(qg => {
            qg.subCategories.forEach(sc => {
              sc.questions.forEach(q => {
                if (qlist.includes(q.questionId)) {
                  const display = qg.groupHeadingText
                    + (q.is_Maturity ? " " : " #")
                    + q.displayNumber;
                  array.push(display);
                }
              });
            });
          });
        } else {
          console.log('there were no domains for questions!!!');
        }


        // Format a list of questions
        let msg = "This document is attached to the following questions: <ul>";
        array.forEach(element => {
          msg += "<li>" + element + "</li>";
        });
        msg += "</ul>";

        this.dialogRef = this.dialog.open(OkayComponent,
          {
            data: { title: "Related Questions", iconClass: "cset2-icons-q", messageText: msg }
          });
        this.dialogRef.componentInstance.hasHeader = true;
      });
  }

  /**
   *
   */
  downloadFile(document) {
    this.fileSvc.downloadFile(document.document_Id).subscribe((data: Response) => {
      // this.downloadFileData(data),
    },
      error => console.log(error)
    );
  }

  /**
   *
   */
  download(doc: any) {
    // get short-term JWT from API
    this.authSvc.getShortLivedToken().subscribe((response: any) => {
      const url = this.fileSvc.downloadUrl + doc.document_Id + "?token=" + response.token;
      window.location.href = url;
    });
  }

  // downloadFileData(data: Response) {
  //   const blob = new Blob([data], { type: 'text/csv' });
  //   const url = window.URL.createObjectURL(blob);
  //   window.open(url);
  // }

  autoLoadSupplemental() {
    return this.questionsSvc.autoLoadSupplemental(this.assessSvc.assessment.maturityModel);
  }

  /**
   * Returns a boolean indicating if ANY type of supplemental exists
   */
  supplementalExists() {
    return (
      !!this.tab?.requirementsData?.supplementalInfo
      || !!this.myQuestion.scope
      || !!this.myQuestion.recommendedAction
      || !!this.myQuestion.services);
  }

  /**
   * Programmatically clicks a question extra button to force the lazy load of its content.
   * Do nothing if the user has already selected a mode or collapsed the extras.
   */
  forceLoadQuestionExtra(extra: string) {
    if ((!!this.mode || this.mode === '') && (!this.assessSvc.usesMaturityModel('HYDRO') && extra != 'CMNT')) {
      return;
    }

    this.expanded = false;
    const btn: HTMLElement = document.getElementById(`btn_${extra}_` + this.myQuestion.questionId) as HTMLElement;
    btn.click();
  }

  autoLoadComments() {
    return this.usesRAC() || this.assessSvc.usesMaturityModel('HYDRO');
  }

  /**
   * check if approach exists for acet questions
   * @param approach
   */
  checkForApproach(approach: string) {
    if (!!approach) {
      return true;
    }

    return false;
  }

  /**
   * Encapsulates logic that determines whether an icon should be displayed.
   * Use "moduleBehaviors" configuration for the current module/model.
   */
  displayIcon(mode) {
    //NCUA asked for specific behavior. See comment on displayIconISE function.
    if (this.ncuaDisplay) {
      let result = this.displayIconISE(mode);
      return result;
    }

    const behavior = this.configSvc.config.moduleBehaviors.find(m => m.moduleName == this.assessSvc.assessment.maturityModel?.modelName)

    if (mode == 'DETAIL') {
      return behavior?.questionIcons?.showDetails ?? true;
    }

    if (mode == 'SUPP') {
      return behavior?.questionIcons?.showGuidance ?? true;
    }

    if (mode == 'REFS') {
      return behavior?.questionIcons?.showReferences ?? true;
    }

    if (mode == 'OBSV') {
      return behavior?.questionIcons?.showObservations ?? true;
    }

    if (mode == 'REVIEWED') {
      return behavior?.questionIcons?.showReviewed ?? true;
    }


    // TODO:  define module-specific behaviors for these

    if (mode == 'DOCS') {
      return this.configSvc.behaviors.showAssessmentDocuments;
    }

    if (mode == 'CMNT') {
      return this.configSvc.behaviors.showComments;
    }

    if (mode == 'FDBK') {
      return this.configSvc.behaviors.showFeedback;
    }

    return true;
  }

  /**
   * Custom show/hide functionality for ISE icons. Requires "this.ncuaDisplay" to be true.
   * This function takes an array of strings ("this.iconsToDisplay") and if it finds the mode (icon)
   * you want to show (['REFS', 'SUPP'], etc)
   */
  displayIconISE(mode) {
    if (this.iconsToDisplay.includes(mode)) {
      return true;
    } else {
      return false;
    }
  }

  /**
   * Returns an "I" or "G", depending on which version of the suppemental icon
   * should be shown based on context.
   * @returns
   */
  whichSupplementalIcon() {
    const behavior = this.configSvc.config.moduleBehaviors.find(m => m.moduleName == this.assessSvc.assessment.maturityModel?.modelName);
    if (!!behavior && behavior.questionIcons?.guidanceIcon?.toLowerCase() == 'g') {
      return "G";
    } else {
      return "I";
    }
  }

  /**
   * Returns 'Observation' if the assessment is not ISE, 'Issue' if it is ISE
   */
  observationOrIssue() {
    if (this.assessSvc.isISE()) {
      return 'Issue';
    }
    else {
      return 'Observation';
    }
  }

  /**
   * Returns the custom label if the model has one (currently only ISE), or the default if not
   */
  documentLabel(defaultLabel: string) {
    if (this.assessSvc.isISE()) {
      if (defaultLabel === 'Source Documents') {
        return 'Resources';
      } else if (defaultLabel === 'Additional Documents') {
        return 'References';
      }
    }
    return defaultLabel;
  }

  /**
   * Checks if the current assessment uses the Rapid Assessment Control Set.
   */
  usesRAC() {
    return this.assessSvc.assessment?.useStandard && this.assessSvc.usesStandard('RAC');
  }

  /**
   * Adding this back in for now (I need the old table format)
   * @param document
   * @returns
   */
formatDocumentUrl(document: ReferenceDocLink, bookmark: any) {
    return this.resourceLibSvc.formatDocumentUrl(document, bookmark);
  }

  /**
   *
   */
  areNoReferenceDocumentsAvailable() {
    return (!this.tab?.referenceTextList || this.tab.referenceTextList.length === 0)
      && (!this.tab?.sourceDocumentsList || this.tab.sourceDocumentsList.length === 0)
      && (!this.tab?.additionalDocumentsList || this.tab.additionalDocumentsList.length === 0)
  }

  /**
   * Returns if Supplemental Guidance should be
   * independent from Examination Approach or not
   * @returns
   */
  seperateGuidanceFromApproach() {
    const behavior = this.configSvc.config.moduleBehaviors.find(m => m.moduleName == this.assessSvc.assessment.maturityModel?.modelName);
    return behavior?.independentSuppGuidance;
  }

  /**
   * For CIE, where feedback can be merged with other assessments
   * @param q
   * @returns
   */
  getFeedback(q: Question) {
    if (this.cieSvc.feedbackMap.get(q.questionId) == null && q.feedback == null) {
      return '';
    }
    else if (this.cieSvc.feedbackMap.get(q.questionId) == null && q.feedback != null) {
      this.cieSvc.feedbackMap.set(q.questionId, this.cieSvc.applyContactAndEndTag(q.feedback, '\n- - End of Feedback - -\n'));
    }

    return this.cieSvc.feedbackMap.get(q.questionId);
  }

}
