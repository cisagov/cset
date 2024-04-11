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
import { AssessmentService } from '../../../services/assessment.service';
import {
    AdminSaveData, AdminPageData, HoursOverride, AdminTableData, AttributePair,
    AdminSaveResponse
} from '../../../models/admin-save.model';
import { ACETService } from '../../../services/acet.service';
import { NavigationService } from '../../../services/navigation/navigation.service';

@Component({
    selector: 'app-admin',
    templateUrl: './admin.component.html',
    styleUrls: ['./admin.component.scss']
})
export class AdminComponent implements OnInit {
    constructor(private router: Router,
        private assessSvc: AssessmentService,
        public navSvc: NavigationService,
        private acetSvc: ACETService
    ) { }

    assessmentId: number;
    info: AdminPageData;
    grandTotal: number;
    documentationTotal: number;
    interviewTotal: number;
    reviewedStatementTotal: number;
    components: AdminTableData[];
    error: string;

    ngOnInit() {
        this.info = null;

        this.assessmentId = this.assessSvc.id();

        this.acetSvc.getAdminData().subscribe(
            (data: AdminPageData) => {
                this.info = data;
                this.processData();
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    processData() {
        /// the data type Barry used to load data for this screen would be really, really hard
        /// to work with in angular, with a single row described in multiple entries.
        /// so here i turn barry's model into something more workable.
        this.components = [];

        // the totals at the bottom of the table
        this.grandTotal = this.info.grandTotal;
        for (let i = 0; i < this.info.reviewTotals.length; i++) {
            if (this.info.reviewTotals[i].reviewType === "Documentation") {
                this.documentationTotal = this.info.reviewTotals[i].total;
            } else if (this.info.reviewTotals[i].reviewType === "Interview Process") {
                this.interviewTotal = this.info.reviewTotals[i].total;
            } else if (this.info.reviewTotals[i].reviewType === "Statements Reviewed") {
                this.reviewedStatementTotal = this.info.reviewTotals[i].total;
            }
        }

        // Create a framework for the page's values
        this.buildComponent(this.components, "Pre-exam prep", false);
        this.buildComponent(this.components, "IRP", false);
        this.buildComponent(this.components, "Domain 1", false);
        this.buildComponent(this.components, "Domain 2", false);
        this.buildComponent(this.components, "Domain 3", false);
        this.buildComponent(this.components, "Domain 4", false);
        this.buildComponent(this.components, "Domain 5", false);
        this.buildComponent(this.components, "Discussing end results with CU", false);
        this.buildComponent(this.components, "Other (specify)", true);
        this.buildComponent(this.components, "Additional Other (specify)", true);

        // the "meat" of the page, the components list and hours on each
        for (let i = 0; i < this.info.detailData.length; i++) {
            const detail: HoursOverride = this.info.detailData[i];

            // find the corresponding Component/Row in the framework
            const c = this.components.find(function (element) {
                return element.component === detail.data.component;
            });

            if (!!c) {
                // drop in the hours
                if (detail.data.reviewType === "Documentation") {
                    c.documentationHours = detail.data.hours;
                } else if (detail.data.reviewType === "Interview Process") {
                    c.interviewHours = detail.data.hours;
                }

                c.statementsReviewed = detail.statementsReviewed;

                c.otherSpecifyValue = detail.data.otherSpecifyValue;
            }
        }
    }

    /**
     * Builds one 'row/component'.
     */
    buildComponent(components: AdminTableData[], componentName: string, hasSpecifyField: boolean) {
        const comp = new AdminTableData();
        comp.component = componentName;
        comp.documentationHours = 0;
        comp.interviewHours = 0;
        comp.statementsReviewed = 0;
        comp.hasSpecifyField = hasSpecifyField;
        components.push(comp);
    }

    hideStatementsReviewed(comp) {
        if (comp.includes("Domain")) {
            return false;
        } else {
            return true;
        }
    }

    test(stdata: string) {
        if (stdata == "-") {
            return false;
        }
        let data = Number(stdata);
        if (isNaN(data)) {
            this.error = "Must be a number";
            return true;
        }
        let rval = ((data > 10000) || (data < -10));
        if (rval) {
            if (data > 10000) {
                this.error = "Must be < 10000";
            }
            if (data < -10) {
                this.error = "Must be > -10";
            }
        }
        return rval;
    }
    /**
     *
     */
    saveData(data: AdminTableData, type: string) {
        if ((data.documentationHours > 1000) || (data.documentationHours < -10)
            || isNaN(data.documentationHours)) {
            data.documentationHours = 0;
            return;
        }
        if ((data.interviewHours > 1000) || (data.interviewHours < -10)
            || isNaN(data.interviewHours)) {
            data.interviewHours = 0;
            return;
        }


        const saveData: AdminSaveData = new AdminSaveData();
        saveData.component = data.component;
        saveData.reviewType = '';
        saveData.hours = 1;
        saveData.otherSpecifyValue = data.otherSpecifyValue;

        if (type === 'doc') {
            saveData.reviewType = "Documentation";
            saveData.hours = data.documentationHours;
        } else if (type === 'int') {
            saveData.reviewType = "Interview Process";
            saveData.hours = data.interviewHours;
        } else if (type === 'other') {
            // otherspecifyvalue is already set
        } else {
            return;
        }

        this.acetSvc.saveData(saveData).subscribe((resp: AdminSaveResponse) => {
            this.interviewTotal = resp.interviewTotal;
            this.grandTotal = resp.grandTotal;
            this.documentationTotal = resp.documentationTotal;
        });
    }

    saveAttribute(data: AttributePair) {
        this.acetSvc.saveAttribute(data).subscribe();
    }
}
