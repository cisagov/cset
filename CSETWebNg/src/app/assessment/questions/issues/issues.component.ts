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

@Component({
  selector: 'app-issues',
  templateUrl: './issues.component.html'
})


export class IssuesComponent implements OnInit {

  riskAreas: string[] = ["Strategic", "Compliance", "Transaction", "Reputation"];

  strategicSubRisks: string[] = [
    "Other", "Organizational Risk Management Program", "Staffing", "Field of Membership", 
    "Product/Service Outsourcing", "Program Monitoring, Oversight, & Reporting",
    "Business/Strategic/Budgeting", "Board of Director Oversight", "Training", "Capital Plans"
  ];

  complianceSubRisks: string[] = [
    "Regulatory Compliance", "Policies & Procedures", "Other",
    "Consumer Compliance", "BSA", "Reporting", "Fair Lending"
  ];

  transactionSubRisks: string[] = [
    "Audit", "Account out of Balance/Misstatement", "Internal Controls",
    "Information Systems & Technology Controls", "Fraud", "Other",
    "Supervisory Committee Activites", "Full and Fair Disclosure",
    "Electronic Payment & Card Services", "Recordkeeping-Significant",
    "Security Program", "Account Verification", "Policies & Procedures",
    "Program Monitoring, Oversight, & Reporting", "Internal Audit & Review"
  ];

  reputationSubRisks: string[] = [
    "Other", "Management", "Insider Activities", "Legal", "Reporting"
  ];

  ratings: string[] = [
    "Low", "Medium", "High"
  ];

  selectedRiskArea: string = "";

  constructor(
    private ncuaSvc: NCUAService,
    private dialog: MatDialogRef<IssuesComponent>,
    private router: Router,
    public assessSvc: AssessmentService
  ) {}
  
  ngOnInit() {
  }

  updateRiskArea(e) {
    this.selectedRiskArea = e.target.value;
  }

  update() {
    this.dialog.close(true);
  }

  saveIssue() {
    this.dialog.close(true);
  }

  cancel() {
    this.dialog.close(true);
  }
}