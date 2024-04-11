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
import { DatePipe } from '@angular/common';
import { CsiOrganizationDemographic, CsiStaffCount } from '../../../../models/csi.model';
import { CsiService } from '../../../../services/cis-csi.service';
import { AssessmentService } from './../../../../services/assessment.service';

@Component({
  selector: 'app-csi-organization-demographics',
  templateUrl: './csi-organization-demographics.component.html',
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CsiOrganizationDemographicsComponent implements OnInit {

  orgDemographic: CsiOrganizationDemographic = {};
  staffCountsList: CsiStaffCount[];
  cyberStaffCountsList: CsiStaffCount[];

  constructor(private csiSvc: CsiService, private assessSvc: AssessmentService, private datePipe: DatePipe) { }

  ngOnInit(): void {
    this.csiSvc.getAllCsiStaffCounts().subscribe(
      (data: CsiStaffCount[]) => {
        this.staffCountsList = this.filterStaffCounts(data);
        this.cyberStaffCountsList = this.filterCyberStaffCounts(data);
      },
      error => {
        console.log('Error Getting all CSI staff count options: ' + (<Error>error).name + (<Error>error).message);
      });

    if (this.assessSvc.id()) {
      this.getCsiOrgDemographics();
    }
  }

  /**
   * POSTs data to API
   */
  update() {
    this.csiSvc.updateCsiOrgDemographic(this.orgDemographic);
  }

  filterStaffCounts(list: CsiStaffCount[]) {
    return list.filter(
      x => x.sequence == 2 || x.sequence == 4 || x.sequence == 6 || x.sequence == 8
    ).sort((a, b) => (a.sequence > b.sequence) ? 1 : -1);
  }

  filterCyberStaffCounts(list: CsiStaffCount[]) {
    return list.filter(
      x => x.sequence == 2 || x.sequence == 3 || x.sequence == 5 || x.sequence == 7
    ).sort((a, b) => (a.sequence > b.sequence) ? 1 : -1);
  }

  getCsiOrgDemographics() {
    this.csiSvc.getCsiOrgDemographic().subscribe(
      (data: CsiOrganizationDemographic) => {
        this.orgDemographic = data;
        this.orgDemographic.visitDate = this.datePipe.transform(this.orgDemographic.visitDate, 'yyyy-MM-dd');
      },
      error => console.log('CIS CSI organization demographic load Error: ' + (<Error>error).message)
    );
  }

}
