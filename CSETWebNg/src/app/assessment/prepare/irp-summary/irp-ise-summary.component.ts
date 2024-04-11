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
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AcetDashboard } from '../../../models/acet-dashboard.model';
import { AssessmentService } from '../../../services/assessment.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { ACETService } from '../../../services/acet.service';
import { AcetFilteringService } from '../../../services/filtering/maturity-filtering/acet-filtering.service';
import { NCUAService } from '../../../services/ncua.service';

@Component({
    selector: 'app-irp-ise-summary',
    templateUrl: './irp-ise-summary.component.html'
})
export class ExamProfileSummaryComponent implements OnInit {

    acetDashboard: AcetDashboard;

    overrideLabel: string;

    /**
     * 
     */
    constructor(
        private router: Router,
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        public acetSvc: ACETService,
        public acetFilteringSvc: AcetFilteringService,
        public ncuaSvc: NCUAService
    ) { }

    /**
     * 
     */
    ngOnInit() {
        this.loadDashboard();
        this.checkRiskLevel();
    }

    /**
     * 
     */
    loadDashboard() {
        this.acetSvc.getAcetDashboard().subscribe(
            (data: AcetDashboard) => {
                this.acetDashboard = data;

                if (this.ncuaSvc.switchStatus && this.assessSvc.usesMaturityModel('ISE')) {
                    for (let i = 0; i < 5; i++) {
                        // Removes the ACET irps, leaving the single ISE irp
                        this.acetDashboard.irps.shift();
                    }
                    // "Resets" the IRP table to only use ISE irp statements, preventing any ACET irp carry over if user switches assessment type.
                    this.acetDashboard.sumRisk = this.acetDashboard.irps[0].riskCount;
                } else {
                    // Same thing as above, but reverse. Subtracts ISE irp answers from the ACET irp results so they don't mess things up.
                    let lastHeader = this.acetDashboard.irps.length - 1;
                    let iseRisk = this.acetDashboard.irps[lastHeader].riskCount;
                    let acetRisk = this.acetDashboard.sumRisk;
                    let result = acetRisk.map((item, index) => item - iseRisk[index]);
                    this.acetDashboard.sumRisk = result;

                    // Remove the ISE irp from ACET IRP's results table.
                    this.acetDashboard.irps.pop();
                }

                for (let i = 0; i < this.acetDashboard.irps.length; i++) {
                    this.acetDashboard.irps[i].comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.irps[i].riskLevel);
                }

                this.overrideLabel = this.ncuaSvc.proposedExamLevel;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    changeInfoIrp() {
        this.acetFilteringSvc.resetDomainFilters(this.acetDashboard.override);
        this.changeInfo();
    }

    /**
     * 
     */
    changeInfo() {
        if (this.acetDashboard.override === 0) {
            this.ncuaSvc.usingExamLevelOverride = false;
            this.acetDashboard.overrideReason = '';
            this.ncuaSvc.chosenOverrideLevel = "";
        } else if (this.acetDashboard.override === 1) {
            this.ncuaSvc.usingExamLevelOverride = true;
            this.ncuaSvc.chosenOverrideLevel = 'SCUEP';
            this.ncuaSvc.refreshGroupList(1);
        } else if (this.acetDashboard.override === 2) {
            this.ncuaSvc.usingExamLevelOverride = true;
            this.ncuaSvc.chosenOverrideLevel = 'CORE';
            this.ncuaSvc.refreshGroupList(3);
        }

        this.acetSvc.postSelection(this.acetDashboard).subscribe((data: any) => {
            this.loadDashboard();
        },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    checkRiskLevel() {
        if (this.ncuaSvc.usingExamLevelOverride === false) {
            //this.ncuaSvc.getIRPfromAssets(true);
        } else {
            //this.ncuaSvc.getIRPfromOverride();
        }
    }
}
