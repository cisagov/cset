import { Injectable } from '@angular/core';
import { CharterMismatchComponent } from '../dialogs/charter-mistmatch/charter-mismatch.component';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { TranslocoService } from '@ngneat/transloco';
import { DateAdapter } from '@angular/material/core';
import { ACETService } from './acet.service';
import { AssessmentService } from './assessment.service';
import { AuthenticationService } from './authentication.service';
import { ConfigService } from './config.service';
import { AcetFilteringService } from './filtering/maturity-filtering/acet-filtering.service';
import { IRPService } from './irp.service';
import { MaturityService } from './maturity.service';
import { ReportService } from './report.service';
import { Question } from '../models/questions.model';
import { List } from 'lodash';
import { QuestionFilterService } from './filtering/question-filter.service';
import { QuestionFiltersReportsComponent } from '../dialogs/question-filters-reports/question-filters-reports.component';

let headers = {
  headers: new HttpHeaders()
    .set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class CieService {

  // used for keeping track of which examinations are being merged
  prepForMerge: boolean = false;
  assessmentsToMerge: any[] = [];
  mainAssessFacility: string = "";
  backupCharter: string = "";
  hasShownCharterWarning: boolean = false;
  apiUrl = this.configSvc.apiUrl;

  exampleExpanded = false;
  tutorialExpanded = false;

  contactInitials = "";
  freeResponseSegment = "";

  feedbackMap: Map<number, string> = new Map<number, string>();
  commentMap: Map<number, string> = new Map<number, string>();

  filterDialogRef: MatDialogRef<QuestionFiltersReportsComponent>;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public dialog: MatDialog,
    public acetFilteringSvc: AcetFilteringService,
    public assessSvc: AssessmentService,
    private maturitySvc: MaturityService,
    private acetSvc: ACETService,
    private irpSvc: IRPService,
    private assessmentSvc: AssessmentService,
    private authSvc: AuthenticationService,
    private dateAdapter: DateAdapter<any>,
    private tSvc: TranslocoService,
    private reportSvc: ReportService,
    private filterSvc: QuestionFilterService
  ) { }

  /*
  * The following functions are all used for the 'Assessment merge' functionality
  */
  // Opens merge toggle checkboxes on the assessment selection (landing) page
  prepExaminationMerge() {
    if (this.prepForMerge === false) {
      this.prepForMerge = true;
    } else if (this.prepForMerge === true) {
      this.assessmentsToMerge = [];
      this.mainAssessFacility = "";
      this.backupCharter = "";
      this.hasShownCharterWarning = false;
      this.prepForMerge = false;
    }
  }

  
  // Adds or removes selected CIE examinations to the list to merge
  modifyMergeList(assessment: any, event: any) {
    let tempFacility = "";
    const optionChecked = event.target.checked;
    if (optionChecked) {
      //tempFacility = assessment.facili;

      // Sets a fallback charter number if the user deselects the first exam that they selected
      if (this.assessmentsToMerge.length === 1) {
        this.backupCharter = tempFacility;
      }

      if (this.mainAssessFacility === "") {
        this.mainAssessFacility = tempFacility;
      }

      if (this.mainAssessFacility !== tempFacility && this.hasShownCharterWarning === false) {
        this.openCharterWarning();
      }

      this.assessmentsToMerge.push(assessment.assessmentId);
    } else {
      const index = this.assessmentsToMerge.indexOf(assessment.assessmentId);
      this.assessmentsToMerge.splice(index, 1);

      if (index === 0) {
        this.mainAssessFacility = this.backupCharter;
      }

      if (this.assessmentsToMerge.length === 0) {
        this.mainAssessFacility = "";
        this.backupCharter = "";
      }
    }
  }

  pullAssessmentCharter(assessment: any) {
    // All ISE charters start on the 4th character (after the 'ISE' and space) and are 5 digits long.
    let charterNum = "";
    for (let i = 4; i < 9; i++) {
      charterNum += assessment.assessmentName[i];
    }

    return charterNum;
  }

  openCharterWarning() {
    let dialogRef = this.dialog.open(CharterMismatchComponent, {
      width: '250px',
    });

    dialogRef.afterClosed().subscribe(result => {
      this.hasShownCharterWarning = true;
    });
  }

  // Fires off 2 - 10 assessments to the API to run the stored proc to check for conflicting answers
  getAnswers() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
      .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);

    return this.http.get(this.configSvc.apiUrl + 'getCieMergeData', headers)
  }

  getNames() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
      .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);

    return this.http.get(this.configSvc.apiUrl + 'getCieMergeData', headers);
  }

  getCieAllQuestions() {
    return this.http.get(this.configSvc.apiUrl + 'reports/getCieAllQuestions');
  }

  getCiePrincipleQuestions() {
    return this.http.get(this.configSvc.apiUrl + 'reports/getCiePrincipleQuestions');
  }

  getCiePhaseQuestions() {
    return this.http.get(this.configSvc.apiUrl + 'reports/getCiePhaseQuestions');
  }

  getCieNaQuestions() {
    return this.http.get(this.configSvc.apiUrl + 'reports/getCieNaQuestions');
  }
  
  getCieAssessmentDocuments() {
    return this.http.get(this.apiUrl + 'reports/getCieAllQuestionsWithDocuments');
  }

  getCieAllMfrQuestionsWithDocuments() {
    return this.http.get(this.apiUrl + 'reports/getCieAllMfrQuestionsWithDocuments');
  }

  getObservations() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
      .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);
    return this.http.get(this.apiUrl + 'getAssessmentObservations', headers);
  }

  getDocuments() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
      .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);
    return this.http.get(this.apiUrl + 'getAssessmentDocuments', headers);
  }

  saveDocuments(documentsForAssessment: any[]) {
    console.log(documentsForAssessment)

    const documents: DocumentsForMerge = {
      DocumentWithAnswerId: documentsForAssessment
    };
    console.log(documents)
    return this.http.post(this.apiUrl + 'saveNewDocumentsForMerge', documents)
  }

  applyContactAndEndTag(textToAppend: string, convoBuffer: string) {
    let bracketContact = '[' + this.assessSvc.assessment.assessmentName + ']';

    if (textToAppend.indexOf(bracketContact) !== 0) {
      if (!!textToAppend) {
        if (textToAppend.indexOf('[') !== 0) {
          this.freeResponseSegment = bracketContact + ' ' + textToAppend;
          textToAppend = this.freeResponseSegment + convoBuffer;
        }

        else {
          let previousContactInitials = textToAppend.substring(textToAppend.lastIndexOf('[') + 1, textToAppend.lastIndexOf(']'));
          let endOfLastBuffer = textToAppend.lastIndexOf(convoBuffer) + convoBuffer.length;
          if (previousContactInitials !== this.assessSvc.assessment.assessmentName) {
            // if ( endOfLastBuffer !== q.altAnswerText.length || endOfLastBuffer !== q.altAnswerText.length - 1) {
            let oldComments = textToAppend.substring(0, endOfLastBuffer);
            let newComment = textToAppend.substring(oldComments.length);

            textToAppend = oldComments + bracketContact + ' ' + newComment + convoBuffer;
            // }
          }
        }
      }
    }

    return textToAppend;
  }
}

export interface DocumentsForMerge {
  DocumentWithAnswerId: any[];
}
