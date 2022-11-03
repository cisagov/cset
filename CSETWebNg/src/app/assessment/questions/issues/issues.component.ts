////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { Component, OnInit, Inject, ChangeDetectorRef } from '@angular/core';
import * as _ from 'lodash';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { AssessmentService } from '../../../services/assessment.service';
import { Finding, FindingContact, Importance, SubRiskArea } from '../findings/findings.model';
import { FindingsService } from '../../../services/findings.service';
import { QuestionsService } from '../../../services/questions.service';

@Component({
  selector: 'app-issues',
  templateUrl: './issues.component.html',
  styleUrls: ['./issues.component.scss']
})
 
export class IssuesComponent implements OnInit {
  assessmentId: any;
  finding: Finding;
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

  riskType: string = "";
  subRisk: string = "";
  transactionSubRisks = ['Audit', 'Account out of Balance/Misstatement', 'Internal Controls', 'Information Systems & Technology Controls',
                         'Fraud', 'Other', 'Supervisory Committee Activities', 'Full and Fair Disclosure', 'Electronic Payment & Card Services', 
                         'Recordkeeping-Significant', 'Security Program', 'Account Verification', 'Policies & Procedures', 
                         'Program Monitoring', 'Oversight & Reporting', 'Internal Audit & Review'];

  constructor(
    private dialog: MatDialogRef<IssuesComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Finding,
    public assessSvc: AssessmentService,
    private findSvc: FindingsService,
    public questionsSvc: QuestionsService,

  ) {
    this.finding = data;
    this.issueTitle = this.finding.title; // storing a temp name that may or may not be used later
    this.answerID = data.answer_Id;
    this.questionID = data.question_Id;
    this.autoGen = data.auto_Generated;
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
      this.suppGuidance = this.cleanText(details.listTabs[0].requirementsData.supplementalInfo);  
    });


    // Grab the finding from the db if there is one.
    this.findSvc.getFinding(this.finding.answer_Id, this.finding.finding_Id, this.finding.question_Id, questionType).subscribe((response: Finding) => {
      this.finding = response;

      this.questionsSvc.getActionItems(this.questionID).subscribe(
        (data: any) => {
          this.actionItems = data;

          if (this.autoGen === 1) {
            this.finding.auto_Generated = 1;
          } else if (this.autoGen === 0 && this.finding.auto_Generated !== 1) {
            this.finding.auto_Generated = 0;
          }

          if (this.finding.title === null) {
            this.finding.title = this.issueTitle;
          }

          if (this.finding.auto_Generated === 1 && this.finding.description === '') {
            this.finding.description = this.actionItems[0]?.description;
          }

          this.answerID = this.finding.answer_Id;
          this.questionID = this.finding.question_Id;

          this.loading = false;
        });
    });
  }

  checkFinding(finding: Finding) {
    let findingCompleted = true;

    findingCompleted = (finding.impact == null);
    findingCompleted = (finding.importance == null) && (findingCompleted);
    findingCompleted = (finding.issue == null) && (findingCompleted);
    findingCompleted = (finding.recommendations == null) && (findingCompleted);
    findingCompleted = (finding.resolution_Date == null) && (findingCompleted);
    findingCompleted = (finding.summary == null) && (findingCompleted);
    findingCompleted = (finding.vulnerabilities == null) && (findingCompleted);

    return !finding;
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
    text = text.replace (/&#8221;/g, '');
    text = text.replace(/&#34;/g, '\'');
    text = text.replace(/&#167;/g, '');
    text = text.replace(/&#183;/g, '');
    text = text.replace('ISE Reference', '');
    text = text.replace('/\s/g', ' ');
    
    return (text);
    }

  updateRiskArea(riskArea: string) {
    this.riskType = riskArea;
  }

  updateSubRisk(subRisk: string) {
    this.subRisk = subRisk;
  }

  update() {
    this.finding.answer_Id = this.answerID;
    this.finding.question_Id = this.questionID;

    //for all the action items texts call the save service function
    //You will Need to add the parameters to this function call
    //I need a list of  this.questionID (where it is not the parent id), 'This is the text from the box'
    this.findSvc.saveIssueText().subscribe();


    if (this.finding.type !== null) {
      this.findSvc.saveDiscovery(this.finding).subscribe(() => {
        this.dialog.close(true);
      });
    } else {
      this.showRequiredHelper = true;
      let el = document.getElementById("titleLabel");
      el.scrollIntoView();
    }
  }

  cancel() {
    this.dialog.close(true);
  }

}