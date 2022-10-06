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
  templateUrl: './issues.component.html'
})
 

export class IssuesComponent implements OnInit {
  finding: Finding;
  suppGuidance: string = "";

  issueTitle = "";
  issueDescription: string = "";
  
  subRiskAreas: SubRiskArea[];
  importances: Importance[];
  
  riskAreaOptions: string[] = [];
  selectedRiskArea: string = "";
  strategicSubRisks: any[] = [];
  complianceSubRisks: any[] = [];
  transactionSubRisks: any[] = [];
  reputationSubRisks: any[] = [];

  contactsmodel: any[];
  answerID: number;
  questionID: number;

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
  }
  
  ngOnInit() {
    this.dialog.backdropClick()
    .subscribe(() => {
      this.update();
    });

    let questionType = localStorage.getItem('questionSet');

    // Grab the finding from the db if there is one.
    this.findSvc.getFinding(this.finding.answer_Id, this.finding.finding_Id, this.finding.question_Id, questionType).subscribe((response: Finding) => {
      this.finding = response;

      if (this.finding.title === null) {
        this.finding.title = this.issueTitle;
      }

      if (this.finding.description === null) {
        this.finding.description = this.generateIssueDescription();
      }
          
      this.answerID = this.finding.answer_Id;
      this.questionID = this.finding.question_Id;
          
      if (this.finding.sub_Risk_Area_Id === null) {
        this.updateRiskArea('Strategic');
      } else {
        this.getSelectedRiskArea(this.finding.sub_Risk_Area_Id);
      }
    });

    this.findSvc.getSubRisks().subscribe((result: any[]) => {
      this.subRiskAreas = result;

      // Generate the select drop down options for risk area & sub risk areas
      for (let i = 0; i < result.length; i++) {
        if (!this.riskAreaOptions.includes(result[i].risk_Area)) {
          this.riskAreaOptions.push(result[i].risk_Area);
        }
        if (result[i].risk_Area === 'Strategic') {
          this.strategicSubRisks.push({'name':result[i].sub_Risk_Area, 'id':result[i].sub_Risk_Area_Id});
        } else if (result[i].risk_Area === 'Compliance') {
          this.complianceSubRisks.push({'name':result[i].sub_Risk_Area, 'id':result[i].sub_Risk_Area_Id});
        } else if (result[i].risk_Area === 'Transaction') {
          this.transactionSubRisks.push({'name':result[i].sub_Risk_Area, 'id':result[i].sub_Risk_Area_Id});
        } else if (result[i].risk_Area === 'Reputation') {
          this.reputationSubRisks.push({'name':result[i].sub_Risk_Area, 'id':result[i].sub_Risk_Area_Id});
        }
      }
    });

    this.questionsSvc.getDetails(this.finding.question_Id, questionType).subscribe((details) => {
      this.suppGuidance = this.cleanText(details.listTabs[0].requirementsData.supplementalInfo);
    });
  }

  cleanText(input: string) {
    let text = input;
    text = text.replace(/<.*?>/g, '');
    text = text.replace(/&#10;/g, ' ');
    text = text.replace(/&#8217;/g, '\'');
    text = text.replace(/&#160;/g, '');
    text = text.replace (/&#8221;/g, '');
    text = text.replace(/&#34;/g, '\'');
    text = text.replace('/\s/g', ' ');
    return (text);
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

  update() {
    this.finding.answer_Id = this.answerID;
    this.finding.question_Id = this.questionID;
    this.findSvc.saveDiscovery(this.finding).subscribe(() => {
      this.dialog.close(true);
    });
  }

  generateIssueDescription(): string {
    // Formatting it this way for demo purposes. Will fix it later.
    let description = `The information security program policies and procedures are not commensurable to its size, complexity, and risk. Each credit union must identify and evaluate risks to its information, develop a plan to mitigate the risks, implement the plan, test the plan, and monitor the need to update the plan.

As information security program is the written plan created and implemented by a credit union to identify and control risks to information and information systems and to properly dispose of information. The plan includes policies and procedures regarding the institution's risk assessment, controls, testing, service-provider oversight, periodic review and updating, and reporting to its board of directors.`;

    return description;
  }

  getSelectedRiskArea(id: number) {
    let area = "";
    if (id >= 1 && id <= 10) {
      area = 'Strategic';
    } else if (id > 10 && id <= 17) {
      area = 'Compliance';
    } else if (id > 17 && id <= 32) {
      area = 'Transaction';
    } else if (id > 32 && id <= 37) {
      area = 'Reputation';
    }

    this.updateRiskArea(area);
  }

  updateRiskArea(riskArea) {
    this.selectedRiskArea = riskArea;
  }

  updateSubRisk(value) {
    this.finding.sub_Risk_Area_Id = value;
  }

  cancel() {
    this.dialog.close(true);
  }

}