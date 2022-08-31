import { Component, Input, OnInit } from '@angular/core';
import { Answer, MaturityQuestionResponse, QuestionGrouping } from '../../models/questions.model';
import { AssessmentContactsResponse, AssessmentDetail } from '../../models/assessment-info.model';
import { AssessmentService } from '../../services/assessment.service';
import { ConfigService } from '../../services/config.service';
import { MaturityService } from '../../services/maturity.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';
import { AuthenticationService } from '../../services/authentication.service';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';

@Component({
  selector: 'merge-examinations',
  templateUrl: './merge-examinations.component.html',
  styles: ['tr { border-bottom: 1px solid black; text-align: center; }']
})
export class MergeExaminationsComponent implements OnInit {
  // Show a spinner on the frontend if the "behind the scenes" code is still running.
  pageLoading: boolean = false;

  // Stored proc data
  mergeConflicts: any[] = [];

  // Assessment Names & pieces of the merged assessment naming convention
  assessmentNames: string[] = [];
  contactsInitials: any[] = [];
  initialsAsString: string = "";

  // Answers pulled from the assessments being merged (that aren't in conflict)
  mergingAssessmentAnswers: Answer[] = [];

  // Values the user picks
  mergeRadioSelections: string[] = [];

  // Radio values converted to an Answer Object
  mergeAnswers: Answer[] = [];

  // The returned merged assessment
  mergedAssessment: AssessmentDetail = {};
  attemptingToMerge: boolean = false;

  // "Temp" variables to help the merge track when it needs to do certain things.
  count: number = 0;
  count2: number = 0;

  constructor(
    public ncuaSvc: NCUAService,
    public assessSvc: AssessmentService,
    private authSvc: AuthenticationService,
    public maturitySvc: MaturityService,
    public questionSvc: QuestionsService,
    public configSvc: ConfigService,
    private router: Router,
    public datePipe: DatePipe,
    private dialog: MatDialog

  ) { }

  ngOnInit() {
    this.pageLoading = true;
    this.getMergingAssessmentAnswers();
    this.getConflicts();
  }

  getMergingAssessmentAnswers() {
    for(let i = 0; i < this.ncuaSvc.assessmentsToMerge.length; i++) {
      this.assessSvc.getAssessmentToken(this.ncuaSvc.assessmentsToMerge[i]).then(() => {
        this.getAssessmentContactInitials();
        this.maturitySvc.getQuestionsList("ACET", false).subscribe(
          (response: any) => {
            this.aggregateExistingAnswers(response);
          })
      })
    }
  }

  aggregateExistingAnswers(response) {
    this.count++;

    for (let j = 0; j < response.groupings[0].questions.length; j++) {
      if (response.groupings[0].questions[j].isParentQuestion === false && (this.mergingAssessmentAnswers[j] === undefined || this.mergingAssessmentAnswers[j].answerText === 'U')) {
            this.mergingAssessmentAnswers[j] = {
              answerId: null,
              questionId: response.groupings[0].questions[j].questionId,
              questionType: null,
              questionNumber: '0',
              answerText: response.groupings[0].questions[j].answer,
              altAnswerText: null,
              freeResponseAnswer: null,
              comment: null,
              feedback: null,
              markForReview: false,
              reviewed: false,
              is_Component: false,
              is_Requirement: false,
              is_Maturity: true,
              componentGuid: '00000000-0000-0000-0000-000000000000'
            }
      }
    }

    if (this.count === this.ncuaSvc.assessmentsToMerge.length) {
      this.finishPageLoad();
    }
  }

  finishPageLoad() {
    this.mergingAssessmentAnswers = this.mergingAssessmentAnswers.filter(n => n);
    this.pageLoading = false;
  }

  getConflicts() {
    // run stored proc to grab any differing answers between assessments
    this.ncuaSvc.getAnswers().subscribe(
      (response: any) => {
        this.mergeConflicts = response;
        console.log("this.mergeConflicts: " + JSON.stringify(this.mergeConflicts, null, 4));
        this.getAssessmentNames();
      }
    );
  }

