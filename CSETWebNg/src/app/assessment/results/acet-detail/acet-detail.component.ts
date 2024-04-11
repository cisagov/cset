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
import { MaturityDomain, MaturityAssessment, MaturityComponent } from '../../../models/mat-detail.model';
import { ACETService } from '../../../services/acet.service';
import { NavigationService } from '../../../services/navigation/navigation.service';
import { LayoutService } from '../../../services/layout.service';
import { TranslocoService } from '@ngneat/transloco';


@Component({
    selector: 'app-mat-detail',
    templateUrl: './acet-detail.component.html',
    styleUrls: ['./acet-detail.component.scss', '../../../reports/acet-reports.scss']
})
export class AcetDetailComponent implements OnInit {
    readonly expandAll = "Expand All";
    readonly collapseAll = "Collapse All";
    matDetails: any;
    matRange: any;
    // matRangeString: any;
    matRangeStartString: any;
    matRangeEndString: any;
    expand: string;
    expanded: boolean;
    overallIrp: string;
    targetBandOnly: boolean = true;
    bottomExpected: string;

    domainDataList: any = [];
    sortDomainListKey: string[] = [];

    sortedDomainList: any = [];

    /**
     * 
     */
    constructor(private router: Router,
        private assessSvc: AssessmentService,
        public navSvc: NavigationService,
        public acetSvc: ACETService,
        public layoutSvc: LayoutService,
        private tSvc: TranslocoService
    ) { }

    ngOnInit() {
        this.tSvc.langChanges$.subscribe((event) => {
            this.loadMatDetails();
        });
        this.expand = this.collapseAll;
        this.expanded = true;
        this.getMatRange();
        this.getOverallIrp();
    }

    loadMatDetails() {
        if (this.tSvc.getActiveLang() == "es") {
            this.sortDomainListKey = this.acetSvc.spanishSortDomainListKey;
        }
        else {
            this.sortDomainListKey = this.acetSvc.englishSortDomainListKey;
        }
        this.acetSvc.getMatDetailList().subscribe(
            (data: any) => {
                this.domainDataList = [];
                data.forEach((domain: MaturityDomain) => {
                    var domainData = {
                        domainName: domain.domainName,
                        domainMaturity: this.updateMaturity(domain.domainMaturity),
                        levelDisplay: this.acetSvc.translateMaturity(this.updateMaturity(domain.domainMaturity)),
                        targetPercentageAchieved: domain.targetPercentageAchieved,
                        graphdata: []
                    }
                    domain.assessments.forEach((assignment: MaturityAssessment) => {
                        var assesmentData = {
                            "assessmentFactor": assignment.assessmentFactor,
                            "domainMaturity": this.updateMaturity(assignment.assessmentFactorMaturity),
                            "levelDisplay": this.acetSvc.translateMaturity(this.updateMaturity(assignment.assessmentFactorMaturity)),
                            "sections": []
                        }
                        assignment.components.forEach((component: MaturityComponent) => {
                            var sectionData = [
                                { "name": "Baseline", "value": component.baseline },
                                { "name": "Evolving", "value": component.evolving },
                                { "name": "Intermediate", "value": component.intermediate },
                                { "name": "Advanced", "value": component.advanced },
                                { "name": "Innovative", "value": component.innovative }
                            ]

                            var sectionInfo = {
                                "name": component.componentName,
                                "assessedMaturityLevel": this.updateMaturity(component.assessedMaturityLevel),
                                "levelDisplay": this.acetSvc.translateMaturity(this.updateMaturity(component.assessedMaturityLevel)),
                                "data": sectionData
                            }
                            assesmentData.sections.push(sectionInfo);
                        })
                        domainData.graphdata.push(assesmentData);
                    })
                    this.domainDataList.push(domainData);
                })

                // Domains do not currently come sorted from API, this will sort the domains into proper order.
                this.sortDomainListKey.forEach(domain => {
                    this.domainDataList.filter(item => {
                        if (item.domainName == domain) {
                            this.sortedDomainList.push(item);
                        }
                    })
                })
                this.domainDataList = this.sortedDomainList;

                // clearing the list so it doesn't keep building on old data
                this.sortedDomainList = [];
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    updateMaturity(domainMaturity: string) {
        if (domainMaturity == "Sub-Baseline") {
            domainMaturity = "Ad-hoc";
        }
        return domainMaturity
    }

    getTargetBand() {
        this.acetSvc.getTargetBand().subscribe(
            (data) => {
                this.targetBandOnly = data as boolean;
            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    setTargetBand() {
        this.acetSvc.setTargetBand(this.targetBandOnly).subscribe();
        this.loadMatDetails();
    }

    getMatRange() {
        this.acetSvc.getMatRange().subscribe(
            (data) => {
                var dataArray = data as string[];
                this.matRange = dataArray;
                if (dataArray.length > 1) {
                    // this.matRangeString = dataArray[0] + " - " + dataArray[dataArray.length - 1];
                    this.matRangeStartString = dataArray[0].toLowerCase();
                    this.matRangeEndString = dataArray[dataArray.length - 1].toLowerCase();
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

    checkMaturity(mat: string) {
        if (this.bottomExpected == "Baseline" && mat == "Incomplete") {
            return "domain-gray";
        }
        else if (this.bottomExpected == "Baseline" && mat == "Ad-hoc") {
            return "domain-red";
        } else if (this.bottomExpected == "Evolving" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline")) {
            return "domain-red";
        } else if (this.bottomExpected == "Intermediate" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline" || mat == "Evolving")) {
            return "domain-red";
        } else if (this.bottomExpected == "Advanced" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline" || mat == "Evolving" || mat == "Intermediate")) {
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
