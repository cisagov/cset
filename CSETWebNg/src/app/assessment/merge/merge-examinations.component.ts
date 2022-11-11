import { Component, OnInit } from '@angular/core';
import { Answer, MaturityQuestionResponse } from '../../models/questions.model';
import { AssessmentDetail } from '../../models/assessment-info.model';
import { AssessmentService } from '../../services/assessment.service';
import { ConfigService } from '../../services/config.service';
import { MaturityService } from '../../services/maturity.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';
import { Router } from '@angular/router';
import { DatePipe } from '@angular/common';
import { IRPService } from '../../services/irp.service';
import { IRPResponse } from '../../models/irp.model';
import { FindingsService } from '../../services/findings.service';
import { ActionItemText } from '../questions/findings/findings.model';

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

  // "Base" data to carry over
  primaryAssessDetails: any;
  primaryAssessIrp: any;
  assessmentComments = new Map();
  assessmentIssues = new Map();
  newAnswerIds = new Map();
  parentQuestionIds = new Set([7568,7577,7582,7588,7594,7602,7607,7612,7619,7628,7633,
                              7639,7645,7652,7655,7661,7669,7674,7679,7683,7687,7691,
                              7694,7699,7853,7869,7875,7891,7902, 7912, 7919]);

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
    public irpSvc: IRPService,
    public findSvc: FindingsService,
    private router: Router,
    public datePipe: DatePipe,
  ) { }

  ngOnInit() {
    this.pageLoading = true;
    this.getPrimaryAssessDetails();
    this.getExistingAssessmentAnswers();
    this.getIssues();
    this.getConflicts();
  }

  getPrimaryAssessDetails() {
    let id = this.ncuaSvc.assessmentsToMerge[0];
    this.assessSvc.getAssessmentToken(id).then(() => {
      
      // Grab the Assess Config details
      this.assessSvc.getAssessmentDetail().subscribe(data => {
        this.primaryAssessDetails = data;
      });

      // Grab the IRP values
      this.irpSvc.getIRPList().subscribe(
        (data: IRPResponse) => {
          this.primaryAssessIrp = data.headerList[5].irpList;
        });
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
          // Combine all the existing comments into a map (this is mainly for merge conflicts comment combining)
          if (response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment !== "" &&
              response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment !== null) {
            if (!this.assessmentComments.has(response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId)) {
              this.assessmentComments.set(
                response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId,
                response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment);
            } else {
              let myString = this.assessmentComments.get(response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId);
              myString += ("\n" + response.groupings[0].subGroupings[i].subGroupings[j].questions[k].comment);
              this.assessmentComments.set(response.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId, myString);
              console.log(this.assessmentComments);
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

  getIssues() {
    let myIssues = [];
    this.ncuaSvc.assessmentsToMerge.forEach(assessId => {
      this.assessSvc.getAssessmentToken(assessId).then(() => {
        this.parentQuestionIds.forEach(parentId => {

          // Get issues and all their data
          this.questionSvc.getDetails(parentId, 'Maturity').subscribe(
            (details) => {
              details.findings.forEach(find => {
                myIssues.push(find);
                this.assessmentIssues.set(parentId, myIssues);
              });
              myIssues = [];
            });
        });
      });
    });
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
    let comment = "";
    for (let i = 0; i < length; i++) {
      if (this.assessmentComments.has(this.mergeConflicts[i].question_Or_Requirement_Id1)) {
        comment += this.assessmentComments.get(this.mergeConflicts[i].question_Or_Requirement_Id1);
        console.log(comment);
      } else {
        comment = "";
      }
      
      this.selectedMergeAnswers[i] = {
        answerId: null,
        questionId: this.mergeConflicts[i].question_Or_Requirement_Id1,
        questionType: null,
        questionNumber: '0',
        answerText: answers[i],
        altAnswerText: null,
        freeResponseAnswer: null,
        comment: comment,
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

  saveNewIssues(parentKey: number, issueArray: any[]) {
    let actionItemsOverride = new Map();
    
    // For every issue we have from the original assessments
    issueArray.forEach((issue, index)  => {
    this.questionSvc.getActionItems(parentKey, issue.finding_Id).subscribe(
      (data: any) => {
        data.forEach(item => {
          // Grab each of the action items
          let importantBits: ActionItemText = {Mat_Question_Id: item.question_Id, ActionItemOverrideText: item.action_Items};
          actionItemsOverride.set(item.question_Id, importantBits);
        })

        // Set the finding_Id to 0 to ask the API to generate a new issue for us
        issue.finding_Id = 0;
        issue.answer_Id = this.newAnswerIds.get(parentKey);      
        this.findSvc.saveDiscovery(issue).subscribe((response: any) => {
          // Grab the newly created issue's finding_Id
          let mapToArray = Array.from(actionItemsOverride.values());
          actionItemsOverride.clear();
          this.findSvc.saveIssueText(mapToArray, response).subscribe();
          
          if (index === issueArray.length - 1) {
            // We're finally finished. Go back to the main assessment page.
            this.navToHome();
          } else {

          }
        });
      });
    });
  }


  createMergedAssessment() {
    // Null out the button to prevent multiple clicks
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

            // Add the IRP values back in
            this.irpSvc.getIRPList().subscribe(
              (data: IRPResponse) => {
                // There are 9 ISE IRP questions
                for (let i = 0; i < 9; i++) {
                  this.irpSvc.postSelection(this.primaryAssessIrp[i]).subscribe();
                }
              });

            // Set all of the questions "details" (answerText, comments, etc).
            // This traverses our question list and overrides anything in there if we've
            // picked a new answer with the merge conflict.
            for (let i = 0; i < this.selectedMergeAnswers.length; i++) {
              for (let j = 0; j < this.existingAssessmentAnswers.length; j++) {
                if (this.selectedMergeAnswers[i].questionId === this.existingAssessmentAnswers[j].questionId) {
                  this.existingAssessmentAnswers[j].answerText = this.selectedMergeAnswers[i].answerText;
                  this.existingAssessmentAnswers[j].comment = this.selectedMergeAnswers[i].comment;
                  this.existingAssessmentAnswers[j].altAnswerText += "\n" + this.selectedMergeAnswers[i].altAnswerText;
                }
              }
            }
            
            // Send off a list of the assessment's new answers to the API to save.
            this.questionSvc.storeAllAnswers(this.existingAssessmentAnswers).subscribe((response: any) => {
              this.maturitySvc.getQuestionsList(this.configSvc.installationMode, false).subscribe(
                (questionListResponse: MaturityQuestionResponse) => {

                  // Grab all the new answer_id's to save Issues to the new questions
                  for (let i = 0; i < questionListResponse.groupings[0].subGroupings.length; i++) {
                    for (let j = 0; j < questionListResponse.groupings[0].subGroupings[i].subGroupings.length; j++) {
                      for (let k = 0; k < questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
                        if (questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions[k].isParentQuestion === true) {
                          this.newAnswerIds.set(
                            questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions[k].questionId,
                            questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions[k].answer_Id);
                        }
                      }
                    }
                  }

                  // This block uses the previous answer_Id's to persist issues on the new assessment
                  const iterator = this.assessmentIssues.entries();
                  let parentKey = 0;

                  if (this.assessmentIssues.size !== 0) {
                    for (let iter of iterator) {
                      parentKey = iter[0];
                      let issueArray = this.assessmentIssues.get(parentKey);
                      this.saveNewIssues(parentKey, issueArray);
                    }
                  } else {
                    this.navToHome();
                  }
              });
            });
          });
      });
    });
  }

}