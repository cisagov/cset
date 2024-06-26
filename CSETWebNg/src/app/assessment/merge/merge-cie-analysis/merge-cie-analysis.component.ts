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
import { AssessmentDetail } from '../../../models/assessment-info.model';
import { IRPResponse } from '../../../models/irp.model';
import { Answer, MaturityQuestionResponse } from '../../../models/questions.model';
import { AssessmentService } from '../../../services/assessment.service';
import { ConfigService } from '../../../services/config.service';
import { ObservationsService } from '../../../services/observations.service';
import { IRPService } from '../../../services/irp.service';
import { MaturityService } from '../../../services/maturity.service';
import { CieService } from '../../../services/cie.service';
import { QuestionsService } from '../../../services/questions.service';
import { ActionItemText } from '../../questions/observations/observations.model';
import { ReportService } from '../../../services/report.service';

@Component({
  selector: 'app-merge-cie-analysis',
  templateUrl: './merge-cie-analysis.component.html',
  styles: ['tr { border-bottom: 1px solid black; text-align: center; }']
})
export class MergeCieAnalysisComponent implements OnInit {
  // Show a spinner on the frontend if the "behind the scenes" code is still running.
  pageLoading: boolean = false;

  // Stored proc data
  mergeConflicts: any[] = [];

  // "Base" data to carry over
  primaryAssessDetails: any;
  primaryAssessIrp: any;
  assessmentAnswers = new Map();
  assessmentFreeResponses = new Map();
  assessmentNAReasons = new Map();
  assessmentFeedback = new Map();
  assessmentComment = new Map();
  assessmentCombinedFreeResponse = new Map();
  assessmentCombinedFeedback = new Map();
  assessmentCombinedComment = new Map();

  assessmentContacts: any = [];
  contactsUpdated: number = 0;
  contactsToUpdate: number = 0;

  assessmentIssues = new Map();
  assessmentDocuments = new Map<number, any[]>();

  newAnswerIds = new Map();
  parentQuestionIds = new Set([10932]);

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
  selectedFreeResponseMergeAnswers: Answer[] = [];
  selectedMergeAnswers: Answer[] = [];


  // The returned merged assessment
  mergedAssessment: AssessmentDetail = {};
  attemptingToMerge: boolean = false;

  // "Temp" variables to help the merge track when it needs to do certain things.
  dataReceivedCount: number = 0;
  assessmentsProcessed: number = 0;
  questionsProcessed: number = 0;

  navCounter: number = 0;
  documentsProcessed: boolean = false;
  issuesProcessed: boolean = false;


  constructor(
    public cieSvc: CieService,
    public assessSvc: AssessmentService,
    public maturitySvc: MaturityService,
    public questionSvc: QuestionsService,
    public configSvc: ConfigService,
    public irpSvc: IRPService,
    public observationSvc: ObservationsService,
    private router: Router,
    public datePipe: DatePipe,
    private reportSvc: ReportService
  ) { }

  ngOnInit() {
    this.pageLoading = true;
    this.assessmentDocuments.clear();
    this.assessmentIssues.clear();
    this.getPrimaryAssessDetails();
    this.getConflicts();
    this.getContacts();
    this.getIssues();
    this.getDocuments();
    this.getExistingAssessmentAnswers();
  }

  getPrimaryAssessDetails() {
    let id = this.cieSvc.assessmentsToMerge[0];
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
    this.cieSvc.getAnswers().subscribe(
      (response: any) => {
        if (response.length > 0) {
          this.mergeConflicts = response;
          this.getAssessmentNames();
        } else {
          this.cieSvc.getNames().subscribe((result: any) => this.getAssessmentNames(result));
        }
      }
    );
  }

  getContacts() {
    let assessmentIds = [];

    for (let i = 0; i < this.cieSvc.assessmentsToMerge.length; i++) {
      assessmentIds.push(this.cieSvc.assessmentsToMerge[i]);
    }

    this.assessSvc.getAssessmentContactsById(assessmentIds).subscribe((result: any) => {
      this.assessmentContacts = result;
      this.contactsToUpdate = this.assessmentContacts.length;
    });
  }

