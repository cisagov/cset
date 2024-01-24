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
import { Component, OnInit, ViewChild } from '@angular/core';
import { Requirement, Question, ReferenceDoc, RefDocLists, BasicResponse, CategoryEntry } from '../../models/set-builder.model';
import { SetBuilderService } from '../../services/set-builder.service';
import { ActivatedRoute } from '@angular/router';
import { AngularEditorConfig } from '@kolkov/angular-editor';
import { MatDialog } from '@angular/material/dialog';
import { ConfirmComponent } from '../../dialogs/confirm/confirm.component';


@Component({
  selector: 'app-requirement-detail',
  templateUrl: './requirement-detail.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a w-100' }
})
export class RequirementDetailComponent implements OnInit {

  r: Requirement = {};
  rBackup: Requirement = {};

  categories: CategoryEntry[];
  subcategories: CategoryEntry[];
  groupHeadings: CategoryEntry[];


  titleEmpty = false;
  textEmpty = false;

  questionBeingEdited: Question = null;
  originalQuestionText: string = null;
  editedQuestionInUse = false;
  duplicateTextQuestion: Question = null;

  sourceDocs: ReferenceDoc[] = [];

  refDocOptions: ReferenceDoc[] = [];
  newSourceDocId = 0;
  newSourceSectionRef = '';
  sourceDocMissing = false;

  additionalDocs: ReferenceDoc[] = [];
  newAdditionalDocId = 0;
  newAdditionalSectionRef = '';
  additionalDocMissing = false;

  @ViewChild('editQ') editQControl;

  editorConfig: AngularEditorConfig = {
    editable: true,
    spellcheck: true,
    height: '25rem',
    minHeight: '5rem',
    placeholder: 'Enter text here...',
    translate: 'yes',
    uploadUrl: 'v1/images', // if needed
    fonts: [
      { class: 'arial', name: 'Arial' },
      { class: 'times-new-roman', name: 'Times New Roman' },
      { class: 'calibri', name: 'Calibri' },
      { class: 'comic-sans-ms', name: 'Comic Sans MS' }
    ],
    customClasses: [ // optional
      {
        name: "quote",
        class: "quote",
      },
      {
        name: 'redText',
        class: 'redText'
      },
      {
        name: "titleText",
        class: "titleText",
        tag: "h1",
      },
    ]
  };


  constructor(public setBuilderSvc: SetBuilderService,
    private route: ActivatedRoute,
    private dialog: MatDialog) { }

  /**
   * 
   */
  ngOnInit() {
    let requirementID = 0;
    if (!!this.setBuilderSvc.activeRequirement) {
      requirementID = this.setBuilderSvc.activeRequirement.requirementID;
    } else {
      // if the service doesn't know it, try to get it from the URI
      requirementID = this.route.snapshot.params['id'];
    }

    this.populateSubcategories();

    this.setBuilderSvc.getRequirement(requirementID).subscribe((result: Requirement) => {
      this.r = result;
      this.rBackup = this.r;
      this.setBuilderSvc.activeRequirement = this.r;

      // Default to a low SAL
      if (this.r.salLevels.length === 0) {
        this.r.salLevels.push('L');
        this.setBuilderSvc.setSalLevel(this.r.requirementID, 0, 'L', true).subscribe();
      }
    });

    this.setBuilderSvc.getReferenceDocumentsForSet().subscribe((docs: ReferenceDoc[]) => {
      this.refDocOptions = docs;
    });
  }

  /**
   * 
   */
  populateSubcategories() {
    this.setBuilderSvc.getCategoriesSubcategoriesGroupHeadings().subscribe(
      (data: any) => {
        this.categories = data.categories;
        this.subcategories = data.subcategories;
        this.groupHeadings = data.groupHeadings;
      },
      error => console.log('Categories load Error: ' + (<Error>error).message)
    );
  }

  /**
   *
   */
  updateRequirement(e: Event) {
    this.titleEmpty = (this.r.title.trim().length === 0);
    this.textEmpty = (this.r.requirementText.trim().length === 0);

    // Don't allow either of these fields to be blanked out.
    if (this.titleEmpty) {
      this.r.title = this.rBackup.title;
    }
    if (this.textEmpty) {
      this.r.requirementText = this.rBackup.requirementText;
    }
    if (this.titleEmpty || this.textEmpty) {
      return;
    }

    // call API
    this.setBuilderSvc.updateRequirement(this.r).subscribe();
  }

  /**
   * Not all 'blur' events are firing.  If focus is in the editor and you
   * click the cursor out onto the page, there's no blur event.
   * This needs to be figured out.
   */
  onBlur(e: Event) {
    this.updateRequirement(e);
  }

