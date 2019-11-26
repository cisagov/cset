////////////////////////////////
//
//   Copyright 2019 Battelle Energy Alliance, LLC
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
import { FindingsService } from '../../../services/findings.service';
import { AssessmentService } from '../../../services/assessment.service';
import { MatDialogRef, MAT_DIALOG_DATA } from '@angular/material';
import { Finding, Importance, FindingContact } from './findings.model';
import * as _ from 'lodash';
import { Router } from '@angular/router';

@Component({
  selector: 'app-findings',
  templateUrl: './findings.component.html'
})
export class FindingsComponent implements OnInit {

  finding: Finding;
  importances: Importance[];
  contactsmodel: any[];
  answerID: number;
  questionID: number;

  constructor(
    private findSvc: FindingsService,
    private dialog: MatDialogRef<FindingsComponent>,
    @Inject(MAT_DIALOG_DATA) public data: Finding,
    private router: Router,
    private assessSvc: AssessmentService
  ) {
    this.finding = data;
    this.answerID = data.Answer_Id;
    this.questionID = data.Question_Id;
  }

  ngOnInit() {
    this.dialog.backdropClick()
      .subscribe(() => {
        this.update();
      });

    // send the finding to the server
    // if it is empty or new let the server
    // worry about it
    this.findSvc.GetImportance().subscribe((result: Importance[]) => {
      this.importances = result;
      this.findSvc.GetFinding(this.finding.Answer_Id, this.finding.Finding_Id, this.finding.Question_Id)
        .subscribe((response: Finding) => {
          this.finding = response;
          this.answerID = this.finding.Answer_Id;
          this.questionID = this.finding.Question_Id;
          this.contactsmodel = _.map(_.filter(this.finding.Finding_Contacts,
            { 'Selected': true }),
            'Assessment_Contact_Id');
        });
    });
  }

  reloadContacts():void{
    this.findSvc.GetFinding(this.finding.Answer_Id, this.finding.Finding_Id, this.finding.Question_Id)
        .subscribe((response: Finding) => {
          this.finding = response;
          this.contactsmodel = _.map(_.filter(this.finding.Finding_Contacts,
            { 'Selected': true }),
            'Assessment_Contact_Id');
        });
  }

  clearMulti() {
    this.finding.Finding_Contacts.forEach(c => {
      c.Selected = false;
    });
  }

  checkFinding(finding: Finding) {
    // and a bunch of fields together
    // if they are all null then false
    // else true;
    let findingCompleted = true;

    findingCompleted = (finding.Impact == null);
    findingCompleted = (finding.Importance == null) && (findingCompleted);
    findingCompleted = (finding.Issue == null) && (findingCompleted);
    findingCompleted = (finding.Recommendations == null) && (findingCompleted);
    findingCompleted = (finding.Resolution_Date == null) && (findingCompleted);
    findingCompleted = (finding.Summary == null) && (findingCompleted);
    findingCompleted = (finding.Vulnerabilities == null) && (findingCompleted);

    return !finding;
  }


  update() {
    this.finding.Answer_Id = this.answerID;
    this.finding.Question_Id = this.questionID;
    this.findSvc.SaveDiscovery(this.finding).subscribe(() => {
      this.dialog.close(true);
    });
  }

  updateImportance(importid) {
    this.finding.Importance_Id = importid;
  }

  updateContact(contactid) {
    this.finding.Finding_Contacts.forEach((fc: FindingContact) => {
      if (fc.Assessment_Contact_Id === contactid.Assessment_Contact_Id) {
        fc.Selected = contactid.Selected;
      }
    });
  }
}