  getAssessmentNames() {
    if (this.mergeConflicts.length > 0) {
      this.assessmentNames[0] = this.mergeConflicts[0].assessment_Name1;
      this.assessmentNames[1] = this.mergeConflicts[0].assessment_Name2;
      this.assessmentNames[2] = this.mergeConflicts[0].assessment_Name3;
      this.assessmentNames[3] = this.mergeConflicts[0].assessment_Name4;
      this.assessmentNames[4] = this.mergeConflicts[0].assessment_Name5;
      this.assessmentNames[5] = this.mergeConflicts[0].assessment_Name6;
      this.assessmentNames[6] = this.mergeConflicts[0].assessment_Name7;
      this.assessmentNames[7] = this.mergeConflicts[0].assessment_Name8;
      this.assessmentNames[8] = this.mergeConflicts[0].assessment_Name9;
      this.assessmentNames[9] = this.mergeConflicts[0].assessment_Name10;
    }
  }

  getAssessmentContactInitials() {
    if (this.assessSvc.id()) {
      this.assessSvc.getAssessmentContacts().then((data: AssessmentContactsResponse) => {
        let firstInitial = data.contactList[0].firstName[0];
        let lastInitial = data.contactList[0].lastName[0];
        let contactInitials = firstInitial + lastInitial;
        this.contactsInitials.push(contactInitials);
        this.initialsAsString = this.contactsInitials.join("_");
        }
      )
    }
  }

  navToHome() {
    this.router.navigate(['/landing-page']);
  }

  updateAnswers(i: number, value: string) {
    if (value === 'yes') {
      this.mergeRadioSelections[i] = "Y";
    } else if (value === 'no') {
      this.mergeRadioSelections[i] = "N";
    } else if (value === 'na') {
      this.mergeRadioSelections[i] = "NA";
    }
  }

  // convert "Y" or "N" or "NA" into an ANSWER Object
  convertToAnswerType(length: number, answers: string[]) {
    for (let i = 0; i < length; i++) {
      this.mergeAnswers[i] = {
        answerId: null,
        questionId: this.mergeConflicts[i].question_Or_Requirement_Id1,
        questionType: null,
        questionNumber: '0',
        answerText: answers[i],
        altAnswerText: null,
        freeResponseAnswer: null,
        comment: null,
        feedback: null,
        markForReview: false,
        reviewed: false,
        is_Component: false,
        is_Requirement: false,
        is_Maturity: true,
        componentGuid: '00000000-0000-0000-0000-000000000000'
      }
    }
  }

  createMergedAssessment() {
    // null out the button to prevent multiple clicks
    this.attemptingToMerge = true;

    this.convertToAnswerType(this.mergeRadioSelections.length, this.mergeRadioSelections);
    localStorage.setItem('questionSet', 'Maturity');

    // Create a brand new assessment
    this.assessSvc.createAssessment("ACET")
    .toPromise()
    .then(
      (response: any) => {
        // Authorize the user to modify the new assessment with a new token
        this.assessSvc.getAssessmentToken(response.id).then(() => {
          
          // Pull the new assessment details (mostly empty/defaults)
          this.assessSvc.getAssessmentDetail().subscribe((details: AssessmentDetail) => {

            // Update the assessment with the merge data and send it back
            details.assessmentName = "Merged ISE " + this.mergeConflicts[0].charter_Number + " " + 
                                      this.datePipe.transform(details.assessmentDate, 'MMddyy') + "_" + this.initialsAsString;
            details.charter = this.mergeConflicts[0].charter_Number;
            details.assets = this.mergeConflicts[0].asset_Amount;
            details.isAcetOnly = false;
            details.useMaturity = true;
            details.maturityModel = this.maturitySvc.getModel("ISE");
            this.assessSvc.updateAssessmentDetails(details);

            for (let i = 0; i < this.mergeAnswers.length; i++) {
              for (let j = 0; j < this.mergingAssessmentAnswers.length; j++) {
                if (this.mergeAnswers[i].questionId === this.mergingAssessmentAnswers[j].questionId) {
                  this.mergingAssessmentAnswers[j].answerText = this.mergeAnswers[i].answerText;
                }
              }
            }

            for (let i = 0; i < this.mergingAssessmentAnswers.length; i++) {
              this.questionSvc.storeAnswer(this.mergingAssessmentAnswers[i]).subscribe((response: any) => {
                this.navToHome();

              });
            }
          })
        })
      })
  }
}