  getIssues() {
    this.cieSvc.getObservations().subscribe(
      (details: any) => {
        let myIssues = [];

        details.forEach(pair => {
          pair.observations.forEach(obs => {
            myIssues.push(obs);
          });
        });

        if (myIssues.length > 0) {
          this.maturitySvc.getQuestionsList(false).subscribe(
            (response: any) => {
              for (let i = 0; i < response.groupings[0].subGroupings.length; i++) {
                for (let j = 0; j < response.groupings[0].subGroupings[i].subGroupings.length; j++) {
                  for (let k = 0; k < response.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
                    let question = response.groupings[0].subGroupings[i].subGroupings[j].questions[k];
                    myIssues.forEach(obs => {
                      if (question.questionId == obs.answer.question_Or_Requirement_Id) {
                        if (this.assessmentIssues.get(question.questionId) != null) {
                          let obsForQuestion = this.assessmentIssues.get(question.questionId);
                          obsForQuestion.push(obs);
                          this.assessmentIssues.set(question.questionId, obsForQuestion);
                        } else {
                          let obsArray = [];
                          obsArray.push(obs);
                          this.assessmentIssues.set(question.questionId, obsArray);
                        }
                      }
                      
                    });
                    
                  }
                }
              }
            });
        }
        
      }
    );
  }

  getDocuments() {
    this.cieSvc.getDocuments().subscribe(
      (details: any) => {
        let myDocuments = [];
        details.forEach(pair => {
          pair.documents.forEach(doc => {
            myDocuments.push(doc);
          });
        });

        if (myDocuments.length > 0) {
          this.maturitySvc.getQuestionsList(false).subscribe(
            (response: any) => {
              for (let i = 0; i < response.groupings[0].subGroupings.length; i++) {
                for (let m = 0; m < response.groupings[0].subGroupings[i].questions.length; m++) {
                  let question = response.groupings[0].subGroupings[i].questions[m];
                  myDocuments.forEach(doc => {
                    if (question.questionId == doc.question_Id) {
                      if (this.assessmentDocuments.get(question.questionId) !== undefined) {
                        let existingDocuments = this.assessmentDocuments.get(question.questionId);
                        doc.answer_Id = this.newAnswerIds.get(question.questionId);
                        existingDocuments.push(doc);

                        this.assessmentDocuments.set(question.questionId, existingDocuments);
                      } else {
                        doc.answer_Id = this.newAnswerIds.get(question.questionId);

                        this.assessmentDocuments.set(question.questionId, [doc]);
                      }
                    }
                    
                  });
                }
                for (let j = 0; j < response.groupings[0].subGroupings[i].subGroupings.length; j++) {
                  for (let k = 0; k < response.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
                    let question = response.groupings[0].subGroupings[i].subGroupings[j].questions[k];
                    myDocuments.forEach(doc => {
                      if (question.questionId == doc.question_Id) {
                        if (this.assessmentDocuments.get(question.questionId) !== undefined) {
                          let existingDocuments = this.assessmentDocuments.get(question.questionId);
                          doc.answer_Id = this.newAnswerIds.get(question.questionId);
                          existingDocuments.push(doc);

                          this.assessmentDocuments.set(question.questionId, existingDocuments);
                        } else {
                          doc.answer_Id = this.newAnswerIds.get(question.questionId);

                          this.assessmentDocuments.set(question.questionId, [doc]);
                        }
                      }
                      
                    });
                  }
                }
              }
            });
        }
      }
    );
  }

