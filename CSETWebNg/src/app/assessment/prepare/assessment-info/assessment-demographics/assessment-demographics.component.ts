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
import { Component, OnInit, Input, ViewChild, ElementRef } from '@angular/core';
import { Demographic } from '../../../../models/assessment-info.model';
import { DemographicService } from '../../../../services/demographic.service';
import { AssessmentService } from '../../../../services/assessment.service';
import { AssessmentContactsResponse } from "../../../../models/assessment-info.model";
import { User } from '../../../../models/user.model';
import { ConfigService } from '../../../../services/config.service';
import { Observable } from 'rxjs';
import { OkayComponent } from '../../../../dialogs/okay/okay.component';
import { MatDialog } from '@angular/material/dialog';
import { UploadDemographicsComponent } from "../../../../dialogs/import demographics/import-demographics.component";



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

interface ImportExportData {
    data: any; 
  }

@Component({
    selector: 'app-assessment-demographics',
    templateUrl: './assessment-demographics.component.html',
    // eslint-disable-next-line
    host: { class: 'd-flex flex-column flex-11a' }
})
export class AssessmentDemographicsComponent implements OnInit {
    @ViewChild('assetValueSelect') assetValueSelect: ElementRef;

    @Input() events: Observable<void>;

    private eventsSubscription: any;
    unsupportedImportFile: boolean = false;
    sectorsList: Sector[];
    sizeList: AssessmentSize[];
    assetValues: DemographicsAssetValue[];
    industryList: Industry[];
    contacts: User[];
    isSLTT: boolean = false;
    demographicData: Demographic = {};
    orgTypes: any[];

    assetValueTemp: number; 

    constructor(
        private demoSvc: DemographicService,
        public assessSvc: AssessmentService,
        public configSvc: ConfigService, 
        public dialog: MatDialog,
    ) { }

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

    // Functionality to import demographic information, excluding contacts, organization point of contact, facilitator, critical service point of contact 
    importClick(event){
        let dialogRef = null;
        this.unsupportedImportFile = false;
        if (event.target.files[0].name.endsWith(".json")) {
          // Call Standard import service
          dialogRef = this.dialog.open(UploadDemographicsComponent, {
            data: { files: event.target.files, IsNormalLoad: true }
          });
        } else {
          this.unsupportedImportFile = true;
        }
    
        if (!this.unsupportedImportFile) {
          dialogRef.afterClosed().subscribe(result => {
            this.getDemographics()
            this.getOrganizationTypes()
            this.assessSvc.refreshAssessment()
          });
        }
    }


    //Functionality to export demographic information, excluding contacts, organization point of contact, facilitator, critical service point of contact 
    exportClick(){
        this.demoSvc.exportDemographics()
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

    populateIndustryOptions(sectorId?: any) {
        if (!sectorId || isNaN(Number(sectorId))) {
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

    // Select asset value after import 
    setAssetValue(selectedValue: any): void {
        this.assetValueSelect.nativeElement.value = selectedValue;
    }

    update(event: any) {
        this.updateDemographics();
    }

    updateDemographics() {
        this.demoSvc.updateDemographic(this.demographicData);
    }

    showOrganizationName() {
        return this.configSvc.behaviors.showOrganizationName;
    }

    showBusinessAgencyName() {
        return this.configSvc.behaviors.showBusinessAgencyName;
    }

    showCriticalService() {
        const moduleBehavior = this.configSvc.config.moduleBehaviors.find(m => m.moduleName == this.assessSvc.assessment?.maturityModel?.modelName);
        return (this.configSvc.behaviors.showCriticalService ?? true)
            && (moduleBehavior?.showCriticalServiceDemog ?? true);
    }


    showEdmFields() {
        return this.assessSvc.assessment?.maturityModel?.modelName == 'EDM';
    }

    showFacilitator() {
        return this.configSvc.behaviors.showFacilitatorDropDown;
    }
}
