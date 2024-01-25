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
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { ConfigService } from './config.service';
import { CsiOrganizationDemographic, CsiServiceComposition, CsiServiceDemographic } from '../models/csi.model';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class CsiService {

  apiUrl: string;
  id: number;

  constructor(private http: HttpClient, private configSvc: ConfigService) {
    this.apiUrl = this.configSvc.apiUrl + 'cis/';
  }


  /**
   * GETs the screen data for CIS assessment
   */
  getCsiServiceDemographic() {
    return this.http.get(this.apiUrl + 'serviceDemographics');
  }

  /**
 * POSTs the CIS organization demographic screen data to the API.
 * @param csiServiceDemographic
 */
  updateCsiServiceDemographic(csiServiceDemographic: CsiServiceDemographic) {
    this.http.post(this.apiUrl + 'serviceDemographics', JSON.stringify(csiServiceDemographic), headers).subscribe();
  }

  /**
 * GETs the screen data for CIS assessment organization demographic
 */
  getCsiOrgDemographic() {
    return this.http.get(this.apiUrl + 'organizationDemographics');
  }

  /**
  * GETs the screen data for CIS assessment service composition
  */
  getCsiServiceComposition() {
    return this.http.get(this.apiUrl + 'serviceComposition');
  }

  /**
 * POSTs the CIS organization demographic screen data to the API.
 * @param orgDemographic
 */
  updateCsiOrgDemographic(orgDemographic: CsiOrganizationDemographic) {
    this.http.post(this.apiUrl + 'organizationDemographics', JSON.stringify(orgDemographic), headers).subscribe();
  }

  /**
 * POSTs the CIS service composition screen data to the API.
 * @param orgDemographic
 */
  updateCsiServiceComposition(serviceComposition: CsiServiceComposition) {
    this.http.post(this.apiUrl + 'serviceComposition', JSON.stringify(serviceComposition), headers).subscribe();
  }

  /**
   * GETs staff counts for CIS assessment
   */
  getAllCsiStaffCounts() {
    return this.http.get(this.apiUrl + 'staffCounts');
  }

  /**
   * GETs defining system options for CIS assessment
   */
  getAllCsiDefiningSystems() {
    return this.http.get(this.apiUrl + 'definingSystems');
  }

  /**
   * GETs budget basis options for CIS assessment
   */
  getAllCsiBudgetBases() {
    return this.http.get(this.apiUrl + 'budgetBases');
  }

  /**
   * GETs budget basis options for CIS assessment
   */
  getAllCsiUserCounts() {
    return this.http.get(this.apiUrl + 'userCounts');
  }

  /**
   * GETs budget basis options for CIS assessment
   */
  getAllCsiCustomerCounts() {
    return this.http.get(this.apiUrl + 'customerCounts');
  }
}
