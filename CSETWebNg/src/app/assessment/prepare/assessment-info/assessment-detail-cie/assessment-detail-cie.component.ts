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
import { DatePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { MatDialog, MatDialogRef } from '@angular/material/dialog';
import { AssessmentDetail } from '../../../../models/assessment-info.model';
import { AssessmentService } from '../../../../services/assessment.service';
import { ConfigService } from '../../../../services/config.service';
import { NavigationService } from '../../../../services/navigation/navigation.service';
import { AwwaStandardComponent } from '../../standards/awwa-standard/awwa-standard.component';


@Component({
  selector: 'app-assessment-detail-cie',
  templateUrl: './assessment-detail-cie.component.html',
  // eslint-disable-next-line
  host: { class: 'd-flex flex-column flex-11a' }
})
export class AssessmentDetailCieComponent implements OnInit {

  assessment: AssessmentDetail = {
    assessmentName: ''
  };

  dialogRefAwwa: MatDialogRef<AwwaStandardComponent>;
  isAwwa = false;
  summaryBoxMax = 275;

  /**
   *
   */
  constructor(
    private assessSvc: AssessmentService,
    public navSvc: NavigationService,
    public configSvc: ConfigService,
    public datePipe: DatePipe,
    public dialog: MatDialog
  ) { }

  ngOnInit() {
    if (this.assessSvc.id()) {
      this.getAssessmentDetail();
    }
  }


  /**
   * Called every time this page is loaded.
   */
  getAssessmentDetail() {
    this.assessment = this.assessSvc.assessment;
    if (this.assessment.assessmentName.trim().length === 0 || this.assessment.assessmentName.trim() == "New Assessment") {
      this.assessment.assessmentName = "New Analysis";
      this.assessSvc.updateAssessmentDetails(this.assessment);
    }

    // Null out a 'low date' so that we display a blank
    const assessDate: Date = new Date(this.assessment.assessmentDate);
    if (assessDate.getFullYear() <= 1900) {
      this.assessment.assessmentDate = null;
    }
  }

  /**
   *
   */
  update(e) {
    // default Assessment Name if it is left empty
    if (!!this.assessment) {
      if (this.assessment.assessmentName.trim().length === 0) {
        this.assessment.assessmentName = "New Analysis";
      }
    }
    console.log(this.assessment)
    this.assessSvc.updateAssessmentDetails(this.assessment);
  }

  showAssessmentNameDisclaimer() {
    return this.configSvc.behaviors.showNameDisclaimer;
  }

  showFacilityName() {
    return this.configSvc.behaviors.showFacilityName;
  }

  showCityName() {
    return this.configSvc.behaviors.showCityName;
  }

  showStateName() {
    return this.configSvc.behaviors.showStateName;
  }

  /**
   * Show the AWWA tool import dialog
   */
  showAwwaDialog() {
    let msg = '';
    this.dialogRefAwwa = this.dialog.open(AwwaStandardComponent, { data: { messageText: msg } });

    let rval = false;

    this.dialogRefAwwa.afterClosed().subscribe(result => {
      if (result) {
        rval = true;
      } else {
        rval = false;
      }
      this.dialogRefAwwa = null;
    });
  }

  autoResize() {
    let textArea = document.getElementById("otherDetailsTextarea");
    textArea.style.overflow = 'hidden';
    // textArea.style.overflowY = 'hidden';
    textArea.style.height = '0px';
    textArea.style.height = textArea.scrollHeight + 'px';
    if (textArea.scrollHeight > this.summaryBoxMax) {
      textArea.style.height = this.summaryBoxMax + 'px';
      textArea.style.overflowY = 'scroll';

    }
  }

}

