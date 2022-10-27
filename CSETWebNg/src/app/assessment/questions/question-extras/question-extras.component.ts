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
import { Component, EventEmitter, Input, OnInit, Output, ViewEncapsulation, ViewChild, ElementRef } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { OkayComponent } from '../../../dialogs/okay/okay.component';
import { ConfirmComponent } from '../../../dialogs/confirm/confirm.component';
// tslint:disable-next-line:max-line-length
import { CustomDocument, QuestionDetailsContentViewModel, QuestionInformationTabData } from '../../../models/question-extras.model';
import { Answer, Question } from '../../../models/questions.model';
import { ConfigService } from '../../../services/config.service';
import { FileUploadClientService } from '../../../services/file-client.service';
import { FindingsService } from '../../../services/findings.service';
import { QuestionsService } from '../../../services/questions.service';
import { AuthenticationService } from './../../../services/authentication.service';
import { FindingsComponent } from './../findings/findings.component';
import { Finding } from './../findings/findings.model';
import { AssessmentService } from '../../../services/assessment.service';
import { ComponentOverrideComponent } from '../../../dialogs/component-override/component-override.component';
import { MaturityService } from '../../../services/maturity.service';
import { LayoutService } from '../../../services/layout.service';


@Component({
  selector: 'app-question-extras',
  templateUrl: './question-extras.component.html',
  styleUrls: ['./question-extras.component.css'],
  encapsulation: ViewEncapsulation.None,
  // tslint:disable-next-line:use-host-property-decorator
  host: { class: 'd-flex flex-column flex-11a' }
})
export class QuestionExtrasComponent implements OnInit {

  @Input() myQuestion: Question;
  @Output() changeExtras = new EventEmitter();
  @Output() changeComponents = new EventEmitter();
  @ViewChild('questionExtras') questionExtrasDiv: ElementRef;

  @Input() myOptions: any;

  extras: QuestionDetailsContentViewModel;
  tab: QuestionInformationTabData;
  expanded = false;
  mode: string;  // selector for which data is being displayed, 'DETAIL', 'SUPP', 'CMNT', 'DOCS', 'DISC', 'FDBK'.
  answer: Answer;
  dialogRef: MatDialogRef<OkayComponent>;

  showMfr = false;

  showQuestionIds = false;

  /**
   * Stores the original document title, in case the user escapes out of an unwanted change
   */
  origTitle: string;

  constructor(
    public questionsSvc: QuestionsService,
    private findSvc: FindingsService,
    public fileSvc: FileUploadClientService,
    public dialog: MatDialog,
    public configSvc: ConfigService,
    public authSvc: AuthenticationService,
    public assessSvc: AssessmentService,
    private maturitySvc: MaturityService,
    public layoutSvc: LayoutService
    ) {
  }


  ngOnInit() {
    this.showQuestionIds = this.configSvc.showQuestionAndRequirementIDs();

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
      width: this.layoutSvc.hp ? '90%' : '600px',
      maxWidth: this.layoutSvc.hp ? '90%' : '600px',
      height: '800px',
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
      this.scrollToExtras();
      return;
    }

