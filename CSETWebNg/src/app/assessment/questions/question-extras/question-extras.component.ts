////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { Component, EventEmitter, Input, OnInit, Output, ViewEncapsulation } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material';
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

  extras: QuestionDetailsContentViewModel;
  tab: QuestionInformationTabData;
  expanded = false;
  mode: string;  // selector for which data is being displayed, 'DETAIL', 'SUPP', 'CMNT', 'DOCS', 'DISC', 'FDBK'.
  answer: Answer;
  dialogRef: MatDialogRef<OkayComponent>;

  /**
   * Stores the original document title, in case the user escapes out of an unwanted change
   */
  origTitle: string;

  constructor(
    private questionsSvc: QuestionsService,
    private findSvc: FindingsService,
    public fileSvc: FileUploadClientService,
    public dialog: MatDialog,
    public configSvc: ConfigService,
    public authSvc: AuthenticationService,
    public assessSvc: AssessmentService) {
  }


  ngOnInit() {
  }


  showOverrideDialog(componentType: any): void {
    const dialogRef = this.dialog.open(ComponentOverrideComponent, {
      width: '600px',
      height: '800px',
      data: { ComponentType: componentType, Component_Symbol_Id: componentType.Component_Symbol_Id, myQuestion: this.myQuestion },
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

  /**
   *
   */
  show() {
    // we already have content - don't make another server call
    if (this.tab != null) {
      return;
    }

    // Call the API for content
    this.questionsSvc.getDetails(this.myQuestion.QuestionId,
      this.myQuestion.Is_Component).subscribe(
        (details) => {
          this.extras = details;
          // populate my details with the first "non-null" tab
          this.tab = this.extras.ListTabs.find(t => t.RequirementFrameworkTitle != null);

          // add questionIDs to related questions for debug if configured to do so
          if (this.configSvc.showQuestionAndRequirementIDs()) {
            if (this.tab) {
              if (this.tab.IsComponent) {
              } else {
                if (!!this.tab.QuestionsList) {
                  this.tab.QuestionsList.forEach((q: any) => {
                    q.QuestionText += '<span class="debug-highlight">' + q.QuestionID + '</span>';
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
    this.answer.Comment = e.srcElement.value;
    this.saveAnswer();
  }

  /**
  *
  * @param e
  */
  saveFeedBack(e) {
    this.defaultEmptyAnswer();
    this.answer.FeedBack = e.srcElement.value;
    this.saveAnswer();
  }

  /**
   *
   * @param q
   */
  storeReviewed(e: any) {
    this.defaultEmptyAnswer();
    this.myQuestion.Reviewed = e.target.checked;
    this.answer.Reviewed = this.myQuestion.Reviewed;
    this.saveAnswer();
  }

  /**
   * Creates an Answer if one does not already exist.
   */
  defaultEmptyAnswer() {
    if (this.answer == null) {
      const newAnswer: Answer = {
        QuestionId: this.myQuestion.QuestionId,
        QuestionNumber: this.myQuestion.DisplayNumber,
        AnswerText: this.myQuestion.Answer,
        AltAnswerText: this.myQuestion.AltAnswerText,
        Comment: '',
        FeedBack: '',
        MarkForReview: false,
        Reviewed: false,
        Is_Component: this.myQuestion.Is_Component,
        Is_Requirement: this.myQuestion.Is_Requirement,
        ComponentGuid: ''
      };

      this.answer = newAnswer;
    }
  }

  /**
   *
   */
  saveAnswer() {
    this.defaultEmptyAnswer();

    this.answer.QuestionId = this.myQuestion.QuestionId;
    this.answer.AnswerText = this.myQuestion.Answer;
    this.answer.AltAnswerText = this.myQuestion.AltAnswerText;
    this.answer.MarkForReview = this.myQuestion.MarkForReview;
    this.answer.Reviewed = this.myQuestion.Reviewed;
    this.answer.Comment = this.myQuestion.Comment;
    this.answer.FeedBack = this.myQuestion.FeedBack;

    // Tell the parent (subcategory) component that something changed
    this.changeExtras.emit(null);

    this.questionsSvc.storeAnswer(this.answer).subscribe(
      (response: number) => {
        this.myQuestion.Answer_Id = response;
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
        return (this.myQuestion.Comment && this.myQuestion.Comment.length > 0) ? 'inline' : 'none';

      case 'FDBK':
        return (this.myQuestion.FeedBack && this.myQuestion.FeedBack.length > 0) ? 'inline' : 'none';

      case 'DOCS':
        // if the extras have not been pulled, get the indicator from the question list JSON
        if (this.extras == null || this.extras.Documents == null) {
          return this.myQuestion.HasDocument ? 'inline' : 'none';
        }
        return (this.extras && this.extras.Documents && this.extras.Documents.length > 0) ? 'inline' : 'none';

      case 'DISC':
        // if the extras have not been pulled, get the indicator from the question list JSON
        if (this.extras == null || this.extras.Findings == null) {
          return this.myQuestion.HasDiscovery ? 'inline' : 'none';
        }
        return (this.extras && this.extras.Findings && this.extras.Findings.length > 0) ? 'inline' : 'none';
    }
  }

  /**
   *
   * @param findid
   */
  addEditDiscovery(findid) {
    this.saveAnswer();

    // TODO Always send an empty one for now.
    // At some juncture we need to change this to
    // either send the finding to be edited or
    // send an empty one.
    const find: Finding = {
      Question_Id: this.myQuestion.QuestionId,
      Answer_Id: this.myQuestion.Answer_Id,
      Finding_Id: findid,
      Summary: '',
      Finding_Contacts: null,
      Impact: '',
      Importance: null,
      Importance_Id: 1,
      Issue: '',
      Recommendations: '',
      Resolution_Date: null,
      Vulnerabilities: ''
    };

    this.dialog
      .open(FindingsComponent, { data: find, disableClose: true })
      .afterClosed().subscribe(result => {
        const answerID = this.myQuestion.Answer_Id;
        this.findSvc.getAllDiscoveries(answerID).subscribe(
          (response: Finding[]) => {
            this.extras.Findings = response;
            this.myQuestion.HasDiscovery = (this.extras.Findings.length > 0);
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
    let msg = "Are you sure you want to delete observation '"
      + findingToDelete.Summary
      + "?'";

    if (findingToDelete.Summary === null) {
      msg = "Are you sure you want to delete this observation?";
    }


    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage = msg;

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.findSvc.deleteFinding(findingToDelete.Finding_Id).subscribe();
        let deleteIndex = null;

        for (let i = 0; i < this.extras.Findings.length; i++) {
          if (this.extras.Findings[i].Finding_Id === findingToDelete.Finding_Id) {
            deleteIndex = i;
          }
        }
        this.extras.Findings.splice(deleteIndex, 1);
        this.myQuestion.HasDiscovery = (this.extras.Findings.length > 0);
      }
    });
  }

  /**
   * Programatically clicks the corresponding file upload element.
   * @param event
   */
  openFileBrowser(event: any) {
    event.preventDefault();
    const element: HTMLElement = document.getElementById('docUpload_q' + this.myQuestion.QuestionId) as HTMLElement;
    element.click();
  }

  /**
   * Uploads the selected file to the API.
   * @param e The 'file' event
   */
  fileSelect(e) {
    const options = {};
    options['questionId'] = this.myQuestion.QuestionId;
    options['answerId'] = this.myQuestion.Answer_Id;

    this.fileSvc.fileUpload(e.target.files[0], options)
      .subscribe(resp => {
        // refresh the document list
        this.extras.Documents = resp.body;
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
    this.origTitle = document.Title;
  }

  /**
   * Changes the title of a stored document.
   */
  renameDocument(document) {
    document.isEdit = false;
    if (this.isNullOrWhiteSpace(document.Title)) {
      document.Title = "click to edit";
    }
    this.questionsSvc.renameDocument(document.Document_Id, document.Title)
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
    document.Title = this.origTitle;
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
      + document.Title
      + "?'";
    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        // remove from the local model
        this.extras.Documents = this.extras.Documents.filter(d => d.Document_Id !== document.Document_Id);

        // push the change to the API
        this.questionsSvc.deleteDocument(document.Document_Id, this.myQuestion.Answer_Id)
          .subscribe();
      }
    });
  }

  documentUrl(document: CustomDocument) {
    return (document.Is_Uploaded ?
      this.configSvc.apiUrl + '/ReferenceDocuments/'
      : this.configSvc.docUrl)
      + document.File_Name + '#' + document.Section_Ref;
  }
  /**
   * Displays a dialog with questions that have this document attached.
   * @param document
   */
  showRelatedQuestions(document) {
    // call the API to get the list of questions
    this.questionsSvc.getQuestionsForDocument(document.Document_Id)
      .subscribe((qlist: number[]) => {
        const array = [];


        // Traverse the local model to get the "display" question numbers
        if (this.questionsSvc.domains) {
          this.questionsSvc.domains.forEach(d => {
            d.QuestionGroups.forEach(qg => {
              qg.SubCategories.forEach(sc => {
                sc.Questions.forEach(q => {
                  if (qlist.includes(q.QuestionId)) {
                    array.push(qg.GroupHeadingText + " #" + q.DisplayNumber);
                  }
                });
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

  downloadFile(document) {
    this.fileSvc.downloadFile(document.Document_Id).subscribe((data: Response) =>
      console.log(data),
      // this.downloadFileData(data),
      error => console.log(error)
    );
  }

  download(doc: any) {
    // get short-term JWT from API
    this.authSvc.getShortLivedToken().subscribe((response: any) => {
      const url = this.fileSvc.downloadUrl + doc.Document_Id + "?token=" + response.Token;
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
   */
  forceLoadSupplemental() {
    this.expanded = false;
    const btn: HTMLElement = document.getElementById('btn_supp_' + this.myQuestion.QuestionId) as HTMLElement;
    btn.click();
  }

  /**
   * Converts linebreak characters to HTML <br> tag.
   */
  formatLinebreaks(text: string) {
    if (!text) {
      return '';
    }
    return text.replace(/(?:\r\n|\r|\n)/g, '<br />');
  }



  /**
   * check if approach exists for acet questions
   * @param approach
   */
  checkForApproach(approach: string) {
    if (typeof approach !== 'undefined' && approach) {
      return true;
    }

    return false;
  }
}

