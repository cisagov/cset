import { Component, Input, OnInit } from '@angular/core';
import { Answer, MaturityQuestionResponse, QuestionGrouping } from '../../models/questions.model';
import { AssessmentDetail } from '../../models/assessment-info.model';
import { AssessmentService } from '../../services/assessment.service';
import { ConfigService } from '../../services/config.service';
import { MaturityService } from '../../services/maturity.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';
import { AuthenticationService } from '../../services/authentication.service';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { MergeOptionsComponent } from '../../dialogs/ise-merge-options/merge-options-dialog.component';
import { JsonpClientBackend } from '@angular/common/http';

@Component({
  selector: 'merge-examinations',
  templateUrl: './merge-examinations.component.html',
  styles: ['tr { border-bottom: 1px solid black; text-align: center; }']
})
export class MergeExaminationsComponent implements OnInit {

  pageLoading: boolean = false;

  // Stored proc data
  mergeConflicts: any[] = [];

  // Merging Assessment Names
  assessmentNames: string[] = [];

  // Main Assessment Answers
  mainAssessmentAnswers: Answer[] = [];

  // Values the user picks
  mergeRadioSelections: string[] = [];

  // Radio values converted to an Answer Object
  mergeAnswers: Answer[] = [];

  // The returned merged assessment
  mergedAssessment: AssessmentDetail = {};

  optionsDialog: MatDialogRef<MergeOptionsComponent>;
  mergeContactInitials: string = "";
  attemptingToMerge: boolean = false;


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
    this.getMainAssessmentAnswers();
    this.getConflicts();
  }

  getMainAssessmentAnswers() {
    this.assessSvc.getAssessmentToken(this.ncuaSvc.assessmentsToMerge[0]).then(() => {
    this.maturitySvc.getQuestionsList("ACET", false).subscribe(
      (response: any) => {
        for (let i = 0; i < response.groupings[0].questions.length; i++) {
          if (response.groupings[0].questions[i].isParentQuestion === false &&
              response.groupings[0].questions[i].answer !== null) {
                this.mainAssessmentAnswers[i] = {
                  answerId: null,
                  questionId: response.groupings[0].questions[i].questionId,
                  questionType: null,
                  questionNumber: '0',
                  answerText: response.groupings[0].questions[i].answer,
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
        // filter out null items (parentQuestions) in the array
        this.mainAssessmentAnswers = this.mainAssessmentAnswers.filter(n => n);
      })
    }) 
  }

  getConflicts() {
    // run stored proc to grab any differing answers between assessments
    this.ncuaSvc.getAnswers().subscribe(
      (response: any) => {
        this.mergeConflicts = response;
        console.log("This.mergeConflicts: " + JSON.stringify(this.mergeConflicts, null, 4));
        this.getAssessmentNames();
        this.pageLoading = false;
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

      // get any name that's not null
      let validNames = [];
      let initialsArray = [];
      for (let i = 0; i < this.ncuaSvc.assessmentsToMerge.length; i++) {
          validNames.push(this.assessmentNames[i]);
        }

      // get the contact initials from the end of each examination being merged
      for (let i = 0; i < validNames.length; i++) {
        let initialOne = validNames[i][validNames[i].length - 2];
        let initialTwo = validNames[i][validNames[i].length - 1];
        initialsArray.push(initialOne + initialTwo);
      }

      this.mergeContactInitials = initialsArray.join("_");
    } else {
      return
    }
  }

  showMergeOptions() {
    this.optionsDialog = this.dialog.open(MergeOptionsComponent, {});

    this.optionsDialog
    .afterClosed()
    .subscribe(() => {
    });
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
            details.assessmentName = "Merged ISE " + this.datePipe.transform(details.assessmentDate, 'MMddyy') + "_" + this.mergeContactInitials;
            details.isAcetOnly = false;
            details.useMaturity = true;
            details.maturityModel = this.maturitySvc.getModel("ISE");
            this.assessSvc.updateAssessmentDetails(details);
            
            localStorage.setItem("questionSet", "Maturity");
          
            // "Copy" all main assessment answers into the new assessment
            for (let i = 0; i < this.mainAssessmentAnswers.length; i++) {
              this.questionSvc.storeAnswer(this.mainAssessmentAnswers[i]).subscribe((response: any) => {
                
                // Overwrite answers with conflict resolution answers (the "merge" functionality)
                this.convertToAnswerType(this.mergeRadioSelections.length, this.mergeRadioSelections);
                for (let i = 0; i < this.mergeAnswers.length; i++) {
                  this.questionSvc.storeAnswer(this.mergeAnswers[i]).subscribe();
                }
              })
            }

            this.navToHome();
          })
        })
      })
  }
}