    // Call the API for content
    this.questionsSvc.getDetails(this.myQuestion.questionId, this.myQuestion.questionType).subscribe(
      (details) => {
        this.extras = details;
        this.extras.questionId = this.myQuestion.questionId;

        // populate my details with the first "non-null" tab
        this.tab = this.extras.listTabs?.find(t => t.requirementFrameworkTitle != null) ?? this.extras.listTabs[0];
        this.scrollToExtras()

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
   *
   * @param e
   */
  saveComment(e) {
    this.defaultEmptyAnswer();
    this.answer.comment = e.target.value;
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
   */
  showFeedbackIcon(): boolean {
    if (this.configSvc.installationMode === 'ACET') {
      return false;
    }
    if (this.configSvc.installationMode === 'RRA') {
      return false;
    }
    return true;
  }

  /**
  *
  * @param e
  */
  saveFeedback(e) {
    this.defaultEmptyAnswer();
    this.answer.feedback = e.target.value;
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
   * Returns a boolean indicating if there are comments, documents or discoveries present
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

      case 'DISC':
        // if the extras have not been pulled, get the indicator from the question list JSON
        if (this.extras == null || this.extras.findings == null) {
          return this.myQuestion.hasDiscovery ? 'inline' : 'none';
        }
        return (this.extras && this.extras.findings && this.extras.findings.length > 0) ? 'inline' : 'none';


    }
  }

  /**
   *
   * @param findid
   */
  addEditDiscovery(findid) {
    //this.saveAnswer();

    // TODO Always send an empty one for now.
    // At some juncture we need to change this to
    // either send the finding to be edited or
    // send an empty one.
    const find: Finding = {
      question_Id: this.myQuestion.questionId,
      answer_Id: this.myQuestion.answer_Id,
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
      title: null,
      type: null,
      description: null,
      sub_Risk_Area_Id: null,
      subRiskArea: null,
      disposition: null,
      identified_Date: null,
      due_Date: null
    };

    this.dialog.open(FindingsComponent, {
        data: find,
        disableClose: true,
        width: this.layoutSvc.hp ? '90%' : '600px',
        maxWidth: this.layoutSvc.hp ? '90%' : '600px'
      })
      .afterClosed().subscribe(result => {
        const answerID = find.answer_Id;
        this.findSvc.getAllDiscoveries(answerID).subscribe(
          (response: Finding[]) => {
            this.extras.findings = response;
            this.myQuestion.hasDiscovery = (this.extras.findings.length > 0);
            this.myQuestion.answer_Id = find.answer_Id;
          },
          error => console.log('Error updating findings | ' + (<Error>error).message)
        );
      });
  }

  /**
   * Deletes a discovery.
   * @param findingToDelete
   */
  deleteDiscovery(findingToDelete) {

    // Build a message whether the observation has a title or not
    let msg = "Are you sure you want to delete "
      + this.observationOrIssue().toLowerCase()
      + " '"
      + findingToDelete.summary
      + "?'";

    if (findingToDelete.summary === null) {
      msg = "Are you sure you want to delete this "
      + this.observationOrIssue().toLowerCase()
      + "?";
    }


    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = msg;

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.findSvc.deleteFinding(findingToDelete.finding_Id).subscribe();
        let deleteIndex = null;

        for (let i = 0; i < this.extras.findings.length; i++) {
          if (this.extras.findings[i].finding_Id === findingToDelete.finding_Id) {
            deleteIndex = i;
          }
        }
        this.extras.findings.splice(deleteIndex, 1);
        this.myQuestion.hasDiscovery = (this.extras.findings.length > 0);

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
   *
   */
  documentUrl(document: CustomDocument) {
    var link = '';
    if (document.is_Uploaded) {
      link = this.configSvc.apiUrl + 'ReferenceDocument/' + document.file_Id + '#' + document.section_Ref;
    } else {
      link = this.configSvc.docUrl + document.file_Name + '#' + document.section_Ref;
    }
    return link;
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
      window.open(url, "_blank");
    });
  }

  // downloadFileData(data: Response) {
  //   const blob = new Blob([data], { type: 'text/csv' });
  //   const url = window.URL.createObjectURL(blob);
  //   window.open(url);
  // }

  autoLoadSupplemental() {
    return this.questionsSvc.autoLoadSupplementalSetting;
  }

  /**
   * Programatically clicks the Supplemental icon button to force the lazy load of its content.
   * Do nothing if the user has already selected a mode or collapsed the extras.
   */
  forceLoadSupplemental() {
    if (!!this.mode || this.mode === '') {
      return;
    }

    this.expanded = false;
    const btn: HTMLElement = document.getElementById('btn_supp_' + this.myQuestion.questionId) as HTMLElement;
    btn.click();
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
   * It can grow as new behaviors are required.
   */
  displayIcon(mode) {

    // EDM
    if (this.myQuestion.is_Maturity
      && (this.assessSvc.usesMaturityModel('EDM')
        || this.assessSvc.usesMaturityModel('CRR')
        || this.assessSvc.isISE())) {
      if (mode == 'DETAIL') {
        return false;
      }
      if (mode == 'REVIEWED') {
        return false;
      }
    }

    // RRA
    if (this.myQuestion.is_Maturity && this.assessSvc.usesMaturityModel('RRA')) {
      if (mode == 'DETAIL') {
        return false;
      }
      if (mode == 'REVIEWED') {
        return false;
      }
    }

    // CISA CIS
    if (this.myQuestion.is_Maturity && this.assessSvc.usesMaturityModel('CIS')) {
      if (mode == 'DETAIL') {
        return false;
      }
      if (mode == 'REVIEWED') {
        return false;
      }
      if (mode == 'DISC') {
        return false;
      }
      if (mode == 'REFS') {
        return false;
      }
    }

    // ISE
    if (this.myQuestion.is_Maturity && this.assessSvc.usesMaturityModel('ISE')) {
      if (mode == 'DISC') {
        return false;
      }
    }

    // DOCUMENTS
    if (mode == 'DOCS') {
      return this.configSvc.behaviors.showAssessmentDocuments;
    }

    return true;
  }

  /**
   * Returns an "I" or "G", depending on which version of the suppemental icon
   * should be shown based on context.
   * @returns
   */
  whichSupplementalIcon() {
    if (this.myQuestion.is_Maturity && this.assessSvc.usesMaturityModel('EDM')) {
      return "G";
    }

    if (this.myQuestion.is_Maturity && this.assessSvc.usesMaturityModel('RRA')) {
      return "G";
    }

    if (this.myQuestion.is_Maturity && this.assessSvc.usesMaturityModel('CRR')) {
      return "G";
    }

    return "I";
  }

  areNoReferenceDocumentsAvailable() {
    return (!this.tab?.referenceTextList || this.tab.referenceTextList.length === 0)
      && (!this.tab?.sourceDocumentsList || this.tab.sourceDocumentsList.length === 0)
      && (!this.tab?.additionalDocumentsList || this.tab.additionalDocumentsList.length === 0)
  }

  /**
   * Returns 'Observation' if the assessment is not ISE, 'Issue' if it is ISE
   */
   observationOrIssue () {
    if (this.assessSvc.isISE()) {
      return 'Issue';
    }
    else {
      return 'Observation';
    }
  }


}