  /**
  *
  */
  hasSAL(r: Requirement, level: string): boolean {
    if (!r) {
      return false;
    }
    return (!!r.salLevels && r.salLevels.indexOf(level) >= 0);
  }

  /**
   * Includes/removes the level from the list of applicable SAL levels for the question.
   */
  toggleSAL(r: Requirement, level: string, e) {
    let state = false;
    const checked = e.target.checked;
    const a = r.salLevels.indexOf(level);

    // trying to remove the last SAL is prohibited
    if (r.salLevels.length === 1 && r.salLevels[0] === level) {
      return;
    }

    if (checked) {
      if (a <= 0) {
        r.salLevels.push(level);
        state = true;
      }
    } else if (a >= 0) {
      r.salLevels = r.salLevels.filter(x => x !== level);
      state = false;
    }

    this.setBuilderSvc.setSalLevel(r.requirementID, 0, level, state).subscribe();
  }

  /**
   * Indicates if no SAL levels are currently selected for the question.
   */
  missingSAL(r: Requirement): boolean {
    if (!r) {
      return false;
    }
    if (!r.salLevels) {
      return true;
    }
    if (r.salLevels.length === 0) {
      return true;
    }
    return false;
  }

  /**
   * Adds or deletes a reference
   * @param reqId
   * @param docId
   * @param sectionRef
   * @param adddelete
   */
  addDeleteReference(reqId: number, docId: number, isSourceDoc: boolean, sectionRef: string, adddelete: boolean) {
    if (docId === 0) {
      if (isSourceDoc) {
        this.sourceDocMissing = true;
      } else {
        this.additionalDocMissing = true;
      }
      return;
    }

    this.sourceDocMissing = false;
    this.additionalDocMissing = false;

    if (sectionRef.startsWith("#")) {
      sectionRef = sectionRef.substring(1);
    }

    this.setBuilderSvc.addDeleteRefDocToRequirement(reqId, docId, isSourceDoc, sectionRef, adddelete)
      .subscribe((lists: RefDocLists) => {
        this.r.sourceDocs = lists.sourceDocs;
        this.newSourceDocId = 0;
        this.newSourceSectionRef = '';

        this.r.additionalDocs = lists.additionalDocs;
        this.newAdditionalDocId = 0;
        this.newAdditionalSectionRef = '';
      });
  }

  /**
   * 
   */
  addQuestion() {
    // set the requirement as 'active' in the service
    this.setBuilderSvc.activeRequirement = this.r;
    this.setBuilderSvc.navOrigin = 'requirement-detail';
    // navigate to add-question
    this.setBuilderSvc.navAddQuestion();
  }

  /**
   * 
   */
  removeQuestion(q: Question) {
    // confirm
    const dialogRef = this.dialog.open(ConfirmComponent);
    dialogRef.componentInstance.confirmMessage =
      "Are you sure you want to remove the question from the requirement?";

    dialogRef.afterClosed().subscribe(result => {
      if (result) {
        this.dropQuestion(q);
      }
    });
  }

  /**
   * Remove the question from the requirement
   */
  dropQuestion(q: Question) {
    this.setBuilderSvc.removeQuestion(q.questionID).subscribe(() => {
      // remove the deleted question from the collection
      const i = this.r.questions.findIndex((x: any) => x.questionID === q.questionID);
      this.r.questions.splice(i, 1);
    });
  }

  /**
   *
   */
  startQuestionEdit(q: Question) {
    this.questionBeingEdited = q;
    this.duplicateTextQuestion = null;
    this.originalQuestionText = q.questionText;

    setTimeout(() => {
      this.editQControl.nativeElement.focus();
      this.editQControl.nativeElement.setSelectionRange(0, 0);
    }, 20);

    this.setBuilderSvc.isQuestionInUse(q).subscribe((inUse: boolean) => {
      this.editedQuestionInUse = inUse;
    });
  }

  /**
   *
   */
  endQuestionEdit(q: Question) {
    this.editedQuestionInUse = false;
    this.questionBeingEdited = null;
    this.setBuilderSvc.updateQuestionText(q).subscribe((resp: BasicResponse) => {
      if (resp.errorMessages.indexOf('DUPLICATE QUESTION TEXT') >= 0) {
        this.duplicateTextQuestion = q;
        this.abandonQuestionEdit(q);
      }
    });
  }

  /**
   * 
   */
  abandonQuestionEdit(q: Question) {
    q.questionText = this.originalQuestionText;
    this.editedQuestionInUse = false;
    this.questionBeingEdited = null;
  }

  /**
   * 
   */
  navStandardDocuments() {
    this.setBuilderSvc.navStandardDocuments('requirement-detail', this.r.requirementID.toString());
  }

  /**
   * 
   */
  formatLinebreaks(text: string) {
    return this.setBuilderSvc.formatLinebreaks(text);
  }
}
