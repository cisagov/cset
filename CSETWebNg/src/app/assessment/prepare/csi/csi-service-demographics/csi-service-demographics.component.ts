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
import {
  CsiServiceDemographic,
  CsiBudgetBasis,
  CsiStaffCount,
  CsiCustomerCount,
  CsiUserCount
} from '../../../../models/csi.model';
import { CsiService } from '../../../../services/cis-csi.service';
import { ConfigService } from './../../../../services/config.service';
import { DemographicService } from '../../../../services/demographic.service';

@Component({
  selector: 'app-csi-service-demographics',
  templateUrl: './csi-service-demographics.component.html',
  host: { class: 'd-flex flex-column flex-11a' },
  styleUrls: ['./csi-service-demographics.component.scss']
})
export class CsiServiceDemographicsComponent implements OnInit {
  csiServiceDemographic: CsiServiceDemographic = {};

  budgetBasisList: CsiBudgetBasis[] = [
    // 'No formal budget is established',
    // 'Strict dollar amount',
    // 'Strict percentage of IT budget',
    // 'Strict percentage of overall budget',
    // 'Management discretion',
    // 'Some other format',
  ];
  itIcsStaffCountList: CsiStaffCount[] = [
    // 'None',
    // '1 to 5',
    // '6 to 20',
    // '21 to 50',
    // '> 50',
  ];
  cyberSecurityItIcsStaffCountList: CsiStaffCount[] = [
    // 'None',
    // '1 to 5',
    // '6 to 10',
    // '11 to 20',
    // '> 20',
  ];
  authorizedOrganizationalUserCountList: CsiUserCount[] = [
    // '1 to 20',
    // '21 to 50',
    // '51 to 100',
    // '101 to 500',
    // '> 500',
  ];
  authorizedNonOrganizationalUserCountList: CsiUserCount[] = [
    // 'None',
    // '1 to 50',
    // '51 to 100',
    // '101 to 1,000',
    // '1,001 to 10,000',
    // '> 10,000',
  ];
  customersCountList: CsiCustomerCount[] = [
    // '1 to 20',
    // '21 to 50',
    // '51 to 100',
    // '101 to 1,000',
    // '1,001 to 10,000',
    // '10,001 to 50,000',
    // '> 50,000'
  ];

  demographics: any = {};

  constructor(private csiSvc: CsiService, private demoSvc: DemographicService, private configSvc: ConfigService) { }

  ngOnInit(): void {
    this.csiSvc.getAllCsiBudgetBases().subscribe(
      (data: CsiBudgetBasis[]) => {
        this.budgetBasisList = data;
      },
      (error) => {
        console.log('Error getting all CSI budget basis options: ' + (<Error>error).name + (<Error>error).message);
      }
    );
    this.csiSvc.getAllCsiStaffCounts().subscribe(
      (data: CsiStaffCount[]) => {
        this.itIcsStaffCountList = this.filterItIcsStaffCounts(data);
        this.cyberSecurityItIcsStaffCountList = this.filterCybersecurityItIcsStaffCounts(data);
      },
      (error) => {
        console.log('Error getting all CSI staff count options: ' + (<Error>error).name + (<Error>error).message);
      }
    );
    this.csiSvc.getAllCsiUserCounts().subscribe(
      (data: CsiUserCount[]) => {
        this.authorizedOrganizationalUserCountList = this.filterOrganizationalUserCounts(data);
        this.authorizedNonOrganizationalUserCountList = this.filterNonOrganizationalUserCounts(data);
      },
      (error) => {
        console.log('Error getting all CSI user count options: ' + (<Error>error).name + (<Error>error).message);
      }
    );
    this.csiSvc.getAllCsiCustomerCounts().subscribe(
      (data: CsiCustomerCount[]) => {
        this.customersCountList = this.sortCustomerCounts(data);
      },
      (error) => {
        console.log('Error getting all CSI customer count options: ' + (<Error>error).name + (<Error>error).message);
      }
    );

    this.csiSvc.getCsiServiceDemographic().subscribe((result: CsiServiceDemographic) => {
      this.csiServiceDemographic = result;
    });

    this.demoSvc.getDemographic().subscribe((data: any) => {
      this.demographics = data;
    });
  }

  update(): void {
    this.csiSvc.updateCsiServiceDemographic(this.csiServiceDemographic);
  }

  updateBaseDemographics() {
    this.demoSvc.updateDemographic(this.demographics);
  }

  filterCybersecurityItIcsStaffCounts(list: CsiStaffCount[]) {
    return list
      .filter((x) => x.sequence == 1 || x.sequence == 2 || x.sequence == 3 || x.sequence == 5 || x.sequence == 7)
      .sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
  }

  filterItIcsStaffCounts(list: CsiStaffCount[]) {
    return list
      .filter((x) => x.sequence == 1 || x.sequence == 2 || x.sequence == 4 || x.sequence == 6 || x.sequence == 8)
      .sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
  }

  filterOrganizationalUserCounts(list: CsiUserCount[]) {
    return list
      .filter((x) => x.sequence == 2 || x.sequence == 4 || x.sequence == 5 || x.sequence == 6 || x.sequence == 8)
      .sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
  }

  filterNonOrganizationalUserCounts(list: CsiUserCount[]) {
    return list
      .filter(
        (x) =>
          x.sequence == 1 ||
          x.sequence == 3 ||
          x.sequence == 5 ||
          x.sequence == 7 ||
          x.sequence == 9 ||
          x.sequence == 10
      )
      .sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
  }

  sortCustomerCounts(list: CsiCustomerCount[]) {
    return list.sort((a, b) => (a.sequence > b.sequence ? 1 : -1));
  }

  showCriticalServiceIdentifyingInfo() {
    return this.configSvc.behaviors.showCriticalService;
  }

  showErrors() {
    return this.configSvc.installationMode === 'IOD';
  }
}
