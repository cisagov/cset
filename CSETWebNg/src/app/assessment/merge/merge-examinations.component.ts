import { Component, Input, OnInit } from '@angular/core';
import { Answer } from '../../models/questions.model';
import { , AssessmentDetail } from '../../models/assessment-info.model';
import { AssessmentService } from '../../services/assessment.service';
import { ConfigService } from '../../services/config.service';
import { MaturityService } from '../../services/maturity.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';

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
  primaryAssessDetails: any;

  // Assessment Names & pieces of the merged assessment naming convention
  assessmentNames: string[] = [];
  contactsInitials: any[] = [];
  mergedContactInitials: string = "";

  // Answers pulled from the assessments being merged (that aren't in conflict)
  apiData = new Map();
  existingAssessmentAnswers: Answer[] = [];

  // Values the user picks
  mergeRadioSelections: string[] = [];

  // Radio values converted to an Answer Object
  selectedMergeAnswers: Answer[] = [];

  // The returned merged assessment
  mergedAssessment: AssessmentDetail = {};
  attemptingToMerge: boolean = false;

  // "Temp" variables to help the merge track when it needs to do certain things.
  dataReceivedCount: number = 0;
  assessmentsProcessed: number = 0;
  questionsProcessed: number = 0;

  constructor(
    public ncuaSvc: NCUAService,
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public questionSvc: QuestionsService,
    public configSvc: ConfigService,
    private router: Router,
    public datePipe: DatePipe,

  ) { }

  ngOnInit() {
    this.pageLoading = true;
    this.getPrimaryAssessDetails();
    this.getExistingAssessmentAnswers();
    this.getConflicts();
  }

  getPrimaryAssessDetails() {
    let id = this.ncuaSvc.assessmentsToMerge[0];
    this.assessSvc.getAssessmentToken(id).then(() => {
      this.assessSvc.getAssessmentDetail().subscribe(data => {
        this.primaryAssessDetails = data;
      })
    });
  }

  getExistingAssessmentAnswers() {
    this.assessSvc.getAssessmentToken(this.ncuaSvc.assessmentsToMerge[this.dataReceivedCount]).then(() => {
      this.maturitySvc.getQuestionsList("ACET", false).subscribe(
        (response: any) => {
          this.dataReceivedCount++;
          this.aggregateExistingAnswers(response);
        }
      )
    })
  }

  aggregateExistingAnswers(response) {
    let l = 0;
    // A 3 tiered loop to check under ever grouping level to grab ALL questions
    for (let i = 0; i < response.groupings[0].subGroupings.length; i++) {
      for (let j = 0; j < response.groupings[0].subGroupings[i].subGroupings.length; j++) {
        for (let k = 0; k < response.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
          
          if (response.groupings[0].subGroupings[i].subGroupings[j].questions[k].isParentQuestion === false) {
            if (this.assessmentsProcessed === 0) {
              // If it's our first pass through, set all the questions.
              this.existingAssessmentAnswers.push({
                answerId: null,
                questionId: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId,
                questionType: null,
                questionNumber: '0',
                answerText: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].answer,
                altAnswerText: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].altAnswerText,
                freeResponseAnswer: null,
                comment: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment,
                feedback: null,
                markForReview: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].markForReview,
                reviewed: false,
                is_Component: false,
                is_Requirement: false,
                is_Maturity: true,
                componentGuid: '00000000-0000-0000-0000-000000000000'
              });
            } else if (this.assessmentsProcessed > 0) {
              // If it's not our first pass through, ONLY add questions if it was unanswered previously
              if (this.existingAssessmentAnswers[l].answerText === "U") {
                this.existingAssessmentAnswers[l] = {
                  answerId: null,
                  questionId: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId,
                  questionType: null,
                  questionNumber: '0',
                  answerText: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].answer,
                  altAnswerText: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].altAnswerText,
                  freeResponseAnswer: null,
                  comment: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment,
                  feedback: null,
                  markForReview: response.groupings[0].subGroupings[i].subGroupings[j].questions[k].markForReview,
                  reviewed: false,
                  is_Component: false,
                  is_Requirement: false,
                  is_Maturity: true,
                  componentGuid: '00000000-0000-0000-0000-000000000000'
                }
              }
              l++;
            }
          }
        }
      }
    }    
    this.assessmentsProcessed++;

    if (this.dataReceivedCount !== this.ncuaSvc.assessmentsToMerge.length) {
      this.getExistingAssessmentAnswers();
    } else {
      this.finishPageLoad();
    }
  }

  getConflicts() {
    // run stored proc to grab any differing answers between assessments
    this.ncuaSvc.getAnswers().subscribe(
      (response: any) => {
        if (response.length > 0) {
          this.mergeConflicts = response;
        }
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

  finishPageLoad() {
    this.pageLoading = false;
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

      this.selectedMergeAnswers[i] = {
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
    }
    if (this.mergeConflicts[i].alt_Text2 !== null && this.mergeConflicts[i].alt_Text2 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text2 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text3 !== null && this.mergeConflicts[i].alt_Text3 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text3 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text4 !== null && this.mergeConflicts[i].alt_Text4 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text4 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text5 !== null && this.mergeConflicts[i].alt_Text5 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text5 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text6 !== null && this.mergeConflicts[i].alt_Text6 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text6 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text7 !== null && this.mergeConflicts[i].alt_Text7 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text7 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text8 !== null && this.mergeConflicts[i].alt_Text8 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text8 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text9 !== null && this.mergeConflicts[i].alt_Text9 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text9 + "\n";
    }
    if (this.mergeConflicts[i].alt_Text10 !== null && this.mergeConflicts[i].alt_Text10 !== undefined) {
      myString += this.mergeConflicts[i].alt_Text10 + "\n";
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

            // Update the assessment with the new data and send it back.
            details.assessmentName = "Merged ISE " + this.primaryAssessDetails.charter + " " + 
                                        this.datePipe.transform(details.assessmentDate, 'MMddyy') + this.mergedContactInitials;
            details.cityOrSiteName = this.primaryAssessDetails.cityOrSiteName;
            details.stateProvRegion = this.primaryAssessDetails.stateProvRegion;
            details.creditUnion = this.primaryAssessDetails.creditUnion;
            details.charter = this.primaryAssessDetails.charter;
            details.assets = this.primaryAssessDetails.assets;
            details.isAcetOnly = true;
            details.useMaturity = true;
            details.maturityModel = this.maturitySvc.getModel("ISE");
            this.assessSvc.updateAssessmentDetails(details);

            // Set all of the questions "details" (answerText, comments, etc)
            for (let i = 0; i < this.selectedMergeAnswers.length; i++) {
              for (let j = 0; j < this.existingAssessmentAnswers.length; j++) {
                if (this.selectedMergeAnswers[i].questionId === this.existingAssessmentAnswers[j].questionId) {
                  this.existingAssessmentAnswers[j].answerText = this.selectedMergeAnswers[i].answerText;
                  this.existingAssessmentAnswers[j].comment = this.selectedMergeAnswers[i].comment;
                  this.existingAssessmentAnswers[j].altAnswerText = this.selectedMergeAnswers[i].altAnswerText;
                }
              }
            }
            
            // Send off a list of the assessment's new answers to the API to save. Then go to the main assessment screen
            this.questionSvc.storeAllAnswers(this.existingAssessmentAnswers).subscribe((response: any) => {
              this.navToHome();
            });
        })
      })
    })
  }
}