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
import { Component, OnInit, Inject } from '@angular/core';
import * as _ from 'lodash';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material/dialog';
import { Router } from '@angular/router';
import { NCUAService } from '../../../services/ncua.service';
import { AssessmentService } from '../../../services/assessment.service';
import { Finding, FindingContact, Importance, SubRiskArea } from '../findings/findings.model';
import { FindingsService } from '../../../services/findings.service';

@Component({
  selector: 'app-issues',
  templateUrl: './issues.component.html'
})
 

export class IssuesComponent implements OnInit {
  finding: Finding;
  subRiskAreas: SubRiskArea[];
  importances: Importance[];
  
  riskAreaOptions: string[] = [];



  contactsmodel: any[];
  answerID: number;
  questionID: number;

  selectedRiskArea: string = "";

  constructor(
    private ncuaSvc: NCUAService,
    private dialog: MatDialogRef<IssuesComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Finding,
    private router: Router,
    public assessSvc: AssessmentService,
    private findSvc: FindingsService,

  ) {
    this.finding = data;
    this.answerID = data.answer_Id;
    this.questionID = data.question_Id;
  }
  
  ngOnInit() {
    this.dialog.backdropClick()
    .subscribe(() => {
      this.update();
    });

    this.findSvc.getSubRisks().subscribe((result: any[]) => {
      this.subRiskAreas = result;
      console.log("result: " + JSON.stringify(this.subRiskAreas, null, 4))
      for (let i = 0; i < result.length; i++) {
        if (!this.riskAreaOptions.includes(result[i].risk_Area)) {
          this.riskAreaOptions.push(result[i].risk_Area);
        }
      }
    });

    this.findSvc.getImportance().subscribe((result: Importance[]) => {
      this.importances = result;
      let questionType = localStorage.getItem('questionSet');
      this.findSvc.getFinding(this.finding.answer_Id, this.finding.finding_Id, this.finding.question_Id, questionType)
        .subscribe((response: Finding) => {
          console.log("finding response: " + JSON.stringify(response, null, 4));
          this.finding = response;
          this.answerID = this.finding.answer_Id;
          this.questionID = this.finding.question_Id;
          this.contactsmodel = _.map(_.filter(this.finding.finding_Contacts,
            { 'selected': true }),
            'Assessment_Contact_Id');
          this.data.answer_Id = this.answerID;
        });
    });
  }

  refreshContacts():void{
    let questionType = localStorage.getItem('questionSet');
    this.findSvc.getFinding(this.finding.answer_Id, this.finding.finding_Id, this.finding.question_Id, questionType)
        .subscribe((response: Finding) => {
          this.finding = response;
          this.contactsmodel = _.map(_.filter(this.finding.finding_Contacts,
            { 'selected': true }),
            'Assessment_Contact_Id');
        });
  }

  clearMulti() {
    this.finding.finding_Contacts.forEach(c => {
      c.selected = false;
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

  update() {
    this.finding.answer_Id = this.answerID;
    this.finding.question_Id = this.questionID;
    this.finding.sub_Risk_Area_Id = 1;
    this.finding.subRiskArea = {'subRisk_Id': 1, 'value': 'Other', 'riskArea': 'Strategic'};
    this.findSvc.saveDiscovery(this.finding).subscribe(() => {
      this.dialog.close(true);
    });
  }

  updateRiskArea(riskArea) {
    this.selectedRiskArea = riskArea;
  }

  updateSubRisk(sub_id) {
    this.finding.subRiskArea = {'subRisk_Id': 1, 'value': 'Other', 'riskArea': this.selectedRiskArea};
  }

  updateImportance(importid) {
    this.finding.importance_Id = importid;
  }

  updateContact(contactid) {
    this.finding.finding_Contacts.forEach((fc: FindingContact) => {
      if (fc.assessment_Contact_Id === contactid.assessment_Contact_Id) {
        fc.selected = contactid.selected;
      }
    });
  }

  saveIssue() {
    this.dialog.close(true);
  }

  cancel() {
    this.dialog.close(true);
  }

}