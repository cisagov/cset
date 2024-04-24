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
import { AssessmentService } from './assessment.service';

const headers = {
  headers: new HttpHeaders().set('Content-Type', 'application/json'),
  params: new HttpParams()
};

@Injectable({
  providedIn: 'root'
})
export class DemographicIodService {

  apiUrl: string;

  /**
   * 
   * @param http 
   * @param configSvc 
   */
  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    private assessSvc: AssessmentService
  ) {
    this.apiUrl = this.configSvc.apiUrl + 'demographics/ext2';
  }

  /**
   * 
   * @returns 
   */
  getDemographics() {
    return this.http.get(this.apiUrl);
  }

  /**
   * 
   * @param sectorId 
   * @returns 
   */
  getSubsectors(sectorId) {
    return this.http.get(this.apiUrl + `/subsectors/${sectorId}`);
  }


  /**
   * POSTs the screen data to the API.
   * @param demographic
   */
  updateDemographic(demographic: any) {
    this.http.post(this.apiUrl, JSON.stringify(demographic), headers)
      .subscribe(() => {
        if (this.configSvc.cisaAssessorWorkflow) {
          this.assessSvc.updateAssessmentName();
        }
      });
  }

  /**
   * POSTs the screen data to the API.
   * @param demographic
   */
  updateIndividualDemographics(name: string, val: any, type: string){

     // Setting up query parameters
     let queryParams = new HttpParams()
     .set('name', name)
     .set('val', val)
     .set('t', type);

    this.http.post(this.configSvc.apiUrl + 'demographics/ext3', null, { params: queryParams })
    .subscribe(() => {})
  }
}
