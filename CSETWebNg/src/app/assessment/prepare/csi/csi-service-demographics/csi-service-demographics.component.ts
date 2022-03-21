////////////////////////////////
//
//   Copyright 2022 Battelle Energy Alliance, LLC
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
import { CsiServiceDemographic } from '../../../../models/csi.model';
import { CsiService } from '../../../../services/csi.service';


@Component({
  selector: 'app-csi-service-demographics',
  templateUrl: './csi-service-demographics.component.html',
  host: { class: 'd-flex flex-column flex-11a' }
})
export class CsiServiceDemographicsComponent implements OnInit {

  csiServiceDemographic: CsiServiceDemographic;

budgetBasisList: string[] = [
  'No formal budget is established',
  'Strict dollar amount',
  'Strict percentage of IT budget',
  'Strict percentage of overall budget',
  'Management discretion',
  'Some other format',
  ];
  totalITStaffList: string[] = [
  'None',
  '1 to 5',
  '6 to 10',
  '11 to 20',
  '> 20',
  ];
  authorizedOrganizationalUserCountList: string[] = [
  '1 to 20',
  '21 to 50',
  '51 to 100',
  '101 to 500',
  '> 500',
  ];
  authorizedNonOrganizationUserCountList: string[] = [
  'None',
  '1 to 50',
  '51 to 100',
  '101 to 1,000',
  '1,001 to 10,000',
  '> 10,000',
  ];
  customersCountList: string[] = [
  '1 to 20',
  '21 to 50',
  '51 to 100',
  '101 to 1,000',
  '1,001 to 10,000',
  '10,001 to 50,000',
  '> 50,000'];

  constructor(private csiSvc: CsiService) { }

  ngOnInit(): void {

     this.csiSvc.getCsiServiceDemographic().subscribe((result: CsiServiceDemographic)=>{
       console.log(result);
        this.csiServiceDemographic = result;
     });
  }

  update(): void {

  }
}
