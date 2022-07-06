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
import { Injectable, SkipSelf } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { AssessmentService } from './assessment.service';
import { AssessmentDetailComponent } from '../assessment/prepare/assessment-info/assessment-detail/assessment-detail.component';
import { AssessmentDetail } from '../models/assessment-info.model';

let headers = {
    headers: new HttpHeaders()
        .set('Content-Type', 'application/json'),
    params: new HttpParams()
};

/**
 * A service that checks for the NCUA examiner's installation switch.
 */
 @Injectable({
    providedIn: 'root'
  })
  
 export class NCUAService {

  // used to determine whether this is an NCUA installation or not
  apiUrl: string;
  switchStatus: boolean;

  // used for keeping track of which examinations are being merged
  prepForMerge: boolean = false;
  assessmentsToMerge: any[] = [];

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
  ) {
    this.init();
  }

  async init() {
  this.getSwitchStatus();
  }

  // check if it's an examiner using ACET - switch is toggled during installation
  getSwitchStatus() {
    this.http.get(this.configSvc.apiUrl + 'isExaminersModule', headers).subscribe((
      response: boolean) => {
        this.switchStatus = response;
      }
    );
  }

  // Opens merge toggle checkboxes on the assessment selection (landing) page
  prepExaminationMerge() {
    if (this.prepForMerge === false) {
      this.prepForMerge = true;
    } else if (this.prepForMerge === true) {
      this.prepForMerge = false;
    }
  }

  // Adds or removes selected ISE examinations to the list to merge
  modifyMergeList(assessment: any, event: any) {
    const optionChecked = event.srcElement.checked;

    if (optionChecked) {
      this.assessmentsToMerge.push(assessment.assessmentId);
      } else {
      const index = this.assessmentsToMerge.indexOf(assessment);
      this.assessmentsToMerge.splice(index, 1);
    }
  }


  getAnswers(id1: number, id2: number) {
    headers.params = headers.params.set('id1', id1).set('id2', id2);
    return this.http.get(this.configSvc.apiUrl + 'getMergeData', headers)
  }

}