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
import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders, HttpParams } from '@angular/common/http';
import { ConfigService } from './config.service';
import { MatDialog } from '@angular/material/dialog';
import { CharterMismatchComponent } from '../dialogs/charter-mistmatch/charter-mismatch.component';

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
  mainAssessCharter: string = "";
  charterWarningShown: boolean = false;

  constructor(
    private http: HttpClient,
    private configSvc: ConfigService,
    public dialog: MatDialog
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
    let tempCharter = "";

    if (this.mainAssessCharter === "") {
      for (let i = 4; i < 9; i++) {
        this.mainAssessCharter += assessment.assessmentName[i];
      }
    } else {
      for (let i = 4; i < 9; i++) {
        tempCharter += assessment.assessmentName[i];
      }
    }

    const optionChecked = event.srcElement.checked;

    if (this.mainAssessCharter !== "" && tempCharter !== "" && optionChecked) {
      if (this.mainAssessCharter !== tempCharter && this.charterWarningShown === false) {
        this.openCharterWarning();
      }
    }

    if (optionChecked) {
      this.assessmentsToMerge.push(assessment.assessmentId);
    } else {
      const index = this.assessmentsToMerge.indexOf(assessment);
      this.assessmentsToMerge.splice(index, 1);
    }

    if (this.assessmentsToMerge.length === 0) {
      this.mainAssessCharter = "";
      this.charterWarningShown = false;
    }
  }

  openCharterWarning() {
    let dialogRef = this.dialog.open(CharterMismatchComponent, {
      width: '250px',
    });

    dialogRef.afterClosed().subscribe(result => {
      this.charterWarningShown = true;
    });
  }


  getAnswers() {
    let id1 = this.assessmentsToMerge[0];
    let id2 = this.assessmentsToMerge[1];
    let id3 = (this.assessmentsToMerge[2] !== undefined ? this.assessmentsToMerge[2] : 0);
    let id4 = (this.assessmentsToMerge[3] !== undefined ? this.assessmentsToMerge[3] : 0);
    let id5 = (this.assessmentsToMerge[4] !== undefined ? this.assessmentsToMerge[4] : 0);
    let id6 = (this.assessmentsToMerge[5] !== undefined ? this.assessmentsToMerge[5] : 0);
    let id7 = (this.assessmentsToMerge[6] !== undefined ? this.assessmentsToMerge[6] : 0);
    let id8 = (this.assessmentsToMerge[7] !== undefined ? this.assessmentsToMerge[7] : 0);
    let id9 = (this.assessmentsToMerge[8] !== undefined ? this.assessmentsToMerge[8] : 0);
    let id10 = (this.assessmentsToMerge[9] !== undefined ? this.assessmentsToMerge[9] : 0);
   

    headers.params = headers.params.set('id1', id1).set('id2', id2).set('id3', id3).set('id4', id4)
    .set('id5', id5).set('id6', id6).set('id7', id7).set('id8', id8).set('id9', id9).set('id10', id10);

    return this.http.get(this.configSvc.apiUrl + 'getMergeData', headers)
  }

}