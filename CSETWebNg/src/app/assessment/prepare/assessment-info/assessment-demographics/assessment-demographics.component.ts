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
import { Demographic } from '../../../../models/assessment-info.model';
import { DemographicService } from '../../../../services/demographic.service';

interface DemographicsAssetValue {
    DemographicsAssetId: number;
    AssetValue: string;
}

interface Industry {
    SectorId: number;
    IndustryId: number;
    IndustryName: string;
}

interface Sector {
    SectorId: number;
    SectorName: string;
}

interface AssessmentSize {
    DemographicId: number;
    Size: string;
    Description: string;
}

@Component({
    selector: 'app-assessment-demographics',
    templateUrl: './assessment-demographics.component.html',
    // tslint:disable-next-line:use-host-property-decorator
    host: {class: 'd-flex flex-column flex-11a'}
})
export class AssessmentDemographicsComponent implements OnInit {
    sectorsList: Sector[];
    sizeList: AssessmentSize[];
    assetValues: DemographicsAssetValue[];
    industryList: Industry[];

    demographicData: Demographic = {};

    constructor(private demoSvc: DemographicService) { }

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
    }

    onSelectSector(sectorId: number) {
        this.populateIndustryOptions(sectorId);
        // invalidate the current Industry, as the Sector list has just changed
        this.demographicData.IndustryId = 0;
        this.updateDemographics();
    }

    getDemographics() {
        this.demoSvc.getDemographic().subscribe(
            (data: Demographic) => {
                this.demographicData = data;

                // populate Industry dropdown based on Sector
                this.populateIndustryOptions(this.demographicData.SectorId);
            },
            error => console.log('Demographic load Error: ' + (<Error>error).message)
        );
    }

    populateIndustryOptions(sectorId: number) {
        if (!sectorId) {
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
        this.demographicData.AssetValue = event.target.value;
        this.updateDemographics();
    }

    changeSize(event: any) {
        this.demographicData.Size = event.target.value;
        this.updateDemographics();
    }

    update(event: any) {
        this.updateDemographics();
    }

    updateDemographics() {
        this.demoSvc.updateDemographic(this.demographicData);
    }
}
