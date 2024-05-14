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
import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentDetail } from '../../models/assessment-info.model';
import { IRPResponse } from '../../models/irp.model';
import { Answer, MaturityQuestionResponse } from '../../models/questions.model';
import { AssessmentService } from '../../services/assessment.service';
import { ConfigService } from '../../services/config.service';
import { ObservationsService } from '../../services/observations.service';
import { IRPService } from '../../services/irp.service';
import { MaturityService } from '../../services/maturity.service';
import { NCUAService } from '../../services/ncua.service';
import { QuestionsService } from '../../services/questions.service';
import { ActionItemText } from '../questions/observations/observations.model';

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
  parentQuestionIds = new Set([7568, 7577, 7582, 7588, 7594, 7602, 7607, 7612, 7619, 7628, 7633,
    7639, 7645, 7652, 7655, 7661, 7669, 7674, 7679, 7683, 7687, 7691,
    7694, 7699, 7852, 7868, 7874, 7890, 7901, 7911, 7918, 7947, 7966]);

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
    public observationSvc: ObservationsService,
    private router: Router,
    public datePipe: DatePipe,
  ) { }

  ngOnInit() {
    this.pageLoading = true;
    this.getPrimaryAssessDetails();
    this.getConflicts();
    this.getIssues();
    this.getExistingAssessmentAnswers();
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

  getConflicts() {
    // run stored proc to grab any differing answers between assessments
    this.ncuaSvc.getAnswers().subscribe(
      (response: any) => {
        if (response.length > 0) {
          this.mergeConflicts = response;
          this.getAssessmentNames();
        } else {
          this.ncuaSvc.getNames().subscribe((result: any) => this.getAssessmentNames(result));
        }
      }
    );
  }

  getIssues() {
    this.ncuaSvc.assessmentsToMerge.forEach(assessId => {
      this.assessSvc.getAssessmentToken(assessId).then(() => {
        this.parentQuestionIds.forEach(parentId => {

          // Get issues and all their data
          this.questionSvc.getDetails(parentId, 'Maturity').subscribe(
            (details) => {
              let myIssues = [];
              details.observations.forEach(obs => {
                myIssues.push(obs);
              });

              if (myIssues.length > 0) {
                if (this.assessmentIssues.get(parentId) !== undefined) {
                  let arr = this.assessmentIssues.get(parentId);
                  let savedIssues = arr.concat(myIssues);
                  this.assessmentIssues.set(parentId, savedIssues);
                } else {
                  this.assessmentIssues.set(parentId, myIssues);
                }
              }
            });
        });
      });
    });
  }

  getExistingAssessmentAnswers() {
    this.assessSvc.getAssessmentToken(this.ncuaSvc.assessmentsToMerge[this.dataReceivedCount]).then(() => {
      this.maturitySvc.getQuestionsList(false).subscribe(
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
          let question = response.groupings[0].subGroupings[i].subGroupings[j].questions[k];

          // Combine the existing comments
          if (question.comment !== "" && question.comment !== null) {
            if (!this.assessmentComments.has(question.questionId)) {
              this.assessmentComments.set(question.questionId, question.comment);
            } else {
              let myString = this.assessmentComments.get(question.questionId);
              myString += ("\n" + question.comment);
              this.assessmentComments.set(question.questionId, myString);
            }
          }

          let answerToSave: Answer = {
            answerId: null,
            questionId: question.questionId,
            questionType: null,
            questionNumber: '0',
            answerText: question.answer,
            altAnswerText: question.altAnswerText,
            freeResponseAnswer: null,
            comment: question.comment,
            feedback: null,
            markForReview: question.markForReview,
            reviewed: false,
            is_Component: false,
            is_Requirement: false,
            is_Maturity: true,
            componentGuid: '00000000-0000-0000-0000-000000000000'
          }

          if (this.assessmentsProcessed === 0) {
            // If it's our first pass through, set all the questions.
            this.existingAssessmentAnswers.push(answerToSave);
          } else if (this.assessmentsProcessed > 0 && this.existingAssessmentAnswers[l].answerText === 'U') {
            // If it's not our first pass through, ONLY add questions if it was unanswered previously
            this.existingAssessmentAnswers[l] = answerToSave;
          }
          l++;
        }
      }
    }
    // Are we finished going over every assessment we want to merge?
    if (this.dataReceivedCount !== this.ncuaSvc.assessmentsToMerge.length) {
      this.assessmentsProcessed++;
      this.getExistingAssessmentAnswers();
    } else {
      // Once we have all the comments from all the assessments, combine them.
      for (let i = 0; i < this.existingAssessmentAnswers.length; i++) {
        if (this.assessmentComments.has(this.existingAssessmentAnswers[i].questionId)) {
          this.existingAssessmentAnswers[i].comment = this.assessmentComments.get(this.existingAssessmentAnswers[i].questionId);
        }
      }
      // Stop the loading spinner once we're done with all our prep
      this.finishPageLoad();
    }
  }

  getAssessmentNames(result = '') {
    if (result === '') {
      let names = [];

      if (this.mergeConflicts.length > 0) {
        names.push(this.mergeConflicts[0].assessment_Name1, this.mergeConflicts[0].assessment_Name2, this.mergeConflicts[0].assessment_Name3,
          this.mergeConflicts[0].assessment_Name4, this.mergeConflicts[0].assessment_Name5, this.mergeConflicts[0].assessment_Name6,
          this.mergeConflicts[0].assessment_Name7, this.mergeConflicts[0].assessment_Name8, this.mergeConflicts[0].assessment_Name9,
          this.mergeConflicts[0].assessment_Name10);
      }

      for (let i = 0; i < names.length; i++) {
        this.assessmentNames[i] = names[i];
      }

      this.assessmentNames.forEach(name => {
        if (name !== null) {
          this.getAssessmentContactInitials(name);
        }
      });
    } else {
      for (let i = 0; i < result.length; i++) {
        this.getAssessmentContactInitials(result[i]);
      }
    }
  }

  getAssessmentContactInitials(assessmentName: string) {
    let splitArray = assessmentName.split("_");
    let initials = splitArray[1];
    this.mergedContactInitials += ("_" + initials);
  }

  finishPageLoad() {
    this.pageLoading = false;
  }

  navToHome() {
    this.ncuaSvc.prepForMerge = false;
    this.router.navigate(['/landing-page']);
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
      let tempArray = altText.split("- - End of Note - -");
      for (let i = 0; i < tempArray.length; i++) {
        if (!tempArray[i].includes("- - End of Note - -")) {
          commentString += tempArray[i];
        }
      }
      return commentString;
    }
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
    // Make sure we pull in comments from all conflicting answers
    let comment = "";
    for (let i = 0; i < length; i++) {
      if (this.assessmentComments.has(this.mergeConflicts[i].question_Or_Requirement_Id1)) {
        comment += this.assessmentComments.get(this.mergeConflicts[i].question_Or_Requirement_Id1);
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
    // For every issue we have from the original assessments
    issueArray.forEach((issue, index) => {
      let actionItemsOverride: ActionItemText[] = [];

      this.questionSvc.getActionItems(parentKey, issue.observation_Id).subscribe((data: any) => {

        for (let i = 0; i < data.length; i++) {
          actionItemsOverride.push({ Mat_Question_Id: data[i].question_Id, ActionItemOverrideText: data[i].action_Items });
        }

        issue.observation_Id = 0;
        issue.answer_Id = this.newAnswerIds.get(parentKey);

        this.observationSvc.saveObservation(issue).subscribe((response: any) => {
          this.observationSvc.saveIssueText(actionItemsOverride, response).subscribe();

          if (index === (issueArray.length - 1)) {
            this.navToHome();
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

    // Create a fake gallery item for the GUID. Using ISE's GUID because only ISE's can be merged currently
    let galItem = { gallery_Item_Guid: "f2407ff1-9f0f-420b-8f86-8528b60fcbc1" };

    // Create a brand new assessment
    this.assessSvc.createNewAssessmentFromGallery("ACET", galItem)
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
              details.isE_StateLed = this.primaryAssessDetails.isE_StateLed;
              details.regionCode = this.primaryAssessDetails.regionCode;
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
                this.maturitySvc.getQuestionsList(false).subscribe(
                  (questionListResponse: MaturityQuestionResponse) => {

                    // Grab all the new answer_id's to save Issues to the new questions
                    for (let i = 0; i < questionListResponse.groupings[0].subGroupings.length; i++) {
                      for (let j = 0; j < questionListResponse.groupings[0].subGroupings[i].subGroupings.length; j++) {
                        for (let k = 0; k < questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
                          let question = questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions[k];

                          if (question.isParentQuestion === true) {
                            this.newAnswerIds.set(question.questionId, question.answer_Id);
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
                      // If we dont have any issues, we can be done.
                      this.navToHome();
                    }
                  });
              });
            });
          });
        });
  }

}