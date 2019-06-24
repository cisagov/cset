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
import { Component, OnInit } from '@angular/core';
import { Router } from '@angular/router';
import { AssessmentService } from '../../../services/assessment.service';
import { MatDetailResponse, MaturityDomain, MaturityAssessment, MaturityComponent } from '../../../models/mat-detail.model';
import { MatExpansionModule } from '@angular/material/expansion';
import { ACETService } from '../../../services/acet.service';
import { Navigation2Service } from '../../../services/navigation2.service';

@Component({
    selector: 'app-mat-detail',
    templateUrl: './mat-detail.component.html',
    styleUrls: ['./mat-detail.component.scss']
})
export class MatDetailComponent implements OnInit {
    readonly expandAll = "Expand All";
    readonly collapseAll = "Collapse All";
    matDetails: any;
    matRange: any;
    expand: string;
    expanded: boolean;
    overallIrp: string;
    targetBandOnly: boolean = true;
    bottomExpected: string;
    

    constructor(private router: Router,
        private assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
        public acetSvc: ACETService
    ) { }

    ngOnInit() {
        this.expand = this.collapseAll;
        this.expanded = true;
        this.loadMatDetails();
        this.getMatRange();
        this.getOverallIrp();
        //this.getTargetBand();
    }

    loadMatDetails() {
        this.acetSvc.getMatDetailList().subscribe(
            (data) => {
                this.matDetails = data;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    getTargetBand(){
        this.acetSvc.getTargetBand().subscribe(
            (data) => {
                this.targetBandOnly = data as boolean;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    setTargetBand(){
        this.acetSvc.setTargetBand(this.targetBandOnly).subscribe();
        this.loadMatDetails();
    }

    getMatRange(){
        this.acetSvc.getMatRange().subscribe(
            (data) => {
                var dataArray = data as string[];
                if(dataArray.length > 1)
                {
                    
                    this.matRange = dataArray[0] + " - " + dataArray[dataArray.length - 1];
                    this.bottomExpected = dataArray[0];
                }
               
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    getOverallIrp() {
        this.acetSvc.getOverallIrp().subscribe(
            (data) => {
                this.overallIrp = data as string;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }
    
    checkMaturity(mat:string){
        if(this.bottomExpected == "Baseline" && mat == "Incomplete"){
            return "domain-red";
        } else if( this.bottomExpected == "Evolving" && (mat == "Incomplete" || mat == "Baseline")){
            return "domain-red";
        } else if (this.bottomExpected == "Intermediate" && (mat == "Incomplete" || mat == "Baseline" || mat == "Evolving")){
            return "domain-red";
        } else if (this.bottomExpected == "Advanced" && (mat == "Incomplete" || mat == "Baseline" || mat == "Evolving" || mat == "Intermediate")){
            return "domain-red";
        } else {
            return "domain-green";
        }

    }

    checkExpand() {
        if (this.expand === this.collapseAll) {
            this.expand = this.expandAll;
            this.expanded = false;
        } else {
            this.expand = this.collapseAll;
            this.expanded = true;
        }
    }
}
