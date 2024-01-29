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
import { ACETService } from '../../../services/acet.service';
import { AcetDashboard } from '../../../models/acet-dashboard.model';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { TranslocoService } from '@ngneat/transloco';

@Component({
    selector: 'app-acet-dashboard',
    templateUrl: './acet-dashboard.component.html',
    styleUrls: ['./acet-dashboard.component.scss']
})
export class AcetDashboardComponent implements OnInit {
    acetDashboard: AcetDashboard;

    overrideLabel: string;
    overriddenLabel: string;
    sortDomainListKey: string[] = [];

    sortedDomainList: any = [];

    constructor(private router: Router,
        public assessSvc: AssessmentService,
        public navSvc: NavigationService,
        public acetSvc: ACETService,
        private tSvc: TranslocoService
    ) { }

    ngOnInit() {
        this.tSvc.langChanges$.subscribe((event) => {
            this.sortDomainListKey = [];
            if (this.tSvc.getActiveLang() == "es") {
                this.sortDomainListKey = this.acetSvc.spanishSortDomainListKey;
            }
            else {
                this.sortDomainListKey = this.acetSvc.englishSortDomainListKey;
            }
            this.loadDashboard();
        });
    }

    loadDashboard() {
        this.acetSvc.getAcetDashboard().subscribe(
            (data: AcetDashboard) => {
                this.acetDashboard = data;

                // Checks to remove any ISE irp data from the ACET results
                let lastHeader = this.acetDashboard.irps.length - 1;
                let iseRisk = this.acetDashboard.irps[lastHeader].riskCount;
                let acetRisk = this.acetDashboard.sumRisk;
                let result = acetRisk.map((item, index) => item - iseRisk[index]);
                this.acetDashboard.sumRisk = result;

                let highest = Math.max(...this.acetDashboard.sumRisk);
                let index = this.acetDashboard.sumRisk.indexOf(highest);
                this.acetDashboard.sumRiskLevel = (index + 1);

                // Remove the ISE irp from ACET IRP's results table.
                this.acetDashboard.irps.pop();

                // Domains do not currently come sorted from API, this will sort the domains into proper order.
                this.sortDomainListKey.forEach(domain => {
                    data.domains.filter(item => {
                        if (item.name == domain) {
                            this.sortedDomainList.push(item);
                        }
                    })
                })
                this.acetDashboard.domains = this.sortedDomainList;

                // clearing the list so it doesn't keep building on old data
                this.sortedDomainList = [];

                this.acetDashboard.domains.forEach(d => {
                    d.levelDisplay = this.acetSvc.translateMaturity(d.maturity);
                });

                for (let i = 0; i < this.acetDashboard.irps.length; i++) {
                    this.acetDashboard.irps[i].comment = this.acetSvc.interpretRiskLevel(this.acetDashboard.irps[i].riskLevel);
                }

                this.overrideLabel = this.acetSvc.interpretRiskLevel(this.acetDashboard.sumRiskLevel);
                this.overriddenLabel = (this.acetSvc.interpretRiskLevel(this.acetDashboard.override));

                if (this.overriddenLabel == "0 - Incomplete") {
                    this.overriddenLabel = "No Override";
                }
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }


    changeInfo() {
        if (this.acetDashboard.override === 0) {
            this.acetDashboard.overrideReason = '';
        }

        this.acetSvc.postSelection(this.acetDashboard).subscribe((data: any) => {
            this.loadDashboard();
        },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }
}
