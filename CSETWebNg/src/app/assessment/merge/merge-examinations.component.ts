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
  mergedContactInitials: string = "";

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
        this.maturitySvc.getQuestionsList("ACET", false).subscribe(
          (response: any) => {
            this.aggregateExistingAnswers(response);
          })
      })
    }
  }

  aggregateExistingAnswers(response) {
    this.count++;

    /** A 3 tiered loop to check under ever grouping level.
    /* TODO: Currently breaks if SCUEP statements 1 - 7 are answered and 
    /* CORE statements 1 - 7 are also answered.
    **/
    for (let i = 0; i < response.groupings[0].subGroupings.length; i++) {
      for (let j = 0; j < response.groupings[0].subGroupings[i].subGroupings.length; j++) {
        for (let k = 0; k < response.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
        if (response.groupings[0].subGroupings[i].subGroupings[j].questions[k].isParentQuestion === false && 
            (this.mergingAssessmentAnswers[k] === undefined || this.mergingAssessmentAnswers[k].answerText === 'U')) 
          {
            this.mergingAssessmentAnswers[k] = {
              answerId: null,
              questionId: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId,
              questionType: null,
              questionNumber: '0',
              answerText: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].answer,
              altAnswerText: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].altAnswerText,
              freeResponseAnswer: null,
              comment: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment,
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

      this.assessmentNames.forEach(name => {
        if (name !== null) {
          this.getAssessmentContactInitials(name);
        }
      });
    }
  }

  getAssessmentContactInitials(assessmentName: string) {
    let splitArray = assessmentName.split("_");
    let initials = splitArray[1];
    this.mergedContactInitials += ("_" + initials);
  }

  getDisplayText(answerText: String) {
    if (answerText === 'U') {
      return '';
    } else if (answerText === 'A') {
      return 'Comment';
    } else {
      return answerText;
    }
  }

  getAltText(altText: any) {
    let commentString = "";

    if (altText === null || altText === "") {
      return "";
    } else {
      let tempArray = altText.split("- - End of Comment - -");
      for (let i = 0; i < tempArray.length; i++) {
        if (!tempArray[i].includes("- - End of Comment - -")) {
          commentString += tempArray[i];
        }
      }
      return commentString;
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
      let comments = this.combineComments(i);
      let altText = this.combineAltText(i);

      this.mergeAnswers[i] = {
        answerId: null,
        questionId: this.mergeConflicts[i].question_Or_Requirement_Id1,
        questionType: null,
        questionNumber: '0',
        answerText: answers[i],
        altAnswerText: altText,
        freeResponseAnswer: null,
        comment: comments,
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

  combineComments(length: number) {
    let myString = "";
    /*
    for (let i = 0; i < length; i++) {
      if (this.mergeConflicts[i].comment1 !== null) {
        myString += this.mergeConflicts[i].comment1 + "\n";
      }
      if (this.mergeConflicts[i].comment2 !== null) {
        myString += this.mergeConflicts[i].comment2 + "\n";
      }
      if (this.mergeConflicts[i].comment3 !== null) {
        myString += this.mergeConflicts[i].comment3 + "\n";
      }
      if (this.mergeConflicts[i].comment4 !== null) {
        myString += this.mergeConflicts[i].comment1 + "\n";
      }
      if (this.mergeConflicts[i].comment5 !== null) {
        myString += this.mergeConflicts[i].comment2 + "\n";
      }
      if (this.mergeConflicts[i].comment6 !== null) {
        myString += this.mergeConflicts[i].comment3 + "\n";
      }
      if (this.mergeConflicts[i].comment7 !== null) {
        myString += this.mergeConflicts[i].comment1 + "\n";
      }
      if (this.mergeConflicts[i].comment8 !== null) {
        myString += this.mergeConflicts[i].comment2 + "\n";
      }
      if (this.mergeConflicts[i].comment9 !== null) {
        myString += this.mergeConflicts[i].comment3 + "\n";
      }
      if (this.mergeConflicts[i].comment10 !== null) {
        myString += this.mergeConflicts[i].comment4 + "\n";
      }
    }
    */
    return myString;
  }

  combineAltText(i: number) {
    let myString = "";
    if (this.mergeConflicts[i].alt_Text1 !== null && this.mergeConflicts[i].alt_Text1 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text1 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text1: " + this.mergeConflicts[i].alt_Text1);
    }
    if (this.mergeConflicts[i].alt_Text2 !== null && this.mergeConflicts[i].alt_Text2 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text2 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text2: " + this.mergeConflicts[i].alt_Text2);
    }
    if (this.mergeConflicts[i].alt_Text3 !== null && this.mergeConflicts[i].alt_Text3 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text3 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text3: " + this.mergeConflicts[i].alt_Text3);
    }
    if (this.mergeConflicts[i].alt_Text4 !== null && this.mergeConflicts[i].alt_Text4 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text4 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text4: " + this.mergeConflicts[i].alt_Text4);
    }
    if (this.mergeConflicts[i].alt_Text5 !== null && this.mergeConflicts[i].alt_Text5 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text5 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text5: " + this.mergeConflicts[i].alt_Text5);
    }
    if (this.mergeConflicts[i].alt_Text6 !== null && this.mergeConflicts[i].alt_Text6 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text6 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text6: " + this.mergeConflicts[i].alt_Text6);
    }
    if (this.mergeConflicts[i].alt_Text7 !== null && this.mergeConflicts[i].alt_Text7 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text7 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text7: " + this.mergeConflicts[i].alt_Text7);
    }
    if (this.mergeConflicts[i].alt_Text8 !== null && this.mergeConflicts[i].alt_Text8 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text8 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text8: " + this.mergeConflicts[i].alt_Text8);
    }
    if (this.mergeConflicts[i].alt_Text9 !== null && this.mergeConflicts[i].alt_Text9 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text9 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text9: " + this.mergeConflicts[i].alt_Text9);   
    }
    if (this.mergeConflicts[i].alt_Text10 !== null && this.mergeConflicts[i].alt_Text10 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text10 + "\n";
      console.log("this.mergeConflicts[" + i + "].alt_Text10: " + this.mergeConflicts[i].alt_Text10);
    }
  return myString;
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
                                      this.datePipe.transform(details.assessmentDate, 'MMddyy') + this.mergedContactInitials;
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
                  this.mergingAssessmentAnswers[j].comment = this.mergeAnswers[i].comment;
                  this.mergingAssessmentAnswers[j].altAnswerText = this.mergeAnswers[i].altAnswerText;
                  console.log("mergeAnswers[i].altAnswerText" + this.mergeAnswers[i].altAnswerText);
                  console.log("mergingAssessmentAnswers[j].Alt Text: " + this.mergingAssessmentAnswers[j].altAnswerText);
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