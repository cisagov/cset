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
import { ACETService } from '../../../services/acet.service';
import { AcetDashboard } from '../../../models/acet-dashboard.model';
import { Navigation2Service } from '../../../services/navigation2.service';

@Component({
    selector: 'app-acet-dashboard',
    templateUrl: './acet-dashboard.component.html',
    styleUrls: ['./acet-dashboard.component.scss']
})
export class ACETDashboardComponent implements OnInit {
    acetDashboard: AcetDashboard;

    overrideLabel: string;
    overriddenLabel: string;

    constructor(private router: Router,
        public assessSvc: AssessmentService,
        public navSvc2: Navigation2Service,
        public acetSvc: ACETService
    ) { }

    ngOnInit() {
        this.loadDashboard();
    }

    loadDashboard() {
        this.acetSvc.getAcetDashboard().subscribe(
            (data: AcetDashboard) => {
                this.acetDashboard = data;

                for (let i = 0; i < this.acetDashboard.IRPs.length; i++) {
                    this.acetDashboard.IRPs[i].Comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.IRPs[i].RiskLevel);
                }

                this.overrideLabel = this.acetSvc.interpretRiskLevel(this.acetDashboard.SumRiskLevel);
                this.overriddenLabel = this.acetSvc.interpretRiskLevel(this.acetDashboard.Override);
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }


    changeInfo() {
        if (this.acetDashboard.Override === 0) {
            this.acetDashboard.OverrideReason = '';
        }

        this.acetSvc.postSelection(this.acetDashboard).subscribe((data:any)=>{
            this.loadDashboard();
        }, 
        error => {
            console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
            console.log('Error getting all documents: ' + (<Error>error).stack);
        });
    }
}
