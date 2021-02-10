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
import { MatDetailResponse, MaturityDomain, MaturityAssessment, MaturityComponent } from '../../../models/mat-detail.model';
import { MatExpansionModule } from '@angular/material/expansion';
import { ACETService } from '../../../services/acet.service';
import { NavigationService } from '../../../services/navigation.service';

@Component({
    selector: 'app-mat-detail',
    templateUrl: './mat-detail.component.html',
    styleUrls: ['./mat-detail.component.scss', '../../../reports/acet-reports.scss']
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

    domainDataList: any = [];
    sortDomainListKey: string[] = ["Cyber Risk Management & Oversight",
        "Threat Intelligence & Collaboration",
        "Cybersecurity Controls",
        "External Dependency Management",
        "Cyber Incident Management and Resilience"]

    sortedDomainList: any = []

    constructor(private router: Router,
        private assessSvc: AssessmentService,
        public navSvc: NavigationService,
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
            (data: any) => {
                data.forEach((domain: MaturityDomain) => {
                    var domainData = {
                        domainName: domain.DomainName,
                        domainMaturity: this.updateMaturity(domain.DomainMaturity),
                        targetPercentageAchieved: domain.TargetPercentageAchieved,
                        graphdata: []
                    }
                    domain.Assessments.forEach((assignment: MaturityAssessment) => {
                        var assesmentData = {
                            "asseessmentFactor": assignment.AssessmentFactor,
                            "domainMaturity": this.updateMaturity(assignment.AssessmentFactorMaturity),
                            "sections": []
                        }
                        assignment.Components.forEach((component: MaturityComponent) => {
                            var sectionData = [
                                { "name": "Baseline", "value": component.Baseline },
                                { "name": "Evolving", "value": component.Evolving },
                                { "name": "Intermediate", "value": component.Intermediate },
                                { "name": "Advanced", "value": component.Advanced },
                                { "name": "Innovative", "value": component.Innovative }
                            ]

                            var sectonInfo = {
                                "name": component.ComponentName,
                                "AssessedMaturityLevel": this.updateMaturity(component.AssessedMaturityLevel),
                                "data": sectionData
                            }
                            assesmentData.sections.push(sectonInfo);
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

            },
            error => {
                console.log('Error getting all documents: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error getting all documents: ' + (<Error>error).stack);
            });
    }

    updateMaturity(domainMaturity: string){
        if (domainMaturity == "Sub-Baseline") {
            domainMaturity = "Ad-hoc";
        }
        return domainMaturity
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
            return "domain-gray";
        }
        else if (this.bottomExpected == "Baseline" && mat == "Ad-hoc") {
            return "domain-red";
        } else if( this.bottomExpected == "Evolving" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline")){
            return "domain-red";
        } else if (this.bottomExpected == "Intermediate" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline" || mat == "Evolving")){
            return "domain-red";
        } else if (this.bottomExpected == "Advanced" && (mat == "Ad-hoc" || mat == "Incomplete" || mat == "Baseline" || mat == "Evolving" || mat == "Intermediate")){
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
