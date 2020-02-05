////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
import { AdminSaveData, AdminPageData, HoursOverride, AdminTableData, AttributePair,
    AdminSaveResponse } from '../../../models/admin-save.model';
import { ACETService } from '../../../services/acet.service';
import { Navigation2Service } from '../../../services/navigation2.service';

@Component({
    selector: 'app-admin',
    templateUrl: './admin.component.html',
    styleUrls: ['./admin.component.scss']
})
export class AdminComponent implements OnInit {
    constructor(private router: Router,
        private assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
        private acetSvc: ACETService
    ) { }

    assessmentId: number;
    info: AdminPageData;
    GrandTotal: number;
    DocumentationTotal: number;
    InterviewTotal: number;
    ReviewedStatementTotal: number;
    Components: AdminTableData[];
    error: string;

    ngOnInit() {
        this.info = null;

        this.assessmentId = this.assessSvc.id();

        this.acetSvc.getAdminData().subscribe(
            (data: AdminPageData) => {
                this.info = data;
                this.ProcessData();
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    ProcessData() {
        /// the data type Barry used to load data for this screen would be really, really hard
        /// to work with in angular, with a single row described in multiple entries.
        /// so here i turn barry's model into something more workable.
        this.Components = [];

        // the totals at the bottom of the table
        this.GrandTotal = this.info.GrandTotal;
        for (let i = 0; i < this.info.ReviewTotals.length; i++) {
            if (this.info.ReviewTotals[i].ReviewType === "Documentation") {
                this.DocumentationTotal = this.info.ReviewTotals[i].Total;
            } else if (this.info.ReviewTotals[i].ReviewType === "Interview Process") {
                this.InterviewTotal = this.info.ReviewTotals[i].Total;
            } else if (this.info.ReviewTotals[i].ReviewType === "Statements Reviewed") {
                this.ReviewedStatementTotal = this.info.ReviewTotals[i].Total;
            }
        }

        // Create a framework for the page's values
        this.BuildComponent(this.Components, "Pre-exam prep", false);
        this.BuildComponent(this.Components, "IRP", false);
        this.BuildComponent(this.Components, "Domain 1", false);
        this.BuildComponent(this.Components, "Domain 2", false);
        this.BuildComponent(this.Components, "Domain 3", false);
        this.BuildComponent(this.Components, "Domain 4", false);
        this.BuildComponent(this.Components, "Domain 5", false);
        this.BuildComponent(this.Components, "Discussing end results with CU", false);
        this.BuildComponent(this.Components, "Other (specify)", true);
        this.BuildComponent(this.Components, "Additional Other (specify)", true);

        // the "meat" of the page, the components list and hours on each
        for (let i = 0; i < this.info.DetailData.length; i++) {
            const detail: HoursOverride = this.info.DetailData[i];

            // find the corresponding Component/Row in the framework
            const c = this.Components.find(function (element) {
                return element.Component === detail.Data.Component;
            });

            if (!!c) {
                // drop in the hours
                if (detail.Data.ReviewType === "Documentation") {
                    c.DocumentationHours = detail.Data.Hours;
                } else if (detail.Data.ReviewType === "Interview Process") {
                    c.InterviewHours = detail.Data.Hours;
                }

                c.StatementsReviewed = detail.StatementsReviewed;

                c.OtherSpecifyValue = detail.Data.OtherSpecifyValue;
            }
        }
    }

    /**
     * Builds one 'row/component'.
     */
    BuildComponent(components: AdminTableData[], componentName: string, hasSpecifyField: boolean) {
        const comp = new AdminTableData();
        comp.Component = componentName;
        comp.DocumentationHours = 0;
        comp.InterviewHours = 0;
        comp.StatementsReviewed = 0;
        comp.HasSpecifyField = hasSpecifyField;
        components.push(comp);
    }

    HideStatementsReviewed(comp) {
        if (comp.includes("Domain")) {
            return false;
        } else {
            return true;
        }
    }

    test(stdata: string){        
        if(stdata=="-"){
            return false;
        }
        let data = Number(stdata);
        if(isNaN(data)){
            this.error = "Must be a number";
            return true;
        }
        let rval = ((data>10000)||(data<-10));        
        if(rval){
            if(data>10000){
                this.error = "Must be < 10000";
            }
            if(data<-10){
                this.error = "Must be > -10";
            }
        }
        return rval; 
    }
    /**
     *
     */
    SaveData(data: AdminTableData, type: string) {
         if((data.DocumentationHours>1000)||(data.DocumentationHours<-10) 
            || isNaN(data.DocumentationHours)){
             data.DocumentationHours = 0;
            return;
        }
        if((data.InterviewHours>1000)||(data.InterviewHours<-10)
        || isNaN(data.InterviewHours)){
            data.InterviewHours = 0;
            return;
        }


        const saveData: AdminSaveData = new AdminSaveData();
        saveData.Component = data.Component;
        saveData.ReviewType = '';
        saveData.Hours = 1;
        saveData.OtherSpecifyValue = data.OtherSpecifyValue;

        if (type === 'doc') {
            saveData.ReviewType = "Documentation";
            saveData.Hours = data.DocumentationHours;
        } else if (type === 'int') {
            saveData.ReviewType = "Interview Process";
            saveData.Hours = data.InterviewHours;
        } else if (type === 'other') {
            // otherspecifyvalue is already set
        } else {
            return;
        }

        this.acetSvc.saveData(saveData).subscribe((resp: AdminSaveResponse) => {
            this.InterviewTotal = resp.InterviewTotal;
            this.GrandTotal = resp.GrandTotal;
            this.DocumentationTotal = resp.DocumentationTotal;
        });
    }

    SaveAttribute(data: AttributePair) {
        this.acetSvc.saveAttribute(data).subscribe();
    }
}
