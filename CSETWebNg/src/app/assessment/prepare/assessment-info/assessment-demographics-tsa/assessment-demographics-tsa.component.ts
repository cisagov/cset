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
import { Demographic } from '../../../../models/assessment-info.model';
import { DemographicService } from '../../../../services/demographic.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { AssessmentContactsResponse } from "../../../../models/assessment-info.model";
import { User } from '../../../../models/user.model';

interface DemographicsAssetValue {
    demographicsAssetId: number;
    assetValue: string;
}

interface Industry {
    sectorId: number;
    industryId: number;
    industryName: string;
}

interface Sector {
    sectorId: number;
    sectorName: string;
}

interface AssessmentSize {
    demographicId: number;
    size: string;
    description: string;
}

@Component({
    selector: 'app-assessment-demographics-tsa',
    templateUrl: './assessment-demographics-tsa.component.html',
    styleUrls: ['./assessment-demographics-tsa.component.scss'],
    host: { class: 'd-flex flex-column flex-11a' }
})
export class AssessmentDemographicsTsaComponent implements OnInit {
    sectorsList: Sector[];
    sizeList: AssessmentSize[];
    assetValues: DemographicsAssetValue[];
    industryList: Industry[];
    contacts: User[];

    demographicData: Demographic = {};
    orgTypes: any[];
    isSLTT: boolean = false;
    constructor(private demoSvc: DemographicService, public assessSvc: AssessmentService) { }

    ngOnInit() {
        this.demoSvc.getAllSectors().subscribe(
            (data: Sector[]) => {
                this.sectorsList = data;
            },
            error => {
                console.log('Error Getting all sectors: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error Getting all sectors (cont): ' + (<Error>error).stack);
            });
        this.demoSvc.getAllAssetValues().subscribe(
            (data: DemographicsAssetValue[]) => {
                this.assetValues = data;
            },
            error => {
                console.log('Error Getting all asset values: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error Getting all asset values (cont): ' + (<Error>error).stack);
            });
        this.demoSvc.getSizeValues().subscribe(
            (data: AssessmentSize[]) => {
                this.sizeList = data;
            },
            error => {
                console.log('Error Getting size values: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error Getting size values (cont): ' + (<Error>error).stack);
            });

        if (this.demoSvc.id) {
            this.getDemographics();
        }
        this.refreshContacts();
        this.getOrganizationTypes();
    }

    onSelectSector(sectorId: number) {
        this.populateIndustryOptions(sectorId);
        // invalidate the current Industry, as the Sector list has just changed
        this.demographicData.industryId = null;
        this.updateDemographics();
    }

    getDemographics() {
        this.demoSvc.getDemographic().subscribe(
            (data: Demographic) => {
                this.demographicData = data;
                if (this.demographicData.sectorId == null) {
                    this.demographicData.sectorId = 15;
                }
                if (this.demographicData.organizationType == "3") {
                    this.isSLTT = true;
                }
                // populate Industry dropdown based on Sector
                this.populateIndustryOptions(this.demographicData.sectorId);
            },
            error => console.log('Demographic load Error: ' + (<Error>error).message)
        );
    }

    getOrganizationTypes() {
        this.assessSvc.getOrganizationTypes().subscribe(
            (data: any) => {
                this.orgTypes = data;
            }
        )
    }

    refreshContacts() {
        if (this.assessSvc.id()) {
            this.assessSvc
                .getAssessmentContacts()
                .then((data: AssessmentContactsResponse) => {
                    this.contacts = data.contactList;
                });
        }
    }

    populateIndustryOptions(sectorId: number) {
        if (!sectorId || sectorId.toString() == "0: null") {
            return;
        }
        this.demoSvc.getIndustry(sectorId).subscribe(
            (data: Industry[]) => {
                this.industryList = data;
            },
            error => {
                console.log('Error Getting Industry: ' + (<Error>error).name + (<Error>error).message);
                console.log('Error Getting Industry (cont): ' + (<Error>error).stack);
            });
    }

    changeAssetValue(event: any) {
        this.demographicData.assetValue = event.target.value;
        this.updateDemographics();
    }

    changeOrgType(event: any) {
        this.demographicData.organizationType = event.target.value;
        this.updateDemographics();
    }

    changeFacilitator(event: any) {
        this.demographicData.facilitator = event.target.value;
        this.updateDemographics();
    }

    changeOrgName(event: any) {
        this.demographicData.organizationName = event.target.value;
        this.updateDemographics();
    }

    changeAgency(event: any) {
        this.demographicData.agency = event.target.value;
        this.updateDemographics();
    }

    changeCriticalService(event: any) {
        this.demographicData.criticalService = event.target.value;
        this.updateDemographics();
    }

    changePointOfContact(event: any) {
        this.demographicData.pointOfContact = event.target.value;
        this.updateDemographics();
    }

    changeIsScoped(event: any) {
        //this.demographicData.isScoped = event.target.value;
        this.updateDemographics();
    }

    changeSize(event: any) {
        this.demographicData.size = event.target.value;
        this.updateDemographics();
    }

    update(event: any) {
        this.updateDemographics();
    }

    updateDemographics() {
        this.demoSvc.updateDemographic(this.demographicData);
    }
}
