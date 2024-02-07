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
import { Component, OnInit, Inject } from '@angular/core';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';
import { Observation, ActionItemText } from '../observations/observations.model';
import { ObservationsService } from '../../../services/observations.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-issues',
  templateUrl: './issues.component.html',
  styleUrls: ['./issues.component.scss']
})

export class IssuesComponent implements OnInit {
  assessmentId: any;
  observation: Observation;
  questionData: any = null;
  actionItems: any = null;
  suppGuidance: string = "";
  regCitation: string = "";
  autoGen: number;

  issueTitle = "";

  contactsmodel: any[];
  answerID: number;
  questionID: number;

  loading: boolean;
  showRequiredHelper: boolean = false;

  // Per client request: "Just make them static for now"
  risk: string = "Transaction";
  subRisk: string = "Information Systems & Technology Controls";
  updatedActionText: string[] = [];
  ActionItemList = new Map();

  constructor(
    private dialog: MatDialogRef<IssuesComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Observation,
    public assessSvc: AssessmentService,
    private observationSvc: ObservationsService,
    public questionsSvc: QuestionsService,

  ) {
    this.observation = data;
    this.issueTitle = this.observation.title; // storing a temp name that may or may not be used later
    this.answerID = data.answer_Id;
    this.questionID = data.question_Id;
    this.autoGen = data.auto_Generated;
    this.observation.risk_Area = this.risk;
    this.observation.sub_Risk = this.subRisk;
  }

  ngOnInit() {
    this.loading = true;

    this.assessmentId = localStorage.getItem('assessmentId');
    let questionType = localStorage.getItem('questionSet');

    this.dialog.backdropClick()
      .subscribe(() => {
        this.update();
      });

    this.questionsSvc.getChildAnswers(this.questionID, this.assessmentId).subscribe(
      (data: any) => {
        this.questionData = data;
      });

    this.questionsSvc.getDetails(this.questionID, questionType).subscribe((details) => {
      this.suppGuidance = this.cleanText(details.listTabs[0].requirementsData.supplementalFact);
    });

    // Grab the finding from the db if there is one.
    this.observationSvc.getObservation(this.observation.answer_Id, this.observation.observation_Id, this.observation.question_Id, questionType).subscribe((response: Observation) => {

      this.observation = response;

      this.questionsSvc.getActionItems(this.questionID, this.observation.observation_Id).subscribe(
        (data: any) => {
          this.actionItems = data;

          this.observation.risk_Area = this.risk;
          this.observation.sub_Risk = this.subRisk;

          if (this.autoGen === 1) {
            this.observation.auto_Generated = 1;
          } else if (this.autoGen === 0 && this.observation.auto_Generated !== 1) {
            this.observation.auto_Generated = 0;
          }

          if (this.observation.title === null) {
            this.observation.title = this.issueTitle;
          }

          if (this.observation.auto_Generated === 1 && this.observation.description === '') {
            this.observation.description = this.actionItems[0]?.description;
          }

          if (this.observation.supp_Guidance === null) {
            this.observation.supp_Guidance = this.suppGuidance;
          }

          this.answerID = this.observation.answer_Id;
          this.questionID = this.observation.question_Id;

          this.loading = false;
        });
    });
  }

  checkObservation(observation: Observation) {
    let observationCompleted = true;

    observationCompleted = (observation.impact == null);
    observationCompleted = (observation.importance == null) && (observationCompleted);
    observationCompleted = (observation.issue == null) && (observationCompleted);
    observationCompleted = (observation.recommendations == null) && (observationCompleted);
    observationCompleted = (observation.resolution_Date == null) && (observationCompleted);
    observationCompleted = (observation.summary == null) && (observationCompleted);
    observationCompleted = (observation.vulnerabilities == null) && (observationCompleted);

    return !observation;
  }

  /*
  * Function used to remove HTML formatting pulled in from the API when all we want
  * in the UI is basic text. (No tags or special characters, etc).
  */
  cleanText(input: string) {
    let text = input;
    text = text.replace(/<.*?>/g, '');
    text = text.replace(/&#10;/g, ' ');
    text = text.replace(/&#8217;/g, '\'');
    text = text.replace(/&#160;/g, '');
    text = text.replace(/&#8221;/g, '');
    text = text.replace(/&#34;/g, '\'');
    text = text.replace(/&#167;/g, '');
    text = text.replace(/&#183;/g, '');
    text = text.replace(/&nbsp;/g, '');
    text = text.replace('ISE Reference', '');
    text = text.replace('/\s/g', ' ');

    return (text);
  }

  updateRiskArea(riskArea: string) {
    this.risk = riskArea;
  }

  updateSubRisk(subRisk: string) {
    this.subRisk = subRisk;
  }

  updateActionText(e: any, q: any) {
    const item: ActionItemText = { Mat_Question_Id: q.mat_Question_Id, ActionItemOverrideText: e.target.value };
    this.ActionItemList.set(q.mat_Question_Id, item);
  }

  update() {
    this.observation.answer_Id = this.answerID;
    this.observation.question_Id = this.questionID;

    let mapToArray = Array.from(this.ActionItemList.values());
    this.observationSvc.saveIssueText(mapToArray, this.observation.observation_Id).subscribe();

    if (this.observation.type !== null) {
      this.observationSvc.saveObservation(this.observation).subscribe(() => {
        this.dialog.close(true);
      });
    } else {
      this.showRequiredHelper = true;
      let el = document.getElementById("titleLabel");
      el.scrollIntoView();
    }
  }

  openIssue() {
    this.observation.answer_Id = this.answerID;
    this.observation.question_Id = this.questionID;
  }

  cancel() {
    this.dialog.close(this.observation.observation_Id);
  }

  isIssueEmpty() {
    if (this.observation.actionItems == null
      && this.observation.citations == null
      && this.observation.description == null
      && this.observation.issue == null
      && this.observation.type == null) {
      return true;
    }
    return false;
  }

}