  getExistingAssessmentAnswers() {
    this.assessSvc.getAssessmentToken(this.cieSvc.assessmentsToMerge[this.dataReceivedCount]).then(() => {
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
      for (let m = 0; m < response.groupings[0].subGroupings[i].questions.length; m++) {
        let question = response.groupings[0].subGroupings[i].questions[m];

        // Combine the existing responses
        if (question.freeResponseAnswer != "" && question.freeResponseAnswer != null) {

          // if the question didn't previously have a mapped response text
          if (!this.assessmentFreeResponses.has(question.questionId) && question.answer == 'U') {
            this.assessmentFreeResponses.set(question.questionId, question.freeResponseAnswer);
          } 
          else if (!this.assessmentNAReasons.has(question.questionId) && question.answer == 'NA') {
            this.assessmentNAReasons.set(question.questionId, question.freeResponseAnswer);
          } 
          else if (this.assessmentFreeResponses.has(question.questionId)) {
            let myString = this.assessmentFreeResponses.get(question.questionId);
            myString += ("\n" + question.freeResponseAnswer);
            this.assessmentFreeResponses.set(question.questionId, myString);
          }
          else if (this.assessmentNAReasons.has(question.questionId)) {
            let myString = this.assessmentNAReasons.get(question.questionId);
            myString += ("\n" + question.freeResponseAnswer);
            this.assessmentNAReasons.set(question.questionId, myString);
          }
        }

        if (question.feedback != null && question.feedback != '') {
          // if the question didn't previously have a mapped feedback
          if (!this.assessmentFeedback.has(question.questionId)) {
            this.assessmentFeedback.set(question.questionId, question.feedback);
          } 
          else if (this.assessmentFeedback.has(question.questionId)) {
            let myString = this.assessmentFeedback.get(question.questionId);
            myString += ("\n" + question.feedback);
            this.assessmentFeedback.set(question.questionId, myString);
          }
        }

        if (question.comment != null && question.comment != '') {
          // if the question didn't previously have a mapped feedback
          if (!this.assessmentComment.has(question.questionId)) {
            this.assessmentComment.set(question.questionId, question.comment);
          } 
          else if (this.assessmentComment.has(question.questionId)) {
            let myString = this.assessmentComment.get(question.questionId);
            myString += ("\n" + question.comment);
            this.assessmentComment.set(question.questionId, myString);
          }
        }

        let answerToSave: Answer = {
          answerId: null,
          questionId: question.questionId,
          questionType: null,
          questionNumber: '0',
          answerText: question.answer,
          altAnswerText: question.altAnswerText,
          freeResponseAnswer: question.freeResponseAnswer,//(question.answer == 'U' && this.assessmentFreeResponses.has(question.questionId)) ? this.assessmentFreeResponses.get(question.questionId) : ((question.answer == 'NA' && this.assessmentNAReasons.has(question.questionId)) ? this.assessmentNAReasons.get(question.questionId) : null),
          comment: question.comment,
          feedback: question.feedback,
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
        } else if (this.assessmentsProcessed > 0 && (this.existingAssessmentAnswers[l].freeResponseAnswer == null
          && this.existingAssessmentAnswers[l].answerText == 'U')
        ) {
          // If it's not our first pass through, ONLY add questions if it was unanswered previously
          this.existingAssessmentAnswers[l] = answerToSave;
        }
        l++;
      }
      for (let j = 0; j < response.groupings[0].subGroupings[i].subGroupings.length; j++) {
        for (let k = 0; k < response.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
          let question = response.groupings[0].subGroupings[i].subGroupings[j].questions[k];

          // Combine the existing responses
          if (question.freeResponseAnswer != "" && question.freeResponseAnswer != null) {

            // if the question didn't previously have a mapped response text
            if (!this.assessmentFreeResponses.has(question.questionId) && question.answer == 'U') {
              this.assessmentFreeResponses.set(question.questionId, question.freeResponseAnswer);
            } 
            else if (!this.assessmentNAReasons.has(question.questionId) && question.answer == 'NA') {
              this.assessmentNAReasons.set(question.questionId, question.freeResponseAnswer);
            } 
            else if (this.assessmentFreeResponses.has(question.questionId)) {
              let myString = this.assessmentFreeResponses.get(question.questionId);
              myString += ("\n" + question.freeResponseAnswer);
              this.assessmentFreeResponses.set(question.questionId, myString);
            }
            else if (this.assessmentNAReasons.has(question.questionId)) {
              let myString = this.assessmentNAReasons.get(question.questionId);
              myString += ("\n" + question.freeResponseAnswer);
              this.assessmentNAReasons.set(question.questionId, myString);
            }
          }

          
          if (question.feedback != null && question.feedback != '') {
            // if the question didn't previously have a mapped feedback
            if (!this.assessmentFeedback.has(question.questionId)) {
              this.assessmentFeedback.set(question.questionId, question.feedback);
            } 
            else if (this.assessmentFeedback.has(question.questionId)) {
              let myString = this.assessmentFeedback.get(question.questionId);
              myString += ("\n" + question.feedback);
              this.assessmentFeedback.set(question.questionId, myString);
            }
          }

          if (question.comment != null && question.comment != '') {
            // if the question didn't previously have a mapped feedback
            if (!this.assessmentComment.has(question.questionId)) {
              this.assessmentComment.set(question.questionId, question.comment);
            } 
            else if (this.assessmentComment.has(question.questionId)) {
              let myString = this.assessmentComment.get(question.questionId);
              myString += ("\n" + question.comment);
              this.assessmentComment.set(question.questionId, myString);
            }
          }
  
          let answerToSave: Answer = {
            answerId: null,
            questionId: question.questionId,
            questionType: null,
            questionNumber: '0',
            answerText: question.answer,
            altAnswerText: question.altAnswerText,
            freeResponseAnswer: question.freeResponseAnswer,//(question.answer == 'U' && this.assessmentFreeResponses.has(question.questionId)) ? this.assessmentFreeResponses.get(question.questionId) : ((question.answer == 'NA' && this.assessmentNAReasons.has(question.questionId)) ? this.assessmentNAReasons.get(question.questionId) : null),
            comment: question.comment,
            feedback: question.feedback,
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
          } else if (this.assessmentsProcessed > 0 && (this.existingAssessmentAnswers[l].freeResponseAnswer == null
            && this.existingAssessmentAnswers[l].answerText == 'U')
          ) {
            // If it's not our first pass through, ONLY add questions if it was unanswered previously
            this.existingAssessmentAnswers[l] = answerToSave;
          }
          l++;
        }
      }
    }

    // Are we finished going over every assessment we want to merge?
    if (this.dataReceivedCount !== this.cieSvc.assessmentsToMerge.length) {
      this.assessmentsProcessed++;
      this.getExistingAssessmentAnswers();
    } else {
      // Once we have all the comments from all the assessments, combine them.
      for (let i = 0; i < this.existingAssessmentAnswers.length; i++) {
        if (this.assessmentFreeResponses.has(this.existingAssessmentAnswers[i].questionId) && this.existingAssessmentAnswers[i].answerText == 'U') {
          this.existingAssessmentAnswers[i].freeResponseAnswer = this.assessmentFreeResponses.get(this.existingAssessmentAnswers[i].questionId);
        }
        else if (this.assessmentNAReasons.has(this.existingAssessmentAnswers[i].questionId) && this.existingAssessmentAnswers[i].answerText == 'NA') {
          this.existingAssessmentAnswers[i].freeResponseAnswer = this.assessmentNAReasons.get(this.existingAssessmentAnswers[i].questionId);
        }

        if (this.assessmentFeedback.has(this.existingAssessmentAnswers[i].questionId)) {
          this.existingAssessmentAnswers[i].feedback = this.assessmentFeedback.get(this.existingAssessmentAnswers[i].questionId);
        }

        if (this.assessmentComment.has(this.existingAssessmentAnswers[i].questionId)) {
          this.existingAssessmentAnswers[i].comment = this.assessmentComment.get(this.existingAssessmentAnswers[i].questionId);
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
          this.getAssessmentContactInitials(name); //check here for merge null names
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
    this.cieSvc.prepForMerge = false;
    this.navCounter = 0;
    this.router.navigate(['/landing-page']);
  }

  getDisplayText(answerText: String, freeResponse: String) {
    
    if (answerText === 'U') {
      return 'Provided Response';
    } else if (answerText === 'NA') {
      return 'Not Applicable';
    } else {
      return answerText;
    }
  }

  getResponseText(responseText: any) {
    let commentString = "";

    if (responseText === null || responseText === "") {
      return "";
    } else {
      let tempArray = responseText.split("- - End of Response - -");
      for (let i = 0; i < tempArray.length; i++) {
        if (!tempArray[i].includes("- - End of Response - -")) {
          commentString += tempArray[i];
        }
      }
      return commentString;
    }
  }

  updateAnswers(i: number, value: string) {
    if (value === 'u') {
      this.mergeRadioSelections[i] = "U";
    } else if (value === 'na') {
      this.mergeRadioSelections[i] = "NA";
    }

  }

  combineFields() {
    this.assessmentCombinedFreeResponse.clear();
    this.assessmentCombinedFeedback.clear();
    this.assessmentCombinedComment.clear();
    
    for (let i = 0; i < this.mergeConflicts.length; i++) {
      let combinedFreeResponse = '';
      let combinedFeedback = '';
      let combinedComment = '';
      
      let selectedAnswer = this.mergeRadioSelections[i];

      for (let j = 0; j < 10; j++) {

        switch (j + 1) {
          case 1:
            // free response
            if (this.mergeConflicts[i].answer_Text1 != null && this.mergeConflicts[i].answer_Text1 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer1 != null) {
                combinedFreeResponse += this.mergeConflicts[i].free_Response_Answer1;
              }
            }
            //feedback
            if (this.mergeConflicts[i].feedback1 != null) {
              combinedFeedback += this.mergeConflicts[i].feedback1;
            }
            //comment
            if (this.mergeConflicts[i].comment1 != null) {
              combinedComment += this.mergeConflicts[i].comment1;
            }
            break;
          case 2:
            // free response
            if (this.mergeConflicts[i].answer_Text2 != null && this.mergeConflicts[i].answer_Text2 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer2 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer2;
              }            
            }
            //feedback
            if (this.mergeConflicts[i].feedback2 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback2;
            }
            //comment
            if (this.mergeConflicts[i].comment2 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment2;
            }
            break;
          case 3:
            // free response
            if (this.mergeConflicts[i].answer_Text3 != null && this.mergeConflicts[i].answer_Text3 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer3 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer3;
              }            
            }   
            //feedback
            if (this.mergeConflicts[i].feedback3 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback3;
            }
            //comment
            if (this.mergeConflicts[i].comment3 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment3;
            }         
            break;
          case 4:
            // free response
            if (this.mergeConflicts[i].answer_Text4 != null && this.mergeConflicts[i].answer_Text4 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer4 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer4;
              }            
            }    
            //feedback
            if (this.mergeConflicts[i].feedback4 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback4;
            }
            //comment
            if (this.mergeConflicts[i].comment4 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment4;
            }        
            break;
          case 5:
            // free response
            if (this.mergeConflicts[i].answer_Text5 != null && this.mergeConflicts[i].answer_Text5 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer5 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer5;
              }            
            }  
            //feedback
            if (this.mergeConflicts[i].feedback5 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback5;
            }
            //comment
            if (this.mergeConflicts[i].comment5 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment5;
            }          
            break;
          case 6:
            // free response
            if (this.mergeConflicts[i].answer_Text6 != null && this.mergeConflicts[i].answer_Text6 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer6 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer6;
              }            
            }       
            //feedback
            if (this.mergeConflicts[i].feedback6 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback6;
            }
            //comment
            if (this.mergeConflicts[i].comment6 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment6;
            }     
            break;
          case 7:
            // free response
            if (this.mergeConflicts[i].answer_Text7 != null && this.mergeConflicts[i].answer_Text7 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer7 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer7;
              }            
            }     
            //feedback
            if (this.mergeConflicts[i].feedback7 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback7;
            }
            //comment
            if (this.mergeConflicts[i].comment7 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment7;
            }       
            break;
          case 8:
            // free response
            if (this.mergeConflicts[i].answer_Text8 != null && this.mergeConflicts[i].answer_Text8 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer8 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer8;
              }            
            }    
            //feedback
            if (this.mergeConflicts[i].feedback8 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback8;
            }
            //comment
            if (this.mergeConflicts[i].comment8 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment8;
            }        
            break;
          case 9:
            // free response
            if (this.mergeConflicts[i].answer_Text9 != null && this.mergeConflicts[i].answer_Text9 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer9 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer9;
              }            
            }   
            //feedback
            if (this.mergeConflicts[i].feedback9 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback9;
            }
            //comment
            if (this.mergeConflicts[i].comment9 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment9;
            }         
            break;
          case 10:
            // free response
            if (this.mergeConflicts[i].answer_Text10 != null && this.mergeConflicts[i].answer_Text10 == selectedAnswer) {
              if (this.mergeConflicts[i].free_Response_Answer10 != null) {
                combinedFreeResponse += '\n' + this.mergeConflicts[i].free_Response_Answer10;
              }            
            }  
            //feedback
            if (this.mergeConflicts[i].feedback10 != null) {
              combinedFeedback += '\n ' + this.mergeConflicts[i].feedback10;
            }
            //comment
            if (this.mergeConflicts[i].comment10 != null) {
              combinedComment += '\n ' + this.mergeConflicts[i].comment10;
            }          
            break;
          default:
            break;
        }
      }

      this.assessmentCombinedFreeResponse.set(this.mergeConflicts[i].question_Or_Requirement_Id1, combinedFreeResponse);
      this.assessmentCombinedFeedback.set(this.mergeConflicts[i].question_Or_Requirement_Id1, combinedFeedback);
      this.assessmentCombinedComment.set(this.mergeConflicts[i].question_Or_Requirement_Id1, combinedComment);

    }

    //return combinedText;
  }

  // convert "Y" or "N" or "NA" into an ANSWER Object
  convertToAnswerType(length: number, answers: string[]) {
    // Make sure we pull in comments from all conflicting answers
    let comment = "";
    for (let i = 0; i < length; i++) {
      this.selectedMergeAnswers[i] = {
        answerId: null,
        questionId: this.mergeConflicts[i].question_Or_Requirement_Id1,
        questionType: null,
        questionNumber: '0',
        answerText: answers[i],
        altAnswerText: null,
        freeResponseAnswer: this.assessmentCombinedFreeResponse.get(this.mergeConflicts[i].question_Or_Requirement_Id1),
        comment: this.assessmentCombinedComment.get(this.mergeConflicts[i].question_Or_Requirement_Id1),
        feedback: this.assessmentCombinedFeedback.get(this.mergeConflicts[i].question_Or_Requirement_Id1),
        markForReview: false,
        reviewed: false,
        is_Component: false,
        is_Requirement: false,
        is_Maturity: true,
        componentGuid: '00000000-0000-0000-0000-000000000000'
      }
    }
  }

  saveNewIssues(questionId: number, issueArray: any[]) {
    // For every issue we have from the original assessments
    issueArray.forEach((issue, index) => {
      if (issue.findinG_CONTACT.length > 0) {
        issue.Observation_Contacts = issue.findinG_CONTACT;
        issue.Observation_Contacts.forEach((contact) => {
          contact.Selected = true;
        });
        console.log(issue);
      }
      issue.observation_Id = 0;
      issue.answer_Id = this.newAnswerIds.get(questionId);

      this.observationSvc.saveObservation(issue, false, true).subscribe((response: any) => {

        if (index === (issueArray.length - 1)) {
          this.navCounter++;

          if (this.navCounter >= 2) {
            this.navToHome();
          }
        }
      });
    });
  }

  saveNewDocuments(questionId: number, documentArray: any[]) {
    documentArray.forEach((assessPair, index) => {
      assessPair.answer_Id = this.newAnswerIds.get(questionId);
    });

    this.cieSvc.saveDocuments(documentArray).subscribe(
      (response: any) => {
        this.navCounter ++;
        if (this.navCounter >= 2) {
          this.navToHome();
        }
    });

  }

  createMergedAssessment() {
    // Null out the button to prevent multiple clicks
    this.attemptingToMerge = true;
    
    this.combineFields(); //freeResponse, feedback, comment

    this.convertToAnswerType(this.mergeRadioSelections.length, this.mergeRadioSelections);
    localStorage.setItem('questionSet', 'Maturity');

    // Create a fake gallery item for the GUID. Using CIE's GUID 
    let galItem = { gallery_Item_Guid: "57C4DCF9-6AC6-4640-B3CA-8C55AF97001C" };

    // Create a brand new assessment
    this.assessSvc.createNewAssessmentFromGallery("CIE", galItem)
      .toPromise()
      .then(
        (response: any) => {
          // Authorize the user to modify the new assessment with a new token
          this.assessSvc.getAssessmentToken(response.id).then(() => {

            // Pull the new assessment details (mostly empty/defaults)
            this.assessSvc.getAssessmentDetail().subscribe((details: AssessmentDetail) => {
              // Update the assessment with the new data and send it back.

              if (this.mergeConflicts.length > 0) {
                for (let i = 0; i < 10; i++) {
                  switch (i + 1) {
                    case 1:
                      if (this.mergeConflicts[0].assessment_Name1 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analysis";
                      }
                      break;
                    case 2:
                      if (this.mergeConflicts[0].assessment_Name2 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }
                      break;
                    case 3:
                      if (this.mergeConflicts[0].assessment_Name3 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }           
                      break;
                    case 4:
                      if (this.mergeConflicts[0].assessment_Name4 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }          
                      break;
                    case 5:
                      if (this.mergeConflicts[0].assessment_Name5 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }           
                      break;
                    case 6:
                      if (this.mergeConflicts[0].assessment_Name6 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }           
                      break;
                    case 7:
                      if (this.mergeConflicts[0].assessment_Name7 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }            
                      break;
                    case 8:
                      if (this.mergeConflicts[0].assessment_Name8 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }          
                      break;
                    case 9:
                      if (this.mergeConflicts[0].assessment_Name9 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }           
                      break;
                    case 10:
                      if (this.mergeConflicts[0].assessment_Name10 != null) {
                        details.assessmentName = "Merged " + (i + 1) + " Analyses";
                      }           
                      break;
                    default:
                      break;
                  }
                }
              }
              else {
                details.assessmentName = "Merged with no conflicts";
              }

              details.facilityName = this.primaryAssessDetails.facilityName;
              details.cityOrSiteName = this.primaryAssessDetails.cityOrSiteName;
              details.stateProvRegion = this.primaryAssessDetails.stateProvRegion;
              details.creditUnion = this.primaryAssessDetails.creditUnion;
              details.additionalNotesAndComments = this.primaryAssessDetails.additionalNotesAndComments;
              details.useMaturity = true;
              details.maturityModel = this.maturitySvc.getModel("CIE");
              this.assessSvc.updateAssessmentDetails(details);

              // Add all the contacts contained in the merging assessments and save them in this new one
              this.saveNewAssessmentContacts(0);
            });
        });
    });
  }

  saveNewAssessmentContacts(num: number) {
    this.assessSvc.createMergeContact(this.assessmentContacts[num]).subscribe(() => {
      if (this.contactsUpdated != (this.contactsToUpdate - 1)) {
        this.contactsUpdated++;
        this.saveNewAssessmentContacts(this.contactsUpdated);
      } else {
        this.updateNewAssessmentAnswers();
      }
    });
  }

  updateNewAssessmentAnswers() {
    // Set all of the questions "details" (answerText, comments, etc).
    // This traverses our question list and overrides anything in there if we've
    // picked a new answer with the merge conflict.
    for (let i = 0; i < this.selectedMergeAnswers.length; i++) {
      for (let j = 0; j < this.existingAssessmentAnswers.length; j++) {
        if (this.existingAssessmentAnswers[j].questionId === this.selectedMergeAnswers[i].questionId) {
          this.existingAssessmentAnswers[j].comment = this.selectedMergeAnswers[i].comment;
          this.existingAssessmentAnswers[j].feedback = this.selectedMergeAnswers[i].feedback;

          if (this.existingAssessmentAnswers[j].answerText == this.selectedMergeAnswers[i].answerText) {
            if (this.selectedMergeAnswers[i].freeResponseAnswer != null && this.selectedMergeAnswers[i].freeResponseAnswer != 'null') {
              //this.existingAssessmentAnswers[j].freeResponseAnswer = this.selectedMergeAnswers[i].freeResponseAnswer;
              //this.existingAssessmentAnswers[j].freeResponseAnswer += "\n" + this.selectedMergeAnswers[i].freeResponseAnswer;
            }
          }
          else {
            if (this.selectedMergeAnswers[i].freeResponseAnswer != null && this.selectedMergeAnswers[i].freeResponseAnswer != 'null') {
              this.existingAssessmentAnswers[j].freeResponseAnswer = this.selectedMergeAnswers[i].freeResponseAnswer;
            }
          }

          this.existingAssessmentAnswers[j].answerText = this.selectedMergeAnswers[i].answerText;
        }
      }
    }
    
    this.saveNewAssessmentAnswers();
  }

  saveNewAssessmentAnswers() {
    // Send off a list of the assessment's new answers to the API to save.
    this.questionSvc.storeAllAnswers(this.existingAssessmentAnswers).subscribe((response: any) => {
      this.maturitySvc.getQuestionsList(false).subscribe((questionListResponse: MaturityQuestionResponse) => {
        // Grab all the new answer_id's to save Issues to the new questions
        for (let i = 0; i < questionListResponse.groupings[0].subGroupings.length; i++) {
          for (let m = 0; m < questionListResponse.groupings[0].subGroupings[i].questions.length; m++) {
            let question = questionListResponse.groupings[0].subGroupings[i].questions[m];
            this.newAnswerIds.set(question.questionId, question.answer_Id);
          }
          for (let j = 0; j < questionListResponse.groupings[0].subGroupings[i].subGroupings.length; j++) {
            for (let k = 0; k < questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions.length; k++) {
              let question = questionListResponse.groupings[0].subGroupings[i].subGroupings[j].questions[k];
              this.newAnswerIds.set(question.questionId, question.answer_Id);
            }
          }
        }

        // This block uses the previous answer_Id's to persist issues on the new assessment'
        if (this.assessmentIssues.size > 0) {
          const iterator = this.assessmentIssues.entries();
          let questionId = 0;

          for (let iter of iterator) {
            questionId = iter[0];
            let issueArray = this.assessmentIssues.get(questionId);
            this.saveNewIssues(questionId, issueArray);
          }
        } else {
          // If we dont have any issues, we can be done.
          this.mergeConflicts = [];
          this.navCounter++;

          if (this.navCounter >= 2) {
            this.navToHome();
          }
        }

        // This block uses the previous answer_Id's to persist documents on the new assessment
        if (this.assessmentDocuments.size > 0) {
          const iterator = this.assessmentDocuments.entries();
          let questionId = 0;

          for (let iter of iterator) {
            questionId = iter[0];
            let documentArray = this.assessmentDocuments.get(questionId);
            this.saveNewDocuments(questionId, documentArray);
          }
        } else {
          this.mergeConflicts = [];
          this.assessmentCombinedFreeResponse.clear();
          this.assessmentCombinedFeedback.clear();
          this.assessmentCombinedComment.clear();
          this.navCounter++;

          if (this.navCounter >= 2) {
            this.navToHome();
          }
        }  
      });
    });
  }

}